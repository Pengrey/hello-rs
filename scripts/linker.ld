SECTIONS {
    /* Standard PE header size. */
    . = SIZEOF_HEADERS;
    . = ALIGN(__section_alignment__); /* Align to page boundary or specified section alignment */

    /* The main code section. */
    .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) : {
        KEEP (*(SORT_NONE(.init)))  /* Initialization code */
        *(.text)                    /* All general .text sections */
        *(SORT(.text$*))            /* Ordered .text sections (e.g., from MSVC) */
        *(.text.*)                  /* Other .text subsections */
        *(.gnu.linkonce.t.*)        /* GNU linkonce text sections */
        *(.glue_7t)                 /* ARM glue code (thumb) */
        *(.glue_7)                  /* ARM glue code (arm) */

        /* Constructor and Destructor lists (more common in ELF, but MinGW can use them) */
        . = ALIGN(8);
        ___CTOR_LIST__ = .;
        __CTOR_LIST__ = .;
        LONG (-1); LONG (-1);       /* Start sentinel */
        KEEP (*(.ctors));
        KEEP (*(.ctor));
        KEEP (*(SORT_BY_NAME(.ctors.*)));
        LONG (0); LONG (0);         /* End sentinel */

        ___DTOR_LIST__ = .;
        __DTOR_LIST__ = .;
        LONG (-1); LONG (-1);       /* Start sentinel */
        KEEP (*(.dtors));
        KEEP (*(.dtor));
        KEEP (*(SORT_BY_NAME(.dtors.*)));
        LONG (0); LONG (0);         /* End sentinel */

        KEEP (*(SORT_NONE(.fini)))  /* Finalization code */

        *(.gcc_exc)                 /* Obsolete GCC exception handling */
        PROVIDE (etext = .);        /* End of text segment */
        KEEP (*(.gcc_except_table)) /* GCC exception handling table */
    }

    /* Read-write initialized data. */
    .data BLOCK(__section_alignment__) : {
        __data_start__ = . ;
        *(.data)
        *(.data2)
        *(SORT(.data$*))
        KEEP(*(.jcr))               /* Java Class Registration, if any */
        __data_end__ = . ;
        *(.data_cygwin_nocopy)      /* Data not to be copied by Cygwin startup */
    }

    /* Read-only data. */
    .rdata BLOCK(__section_alignment__) : {
        *(.rdata)
        *(SORT(.rdata$*))
        *(.rdata.*)
        *(.rodata)
        *(.rodata.*)

        . = ALIGN(4);
        __rt_psrelocs_start = .;
        KEEP(*(.rdata_runtime_pseudo_reloc))
        __rt_psrelocs_end = .;
    }

    /* Exception handling unwind information (program data). */
    .pdata BLOCK(__section_alignment__) : {
        KEEP(*(.pdata*))
    }

    /* Exception handling data. */
    .xdata BLOCK(__section_alignment__) : {
        KEEP(*(.xdata*))
    }

    /* Uninitialized data. */
    .bss BLOCK(__section_alignment__) : {
        __bss_start__ = . ;
        *(.bss)
        *(COMMON)                   /* Common symbols */
        __bss_end__ = . ;
    }

    /* Exported data section (for DLLs). */
    .edata BLOCK(__section_alignment__) : {
        *(.edata)
    }

    /* Import data section. */
    .idata BLOCK(__section_alignment__) : {
        /*
         * This layout is standard for PE import tables.
         * .idata$2: Import Directory Table
         * .idata$3: Null terminator for Import Directory Table
         * .idata$4: Import Lookup Table (ILT) for each DLL
         * .idata$5: Import Address Table (IAT) for each DLL (this is what gets patched by loader)
         * .idata$6: Hint/Name Table (actual import names)
         * .idata$7: Null terminator for ILT/IAT for last DLL
         */
        KEEP (SORT(*)(.idata$2))   /* Import Directory Table */
        KEEP (SORT(*)(.idata$3))   /* Null entry for Import Directory Table */
        LONG (0); LONG (0); LONG (0); LONG (0); LONG (0); /* Space for terminating null ImportDir entry */
        KEEP (SORT(*)(.idata$4))   /* ILTs */
        __IAT_start__ = .;
        SORT(*)(.idata$5)          /* IATs */
        __IAT_end__ = .;
        KEEP (SORT(*)(.idata$6))   /* Hint/Name Table */
        KEEP (SORT(*)(.idata$7))   /* Terminators for ILT/IAT arrays */
    }

    /* Thread Local Storage. */
    .tls BLOCK(__section_alignment__) : {
        ___tls_start__ = . ;
        KEEP (*(.tls$AAA))          /* TLS start marker */
        KEEP (*(.tls))              /* Actual TLS data */
        KEEP (*(.tls$))             /* More TLS data */
        KEEP (*(SORT(.tls$*)))      /* Ordered TLS sections */
        KEEP (*(.tls$ZZZ))          /* TLS end marker */
        ___tls_end__ = . ;
    }

    /* Resource section. */
    .rsrc BLOCK(__section_alignment__) : SUBALIGN(4) {
        KEEP (*(.rsrc))
        KEEP (*(.rsrc$*))
    }

    /* Relocations section (usually stripped from final EXEs but present in OBJs). */
    .reloc BLOCK(__section_alignment__) : {
        *(.reloc)
    }

    /* Sections to discard. */
    /DISCARD/ : {
        *(.debug*)                  /* Debugging information */
        *(.drectve)                 /* Linker directives embedded in object files */
        *(.gnu.lto_*)               /* LTO intermediate sections */
        *(.comment)                 /* Version control, compiler info etc. */
        *(.note*)                   /* Note sections */
        *(.eh_frame*)               /* DWARF exception handling frames (use .pdata/.xdata on Windows) */
        *(.eh_frame_hdr*)
        /* Rust specific metadata, not needed in final binary */
        *(.rustc)
        *(.cargo)
        *(.rmeta)
    }
}
