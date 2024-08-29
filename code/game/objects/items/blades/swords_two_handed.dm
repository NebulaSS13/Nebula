/obj/item/bladed/longsword
	name                 = "longsword"
	desc                 = "A long and heavy two-handed blade with a cruciform hilt and guard."
	icon                 = 'icons/obj/items/bladed/longsword.dmi'
	hilt_material        = /decl/material/solid/metal/brass
	guard_material       = /decl/material/solid/metal/brass
	pommel_material      = /decl/material/solid/metal/brass
	slot_flags           = SLOT_LOWER_BODY | SLOT_BACK
	w_class              = ITEM_SIZE_LARGE
	armor_penetration    = 10
	base_parry_chance    = 50
	melee_accuracy_bonus = 10
	can_be_twohanded     = TRUE
	pickup_sound         = 'sound/foley/scrape1.ogg'
	drop_sound           = 'sound/foley/tooldrop1.ogg'
	_base_attack_force   = 20

/obj/item/bladed/broadsword
	name                 = "broadsword"
	desc                 = "A massive two-handed blade, almost too large to be called a sword."
	icon                 = 'icons/obj/items/bladed/broadsword.dmi'
	hilt_material        = /decl/material/solid/metal/brass
	guard_material       = /decl/material/solid/metal/brass
	pommel_material      = /decl/material/solid/metal/brass
	slot_flags           = SLOT_BACK
	base_parry_chance    = 35
	armor_penetration    = 20
	can_be_twohanded     = TRUE
	pickup_sound         = 'sound/foley/scrape1.ogg'
	drop_sound           = 'sound/foley/tooldrop1.ogg'
	_base_attack_force   = 22
