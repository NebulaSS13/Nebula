
//Components that soak damage before it reaches other components.
/obj/item/stock_parts/shielding
	base_type = /obj/item/stock_parts/shielding
	material_health_multiplier = 0.4
	var/list/protection_types	//types of damage it will soak

/obj/item/stock_parts/shielding/electric
	name = "fuse box"
	icon_state = "fusebox"
	desc = "A bloc of multi-use fuses, protecting the machine against the electrical current spikes."
	protection_types = list(ELECTROCUTE)
	material_composition = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/glass = MATTER_AMOUNT_TERTIARY
	)

/obj/item/stock_parts/shielding/kinetic
	name = "internal armor"
	icon_state = "armor"
	desc = "Kinetic resistant armor plates to line the machine with."
	protection_types = list(BRUTE)
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)

/obj/item/stock_parts/shielding/heat
	name = "heatsink"
	icon_state = "heatsink"
	desc = "Active cooling system protecting machinery against the high temperatures."
	protection_types = list(BURN)
	material_composition = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TERTIARY
	)
