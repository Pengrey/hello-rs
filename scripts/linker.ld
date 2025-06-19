SECTIONS {
    . = SIZEOF_HEADERS;
    . = ALIGN(__section_alignment__);
    .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) : {
        KEEP (*(SORT_NONE(.init)))
        *(.text)
        *(SORT(.text$*))
        *(.text.*)
        *(.gnu.linkonce.t.*)
        *(.glue_7t)
        *(.glue_7)
        . = ALIGN(8);
        ___CTOR_LIST__ = .;
        __CTOR_LIST__ = .;
        LONG (-1); LONG (-1);
        KEEP (*(.ctors));
        KEEP (*(.ctor));
        KEEP (*(SORT_BY_NAME(.ctors.*)));
        LONG (0); LONG (0);
        ___DTOR_LIST__ = .;
        __DTOR_LIST__ = .;
        LONG (-1); LONG (-1);
        KEEP (*(.dtors));
        KEEP (*(.dtor));
        KEEP (*(SORT_BY_NAME(.dtors.*)));
        LONG (0); LONG (0);
        KEEP (*(SORT_NONE(.fini)))
        *(.gcc_exc)
        PROVIDE (etext = .);
        KEEP (*(.gcc_except_table))
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
        KEEP(*(.pdata*))
    }

    .xdata BLOCK(__section_alignment__) : {
        KEEP(*(.xdata*))
    }

    .bss BLOCK(__section_alignment__) : {
        __bss_start__ = . ;
        *(.bss)
        *(COMMON)
        __bss_end__ = . ;
    }

    .edata BLOCK(__section_alignment__) : {
        *(.edata)
    }

    .idata BLOCK(__section_alignment__) : {
        KEEP (SORT(*)(.idata$2))
        KEEP (SORT(*)(.idata$3))
        LONG (0); LONG (0); LONG (0); LONG (0); LONG (0);
        KEEP (SORT(*)(.idata$4))
        __IAT_start__ = .;
        SORT(*)(.idata$5)
        __IAT_end__ = .;
        KEEP (SORT(*)(.idata$6))
        KEEP (SORT(*)(.idata$7))
    }

    .CRT BLOCK(__section_alignment__) : {
        ___crt_xc_start__ = . ;
        KEEP (*(SORT(.CRT$XC*)))  /* C initialization */
        ___crt_xc_end__ = . ;
        ___crt_xi_start__ = . ;
        KEEP (*(SORT(.CRT$XI*)))  /* C++ initialization */
        ___crt_xi_end__ = . ;
        ___crt_xl_start__ = . ;
        KEEP (*(SORT(.CRT$XL*)))  /* TLS callbacks */
        ___crt_xp_start__ = . ;
        KEEP (*(SORT(.CRT$XP*)))  /* Pre-termination */
        ___crt_xp_end__ = . ;
        ___crt_xt_start__ = . ;
        KEEP (*(SORT(.CRT$XT*)))  /* Termination */
        ___crt_xt_end__ = . ;
    }

    .tls BLOCK(__section_alignment__) : {
        ___tls_start__ = . ;
        KEEP (*(.tls$AAA))
        KEEP (*(.tls))
        KEEP (*(.tls$))
        KEEP (*(SORT(.tls$*)))
        KEEP (*(.tls$ZZZ))
        ___tls_end__ = . ;
    }

    .rsrc BLOCK(__section_alignment__) : SUBALIGN(4) {
        KEEP (*(.rsrc))
        KEEP (*(.rsrc$*))
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
