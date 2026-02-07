/**Define a poster's decl and its mapper type */
#define DEFINE_POSTER(TYPENAME, ICONSTATE, NAME, DESC)\
/decl/poster_design/##TYPENAME{name = NAME; desc = DESC; icon_state = ICONSTATE;};\
/obj/structure/sign/poster/##TYPENAME{poster_design = /decl/poster_design/##TYPENAME; name = NAME; icon_state = ICONSTATE;};

#define DEFINE_STACK_SUBTYPES(MAT_ID, MAT_NAME, MAT_TYPE, STACK_TYPE, REINF_TYPE) \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID {                    \
	name = "1 " + MAT_NAME;                                                \
	material = /decl/material/MAT_TYPE;                                    \
	reinf_material = REINF_TYPE;                                           \
	amount = 1;                                                            \
	is_spawnable_type = TRUE;                                              \
	color = parent_type::paint_color || /decl/material/MAT_TYPE::color;    \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/five {               \
	name = "5 " + MAT_NAME;                                                \
	amount = 5;                                                            \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/ten {                \
	name = "10 " + MAT_NAME;                                               \
	amount = 10;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/fifteen {            \
	name = "15 " + MAT_NAME;                                               \
	amount = 15;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/twenty {             \
	name = "20 " + MAT_NAME;                                               \
	amount = 20;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/twentyfive {         \
	name = "25 " + MAT_NAME;                                               \
	amount = 25;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/thirty {             \
	name = "30 " + MAT_NAME;                                               \
	amount = 30;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/forty {              \
	name = "40 " + MAT_NAME;                                               \
	amount = 40;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/fifty {              \
	name = "50 " + MAT_NAME;                                               \
	amount = 50;                                                           \
}
