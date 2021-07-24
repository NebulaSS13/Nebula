/* Solidification */
/datum/chemical_reaction/synthesis
	result = null
	result_amount = 1
	mix_message = "The solution hardens and begins to crystallize."

/datum/chemical_reaction/synthesis/fiberglass
	name = "Fiberglass"
	mix_message = "The glass fibers are bound up in the polymer as it hardens."
	minimum_temperature = T100C
	maximum_temperature = INFINITY

/datum/chemical_reaction/synthesis/fiberglass/New()
	required_reagents = list(
		/decl/material/solid/glass =   CEILING(REAGENT_UNITS_PER_MATERIAL_SHEET/2),
		/decl/material/solid/plastic = CEILING(REAGENT_UNITS_PER_MATERIAL_SHEET/2)
	)
	..()

/datum/chemical_reaction/synthesis/fiberglass/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	created_volume = CEILING(created_volume)
	if(created_volume > 0)
		var/decl/material/mat = GET_DECL(/decl/material/solid/fiberglass)
		mat.create_object(get_turf(holder.my_atom), created_volume)

/datum/chemical_reaction/synthesis/crystalization/can_happen(datum/reagents/holder)
	. = ..() && length(holder.reagent_volumes) > 1

/datum/chemical_reaction/synthesis/crystalization
	name = "Crystalization"
	required_reagents = list(/decl/material/liquid/crystal_agent = 1)
	catalysts = list(/decl/material/liquid/crystal_agent = 5)
	inhibitors = list(
		/decl/material/solid/silicon
	) // Interferes with resin globules.

/datum/chemical_reaction/synthesis/crystalization/can_happen(datum/reagents/holder)
	. = ..() && length(holder.reagent_volumes) > 1
	if(.)
		. = FALSE
		for(var/rtype in holder.reagent_volumes)
			if(rtype != /decl/material/liquid/crystal_agent && REAGENT_VOLUME(holder, rtype) >= REAGENT_UNITS_PER_MATERIAL_SHEET)
				return TRUE

/datum/chemical_reaction/synthesis/crystalization/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	var/list/removing_reagents = list()
	for(var/rtype in holder.reagent_volumes)
		if(rtype != /decl/material/liquid/crystal_agent)
			var/solidifying = FLOOR(REAGENT_VOLUME(holder, rtype) / REAGENT_UNITS_PER_MATERIAL_SHEET)
			if(solidifying)
				SSmaterials.create_object(rtype, get_turf(holder.my_atom), solidifying, /obj/item/stack/material/cubes)
				removing_reagents[rtype] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
	for(var/rtype in removing_reagents)
		holder.remove_reagent(rtype, removing_reagents[rtype])

// Turns gas into a "solid" form for use in PACMAN etc.
/datum/chemical_reaction/synthesis/aerogel
	name = "Aerogel"
	mix_message = "The solution solidifies into a translucent suspension of gas within gel."
	required_reagents = list(/decl/material/solid/silicon = 1)
	inhibitors = list(
		/decl/material/liquid/crystal_agent
	) // Interferes with resin globules.

/datum/chemical_reaction/synthesis/aerogel/can_happen(datum/reagents/holder)
	. = ..() && length(holder.reagent_volumes) > 1
	if(.)
		. = FALSE
		for(var/rtype in holder.reagent_volumes)
			if(REAGENT_VOLUME(holder, rtype) < REAGENT_UNITS_PER_MATERIAL_SHEET)
				continue
			var/decl/material/mat = GET_DECL(rtype)
			if(!mat || mat.default_solid_form != /obj/item/stack/material/aerogel)
				continue
			return TRUE

/datum/chemical_reaction/synthesis/aerogel/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	var/list/removing_reagents = list()
	for(var/rtype in holder.reagent_volumes)
		var/decl/material/mat = GET_DECL(rtype)
		if(mat.default_solid_form == /obj/item/stack/material/aerogel)
			var/solidifying = FLOOR(REAGENT_VOLUME(holder, rtype) / REAGENT_UNITS_PER_MATERIAL_SHEET)
			if(solidifying)
				SSmaterials.create_object(rtype, get_turf(holder.my_atom), solidifying)
				removing_reagents[rtype] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
	for(var/rtype in removing_reagents)
		holder.remove_reagent(rtype, removing_reagents[rtype])

/datum/chemical_reaction/synthesis/plastication
	name = "Plastic"
	required_reagents = list(/decl/material/liquid/acid/polyacid = 1, /decl/material/liquid/plasticide = 2)
	mix_message = "The solution solidifies into a grey-white mass."

/datum/chemical_reaction/synthesis/plastication/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	SSmaterials.create_object(/decl/material/solid/plastic, get_turf(holder.my_atom), created_volume)

/datum/chemical_reaction/synthesis/resin_pack
	name = "Resin Globule"
	required_reagents = list(
		/decl/material/liquid/crystal_agent = 1,
		/decl/material/solid/silicon = 2
	)
	result_amount = 3
	mix_message = "The solution hardens and begins to crystallize."

/datum/chemical_reaction/synthesis/resin_pack/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T))
		var/create_stacks = FLOOR(created_volume)
		if(create_stacks > 0)
			new /obj/item/stack/medical/resin/handmade(T, create_stacks)
