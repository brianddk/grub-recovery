# grub-recovery

Scripts that play with creating grub-recovery images.  These scripts assume your running out of the ARCH Linux ISO.  You can boot the resultant images using the generic "Mac OS X (64 bit)" machine with VirtualBox.

# mkgrub

This is the main script, that actually calls `grubby`, although `grubby` can be called independently.  `mkgrub` will sort of auto-detect known floppy sizes and assume that the size argument refers to blocks instead of megs.

```
mkgrub.sh [file] [size]
    file - An image file name that will hold the contents
    size - BLOCKS for floppies or MEGS for HD images

Examples:
    mkgrub.sh floppy144.img 144
    mkgrub.sh mbrhd4m.img 4    
```

# grubby

This is actually subordinate to `mkgrub` though it can be called independently.

```
grubby.sh [dev] [mnt] [efi-files] [caller] [floppy] [mods]

Example:
    grubby.sh                                 \
        floppy144.img                         \
        /mnt/floppy                           \
        /mnt/efi                              \
        ./mkgrub.sh                           \
        "--allow-floppy"                      \
        "--install-modules=acpi boot cat chain"
```

# Testing Images

To test these images, the easiest way, is to use VirtualBox (version 6.0).

1. Create a new "Mac OS X (64 bit)"
2. Do not use a virtual disk
3. Create
4. Edit (settings)
5. Storage
6. Add Floppy Controller
7. Add USB USB Controller
8. `VBoxManage convertfromraw mbrhd4m.img mbrhd4m.vhd --format VHD --variant fixed`
9. Attach either the floppy `.img` or the HD `.vhd` file
10. Boot VM

Note that fixed-type VHDs will operate exactly like raw images.  A fixed VHD is just a raw image with one sector of meta data tacked to the end.  Also note that the 1.68 MB and 2.88 MB images don't work with VirtualBox, but will likely still work on physical HW.

