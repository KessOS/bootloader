#![no_main]
#![no_std]
#![feature(abi_efiapi)]

use uefi::prelude::*;
use uefi::CStr16 as c16;
use core::fmt::Write;


#[entry]
fn main(_handle: Handle, mut system_table: SystemTable<Boot>) -> Status {
    uefi_services::init(&mut system_table).unwrap();

    let stdout = system_table.stdout();
    stdout.clear();
    stdout.write_str("Hello, World!");

    loop {}
}
