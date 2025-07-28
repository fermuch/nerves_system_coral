# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains the Nerves System configuration for the Google Coral Dev Board, a machine learning-enabled single board computer with an ARM Cortex-A53 quad-core CPU and NPU (Neural Processing Unit) capable of 2.3 TOPS.

This is a **Nerves System** - not an application but a foundational Linux system configuration that other Nerves projects depend on. The system is built using Buildroot and provides the base Linux kernel, drivers, and system packages needed to run Elixir/Erlang applications on the Coral hardware.

## Architecture

### System Structure
- **Root system**: Defines the base Nerves system using Buildroot (mix.exs, nerves_defconfig)
- **Demo application**: Example Nerves app in `/demo` that depends on this system
- **Hardware configuration**: Linux kernel config, U-Boot config, device tree specifications
- **Firmware packaging**: FWUP configuration for creating flashable firmware images

### Key Components
- **Buildroot configuration** (`nerves_defconfig`): Defines all system packages, kernel config, toolchain
- **Linux kernel**: Custom 6.1 kernel from NXP's i.MX fork with Coral-specific patches
- **U-Boot bootloader**: Custom configuration for the i.MX8MQ SoC
- **ARM Trusted Firmware**: Low-level boot firmware for secure world initialization
- **FWUP configuration**: Defines partition layout and upgrade procedures

## Development Commands

### Building the System
```bash
# Build the entire Nerves system (takes 1-2 hours first time)
mix compile
```

Always ask the user for building the system instead of building it yourself.

### Demo Application Commands
```bash
cd demo/

# Get dependencies and compile for target
export MIX_TARGET=nerves_system_coral
mix deps.get
# Always ask the user to run `mix firmware` instead of doing it yourself.
mix firmware

# Create firmware file for flashing
# Always ask the user to run `mix firmware` instead of doing it yourself.
mix firmware.burn

# For development/testing on host
export MIX_TARGET=host
mix deps.get
mix test
```

### Linting and Validation
```bash
# Run Nerves system linter to validate configuration
mix nerves.system.lint

# Generate documentation
mix docs
```

### Configuration Management
```bash
# Load and apply defconfig changes
mix nerves.loaddefconfig

# View current Buildroot configuration
make -C _build/nerves_system_coral_dev/buildroot-* menuconfig
```

## Important Files and Directories

- `nerves_defconfig`: Main Buildroot configuration defining all system packages and settings
- `linux/linux-6.1.defconfig`: Linux kernel configuration
- `uboot/uboot.defconfig`: U-Boot bootloader configuration  
- `fwup.conf`: Firmware update configuration and partition layout
- `post-build.sh`, `post-createfs.sh`: Build scripts for system customization
- `rootfs_overlay/`: Files to be copied directly into the root filesystem
- `patches/`: System-level patches applied during build

## Build Process Notes

- Uses external ARM64 toolchain from Nerves project
- Enables ccache for faster rebuilds (stored in `~/.buildroot-ccache`)
- Downloads sources from NXP's i.MX repositories for kernel and U-Boot
- Applies hardware-specific patches during build
- Creates both development and production firmware variants

## Testing

The demo application includes basic functionality testing. For the system itself:
- Boot testing is done by flashing to actual hardware
- No automated unit tests exist for the system configuration
- Validation happens through the nerves_system_linter dependency

## Target Hardware Specifics

- **SoC**: NXP i.MX8MQ (ARM Cortex-A53 + Cortex-M7)
- **Neural Processor**: Google Edge TPU
- **Boot**: U-Boot -> ARM Trusted Firmware -> Linux kernel
- **Storage**: eMMC with custom partition layout via FWUP
- **Connectivity**: Ethernet, WiFi, Bluetooth
- **Interfaces**: UART console on ttymxc1, GPIO/I2C/SPI via Elixir Circuits