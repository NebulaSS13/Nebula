/decl/material/solid
	name = null
	melting_point = 1000
	boiling_point = 30000
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"

/decl/material/solid/New()
	if(!liquid_name)
		liquid_name = "molten [name]"
	if(!gas_name)
		gas_name = "vaporized [name]"
	if(!ore_compresses_to)
		ore_compresses_to = type
	..()