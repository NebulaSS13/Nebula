/* Solidification */
/decl/chemical_reaction/synthesis
	result = null
	result_amount = 1
	mix_message = "The solution hardens and begins to crystallize."
	abstract_type = /decl/chemical_reaction/synthesis
	reaction_category = REACTION_TYPE_SYNTHESIS

/decl/chemical_reaction/synthesis/fiberglass
	name = "Fiberglass"
	mix_message = "The glass fibers are bound up in the polymer as it hardens."
	minimum_temperature = T100C
	maximum_temperature = INFINITY

/decl/chemical_reaction/synthesis/fiberglass/Initialize()
	required_reagents = list(
		/decl/material/solid/glass =   CEILING(REAGENT_UNITS_PER_MATERIAL_SHEET/2),
		/decl/material/solid/organic/plastic = CEILING(REAGENT_UNITS_PER_MATERIAL_SHEET/2)
	)
	. = ..()

/decl/chemical_reaction/synthesis/fiberglass/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		created_volume = CEILING(created_volume)
		if(created_volume > 0)
			var/decl/material/mat = GET_DECL(/decl/material/solid/fiberglass)
			mat.create_object(location, created_volume)

/decl/chemical_reaction/synthesis/crystalization/can_happen(datum/reagents/holder)
	. = ..() && length(holder.reagent_volumes) > 1

/decl/chemical_reaction/synthesis/crystalization
	name = "Crystalization"
	required_reagents = list(/decl/material/liquid/crystal_agent = 1)
	catalysts = list(/decl/material/liquid/crystal_agent = 5)
	inhibitors = list(
		/decl/material/solid/silicon
	) // Interferes with resin globules.

/decl/chemical_reaction/synthesis/crystalization/can_happen(datum/reagents/holder)
	. = ..() && length(holder.reagent_volumes) > 1
	if(.)
		. = FALSE
		for(var/rtype in holder.reagent_volumes)
			if(rtype != /decl/material/liquid/crystal_agent && REAGENT_VOLUME(holder, rtype) >= REAGENT_UNITS_PER_MATERIAL_SHEET)
				return TRUE

/decl/chemical_reaction/synthesis/crystalization/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		var/list/removing_reagents = list()
		for(var/rtype in holder.reagent_volumes)
			if(rtype != /decl/material/liquid/crystal_agent)
				var/solidifying = FLOOR(REAGENT_VOLUME(holder, rtype) / REAGENT_UNITS_PER_MATERIAL_SHEET)
				if(solidifying)
					SSmaterials.create_object(rtype, location, solidifying, /obj/item/stack/material/cubes)
					removing_reagents[rtype] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
		for(var/rtype in removing_reagents)
			holder.remove_reagent(rtype, removing_reagents[rtype])

// Turns gas into a "solid" form for use in PACMAN etc.
/decl/chemical_reaction/synthesis/aerogel
	name = "Aerogel"
	mix_message = "The solution solidifies into a translucent suspension of gas within gel."
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/liquid/plasticide = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	inhibitors = list(/decl/material/liquid/crystal_agent)

/decl/chemical_reaction/synthesis/aerogel/can_happen(datum/reagents/holder)
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

/decl/chemical_reaction/synthesis/aerogel/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		var/list/removing_reagents = list()
		for(var/rtype in holder.reagent_volumes)
			var/decl/material/mat = GET_DECL(rtype)
			if(mat.default_solid_form == /obj/item/stack/material/aerogel)
				var/solidifying = FLOOR(REAGENT_VOLUME(holder, rtype) / REAGENT_UNITS_PER_MATERIAL_SHEET)
				if(solidifying)
					SSmaterials.create_object(rtype, location, solidifying)
					removing_reagents[rtype] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
		for(var/rtype in removing_reagents)
			holder.remove_reagent(rtype, removing_reagents[rtype])

/decl/chemical_reaction/synthesis/plastication
	name = "Plastic"
	required_reagents = list(/decl/material/liquid/acid = 1, /decl/material/liquid/plasticide = 2)
	mix_message = "The solution solidifies into a grey-white mass."

/decl/chemical_reaction/synthesis/plastication/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		SSmaterials.create_object(/decl/material/solid/organic/plastic, location, created_volume)

/decl/chemical_reaction/synthesis/resin_pack
	name = "Resin Globule"
	required_reagents = list(
		/decl/material/liquid/crystal_agent = 1,
		/decl/material/solid/silicon = 2
	)
	result_amount = 3
	mix_message = "The solution hardens and begins to crystallize."

/decl/chemical_reaction/synthesis/resin_pack/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(!istype(T))
		return
	var/create_stacks = FLOOR(created_volume)
	if(create_stacks <= 0)
		return
	new /obj/item/stack/medical/resin/crafted(T, create_stacks)

/decl/chemical_reaction/synthesis/soap
	name = "Handmade Soap"
	required_reagents = list(
		/decl/material/solid/carbon/ashes         = 5,
		/decl/material/liquid/water               = 5,
		/decl/material/liquid/nutriment/plant_oil = 10
	)
	result_amount = 1
	mix_message = "The solution thickens and solidifies."
	minimum_temperature = 100 CELSIUS

/decl/chemical_reaction/synthesis/soap/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(!istype(T))
		return
	var/create_soap = FLOOR(created_volume)
	if(create_soap <= 0)
		return
	for(var/i = 1 to create_soap)
		new /obj/item/soap/crafted(T)
