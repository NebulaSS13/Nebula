// These are placeholder defines to ensure sanitization etc works properly with Unicode
// in DM 513, they should be replaced over time with the appropriate function call. 
#if DM_VERSION >= 513
#define length(X...)       length_char(X)
#define copytext(X...)     copytext_char(X)
#define spantext(X...)     spantext_char(X)
#define nonspantext(X...)  nonspantext_char(X)
#define findlasttext(X...) findlasttext_char(X)
#define findtext(X...)     findtext_char(X)
#define text2ascii(X...)   text2ascii_char(X)
#endif