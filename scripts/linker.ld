SECTIONS
{
    . = SIZEOF_HEADERS;
    . = ALIGN(__section_alignment__);
    .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) : {
        KEEP (*(SORT_NONE(.init)))
        *(.text)
        *(SORT(.text$*))
        *(.text.*)
    }

    .data BLOCK(__section_alignment__) : {
        __data_start__ = . ;
        *(.data)
        *(.data2)
        *(SORT(.data$*))
        KEEP(*(.jcr))
        __data_end__ = . ;
        *(.data_cygwin_nocopy)
    }

    .rdata BLOCK(__section_alignment__) : {
        *(.rdata)
        *(SORT(.rdata$*))
        . = ALIGN(4);
        __rt_psrelocs_start = .;
        KEEP(*(.rdata_runtime_pseudo_reloc))
        __rt_psrelocs_end = .;
    }

    .pdata BLOCK(__section_alignment__) : {
        *(.pdata*)
    }

    .xdata BLOCK(__section_alignment__) : {
        KEEP(*(.xdata*))
    }

    .edata BLOCK(__section_alignment__) : {
        *(.edata)
    }

    .idata BLOCK(__section_alignment__) : {
        KEEP (SORT(*)(.idata$2))
        KEEP (SORT(*)(.idata$3))
        LONG (0); LONG (0); LONG (0); LONG (0); LONG (0);
        . = ALIGN(8);
        KEEP (SORT(*)(.idata$4))
        __IAT_start__ = .;
        SORT(*)(.idata$5)
        __IAT_end__ = .;
        KEEP (SORT(*)(.idata$6))
        KEEP (SORT(*)(.idata$7))
    }

    .bss BLOCK(__section_alignment__) : {
        __bss_start__ = . ;
        *(.bss)
        *(COMMON)
        __bss_end__ = . ;
    }

    .rsrc BLOCK(__section_alignment__) : SUBALIGN(4) {
            *(.rsrc)
            *(.rsrc.*)
    }

    .reloc BLOCK(__section_alignment__) : {
        *(.reloc)
    }

    /DISCARD/ : {
        *(.debug*)
        *(.drectve)
        *(.gnu.lto_*)
        *(.comment)
        *(.note*)
        *(.eh_fram*)
        *(.rustc)
        *(.cargo)
        *(.rmeta)
    }
}
