SECTIONS {
    /*
    * Start of the output file.
    * SIZEOF_HEADERS is a placeholder for the PE header size.
    * The location counter (.) is advanced past the headers.
    */
    . = SIZEOF_HEADERS;

    /*
    * Align the start of the first section.
    * __section_alignment__ is typically the page size or a smaller power of 2.
    */
    . = ALIGN(__section_alignment__);

    /*
    * .text section: Executable code.
    * The conditional alignment ensures that if __section_alignment__ is less
    * than 0x1000 (a common page size), the virtual address and file offset
    * are synced by using the current offset (.), otherwise align to __section_alignment__.
    * __image_base__ is the base address of the image.
    */
    .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) : {
        KEEP (*(SORT_NONE(.init)))  /* Initialization code (e.g., from crtbegin) */
        *(.text)                    /* Main program code */
        *(SORT(.text$*))            /* Other .text segments, sorted (e.g., MSVC naming convention) */
        *(.text.*)                  /* Wildcard for other .text subsections */
        *(.gnu.linkonce.t.*)        /* GNU link-once text sections */
        *(.glue_7t)                 /* ARM Thumb-2 glue veneers */
        *(.glue_7)                  /* ARM ARM-mode glue veneers */
        . = ALIGN(8);               /* Align before .fini */
        KEEP (*(SORT_NONE(.fini)))  /* Finalization code (e.g., from crtend) */
        *(.gcc_exc)                 /* GCC specific exception handling */
        PROVIDE (etext = .);        /* Symbol marking the end of the text section */
        KEEP (*(.gcc_except_table)) /* GCC exception table data */
    }

    /*
    * .data section: Initialized read-write data.
    * BLOCK(__section_alignment__) ensures this section starts at an aligned address
    * and its size is a multiple of the alignment (often for virtual memory paging).
    */
    .data BLOCK(__section_alignment__) : {
        __data_start__ = . ;        /* Symbol marking the start of the data section */
        *(.data)                    /* Main initialized data */
        *(.data2)                   /* Other initialized data */
        *(SORT(.data$*))            /* Other .data segments, sorted */
        KEEP(*(.jcr))               /* Java Class Registration table (GCC specific) */
        __data_end__ = . ;          /* Symbol marking the end of the data section */

        *(.data_cygwin_nocopy)      /* Cygwin specific no-copy-on-fork data */
    }

    /* .rdata section: Read-only data. */
    .rdata BLOCK(__section_alignment__) : {
        *(.rdata)                   /* Main read-only data */
        *(SORT(.rdata$*))           /* Other .rdata segments, sorted */
        . = ALIGN(4);
        __rt_psrelocs_start = .;    /* Start of MinGW runtime pseudo-relocations table */
        KEEP(*(.rdata_runtime_pseudo_reloc)) /* MinGW runtime pseudo-relocations */
        __rt_psrelocs_end = .;      /* End of MinGW runtime pseudo-relocations table */

        /* .ctors & .dtors sections for C-style global constructors/destructors (GCC) */
        . = ALIGN(8);

        ___CTOR_LIST__ = .;         /* Start of constructor list (GCC) */
        __CTOR_LIST__ = .;          /* Also start of constructor list (GCC) */
        LONG (-1); LONG (-1);       /* Marks beginning of list for some runtimes */
        KEEP (*(.ctors));           /* Global constructors (from .ctors sections) */
        KEEP (*(.ctor));            /* Single global constructor (less common) */
        KEEP (*(SORT_BY_NAME(.ctors.*))); /* Sorted constructor subsections */
        LONG (0); LONG (0);         /* Marks end of list for some runtimes */

        /* See comment about __CTOR_LIST__ above. The same reasoning applies here too. */
        ___DTOR_LIST__ = .;         /* Start of destructor list (GCC) */
        __DTOR_LIST__ = .;          /* Also start of destructor list (GCC) */
        LONG (-1); LONG (-1);       /* Marks beginning of list */
        KEEP (*(.dtors));           /* Global destructors (from .dtors sections) */
        KEEP (*(.dtor));            /* Single global destructor */
        KEEP (*(SORT_BY_NAME(.dtors.*))); /* Sorted destructor subsections */
        LONG (0); LONG (0);         /* Marks end of list */

        /* .CRT sections for MSVC-compatible C/C++ initializers and terminators */
        ___crt_xc_start__ = . ;
        KEEP (*(SORT(.CRT$XC*)))    /* C initialization (e.g., function pointers) */
        ___crt_xc_end__ = . ;
        ___crt_xi_start__ = . ;
        KEEP (*(SORT(.CRT$XI*)))    /* C++ initialization (e.g., constructors for statics) */
        ___crt_xi_end__ = . ;
        ___crt_xl_start__ = . ;
        KEEP (*(SORT(.CRT$XL*)))    /* TLS callbacks */
        /* ___crt_xl_end__ is defined in the TLS Directory support code */
        ___crt_xp_start__ = . ;
        KEEP (*(SORT(.CRT$XP*)))    /* Pre-termination functions */
        ___crt_xp_end__ = . ;
        ___crt_xt_start__ = . ;
        KEEP (*(SORT(.CRT$XT*)))    /* Termination functions */
        ___crt_xt_end__ = . ;
        ___crt_xd_start__ = . ;
        KEEP (*(SORT(.CRT$XD*)))    /* Dynamic TLS Initializer */
        ___crt_xd_end__ = . ;
    }

    /* Definitions for MinGW runtime pseudo-relocations, aliased for compatibility */
    ___RUNTIME_PSEUDO_RELOC_LIST_END__ = __rt_psrelocs_end;
    __RUNTIME_PSEUDO_RELOC_LIST_END__ = __rt_psrelocs_end;
    ___RUNTIME_PSEUDO_RELOC_LIST__ = __rt_psrelocs_start;
    __RUNTIME_PSEUDO_RELOC_LIST__ = __rt_psrelocs_start;

    /* .pdata section: Procedure data for Windows x64 SEH (Structured Exception Handling). */
    .pdata BLOCK(__section_alignment__) : {
        KEEP(*(.pdata*))            /* Exception handling function table entries */
    }

    /* .xdata section: Exception data for Windows x64 SEH (details for .pdata entries). */
    .xdata BLOCK(__section_alignment__) : {
        KEEP(*(.xdata*))            /* Unwind information for exception handling */
    }

    /* .bss section: Uninitialized data (zeroed at program startup). */
    .bss BLOCK(__section_alignment__) : {
        __bss_start__ = . ;         /* Symbol marking the start of the BSS section */
        *(.bss)                     /* Main uninitialized data */
        *(COMMON)                   /* Common symbols (uninitialized data from multiple files) */
        __bss_end__ = . ;           /* Symbol marking the end of the BSS section */
    }

    /* .edata section: PE Export Directory Table data. */
    .edata BLOCK(__section_alignment__) : {
        *(.edata)                   /* Exported symbols information */
    }

    /* .idata section: PE Import Directory Table data. */
    .idata BLOCK(__section_alignment__) : {
        KEEP (SORT(*)(.idata$2))    /* Import Directory Table entries */
        KEEP (SORT(*)(.idata$3))    /* Import Lookup Table (ILT) or OriginalFirstThunk */
        /* These zeroes mark the end of the import list. */
        LONG (0); LONG (0); LONG (0); LONG (0); LONG (0);
        . = ALIGN(8);
        KEEP (SORT(*)(.idata$4))    /* Hint/Name Table (pointers to function names) */
        __IAT_start__ = .;          /* Symbol marking the start of the Import Address Table */
        SORT(*)(.idata$5)           /* Import Address Table (IAT) or FirstThunk */
        __IAT_end__ = .;            /* Symbol marking the end of the Import Address Table */
        KEEP (SORT(*)(.idata$6))    /* DLL names */
        KEEP (SORT(*)(.idata$7))    /* Unused/terminator for import sections */
    }

    /* .rsrc section: PE Resource data (icons, version info, dialogs, etc.). */
    .rsrc BLOCK(__section_alignment__) : SUBALIGN(4) {  /* Resources are often 4-byte aligned */
        KEEP (*(.rsrc))             /* Main resource data */
        KEEP (*(.rsrc$*))           /* Resource subsections */
    }

    /* .reloc section: PE Base Relocation Table. */
    .reloc BLOCK(__section_alignment__) : {
        *(.reloc)                   /* Relocation information for image rebasing */
    }

    /* Sections to discard. */
    /DISCARD/ : {
        *(.debug*)                  /* Debugging information */
        *(.drectve)                 /* Linker directives embedded in object files */
        *(.gnu.lto_*)               /* LTO intermediate sections */
        *(.comment)                 /* Version control, compiler info etc. */
        *(.note*)                   /* Note sections */
        *(.eh_fram*)                /* DWARF exception handling frames (use .pdata/.xdata on Windows) */
        *(.eh_frame_hdr*)
        /* Rust specific metadata, not needed in final binary */
        *(.rustc)
        *(.cargo)
        *(.rmeta)
    }


}
