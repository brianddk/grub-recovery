#!/bin/bash
# [rights]  Copyright brianddk 2019 https://github.com/brianddk
# [license] Licensed under Apache 2.0 https://www.apache.org/licenses/LICENSE-2.0
# [repo]    https://github.com/brianddk/grub-recovery
# [tipjar]  https://git.io/fh6b0 ; LTC: LQjSwZLigtgqHA3rE14yeRNbNNY2r3tXcA
#
file=$1
megs=$2
eimg=/run/archiso/bootmnt/EFI/archiso/efiboot.img
fmnt=/mnt/floppy
emnt=/mnt/efi
mount -o ro,loop,uid=$UID -t vfat "${eimg}" "${emnt}"
imods="--verbose"
floppy="--verbose"
if (( megs < 144 ))
then
   echo "running HD mode"
   read
   dd if=/dev/zero bs=1MiB of="${file}" count="${megs}"
   echo -en "n\np\n\n\n\nt\ne\np\nw\n" | fdisk "${file}"
   losetup -fvP "${file}"
   fdev="$(losetup -l | grep ${file} | awk '{print $1}' | head -1)"
   fdevp1="${fdev}p1"
   mkfs.fat -v "${fdevp1}"
   mount "${fdevp1}" "${fmnt}"
else
   echo "running Floppy mode"
   read
   blocks=$(( megs * 10 ))
   rm -f "${file}"
   floppy="--allow-floppy"
   if (( megs < 168 )); then
      term="$(< mods.144 tr '\n' ' ')"
      imods="--install-modules=$term"
   elif (( megs < 172 )); then
      term="$(< mods.168 tr '\n' ' ')"
      imods="--install-modules=$term"
   elif (( megs < 288 )); then
      term="$(< mods.172 tr '\n' ' ')"
      imods="--install-modules=$term"
   fi
   fdevp1="${file}"
   #mkfs.vfat -v -C "${file}" $blocks
   mkfs.fat -v -D 0x00 -F 12 -M 0xF0 -C "${file}" $blocks
   echo "Sync"
   read
   mount -o loop,uid=$UID -t vfat "${fdevp1}" "${fmnt}"
   echo "Sync"
   read
fi
./grubby.sh "${fdevp1}" "${fmnt}" "${emnt}" $0 "${floppy}" "${imods}"
df "${fmnt}"
umount "${fmnt}"
umount "${emnt}"
if (( megs < 144 )); then losetup -d "${fdev}"; fi
losetup -l
