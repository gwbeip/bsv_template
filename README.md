A Template Project for Bluespec SystemVerilog
===
[![State-of-the-art Shitcode](https://img.shields.io/static/v1?label=State-of-the-art&message=Shitcode&color=7B5804)](https://github.com/trekhleb/state-of-the-art-shitcode)

This repository is a template for designing hardware using [Bluespec SystemVerilog](https://github.com/B-Lang-org) (BSV).

## Usage

#### Basic instruction format
```shell
./bsvrun.sh [actions] [options]
```
The `actions` contains a series of operations which are one or more of the following behaviors. The actions are executed in the order they appear.
- `verilog`: generate verilog files;
- `bsim`: compile the simulation using BSV;
- `rbsim`: run the compiled BSV based simulation; need to run `bsim` before running `rbsim`;
- `clean`: remove all the generated files by BSV.

The `options` contains the following options. There is no priority relationship between them.
- `-tm name`: set the top module to `name`;
- `-tf name`: set the file that contains the top module to `name`;
- `-cc N`: set the maximum number of clock cycles in the simulation to `N`; `N` is an integer that bigger than zero;
- `-vcd` dump VCD files in the simulation.

#### Use the profile
The profile `bsvrun.profile` has a lower priority than the command line `options`. You can set some `options`, such as top module and top file, in it to avoid having to manually enter it on the command line every time. `top_file` is searched in the directory that the `src` point to.
