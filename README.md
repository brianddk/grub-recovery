# grub-recovery

Scripts that play with creating grub-recovery images.

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
