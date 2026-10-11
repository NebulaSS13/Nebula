/decl/material/gas
	name = null
	melting_point = 70
	boiling_point = 180 // -90 C - cryogenic liquid threshold
	gas_color = COLOR_GRAY80
	shard_name = SHARD_NONE
	conductive = 0
	value = 0.15
	burn_product = /decl/material/gas/carbon_dioxide
	molar_mass =    0.032 // kg/mol
	latent_heat = 213
	reflectiveness = 0
	hardness = 0
	weight = 1
	opacity = 0.3
	default_solid_form = /obj/item/stack/material/aerogel
	abstract_type = /decl/material/gas

/decl/material/gas/Initialize()
	liquid_name   ||= "liquid [name]"
	solid_name    ||= "frozen [name]"
	solution_name ||= "[name] solution"
	liquid_color  ||= gas_color
	solid_color   ||= gas_color
	. = ..()
