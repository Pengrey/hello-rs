#![no_std]

#![cfg_attr(not(feature = "debug"), windows_subsystem = "windows")] // only remove the console popup if not debugged

use windows::{core::*, Win32::UI::Shell::*, Win32::UI::WindowsAndMessaging::*};

#[cfg(feature = "debug")]
use print_no_std::println;

fn main() {
    unsafe {
        #[cfg(feature = "debug")]
        println!("[\x1b[33m*\x1b[0m] Using MessageBoxA");
        MessageBoxA(None, s!("Ansi"), s!("World"), MB_OK);

        #[cfg(feature = "debug")]
        println!("[\x1b[33m*\x1b[0m] Using MessageBoxW");
        MessageBoxW(None, h!("WinRT"), h!("World"), MB_OK);

        #[cfg(feature = "debug")]
        println!("[\x1b[33m*\x1b[0m] Using ShellMessageBoxW");
        ShellMessageBoxW(None, None, w!("Wide"), w!("World"), MB_ICONERROR);
    }
}
