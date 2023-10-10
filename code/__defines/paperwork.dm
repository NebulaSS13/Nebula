#define PEN_FLAG_ACTIVE     BITFLAG(0) //If the pen is expanded and ready to write
#define PEN_FLAG_TOGGLEABLE BITFLAG(1) //If the pen can have its head retracted and extended
#define PEN_FLAG_FANCY      BITFLAG(2) //If the pen is a fancy pen, mainly decides the font used
#define PEN_FLAG_CRAYON     BITFLAG(3) //If the pen is a crayon, mainly decides the font used
#define PEN_FLAG_DEL_EMPTY  BITFLAG(4) //If the pen is deleted when its use count reaches 0

#define TONER_USAGE_PAPER 1 //Amount of toner a paper uses
#define TONER_USAGE_PHOTO 5 //Amount of toner a photo uses

///The default font for pen writing
#define PEN_FONT_DEFAULT   "Verdana"
///The font for default pen signature
#define PEN_FONT_SIGNATURE "Times New Roman"
///The font for crayon writing
#define PEN_FONT_CRAYON    "Comic Sans MS"
///The font for fancy pen writing
#define PEN_FONT_FANCY_PEN "Segoe Script"