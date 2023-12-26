/obj/structure/ship_munition/disperser_charge
	name = "unknown disperser charge"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge does not have a defined purpose."
	icon_state = "slug"
	atom_flags =  ATOM_FLAG_CLIMBABLE
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel =   MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper =  MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/exotic_matter = MATTER_AMOUNT_TRACE
	)
	var/chargetype
	var/chargedesc

/obj/structure/ship_munition/disperser_charge/get_single_monetary_worth()
	. = round(..() * 3) // Artificially inflate the value a bit.

/obj/structure/ship_munition/disperser_charge/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(chargedesc)
		name = "\improper [chargedesc] charge"

/obj/structure/ship_munition/disperser_charge/fire
	color = "#b95a00"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to release a localised fire on impact."
	chargetype = OVERMAP_WEAKNESS_FIRE
	chargedesc = "FR1-ENFER"

/obj/structure/ship_munition/disperser_charge/emp
	color = "#6a97b0"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to release a blast of electromagnetic pulse on impact."
	chargetype = OVERMAP_WEAKNESS_EMP
	chargedesc = "EM2-QUASAR"

/obj/structure/ship_munition/disperser_charge/mining
	color = "#cfcf55"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to mine ores on impact."
	chargetype = OVERMAP_WEAKNESS_MINING
	chargedesc = "MN3-BERGBAU"

/obj/structure/ship_munition/disperser_charge/explosive
	color = "#aa5f61"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to explode on impact."
	chargetype = OVERMAP_WEAKNESS_EXPLOSIVE
	chargedesc = "XP4-INDARRA"
