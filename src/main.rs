#![no_std]
#![windows_subsystem = "windows"] // remove the need for a console popup when executed

use windows::{core::*, Win32::UI::Shell::*, Win32::UI::WindowsAndMessaging::*};

fn main() {
    unsafe {
        MessageBoxA(None, s!("Ansi"), s!("World"), MB_OK);
        MessageBoxW(None, h!("WinRT"), h!("World"), MB_OK);
        ShellMessageBoxW(None, None, w!("Wide"), w!("World"), MB_ICONERROR);
    }
}
