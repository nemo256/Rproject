# Rproject
For a given matrix, this R script will generate its associated Graph depending on the composition.

## Dependencies

> `R` version 3.5 or up is required
### Windows & MacOS
> Install build utilities (https://gcc.gnu.org/install/binaries.html)

### Linux
* Build dependencies (Debian based distros):
```bash
$ sudo apt update && apt install make build-essential gcc g++ gfortran
```
* Build dependencies (Arch based distros):
```bash
$ sudo pacman -Syu && pacman -S make build-essential gcc g++ gfortran
```

## Installation

> To setup properly please follow these steps:
1. Run this to clone this repo:
```bash
$ git clone https://github.com/nemo256/Rproject
```
2. Change to the Rproject directory:
```bash
$ cd Rproject
```
3. Edit the matrix and composition (matrix.txt and composition.txt).
4. And finally run the script using this command:
```bash
$ R < script.R matrix.txt composition.txt
```
