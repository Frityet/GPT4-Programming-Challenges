extern crate chrono;
use chrono::{Local, Timelike};
use std::thread;
use std::time::Duration;

fn main() {
    loop {
        let now = Local::now();
        let hours = now.hour();
        let minutes = now.minute();
        let seconds = now.second();

        print!("\x1B[2J\x1B[1;1H"); // Clear terminal screen
        print_ascii_time(hours, minutes, seconds);

        thread::sleep(Duration::from_secs(1));
    }
}

fn print_ascii_time(hours: u32, minutes: u32, seconds: u32) {
    let numbers = [
        " _     _  _     _  _  _  _  _ ",
        "| |  | _| _||_||_ |_   ||_||_|",
        "|_|  ||_  _|  | _||_|  ||_| _|",
    ];

    let hour_digits = format!("{:0>2}", hours);
    let minute_digits = format!("{:0>2}", minutes);
    let second_digits = format!("{:0>2}", seconds);

    let time_digits = format!("{}:{}:{}", hour_digits, minute_digits, second_digits);

    for row in 0..3 {
        for ch in time_digits.chars() {
            match ch {
                '0'..='9' => {
                    let index = ch.to_digit(10).unwrap() as usize;
                    print!("{}", &numbers[row][index * 3..(index + 1) * 3]);
                }
                ':' => {
                    if row == 1 {
                        print!("o ");
                    } else {
                        print!("  ");
                    }
                }
                _ => (),
            }
        }
        println!();
    }
}
