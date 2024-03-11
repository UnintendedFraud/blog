+++
title = "Understanding Go context"
date = 2024-03-11

[taxonomies]
tags = ["go", "learning", "context", "channels"]
+++

Go contexts are a good candidate for something you can use without understanding it. When you see that a context is expected 
in a function's definition, you can pass the request's context, or `context.Background()` and call it a day. If you're feeling 
a little crazy you pass a context with a timeout, and it magically work as expected. Here we will try to see the main usages 
of context (timeout and passing values), but also try to implement a function using a context and see how the implementation 
look like.

<!-- more -->

From the official documentation ([https://pkg.go.dev/context](https://pkg.go.dev/context)), we can highlight:

*"Incoming requests to a server should create a Context, and outgoing calls to servers should accept a Context. 
The chain of function calls between them must propagate the Context, optionally replacing it with a derived 
Context [...] When a Context is canceled, all Contexts derived from it are also canceled."*

From this we already understand multiple things:
- requests usually make heavy use of context, probably where they will be encountered the most
- a context can have children 
- if a parent is cancelled, the children are too

If you want to have more details and visualise it, I would recommend this talk: 
[The context package internals - Damiano Petrungaro](https://www.youtube.com/watch?v=mfgBhGu5pco).

Let's see in our own examples how to use context, for timeouts and adding data to a request.

1. [Overview of our simple server](#1-overview-of-our-simple-server)
2. [Use context to pass request-related data to the endpoint](#2-use-context-to-pass-request-related-data-to-the-endpoint)
3. [Use context for timeout](#3-use-context-for-timeout)
4. [Some tweaked examples](#4-some-tweaked-examples)

## 1. Overview of our simple server

Our examples will be requests related so we need a server. Go has a very useful `http` package to do that, I took the liberty 
to create a wrapper around it to handle middlewares easier.
```go
type ServerHandler func(http.Handler) http.Handler

type Server struct {}

func (s *Server) Handle(addr string, handlers ...ServerHandler) {
	http.Handle(addr, handleMiddlewares(handlers))
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
This allows us to add middlewares in a more readable way than the default.  
`http.Handle(path, middleware1, middleware2, handler)` instead of the default 
`http.Handle(path, middleware1(middleware2(handler)))`.

## 2. Use context to pass request-related data to the endpoint

It is important to note that the doc specify:  
*"Use context Values only for request-scoped data that transits processes and APIs, not for passing optional 
parameters to functions."*

My example will technically not do that, but it should highlight the principle. In real life, 
I've used it to add user-related data to the request, a third-party API client ready to go, things like that. 
I'm sure there are other ways to take advantage of it.

```go
const PORT = 8080

func main() {
	server := &Server{}

	server.Handle("/get-value", addValueToContext, handleGetValue)

	if err := server.Listen(PORT); err != nil {
		panic(err)
	}
	fmt.Println("listening on :", PORT)
}
```

Here we create our server, have a route `/get-value`, a middleware that will add values to the request's context, and the 
route handler that will read from the context and return the values.

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
				"You get the idea",
			},
		}

		ctx3 := context.WithValue(ctx2, "complex_struct", cs)

		next.ServeHTTP(w, r.WithContext(ctx3))
	})
}
```



Here we store 3 values in the context. I added a number, a string and a custom struct to show that we can store anything 
we need.

If you look closely, you'll notice that we create a new context every time. Context can only contain one value, and all 
of their constructor methods expect a context and return a child from that context.  

Here `ctx3` is the "youngest" child, which we pass onto the next step. Below is our route handler: 

```go 
func handleGetValue(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		n := r.Context().Value("number")
		str := r.Context().Value("sad_message")
		complex := r.Context().Value("complex_struct")
		undefined := r.Context().Value("value does not exist")

		w.Write([]byte(fmt.Sprintf("\n number: [%d]", n)))
		w.Write([]byte(fmt.Sprintf("\n message: [%s]", str)))
		w.Write([]byte(fmt.Sprintf("\n complex struct: [%+v]", complex)))
		w.Write([]byte(fmt.Sprintf("\n undefined value: [%+v] \n", undefined)))
	})
}
```

We retrieve the values and write them to the client.  
For good measures I added a value that does not exist to see what happens (spoiler: it's `nil`).  

For simplicity, I will just curl our endpoint from the terminal:
```
curl localhost:8080/get-value

number: [420]
message: [RIP Toriyama :(]
complex struct: [{question:What is your favourite Dragon Ball character? possibleAnswers:[Goku Gohan Vegeta You get the idea]}]
undefined value: [<nil>]
```

We get all of our values as expected.  

You may wonder how did we retrieve all of the values, when we passed the youngest context `ctx3` that only contains the 
complex struct. This is because instead of seeing contexts as individual object, we should see them as one branch of a tree,
starting at the original one (usually `context.Background()`), all the way down to the context we are interacting with 
in our code. Here our full context is really:
```
context.Background() -> r.Context() -> ctx1 -> ctx2 -> ctx3
```
When we query a value, Go will look in the immediate context, and move up one level all the way to the top if 
the value is not found. For example, this is what happen when looking up the value "number":  
1. check the value "numbers" in `ctx3`, it is not there (it is "complex_struct")
2. check the value "numbers" in `ctx2`, it is not there (it is "message")
3. check the value "numbers" in `ctx1`, found

If we attached `ctx2` to our request instead of `ctx3`, then the curl would show `nil` for the complex struct, because `ctx3` would not 
be checked.

## 3. Use context for timeout 

Probably the main reason to use context: timeout and deadlines. Making sure we're not hanging somewhere for too long.

In this example, we'll forget about our context values, and update our route handler to mimic some long operation using 
context. The handler looks like this now:
```go 
func handleGetValue(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Println(t(), "handleGetValue started")
		defer log.Println(t(), "handleGetNumber ended")

		ctx, cancelCtx := context.WithTimeout(r.Context(), 2*time.Second)
		defer cancelCtx()

		err := someLongAction(ctx)
		if err != nil {
			w.Write([]byte(fmt.Sprintf("\n%s - Error happened: %s", t(), err.Error())))
			log.Println(t(), "Error happened: ", err)
			return
		}

		w.Write([]byte(fmt.Sprintf("%s -- operation finished successfully", t())))
	})
}
```
First we need to create a new context that include a timeout. What it means internally is that the context will be cancelled 
once the timeout duration has been reached. It is up to whoever wants to make use of the context to check and return an error 
if that happen.

In our example, this will be the role of `someLongAction`, it should return an error if the context expires. The function 
is defined as:
```go 
func someLongAction(ctx context.Context) error {
	log.Println("someLongAction started")
	defer log.Println("someLongAction ended")

	select {
	case err := <-simulatingOperation():
		return err
	case <-ctx.Done():
		return ctx.Err()
	}
}
```
We wait for whatever happen first: `simulatingOperation()` to finish, or the `ctx` to be done / expired.

```go 
func simulatingOperation() chan error {
	log.Println("simulatingOperation started")
	defer log.Println("simulatingOperation ended")

	chanErr := make(chan error, 1)

	go func() {
		log.Println("goroutine in simulatingOperation started")
		defer log.Println("goroutine in simulatingOperation ended")

		time.Sleep(5 * time.Second)
		chanErr <- nil
	}()

	return chanErr
}
```
The `select` statement cases expect a channel, so our function need to return one. We'll return a channel containing 1 
error, as a real function would probably be suject to fail.

We start a goroutine, sleep for 5 seconds and write the error to the channel at the end. That means that if the timeout 
of the context is more than 5 seconds, we will get the result of `simulatingOperation()`, if not we will propagate the 
context error.

Let's see it in action. Remember above that we set our context timeout to 2 seconds.
```
21:29:57 handleGetValue started
21:29:57 someLongAction started
21:29:57 simulatingOperation started
21:29:57 simulatingOperation ended
21:29:57 goroutine in simulatingOperation started
21:29:59 someLongAction ended
21:29:59 Error happened:  context deadline exceeded
21:29:59 handleGetNumber ended
21:30:02 goroutine in simulatingOperation ended
```
Above are all of server logs, that highlight the execution code in order, with the time on the left to see the effect of 
the sleep and the timeouts.

1. Started request at 29:57
2. The goroutine started sleeping
3. Some long action ended 2 seconds later
4. The error is `context deadline exceeded` as expected
5. Route handler ends right there
6. The goroutine ends after the sleep as expected. I'm not gonna lie, this surprised me at first, I though it would be 
"cancelled" magically, but it does not make sense when you think about it, as it runs concurrently, on its own. Initially 
I was afraid of leaking memory or something like that, it didn't feel good that some useless code is still being executed,
but it's just what it is I think. It's the responsibility of the goroutine to not hang forever.

On our client's side:
```
curl localhost:8080/get-value

21:29:59 - Error happened: context deadline exceeded
```
We can see that we got the correct response, at the right time.

## 4. Some tweaked examples

Below are more examples when I tweaked some values, see what happens.

### 4.1 Increate the timeout to 8 seconds
We should get a successful response after 5 seconds.
```go 
func handleGetValue(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// [...]
		ctx, cancelCtx := context.WithTimeout(r.Context(), 8*time.Second)
        // [...]
	})
}
```

Here are our server logs:
```
22:11:02 handleGetValue started
22:11:02 someLongAction started
22:11:02 simulatingOperation started
22:11:02 simulatingOperation ended
22:11:02 goroutine in simulatingOperation started
22:11:07 goroutine in simulatingOperation ended
22:11:07 someLongAction ended
22:11:07 handleGetNumber ended
```
And our client:
```
curl localhost:8080/get-value

22:11:07 -- operation finished successfully
```
As expected, we get a successful response 5 seconds after initiating the query, no timeout happened.

### 4.2 simulatingOperation returns an error
Keeping it as it is now, make the goroutine returns an error instead.
```go 
func simulatingOperation() chan error {
	// [...]
	go func() {
		// [...]
		chanErr <- fmt.Errorf("something terrible happened, PLEASE HELP!")
	}()
    // [...]
}
```
Running it we get:
```
22:16:53 handleGetValue started
22:16:53 someLongAction started
22:16:53 simlatingOperation started
22:16:53 simlatingOperation ended
22:16:53 goroutine in simulatingOperation started
22:16:58 goroutine in simulatingOperation ended
22:16:58 someLongAction ended
22:16:58 Error happened:  something terrible happened, PLEASE HELP!
22:16:58 handleGetNumber ended
```

```
curl localhost:8080/get-value

22:16:58 - Error happened: something terrible happened, PLEASE HELP!
```
As expected, we get the error after 5 seconds.
