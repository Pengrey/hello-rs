use std::path::PathBuf;

mod bld_logger {
    #[macro_export]
    macro_rules! success {
        ($content:expr) => {
            println!("cargo::warning=\r    [{}] {}", "\x1b[32m+\x1b[0m", $content);
        };
    }

    #[macro_export]
    macro_rules! debug {
        ($content:expr) => {
            println!("cargo::warning=\r    [{}] {}", "\x1b[33m*\x1b[0m", $content);
        };
    }
}

fn main() {
    println!("cargo:rerun-if-changed=build.rs");

    let manifest_path: PathBuf = std::env::var("CARGO_MANIFEST_DIR")
    .unwrap()
    .parse()
    .unwrap();

    let _ld = manifest_path
    .parent()
    .unwrap()
    .join("hello-rs/scripts/linker.ld");

    debug!("Using custom linker script...");
    //println!("cargo:rustc-link-arg=-T{}", ld.display());
    success!("Removed sections");
}
