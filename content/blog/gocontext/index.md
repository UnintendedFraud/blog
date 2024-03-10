+++
title = "Go context"
date = 2024-03-10

[taxonomies]
tags = ["go", "learning", "context"]
+++

Go context are one of those things you can use without understanding them. All you have to do is pass 
`context.Background()` to satisfy some external libraries requirements, maybe add some context with self explanatory 
timeout if you feeling fancy, or simply pass through the request's context. Let's try to understand a bit more 
about how they're used and their possibilities.

<!-- more -->

From the official documentatation ([https://pkg.go.dev/context](https://pkg.go.dev/context)), we can highlight:

"Incoming requests to a server should create a Context, and outgoing calls to servers should accept a Context. 
The chain of function calls between them must propagate the Context, optionally replacing it with a derived 
Context [...] When a Context is canceled, all Contexts derived from it are also canceled."

From this we already understand multiple things:
- it is requests related
- a context can have children 
- if a parent is cancelled, the children are too

If you want to have more details and visualise it, I would recommend this talk (I don't know this person but he 
breaks it down very nicely): [The context package internals - Damiano Petrungaro](https://www.youtube.com/watch?v=mfgBhGu5pco)

Let's see in our own examples how to use context, for timeouts and adding data to a request.

1. [Overview of our simple server](#overview-of-our-simple-server)

### Overview of our simple server

Context being requests related, we need a server. Go has a very useful `http` package to do that, I created a custom 
struct to handle middlewares easier along with timeout. I think it'll make the examples better.

```go
type ServerHandler func(http.Handler) http.Handler

type Server struct {
	timeout time.Duration
}

func NewServer(timeout time.Duration) *Server {
	return &Server{
		timeout,
	}
}

func (s *Server) Handle(addr string, handlers ...ServerHandler) {
	middlewares := append(handlers...)

	http.Handle(addr, handleMiddlewares(middlewares))
}

func (s *Server) Listen(port int) error {
	if err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil); err != nil {
		return fmt.Errorf("server broke: %s", err.Error())
	}

	return nil
}

func handleMiddlewares(handlers []ServerHandler) http.Handler {
	var handler http.Handler

	for i := range handlers {
		handler = handlers[len(handlers)-1-i](handler)
	}

	return handler
}
```

This is a simple wrapper around the `http` package, only two things are added to make things easier:
- Allowing to write middleware like this: `http.Handle(path, middleware1, middleware2, endpoint)` instead of the, in 
my opinion, terrible `http.Handle(path, endpoint(middleware2(middleware1)))`
- Add the timeout to the `Server` struct to play with it easier

In the example above, `timeout` is not used, but it will later in the example below, by adding an arbitrary middleware.

### Use context to pass request-related data to the endpoint

It is important to note that the doc specify:  
"Use context Values only for request-scoped data that transits processes and APIs, not for passing optional 
parameters to functions."

My example will not do that as I want to show how to add values to a context, and read it down the line. In real life, 
I've used it to add user-related data to the request, or a third-party API client already authenticated ready to use 
in your endpoint code. I'm sure there are other ways to take advantage of it.

Let's look at our dumb example:

```go
const PORT = 8080

func main() {
	server := NewServer(0) // the 0 is the timeout, ignore for now

	server.Handle(
		"/get-value",
		addValueToContext,
		handleGetValue,
	)

	if err := server.Listen(PORT); err != nil {
		panic(err)
	}
	fmt.Println("listening on :", PORT)
}
```

Here we create our server, have a route `/get-value`, a middleware that will create a value, and the 
router handler that will read from the context and return that value.

Let's look at the middleware first:  

```go
type ComplexStruct struct {
	question        string
	possibleAnswers []string
}

func addValueToContext(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Add simple values
		ctx1 := context.WithValue(r.Context(), "number", 420)
		ctx2 := context.WithValue(ctx1, "sad_message", "RIP Toriyama :(")

		// Add a more complex one
		cs := ComplexStruct{
			question: "What is your favourite Dragon Ball character?",
			possibleAnswers: []string{
				"Goku",
				"Gohan",
				"Vegeta",
				"You get the idea zz",
			},
		}

		ctx3 := context.WithValue(ctx2, "complex_struct", cs)

		next.ServeHTTP(w, r.WithContext(ctx3))
	})
}
```



Here we store 3 values in the context. I tried a number, a string and a custom struct to show that we can store anything 
we need.

If you look closely, you'll notice that we create a new context every time, this is basically how creating new context 
work (outside of the default `context.TODO()` or `context.Background()`, which are empty and parent for all of the other 
contexts).  

Every new context is created from the previous one, and is therefore a child. Here `ctx3` is the "youngest" child, which 
we pass to our route handler defined below:  

```go 
func handleGetValue(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		n := r.Context().Value("number")
		str := r.Context().Value("sad_message")
		complex := r.Context().Value("complex_struct")
		undefined := r.Context().Value("value does not exist")

		w.Write([]byte(fmt.Sprintf("\n number: [%d]", n)))
		w.Write([]byte(fmt.Sprintf("\n Message: [%s]", str)))
		w.Write([]byte(fmt.Sprintf("\n Complex struct: [%+v]", complex)))
		w.Write([]byte(fmt.Sprintf("\n Undefined value: [%+v] \n", undefined)))
	})
}
```

Here we only retrieve the values and display them on the client.  
For good measures I added a value that does not exist to see what happens (spoiler: it's `nil`).  

The result when calling our endpoint is:
```
curl localhost:8080/get-value

number: [420]
Message: [RIP Toriyama :(]
Complex struct: [{question:What is your favourite Dragon Ball character? possibleAnswers:[Goku Gohan Vegeta You get the idea zz]}]
Undefined value: [<nil>]
```

We get all of our values as expected.  

You may wonder how does it work since we passed the youngest context `ctx3` that only contained the value with the complex 
struct. This is because the way it works is, Go will move up the contextes (is that a word?). For example, when looking 
up `number`, it will do this (I will use the context names from `addValueToContext` for clarity, it's basically going all 
the way up each parent in order until it finds the value or hit the end of the line):
- search `number` in `ctx3`, it's not there
- search `number` in `ctx2`, it's not there
- search `number` in `ctx1`, found

If we passed `ctx2` to `handleGetValue`, then the curl would show `nil` for the complex struct, because `ctx3` would not 
be checked.

### (Server side) Use context for timeout (unexpected behaviour)

Probably the main reason to use context: timeout and deadlines. Making sure we're not hanging somewhere.

To do this, we'll alter our server a little bit, we'll add a middleware in our `Handle` function that will add a 
timeout if the duration specified is more than 0:  

```go
func (s *Server) Handle(addr string, handlers ...ServerHandler) {
	var middlewares []ServerHandler

	if s.timeout == 0 {
		middlewares = handlers
	} else {
		middlewares = append([]ServerHandler{s.timeoutMiddleware}, handlers...)
	}

	http.Handle(addr, handleMiddlewares(middlewares))
}

func (s *Server) timeoutMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), s.timeout)
		defer cancel()

		processDone := make(chan bool)

		go func() {
			next.ServeHTTP(w, r.WithContext(ctx))
			processDone <- true
		}()

		select {
		case <-ctx.Done():
			w.WriteHeader(http.StatusGatewayTimeout)
			w.Write([]byte("\nContext expired"))
            w.Write([]byte(fmt.Sprintf("\nContext error: [%s]", ctx.Err().Error())))
            fmt.Println("context timeout")
		case <-processDone:
			fmt.Println("process done")
		}
	})
}
```

To take advantage of this, we need to add a timeout to our server:

```go
server := NewServer(1 * time.Second) 
```

We will also add a 2 seconds sleep in our middleware to trigger the cancellation of the context due to timeout. I've 
also added some server logs to highlight something I did not expect, and I don't like but I'm not sure what to do 
about it, except maybe considering my example flawed. :/

```go 
func addValueToContext(next http.Handler) http.Handler {
    // [...]

    fmt.Println("Before sleep")
    time.Sleep(2 * time.Second)
    fmt.Println("After sleep")

	next.ServeHTTP(w, r.WithContext(ctx3))
}

func handleGetValue(next http.Handler) http.Handler {
    // [...]

   	fmt.Println("finished executing handleGetNumber") 
}

```

If we run this, we get the correct response at the right time on the client:

```
curl localhost:8080/get-value

context expired
Context error: [context deadline exceeded]
```

However if we look at the server's logs, we unfortunately see this:

```
Before sleep
context timeout
After sleep
finished executing handleGetNumber
```

I would have expected / hoped that the server would stop the execution chain once the request's context expired, but it 
didn't. Feels bad.

To be fair in real situation, our slow process would require a context to be passed, and error out 
if it expires, instead of trying to have a magic middleware in the middle. Let's rewrite our previous example with a 
more expected structure.

Our middleware become the following:

```go 
func (s *Server) timeoutMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), s.timeout)
		defer cancel()

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
```

In a more normal scenario, you would imagine that such a middleware would not exist, and you would create the context 
directly in the endpoint, but let's keep it like this for global timeout.

No more channels action in there, those would be handle by anything that require a context instead.

Our route handler:
```go 
func handleGetValue(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("starting handleGetValue")
		defer fmt.Println("finished executing handleGetNumber")

		message, err := executeHandleGetValue(r.Context(), r)
		if err != nil {
			w.Write([]byte(fmt.Sprintf("\nError happened: %s", err.Error())))
			fmt.Println("Error happened: ", err)
			return
		}

		w.Write([]byte(message))
	})
}
```

Here we call `executeHandleGetValue` which accept a context, return a `string` and an `error`. It is expected that if 
the context expired, we get the appropriate error, otherwise we return the message.

`executeHandleGetValue` looks like this. I removed the reading and printing the context values for clarity.

```go
func executeHandleGetValue(ctx context.Context, r *http.Request) (string, error) {
	chanErr := make(chan error, 1)

	go func() {
		fmt.Println("executeHandleGetValue started")
		defer fmt.Println("executeHandleGetValue ended")

		time.Sleep(2 * time.Second)

		// simulate errors
		shouldError := true

		if shouldError {
			chanErr <- fmt.Errorf("an error happened during goroutine")
		} else {
			chanErr <- nil
		}
	}()

	select {
	case <-ctx.Done():
		return "", ctx.Err()
	case err := <-chanErr:
		return "finished successfully", err
	}
}
```

We put our code in a goroutine so we can track it via a channel. We monitor both the context status and the goroutine 
execution by storing the error returned in the channel.

If the context expired, we return the context error and the goroutine is killed as we exit the function.

Client:
```
curl localhost:8080/get-value

Error happened: context deadline exceeded
```

Server:
```
starting handleGetValue
executeHandleGetValue started
Error happened:  context deadline exceeded
finished executing handleGetNumber
executeHandleGetValue ended
```
