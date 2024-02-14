+++
title = "Rustlings - Solutions"
date = 2023-10-05

[taxonomies]
tags = ["rust", "learning"]
+++

[Rustlings](https://github.com/rust-lang/rustlings/tree/main) is a nice project presenting you with a serie of small
exercises to learn most of the concept of the languages. From declaring variables to more advances concepts. You are
presented with a failing program and should fix it in order to compile.

<!-- more -->

Below are my solutions, maybe it'll help someone, possibly future me who knows.

[intro2.rs](#intro2-rs)  

[variables1.rs](#variables-variables1-rs)  
[variables2.rs](#variables-variables2-rs)  
[variables3.rs](#variables-variables3-rs)  
[variables4.rs](#variables-variables4-rs)  
[variables5.rs](#variables-variables5-rs)  
[variables6.rs](#variables-variables6-rs)  

[functions1.rs](#functions-functions1-rs)  
[functions2.rs](#functions-functions2-rs)  
[functions3.rs](#functions-functions3-rs)  
[functions4.rs](#functions-functions4-rs)  
[functions5.rs](#functions-functions5-rs)  

[if1.rs](#if-if1-rs)  
[if2.rs](#if-if2-rs)  
[if3.rs](#if-if3-rs)  

[quiz1.rs](#quiz1-rs)

[primitive_types1.rs](#primitive-types-primitive-types-1-rs)  
[primitive_types2.rs](#primitive-types-primitive-types-2-rs)  
[primitive_types3.rs](#primitive-types-primitive-types-3-rs)  
[primitive_types4.rs](#primitive-types-primitive-types-4-rs)  
[primitive_types5.rs](#primitive-types-primitive-types-5-rs)  
[primitive_types6.rs](#primitive-types-primitive-types-6-rs)  

[vecs1.rs](#vecs-vecs1-rs)  
[vecs2.rs](#vecs-vecs2-rs)  

[move_semantics1.rs](#move-semantics-move-semantics1-rs)  
[move_semantics2.rs](#move-semantics-move-semantics2-rs)  
[move_semantics3.rs](#move-semantics-move-semantics3-rs)  
[move_semantics4.rs](#move-semantics-move-semantics4-rs)  
[move_semantics5.rs](#move-semantics-move-semantics5-rs)  
[move_semantics6.rs](#move-semantics-move-semantics6-rs)  

[structs1.rs](#structs-structs1-rs)  
[structs2.rs](#structs-structs2-rs)  
[structs3.rs](#structs-structs3-rs)  

[enums1.rs](#enums-enums1-rs)  
[enums2.rs](#enums-enums2-rs)  
[enums3.rs](#enums-enums3-rs)  

[strings1.rs](#strings-strings1-rs)  
[strings2.rs](#strings-strings2-rs)  
[strings3.rs](#strings-strings3-rs)  
[strings4.rs](#strings-strings4-rs)  

[modules1.rs](#modules-modules1-rs)  
[modules2.rs](#modules-modules2-rs)  
[modules3.rs](#modules-modules3-rs)  

[hashmaps1.rs](#hashmaps-hashmaps1-rs)  
[hashmaps2.rs](#hashmaps-hashmaps2-rs)  
[hashmaps3.rs](#hashmaps-hashmaps3-rs)  

TBC.

### intro2.rs
Needed to add an argument to the `println` macro. Or remove the expected argument I guess.

```rs
// Make the code print a greeting to the world.
fn main() {
    println!("Hello {}!", "world");
}
```

### variables/variables1.rs
We need to define `x` using `let`.
```rs
// Make me compile
fn main() {
    let x = 5;
    println!("x has the value {}", x);
}
```

### variables/variables2.rs
`x` was not initialized. You can change leave the default type like I did or specify whatever you want (as long as it's
comparable to `10`).
```rs
fn main() {
    let x = 0;
    if x == 10 {
        println!("x is ten!");
    } else {
        println!("x is not ten!");
    }
}
```

### variables/variables3.rs
`x` needs to be assigned a value before being used.
```rs
fn main() {
    let x: i32 = 12;
    println!("Number {}", x);
}
```

### variables/variables4.rs
Variables are immutable by default, here we want to change the value so we need to initialize the variable as mutable.
```rs
fn main() {
    let mut x = 3;
    println!("Number {}", x);
    x = 5; // don't change this line
    println!("Number {}", x);
}
```

### variables/variables5.rs
Here we "shadow" `x` by re-declaring another variable with the same name.
```rs
fn main() {
    let number = "T-H-R-E-E"; // don't change this line
    println!("Spell a Number : {}", number);
    let number = 3;
    println!("Number plus two is : {}", number + 2);
}
```

### variables/variables6.rs
A `const` need to be typed.
```rs
const NUMBER: usize = 3;
fn main() {
    println!("Number {}", NUMBER);
}
```

### functions/functions1.rs
We need to define the function `call_me` with no arguments and nothing returned.
```rs
fn main() {
    call_me();
}

fn call_me() {
    println!("Call me!");
}
```

### functions/functions2.rs
We need to type the function's argument `num`. Could be any number types.
```rs
fn main() {
    call_me(3);
}

fn call_me(num: i32) {
    for i in 0..num {
        println!("Ring! Call number {}", i + 1);
    }
}
```

### functions/functions3.rs
This one is the kind of the reverse, we cannot call a function without passing the expected arguments.
```rs
fn main() {
    call_me(4);
}

fn call_me(num: u32) {
    for i in 0..num {
        println!("Ring! Call number {}", i + 1);
    }
}
```

### functions/functions4.rs
Here we are missing the return type of `sale_price`. Have to be the same as the argument given because we are returning
either `price - 10` or `price - 3` which would be the same type as `price`.
```rs
// This store is having a sale where if the price is an even number, you get 10
// Rustbucks off, but if it's an odd number, it's 3 Rustbucks off. (Don't worry
// about the function bodies themselves, we're only interested in the signatures
// for now. If anything, this is a good way to peek ahead to future exercises!)

fn main() {
    let original_price = 51;
    println!("Your sale price is {}", sale_price(original_price));
}

fn sale_price(price: i32) -> i32 {
    if is_even(price) {
        price - 10
    } else {
        price - 3
    }
}

fn is_even(num: i32) -> bool {
    num % 2 == 0
}
```

### functions/functions5.rs
Here they probably want us to remove the `;` and therefore returning the statement. I don't like this syntax so let's
just add the `return` keyword like gentlemen.
```rs
fn main() {
    let answer = square(3);
    println!("The square of 3 is {}", answer);
}

fn square(num: i32) -> i32 {
    return num * num;
}
```

### if/if1.rs
```rs
pub fn bigger(a: i32, b: i32) -> i32 {
    // Complete this function to return the bigger number!
    // Do not use:
    // - another function call
    // - additional variables

    if a > b {
        return a;
    } else {
        return b;
    }
}
```

### if/if2.rs
```rs
// Step 1: Make me compile!
// Step 2: Get the bar_for_fuzz and default_to_baz tests passing!
//
pub fn foo_if_fizz(fizzish: &str) -> &str {
    if fizzish == "fizz" {
        return "foo";
    } else if fizzish == "fuzz" {
        return "bar";
    }

    return "baz";
}
```

### if/if3.rs
The `if` statement defining `identifier` was returning different types, which is fine however `identifier` is used 
below as comparison to integers, therefore we need to ensure that identifier is an `int` all the time.
```rs
pub fn animal_habitat(animal: &str) -> &'static str {
    let identifier = if animal == "crab" {
        1
    } else if animal == "gopher" {
        2
    } else if animal == "snake" {
        3
    } else {
        0
    };

    // DO NOT CHANGE THIS STATEMENT BELOW
    let habitat = if identifier == 1 {
        "Beach"
    } else if identifier == 2 {
        "Burrow"
    } else if identifier == 3 {
        "Desert"
    } else {
        "Unknown"
    };

    habitat
}
```

### quiz1.rs
```rs
// Mary is buying apples. The price of an apple is calculated as follows:
// - An apple costs 2 rustbucks.
// - If Mary buys more than 40 apples, each apple only costs 1 rustbuck!
// Write a function that calculates the price of an order of apples given the
// quantity bought.
//

// Put your function here!
fn calculate_price_of_apples(num: i32) -> i32 {
    let price_per_apple = if num > 40 { 1 } else { 2 };

    return num * price_per_apple;
}
```

### primitive_types/primitive_types_1.rs
```rs
// Fill in the rest of the line that has code missing! No hints, there's no
// tricks, just get used to typing these :)

fn main() {
    // Booleans (`bool`)

    let is_morning = true;
    if is_morning {
        println!("Good morning!");
    }

    let is_evening = false;
    if is_evening {
        println!("Good evening!");
    }
}
```

### primitive_types/primitive_types_2.rs
```rs
// Fill in the rest of the line that has code missing! No hints, there's no
// tricks, just get used to typing these :)
fn main() {
    // Characters (`char`)

    // Note the _single_ quotes, these are different from the double quotes
    // you've been seeing around.
    let my_first_initial = 'C';
    if my_first_initial.is_alphabetic() {
        println!("Alphabetical!");
    } else if my_first_initial.is_numeric() {
        println!("Numerical!");
    } else {
        println!("Neither alphabetic nor numeric!");
    }

    // Finish this line like the example! What's your favorite character?
    // Try a letter, try a number, try a special character, try a character
    // from a different language than your own, try an emoji!
    let your_character = '5';
    if your_character.is_alphabetic() {
        println!("Alphabetical!");
    } else if your_character.is_numeric() {
        println!("Numerical!");
    } else {
        println!("Neither alphabetic nor numeric!");
    }
}
```

### primitive_types/primitive_types_3.rs
```rs
// Create an array with at least 100 elements in it where the ??? is.
//
fn main() {
    let a = ["hello"; 150];

    if a.len() >= 100 {
        println!("Wow, that's a big array!");
    } else {
        println!("Meh, I eat arrays like that for breakfast.");
        panic!("Array not big enough, more elements needed")
    }
}
```

### primitive_types/primitive_types_4.rs
```rs
// Get a slice out of Array a where the ??? is so that the test passes.
#[test]
fn slice_out_of_array() {
    let a = [1, 2, 3, 4, 5];

    let nice_slice = &a[1..4];

    assert_eq!([2, 3, 4], nice_slice)
}
```

### primitive_types/primitive_types_5.rs
Note that you can also destructure it directly when declaring cat, and do:  
`let (name, age) = ("Furry McFurson", 3.5);`.
```rs
// Destructure the `cat` tuple so that the println will work.
fn main() {
    let cat = ("Furry McFurson", 3.5);
    let (name, age) = cat;

    println!("{} is {} years old.", name, age);
}
```

### primitive_types/primitive_types_6.rs
```rs
// Use a tuple index to access the second element of `numbers`. You can put the
// expression for the second element where ??? is so that the test passes.
//
#[test]
fn indexing_tuple() {
    let numbers = (1, 2, 3);
    // Replace below ??? with the tuple indexing syntax.
    let second = numbers.1;

    assert_eq!(2, second, "This is not the 2nd number in the tuple!")
}
```

### vecs/vecs1.rs
```rs
// Your task is to create a `Vec` which holds the exact same elements as in the
// array `a`.
//
// Make me compile and pass the test!
fn array_and_vec() -> ([i32; 4], Vec<i32>) {
    let a = [10, 20, 30, 40]; // a plain array
    let v = Vec::from(a);

    (a, v)
}
```

### vecs/vecs2.rs
```rs
// A Vec of even numbers is given. Your task is to complete the loop so that
// each number in the Vec is multiplied by 2.
//
fn vec_loop(mut v: Vec<i32>) -> Vec<i32> {
    for element in v.iter_mut() {
        // TODO: Fill this up so that each element in the Vec `v` is
        // multiplied by 2.
        *element = *element * 2;
    }

    // At this point, `v` should be equal to [4, 8, 12, 16, 20].
    v
}

fn vec_map(v: &Vec<i32>) -> Vec<i32> {
    v.iter()
        .map(|element| {
            // TODO: Do the same thing as above - but instead of mutating the
            // Vec, you can just return the new number!
            return element * 2;
        })
        .collect()
}
```

### move_semantics/move_semantics1.rs
Cannot push to an immutable `Vec`.  
Furthermore, as the hint suggest, if we try to access `vec0` in `main` after using `fill_vec`, we get an error 
indicating that `vec0` was moved to `fill_vec`.
```rs
// Execute `rustlings hint move_semantics1` or use the `hint` watch subcommand
// for a hint.
#[test]
fn main() {
    let vec0 = vec![22, 44, 66];

    let vec1 = fill_vec(vec0);

    assert_eq!(vec1, vec![22, 44, 66, 88]);
}

fn fill_vec(vec: Vec<i32>) -> Vec<i32> {
    let mut vec = vec;

    vec.push(88);

    vec
}
```

### move_semantics/move_semantics2.rs
We pass a reference to `fill_vec` instead of a value so the ownership does not change, and then `clone` the value to 
initiate our vector without issue.
```rs
// Make the test pass by finding a way to keep both Vecs separate!
//
#[test]
fn main() {
    let vec0 = vec![22, 44, 66];

    let mut vec1 = fill_vec(&vec0);

    assert_eq!(vec0, vec![22, 44, 66]);
    assert_eq!(vec1, vec![22, 44, 66, 88]);
}

fn fill_vec(vec: &Vec<i32>) -> Vec<i32> {
    let mut vec = vec.clone();

    vec.push(88);

    vec
}
```

### move_semantics/move_semantics3.rs
We've added `mut` in the argument's definition of `fill_vec` to allow us to push into it.
```rs
// Make me compile without adding new lines -- just changing existing lines! (no
// lines with multiple semicolons necessary!)
//
#[test]
fn main() {
    let vec0 = vec![22, 44, 66];

    let vec1 = fill_vec(vec0);

    assert_eq!(vec1, vec![22, 44, 66, 88]);
}

fn fill_vec(mut vec: Vec<i32>) -> Vec<i32> {
    vec.push(88);

    vec
}
```

### move_semantics/move_semantics4.rs
Simply move the vector initialization to the `fill_vec` function as asked.
```rs
// Refactor this code so that instead of passing `vec0` into the `fill_vec`
// function, the Vector gets created in the function itself and passed back to
// the main function.
//
#[test]
fn main() {
    let mut vec1 = fill_vec();

    assert_eq!(vec1, vec![22, 44, 66, 88]);
}

// `fill_vec()` no longer takes `vec: Vec<i32>` as argument - don't change this!
fn fill_vec() -> Vec<i32> {
    // Instead, let's create and fill the Vec in here - how do you do that?
    let mut vec = vec![22, 44, 66];

    vec.push(88);

    vec
}
```

### move_semantics/move_semantics5.rs
Only one borrow can be active at the same time. In the original order, `y` was unusable once we initialize `z` as it's
borrowing the same original value. We need to make sure to finish everything we want to do with `y` before declaring `z`.
```rs
// Make me compile only by reordering the lines in `main()`, but without adding,
// changing or removing any of them.
//
#[test]
fn main() {
    let mut x = 100;
    let y = &mut x;
    *y += 100;
    let z = &mut x;
    *z += 1000;
    assert_eq!(x, 1200);
}
```

### move_semantics/move_semantics6.rs
We had `get_char` take ownership of `data` and `string_uppercase` taking a reference while we need the other way
around.
```rs
// You can't change anything except adding or removing references.
//
fn main() {
    let data = "Rust is great!".to_string();

    get_char(&data);

    string_uppercase(data);
}

// Should not take ownership
fn get_char(data: &String) -> char {
    data.chars().last().unwrap()
}

// Should take ownership
fn string_uppercase(mut data: String) {
    data = data.to_uppercase();

    println!("{}", data);
}
```

### structs/structs1.rs
```rs
// Address all the TODOs to make the tests pass!
//
struct ColorClassicStruct {
    red: i32,
    green: i32,
    blue: i32,
}

struct ColorTupleStruct(i32, i32, i32);

#[derive(Debug)]
struct UnitLikeStruct;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn classic_c_structs() {
        // TODO: Instantiate a classic c struct!
        let green = ColorClassicStruct {
            red: 0,
            green: 255,
            blue: 0,
        };

        assert_eq!(green.red, 0);
        assert_eq!(green.green, 255);
        assert_eq!(green.blue, 0);
    }

    #[test]
    fn tuple_structs() {
        // TODO: Instantiate a tuple struct!
        let green = (0, 255, 0);

        assert_eq!(green.0, 0);
        assert_eq!(green.1, 255);
        assert_eq!(green.2, 0);
    }

    #[test]
    fn unit_structs() {
        // TODO: Instantiate a unit-like struct!
        let unit_like_struct = UnitLikeStruct;
        let message = format!("{:?}s are fun!", unit_like_struct);

        assert_eq!(message, "UnitLikeStructs are fun!");
    }
}
```

### structs/structs2.rs
```rs
// Address all the TODOs to make the tests pass!
//
#[derive(Debug)]
struct Order {
    name: String,
    year: u32,
    made_by_phone: bool,
    made_by_mobile: bool,
    made_by_email: bool,
    item_number: u32,
    count: u32,
}

fn create_order_template() -> Order {
    Order {
        name: String::from("Bob"),
        year: 2019,
        made_by_phone: false,
        made_by_mobile: false,
        made_by_email: true,
        item_number: 123,
        count: 0,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn your_order() {
        let order_template = create_order_template();
        // TODO: Create your own order using the update syntax and template above!
        let your_order = Order {
            name: String::from("Hacker in Rust"),
            count: 1,
            ..order_template
        };
        assert_eq!(your_order.name, "Hacker in Rust");
        assert_eq!(your_order.year, order_template.year);
        assert_eq!(your_order.made_by_phone, order_template.made_by_phone);
        assert_eq!(your_order.made_by_mobile, order_template.made_by_mobile);
        assert_eq!(your_order.made_by_email, order_template.made_by_email);
        assert_eq!(your_order.item_number, order_template.item_number);
        assert_eq!(your_order.count, 1);
    }
}
```

### structs/structs3.rs
```rs
// Structs contain data, but can also have logic. In this exercise we have
// defined the Package struct and we want to test some logic attached to it.
// Make the code compile and the tests pass!
//
// Execute `rustlings hint structs3` or use the `hint` watch subcommand for a
// hint.

// I AM NOT DONE

#[derive(Debug)]
struct Package {
    sender_country: String,
    recipient_country: String,
    weight_in_grams: u32,
}

impl Package {
    fn new(sender_country: String, recipient_country: String, weight_in_grams: u32) -> Package {
        if weight_in_grams < 10 {
            // This is not how you should handle errors in Rust,
            // but we will learn about error handling later.
            panic!("Can not ship a package with weight below 10 grams.")
        } else {
            Package {
                sender_country,
                recipient_country,
                weight_in_grams,
            }
        }
    }

    fn is_international(&self) -> bool {
        return self.recipient_country != self.sender_country;
    }

    fn get_fees(&self, cents_per_gram: u32) -> u32 {
        return self.weight_in_grams * cents_per_gram;
    }
}
```

### enums/enums1.rs
```rs
#[derive(Debug)]
enum Message {
    Quit,
    Echo,
    Move,
    ChangeColor,
}

fn main() {
    println!("{:?}", Message::Quit);
    println!("{:?}", Message::Echo);
    println!("{:?}", Message::Move);
    println!("{:?}", Message::ChangeColor);
}
```

### enums/enums2.rs
```rs
#[derive(Debug)]
enum Message {
    // TODO: define the different variants used below
    Move { x: i32, y: i32 },
    Echo(String),
    ChangeColor(i32, i32, i32),
    Quit,
}

impl Message {
    fn call(&self) { println!("{:?}", self);
    }
}

fn main() {
    let messages = [
        Message::Move { x: 10, y: 30 },
        Message::Echo(String::from("hello world")),
        Message::ChangeColor(200, 255, 255),
        Message::Quit,
    ];

    for message in &messages {
        message.call();
    }
}
```

### enums/enums3.rs
Here we need to make sure to use `u8` when defining the `ChangeColor` enum, as in the state implementation that's how
color is defined.

```rs
enum Message {
    // TODO
    Echo(String),
    ChangeColor(u8, u8, u8),
    Move(Point),
    Quit,
}

struct Point {
    x: u8,
    y: u8,
}

struct State {
    color: (u8, u8, u8),
    position: Point,
    quit: bool,
    message: String,
}

impl State {
    fn change_color(&mut self, color: (u8, u8, u8)) {
        self.color = color;
    }

    fn quit(&mut self) {
        self.quit = true;
    }

    fn echo(&mut self, s: String) {
        self.message = s
    }

    fn move_position(&mut self, p: Point) {
        self.position = p;
    }

    fn process(&mut self, message: Message) {
        // TODO: create a match expression to process the different message
        // variants
        // Remember: When passing a tuple as a function argument, you'll need
        // extra parentheses: fn function((t, u, p, l, e))

        match message {
            Message::Quit => self.quit = true,
            Message::ChangeColor(r, g, b) => self.change_color((r, g, b)),
            Message::Echo(str) => self.echo(str),
            Message::Move(p) => self.move_position(p),
        }
    }
}
```

### strings/strings1.rs
```rs
// Make me compile without changing the function signature!
//

fn main() {
    let answer = current_favorite_color();
    println!("My current favorite color is {}", answer);
}

fn current_favorite_color() -> String {
    return String::from("blue");
}
```

### strings/strings2.rs
```rs
// Make me compile without changing the function signature!
//
fn main() {
    let word = String::from("green"); // Try not changing this line :)
    if is_a_color_word(word.as_str()) {
        println!("That is a color word I know!");
    } else {
        println!("That is not a color word I know.");
    }
}

fn is_a_color_word(attempt: &str) -> bool {
    attempt == "green" || attempt == "blue" || attempt == "red"
}
```

### strings/strings3.rs
```rs
fn trim_me(input: &str) -> String {
    // TODO: Remove whitespace from both ends of a string!
    return input.trim().to_string();
}

fn compose_me(input: &str) -> String {
    // TODO: Add " world!" to the string! There's multiple ways to do this!
    return input.to_owned() + " world!";
    // return format!("{} world!", input);
}

fn replace_me(input: &str) -> String {
    // TODO: Replace "cars" in the string with "balloons"!
    return input.replace("cars", "balloons");
}
```

### strings/strings4.rs
```rs
// Ok, here are a bunch of values-- some are `String`s, some are `&str`s. Your
// task is to call one of these two functions on each value depending on what
// you think each value is. That is, add either `string_slice` or `string`
// before the parentheses on each line. If you're right, it will compile!
//
fn string_slice(arg: &str) {
    println!("{}", arg);
}
fn string(arg: String) {
    println!("{}", arg);
}

fn main() {
    string_slice("blue");
    string("red".to_string());
    string(String::from("hi"));
    string("rust is fun!".to_owned());
    string_slice("nice weather".into());
    string(format!("Interpolation {}", "Station"));
    string_slice(&String::from("abc")[0..1]);
    string_slice("  hello there ".trim());
    string("Happy Monday!".to_string().replace("Mon", "Tues"));
    string("mY sHiFt KeY iS sTiCkY".to_lowercase());
}
```

### modules/modules1.rs
Functions in a module are private by default, so here we just need to make `make_sausage` public to be used in the 
`main` function.
```rs
mod sausage_factory {
    // Don't let anybody outside of this module see this!
    fn get_secret_recipe() -> String {
        String::from("Ginger")
    }

    pub fn make_sausage() {
        get_secret_recipe();
        println!("sausage!");
    }
}

fn main() {
    sausage_factory::make_sausage();
}
```

### modules/modules2.rs
We need to two changes here, replace both `???` with the name used in the `main` function (`fruit` and `veggie`). We
also need to make those public in order to be able to use it outside of the module.
```rs
// You can bring module paths into scopes and provide new names for them with
// the 'use' and 'as' keywords. Fix these 'use' statements to make the code
// compile.
mod delicious_snacks {
    // TODO: Fix these use statements
    pub use self::fruits::PEAR as fruit;
    pub use self::veggies::CUCUMBER as veggie;

    mod fruits {
        pub const PEAR: &'static str = "Pear";
        pub const APPLE: &'static str = "Apple";
    }

    mod veggies {
        pub const CUCUMBER: &'static str = "Cucumber";
        pub const CARROT: &'static str = "Carrot";
    }
}

fn main() {
    println!(
        "favorite snacks: {} and {}",
        delicious_snacks::fruit,
        delicious_snacks::veggie
    );
}
```

### modules/modules3.rs
```rs
// You can use the 'use' keyword to bring module paths from modules from
// anywhere and especially from the Rust standard library into your scope. Bring
// SystemTime and UNIX_EPOCH from the std::time module. Bonus style points if
// you can do it with one line!
//
// TODO: Complete this use statement
use std::time::{SystemTime, UNIX_EPOCH};

fn main() {
    match SystemTime::now().duration_since(UNIX_EPOCH) {
        Ok(n) => println!("1970-01-01 00:00:00 UTC was {} seconds ago!", n.as_secs()),
        Err(_) => panic!("SystemTime before UNIX EPOCH!"),
    }
}
```

### hashmaps/hashmaps1.rs
```rs
// A basket of fruits in the form of a hash map needs to be defined. The key
// represents the name of the fruit and the value represents how many of that
// particular fruit is in the basket. You have to put at least three different
// types of fruits (e.g apple, banana, mango) in the basket and the total count
// of all the fruits should be at least five.
//
use std::collections::HashMap;

fn fruit_basket() -> HashMap<String, u32> {
    let mut basket = HashMap::new();

    // Two bananas are already given for you :)
    basket.insert(String::from("banana"), 2);

    // TODO: Put more fruits in your basket here.
    basket.insert(String::from("mango"), 6);
    basket.insert(String::from("apple"), 9);

    basket
}
```

### hashmaps/hashmaps2.rs
Adding `4` of each type of fruit is arbitraty, could be anything, could be randomize, as long as it's more than 11 total 
as per the requirement.
```rs
// We're collecting different fruits to bake a delicious fruit cake. For this,
// we have a basket, which we'll represent in the form of a hash map. The key
// represents the name of each fruit we collect and the value represents how
// many of that particular fruit we have collected. Three types of fruits -
// Apple (4), Mango (2) and Lychee (5) are already in the basket hash map. You
// must add fruit to the basket so that there is at least one of each kind and
// more than 11 in total - we have a lot of mouths to feed. You are not allowed
// to insert any more of these fruits!
//
use std::collections::HashMap;

#[derive(Hash, PartialEq, Eq)]
enum Fruit {
    Apple,
    Banana,
    Mango,
    Lychee,
    Pineapple,
}

fn fruit_basket(basket: &mut HashMap<Fruit, u32>) {
    let fruit_kinds = vec![
        Fruit::Apple,
        Fruit::Banana,
        Fruit::Mango,
        Fruit::Lychee,
        Fruit::Pineapple,
    ];

    for fruit in fruit_kinds {
        // basket. Note that you are not allowed to put any type of fruit that's
        // already present!
        if !basket.contains_key(&fruit) {
            basket.insert(fruit, 4);
        }
    }
}
```

### hashmaps/hashmaps3.rs
I extracted the logic of updating the score of a team in a separate function, but you could have duplicated it for 
`team_1` and `team_2` in the `build_scores_table` function directly.
```rs
// A list of scores (one per line) of a soccer match is given. Each line is of
// the form : "<team_1_name>,<team_2_name>,<team_1_goals>,<team_2_goals>"
// Example: England,France,4,2 (England scored 4 goals, France 2).
//
// You have to build a scores table containing the name of the team, goals the
// team scored, and goals the team conceded. One approach to build the scores
// table is to use a Hashmap. The solution is partially written to use a
// Hashmap, complete it to pass the test.

use std::collections::HashMap;

// A structure to store the goal details of a team.
struct Team {
    goals_scored: u8,
    goals_conceded: u8,
}

fn build_scores_table(results: String) -> HashMap<String, Team> {
    // The name of the team is the key and its associated struct is the value.
    let mut scores: HashMap<String, Team> = HashMap::new();

    for r in results.lines() {
        let v: Vec<&str> = r.split(',').collect();
        let team_1_name = v[0].to_string();
        let team_1_score: u8 = v[2].parse().unwrap();
        let team_2_name = v[1].to_string();
        let team_2_score: u8 = v[3].parse().unwrap();
        // TODO: Populate the scores table with details extracted from the
        // current line. Keep in mind that goals scored by team_1
        // will be the number of goals conceded from team_2, and similarly
        // goals scored by team_2 will be the number of goals conceded by
        // team_1.

        add_team_scores(
            &mut scores,
            team_1_name.to_string(),
            team_1_score,
            team_2_score,
        );
        add_team_scores(
            &mut scores,
            team_2_name.to_string(),
            team_2_score,
            team_1_score,
        );
    }
    scores
}

fn add_team_scores(scores: &mut HashMap<String, Team>, name: String, scored: u8, conceded: u8) {
    let team = scores.entry(name).or_insert(Team {
        goals_scored: 0,
        goals_conceded: 0,
    });

    team.goals_conceded += conceded;
    team.goals_scored += scored;
}
```
