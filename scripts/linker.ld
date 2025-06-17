OUTPUT_FORMAT("pe-x86-64", "pe-x86-64", "pe-x86-64")

SECTIONS
{
  .text : {
    *(.text)
  }

  .rdata : {
    *(.rdata)
  }

  .data : {
    *(.data)
  }

  .bss : {
    *(.bss)
  }

  .pdata : {
    *(.pdata)
  }

  .rsrc : {
    *(.rsrc)
  }

  /DISCARD/ : {
    *(.comment)
    *(.note)
    *(.eh_frame*)
    *(.rustc)
    *(.cargo)
    *(.rmeta)
    *(.xdata)
  }
}
