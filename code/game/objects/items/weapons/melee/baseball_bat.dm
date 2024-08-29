/obj/item/baseball_bat
	name                       = "bat"
	desc                       = "HOME RUN!"
	icon                       = 'icons/obj/items/weapon/bat.dmi'
	w_class                    = ITEM_SIZE_LARGE
	can_be_twohanded             = TRUE
	pickup_sound               = 'sound/foley/scrape1.ogg'
	drop_sound                 = 'sound/foley/tooldrop1.ogg'
	slot_flags                 = SLOT_BACK
	attack_verb                = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound                   = 'sound/weapons/genhit3.ogg'
	material                   = /decl/material/solid/organic/wood/maple
	material_alteration        = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	melee_accuracy_bonus       = -10
	_base_attack_force         = 20

//Predefined materials go here.
/obj/item/baseball_bat/aluminium
	material = /decl/material/solid/metal/aluminium

/obj/item/baseball_bat/uranium
	material = /decl/material/solid/metal/uranium

/obj/item/baseball_bat/gold
	material = /decl/material/solid/metal/gold

/obj/item/baseball_bat/platinum
	material = /decl/material/solid/metal/platinum

/obj/item/baseball_bat/diamond
	material = /decl/material/solid/gemstone/diamond
