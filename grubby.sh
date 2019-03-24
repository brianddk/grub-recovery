#!/bin/bash
# [rights]  Copyright brianddk 2019 https://github.com/brianddk
# [license] Licensed under Apache 2.0 https://www.apache.org/licenses/LICENSE-2.0
# [repo]    https://github.com/brianddk/grub-recovery
# [tipjar]  https://git.io/fh6b0 ; LTC: LQjSwZLigtgqHA3rE14yeRNbNNY2r3tXcA
#
device=$1
fmnt=$2
emnt=$3
parent=$4
floppy=$5
imods=$6
echo "Floppy Args [$floppy $imods]"
gstdout="grub.stdout.txt"
gstderr="grub.stderr.txt"

rm -rf ${fmnt}/{efi,boot,script}
mkdir -p ${fmnt}/{script,boot/grub}
echo "exit" > $fmnt/boot/grub/grub.cfg

grub-install \
--target=x86_64-efi \
--recheck \
--themes= \
--locales= \
--fonts= \
--removable \
--verbose \
--compress=xz \
--modules="fshelp fat xzio crypto gcry_crc" \
--efi-directory="${fmnt}" \
--boot-directory="${fmnt}/boot" \
"${imods}" \
"${floppy}" \
"${device}" \
1>"${gstdout}" \
2>"${gstderr}"

rm ${fmnt}/boot/grub/x86_64-efi/grub.efi
mv ${fmnt}/boot/grub/x86_64-efi/core.efi "$fmnt/efi/boot/grub.efi"
cp "${emnt}/efi/shellx64_v2.efi" "${fmnt}/efi/boot/bootx64.efi"

cp $0 "${gstdout}" "${parent}" "${fmnt}/script"
ps -o cmd | grep "${parent}" > "${fmnt}/script/cmd.txt"
gzip --stdout "${gstderr}" > "${fmnt}/script/${gstderr}.gz"
cp mods.* "${fmnt}/script"
dmesg | head > "${fmnt}/script/dmesghead.txt"

