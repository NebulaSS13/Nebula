#define MAPPED_CONDIMENT_TYPE(ID, TYPE) \
/obj/item/chems/condiment/##ID {        \
	initial_condiment_type = TYPE;      \
	morphic_container = FALSE;          \
	name = TYPE::condiment_name;        \
	desc = TYPE::condiment_desc;        \
	icon = TYPE::condiment_icon;        \
}

MAPPED_CONDIMENT_TYPE(enzyme,    /decl/condiment_appearance/enzyme)
MAPPED_CONDIMENT_TYPE(barbecue,  /decl/condiment_appearance/ketchup)
MAPPED_CONDIMENT_TYPE(sugar,     /decl/condiment_appearance/sugar/bag)
MAPPED_CONDIMENT_TYPE(ketchup,   /decl/condiment_appearance/ketchup)
MAPPED_CONDIMENT_TYPE(cornoil,   /decl/condiment_appearance/cornoil)
MAPPED_CONDIMENT_TYPE(vinegar,   /decl/condiment_appearance/vinegar)
MAPPED_CONDIMENT_TYPE(mayo,      /decl/condiment_appearance/mayonnaise)
MAPPED_CONDIMENT_TYPE(frostoil,  /decl/condiment_appearance/coldsauce)
MAPPED_CONDIMENT_TYPE(capsaicin, /decl/condiment_appearance/capsaicin)
MAPPED_CONDIMENT_TYPE(yeast,     /decl/condiment_appearance/yeast)
MAPPED_CONDIMENT_TYPE(flour,     /decl/condiment_appearance/flour)

#undef MAPPED_CONDIMENT_TYPE