# Cargo commands
CARGO := cargo +nightly

# Binary paths
BINARY_NAME  := hello
x64_OUT_PATH := target/x86_64-pc-windows-gnu/release/$(BINARY_NAME).exe
x86_OUT_PATH := target/i686-pc-windows-gnu/release/$(BINARY_NAME).exe

# Logger
define log_info
	echo -e "[\033[0;33m*\033[0m] $(1)"
endef

define log_success
	echo -e "[\033[0;32m+\033[0m] Done"
endef

# Targets for different architectures
all: x64 x86
debug: x64-debug x86-debug

# x64 builds
x64:
	@ $(call log_info,[x64] Compiling...)
	@ $(CARGO) build --release --target x86_64-pc-windows-gnu
	@ $(call log_success)
	@ $(call log_info,[x64] Stripping...)
	@ strip --strip-all $(x64_OUT_PATH)
	@ $(call log_success)
	@ $(call log_info,[x64] Removing sections...)
	@ objcopy -R .comment,.note,.eh_fram,.eh_frame,.eh_frame_hdr,.rustc,.cargo,.rmeta $(x64_OUT_PATH)
	@ $(call log_success)

x64-debug:
	@ $(call log_info,[x64|debug] Compiling...)
	@ $(CARGO) build --features debug --target x86_64-pc-windows-gnu
	@ $(call log_success)

# x86 builds
x86:
	@ $(call log_info,[x86] Compiling...)
	@ $(CARGO) build --release --target i686-pc-windows-gnu
	@ $(call log_success)
	@ $(call log_info,[x86] Stripping...)
	@ strip --strip-all $(x86_OUT_PATH)
	@ $(call log_success)
	@ $(call log_info,[x86] Removing sections...)
	@ objcopy -R .comment,.note,.eh_frame,.eh_frame_hdr,.rustc,.cargo,.rmeta $(x86_OUT_PATH)
	@ $(call log_success)

x86-debug:
	@ $(call log_info,[x86|debug] Compiling...)
	@ $(CARGO) build --features debug --target i686-pc-windows-gnu
	@ $(call log_success)

clean:
	@ $(call log_info,Cleaning build artifacts)
	@ rm -rf target
	@ $(call log_success)

.PHONY: all debug x64 x86 x64-debug x86-debug clean
