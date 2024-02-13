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
