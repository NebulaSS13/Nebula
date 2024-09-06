/obj/item/chems/condiment/small
	name = "small condiment container"
	possible_transfer_amounts = @"[1,2,5,8,10,20]"
	amount_per_transfer_from_this = 1
	volume = 20
	condiment_key = "small"

#define MAPPED_CONDIMENT_TYPE(ID, TYPE) \
/obj/item/chems/condiment/small/##ID {  \
	initial_condiment_type = TYPE;      \
	morphic_container = FALSE;          \
	name = TYPE::condiment_name;        \
	desc = TYPE::condiment_desc;        \
	icon = TYPE::condiment_icon;        \
}

MAPPED_CONDIMENT_TYPE(saltshaker, /decl/condiment_appearance/salt)
MAPPED_CONDIMENT_TYPE(peppermill, /decl/condiment_appearance/peppermill)
MAPPED_CONDIMENT_TYPE(sugar,      /decl/condiment_appearance/sugar)
MAPPED_CONDIMENT_TYPE(mint,       /decl/condiment_appearance/mint)
MAPPED_CONDIMENT_TYPE(soysauce,   /decl/condiment_appearance/soysauce)

#undef MAPPED_CONDIMENT_TYPE
