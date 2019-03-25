@echo off
::!"%ComSpec%"
:: [rights]  Copyright brianddk 2019 https://github.com/brianddk
:: [license] Licensed under Apache 2.0 https://www.apache.org/licenses/LICENSE-2.0
:: [repo]    https://github.com/brianddk/grub-recovery
:: [tipjar]  https://git.io/fh6b0 ; LTC: LQjSwZLigtgqHA3rE14yeRNbNNY2r3tXcA
:: [usage]
::    convertfromraw.cmd images\mbrhd4m.img
::
setlocal
set raw="%~f1"
set vhd="%~dpn1.vhd"
set vbm="%ProgramFiles%\Oracle\VirtualBox\VBoxManage"
%vbm% convertfromraw %raw% %vhd% --format vhd --variant fixed
endlocal