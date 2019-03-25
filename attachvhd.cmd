@echo off
::!"%ComSpec%"
:: [rights]  Copyright brianddk 2019 https://github.com/brianddk
:: [license] Licensed under Apache 2.0 https://www.apache.org/licenses/LICENSE-2.0
:: [repo]    https://github.com/brianddk/grub-recovery
:: [tipjar]  https://git.io/fh6b0 ; LTC: LQjSwZLigtgqHA3rE14yeRNbNNY2r3tXcA
:: [usage]
::    attachvhd.cmd images\mbrhd4m.vhd
::
setlocal
set swapfile=swap.txt
set vhd="%~f1"
(
    echo select vdisk file=%vhd%
    echo attach vdisk
    echo list volume
) | diskpart 
(
    echo select vdisk file=%vhd%
    echo detail vdisk
) | diskpart | findstr /c:"Associated disk#:" > %swapfile%

for /f "tokens=3" %%I in (%swapfile%) do (
    set drive=%%I
)

(
    echo select disk %drive%
    echo detail disk
) | diskpart | findstr /v "###" | findstr /c:"Volume" > %swapfile%

for /f "tokens=2" %%I in (%swapfile%) do (
    set volume=%%I
)
del %swapfile%

(
    echo select volume %volume%
    echo assign
    echo list volume
) | diskpart
endlocal
