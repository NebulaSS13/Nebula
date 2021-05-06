/decl/material/gas
	name = null
	melting_point = 70
	boiling_point = 180 // -90 C - cryogenic liquid threshold
	color = COLOR_GRAY80
	shard_type = SHARD_NONE
	conductive = 0
	value = 0
	burn_product = /decl/material/gas/carbon_dioxide
	gas_specific_heat = 20    // J/(mol*K)
	gas_molar_mass =    0.032 // kg/mol
	reflectiveness = 0
	hardness = 0
	weight = 1
	opacity = 0.3
	default_solid_form = /obj/item/stack/material/aerogel

/decl/material/gas/New()
	if(!liquid_name)
		liquid_name = "liquid [name]"
	if(!solid_name)
		solid_name = "frozen [name]"
	..()
