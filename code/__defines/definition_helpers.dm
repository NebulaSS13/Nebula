/**Define a poster's decl and its mapper type */
#define DEFINE_POSTER(TYPENAME, ICONSTATE, NAME, DESC)\
/decl/poster/##TYPENAME{name = NAME; desc = DESC; icon_state = ICONSTATE;};\
/obj/structure/sign/poster/##TYPENAME{poster_type = /decl/poster/##TYPENAME; name = NAME; icon_state = ICONSTATE;};