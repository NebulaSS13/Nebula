#define PEN_FLAG_ACTIVE     BITFLAG(0) //If the pen is expanded and ready to write
#define PEN_FLAG_TOGGLEABLE BITFLAG(1) //If the pen can have its head retracted and extended
#define PEN_FLAG_FANCY      BITFLAG(2) //If the pen is a fancy pen, mainly decides the font used
#define PEN_FLAG_CRAYON     BITFLAG(3) //If the pen is a crayon, mainly decides the font used
#define PEN_FLAG_DEL_EMPTY  BITFLAG(4) //If the pen is deleted when its use count reaches 0
