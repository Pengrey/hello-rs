mod bld_logger {
    #[macro_export]
    macro_rules! info {
        ($content:expr) => {
            println!("cargo::warning=\r[{}] {}", "\x1b[34m^\x1b[0m", $content);
        };
    }
}

fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed=scripts/linker.ld");
    info!("Using custom linker script...");
    println!("cargo:rustc-link-arg=-T{}/scripts/linker.ld", std::env::current_dir().unwrap().display());
}
