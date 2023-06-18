
//Components that soak damage before it reaches other components.
/obj/item/stock_parts/shielding
	base_type = /obj/item/stock_parts/shielding
	material_health_multiplier = 0.4
	var/list/protection_types	//types of damage it will soak

/obj/item/stock_parts/shielding/electric
	name = "fuse box"
	icon_state = "fusebox"
	desc = "A bloc of multi-use fuses, used to protect components against electrical current spikes."
	protection_types = list(ELECTROCUTE)
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stock_parts/shielding/kinetic
	name = "internal armor"
	icon_state = "armor"
	desc = "An impact-resistant armor plate used to shield delicate machine components."
	protection_types = list(BRUTE)
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/shielding/heat
	name = "heatsink"
	icon_state = "heatsink"
	desc = "An active cooling system used to safeguard machinery against high temperatures."
	protection_types = list(BURN)
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)