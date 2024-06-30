/decl/material/solid
	name = null
	melting_point = 1000
	boiling_point = 30000
	molar_mass = 0.232 //iron Fe3O4
	latent_heat = 6120 //iron
	door_icon_base = "stone"
	icon_base = 'icons/turf/walls/stone.dmi'
	table_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	dug_drop_type = /obj/item/stack/material/ore
	default_solid_form = /obj/item/stack/material/brick
	abstract_type = /decl/material/solid
	bakes_into_material = null

/decl/material/solid/Initialize()
	if(!liquid_name)
		liquid_name = "molten [name]"
	if(!gas_name)
		gas_name = "vaporized [name]"
	if(!solution_name)
		solution_name = "[name] solution"
	if(!ore_compresses_to)
		ore_compresses_to = type
	. = ..()