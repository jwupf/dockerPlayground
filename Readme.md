# Docker for compiling/creating stuff

## Without WSL

right now it works without WSL, but I do not know what I changed to make the compile scenario work.

## WSL

install Debian distro from Windows Store 
- is there a manual way?\
  YES: https://docs.microsoft.com/en-us/windows/wsl/install-manual

set Debian as standart distro:
```
wsl -s Debian
```

start wsl with
```
wsl
```

start a specific Distro:
```
wsl -d Debian
```


## using WSL with vscode

install vscode
```
sudo apt install vscode
```

## Powershell

getting powershell:

```
# Download the Microsoft repository GPG keys
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo apt install packages-microsoft-prod.deb

# Update the list of products
sudo apt update

# Install PowerShell
sudo apt install -y powershell

pwsh

install-module Pester
```

install git
```
sudo apt install git
```

start vscode with:
```
code .
```
This may need the Remote - WSL extension on the windows side

### using WSL for docker

complicated

```
#> wsl -d Debian ls -lisah
#> wsl -d Debian pwsh -noni -Command "& Write-Output 'Hello from pwsh inside of the Debian WSL distro'"
```

run all the tests:
```
wsl -d Debian pwsh -noni -Command "& Invoke-Pester -script ./tests/*.tests.ps1"
```