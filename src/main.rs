#![no_main]
#![no_std]
#![feature(abi_efiapi)]

use uefi::prelude::*;
use core::fmt::Write;


#[entry]
fn main(_handle: Handle, mut system_table: SystemTable<Boot>) -> Status {
    uefi_services::init(&mut system_table).unwrap();

    let stdout = system_table.stdout();
    stdout.clear().unwrap();
    stdout.write_str("Hello, World!").unwrap();

    loop {}
}
