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
		/decl/material/solid/glass =   ceil(REAGENT_UNITS_PER_MATERIAL_SHEET/2),
		/decl/material/solid/organic/plastic = ceil(REAGENT_UNITS_PER_MATERIAL_SHEET/2)
	)
	. = ..()

/decl/chemical_reaction/synthesis/fiberglass/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	..()
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		created_volume = ceil(created_volume)
		if(created_volume > 0)
			var/decl/material/mat = GET_DECL(/decl/material/solid/fiberglass)
			mat.create_object(location, created_volume)

/decl/chemical_reaction/synthesis/crystalization
	name = "Crystalization"
	required_reagents = list(/decl/material/liquid/crystal_agent = 1)
	catalysts = list(/decl/material/liquid/crystal_agent = 5)
	inhibitors = list(
		/decl/material/solid/silicon
	) // Interferes with resin globules.

/decl/chemical_reaction/synthesis/crystalization/can_happen(datum/reagents/holder)
	var/holder_volumes = REAGENT_VOLUMES(holder)
	. = ..() && length(holder_volumes) > 1
	if(.)
		. = FALSE
		for(var/decl/material/reagent as anything in holder_volumes)
			if(reagent.type != /decl/material/liquid/crystal_agent && REAGENT_VOLUME(holder, reagent) >= REAGENT_UNITS_PER_MATERIAL_SHEET)
				return TRUE

/decl/chemical_reaction/synthesis/crystalization/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		var/list/removing_reagents = list()
		for(var/decl/material/reagent as anything in REAGENT_VOLUMES(holder))
			if(reagent.type != /decl/material/liquid/crystal_agent)
				var/solidifying = floor(REAGENT_VOLUME(holder, reagent) / REAGENT_UNITS_PER_MATERIAL_SHEET)
				if(solidifying)
					SSmaterials.create_object(reagent.type, location, solidifying, /obj/item/stack/material/cubes)
					removing_reagents[reagent] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
		for(var/reagent in removing_reagents)
			holder.remove_reagent(reagent, removing_reagents[reagent])

// Turns gas into a "solid" form for use in PACMAN etc.
/decl/chemical_reaction/synthesis/aerogel
	name = "Aerogel"
	mix_message = "The solution solidifies into a translucent suspension of gas within gel."
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/liquid/plasticide = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	inhibitors = list(/decl/material/liquid/crystal_agent)

/decl/chemical_reaction/synthesis/aerogel/can_happen(datum/reagents/holder)
	var/holder_volumes = REAGENT_VOLUMES(holder)
	. = ..() && length(holder_volumes) > 1
	if(.)
		. = FALSE
		for(var/decl/material/reagent as anything in holder_volumes)
			if(REAGENT_VOLUME(holder, reagent) < REAGENT_UNITS_PER_MATERIAL_SHEET)
				continue
			if(reagent.default_solid_form != /obj/item/stack/material/aerogel)
				continue
			return TRUE

/decl/chemical_reaction/synthesis/aerogel/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(location)
		var/list/removing_reagents = list()
		for(var/decl/material/reagent as anything in REAGENT_VOLUMES(holder))
			if(reagent.default_solid_form == /obj/item/stack/material/aerogel)
				var/solidifying = floor(REAGENT_VOLUME(holder, reagent) / REAGENT_UNITS_PER_MATERIAL_SHEET)
				if(solidifying)
					SSmaterials.create_object(reagent.type, location, solidifying)
					removing_reagents[reagent] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
		for(var/reagent in removing_reagents)
			holder.remove_reagent(reagent, removing_reagents[reagent])

/decl/chemical_reaction/synthesis/plastication
	name = "Plastic"
	required_reagents = list(/decl/material/liquid/acid = 1, /decl/material/liquid/plasticide = 2)
	mix_message = "The solution solidifies into a grey-white mass."

/decl/chemical_reaction/synthesis/plastication/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
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

/decl/chemical_reaction/synthesis/resin_pack/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	..()
	var/turf/T = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(!istype(T))
		return
	var/create_stacks = floor(created_volume)
	if(create_stacks <= 0)
		return
	new /obj/item/stack/medical/resin/crafted(T, create_stacks)

/decl/chemical_reaction/synthesis/soap
	name = "Handmade Plant Soap"
	required_reagents = list(
		/decl/material/solid/carbon/ashes = 5,
		/decl/material/liquid/water       = 5,
		/decl/material/liquid/oil/plant   = 10
	)
	result_amount = 1
	mix_message = "The solution thickens and solidifies."
	minimum_temperature = 100 CELSIUS

/decl/chemical_reaction/synthesis/soap/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	..()
	var/turf/T = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(!istype(T))
		return
	var/create_soap = floor(created_volume)
	if(create_soap <= 0)
		return
	for(var/i = 1 to create_soap)
		new /obj/item/soap/crafted(T)

/decl/chemical_reaction/synthesis/soap/corn
	name = "Handmade Corn Soap"
	required_reagents = list(
		/decl/material/solid/carbon/ashes    = 5,
		/decl/material/liquid/water          = 5,
		/decl/material/liquid/oil/plant/corn = 10
	)

// Making chipboard out of wood scraps/recycled wood.
/decl/chemical_reaction/synthesis/chipboard
	name = "Oak Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/oak = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic  = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	result_amount = 1
	mix_message = "The wood particulate binds with the plastic to form laminated chipboard."
	minimum_temperature = 100 CELSIUS
	var/chipboard_type = /decl/material/solid/organic/wood/chipboard

/decl/chemical_reaction/synthesis/chipboard/on_reaction(datum/reagents/holder, created_volume, list/reaction_data)
	..()
	var/turf/T = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(!istype(T))
		return
	var/create_sheets = floor(created_volume)
	if(create_sheets <= 0)
		return
	new /obj/item/stack/material/sheet(T, create_sheets, chipboard_type)

/decl/chemical_reaction/synthesis/chipboard/maple
	name = "Maple Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/maple = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic    = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	chipboard_type = /decl/material/solid/organic/wood/chipboard/maple

/decl/chemical_reaction/synthesis/chipboard/mahogany
	name = "Mahogany Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/mahogany = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic       = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	chipboard_type = /decl/material/solid/organic/wood/chipboard/mahogany

/decl/chemical_reaction/synthesis/chipboard/ebony
	name = "Ebony Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/ebony = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic    = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	chipboard_type = /decl/material/solid/organic/wood/chipboard/ebony

/decl/chemical_reaction/synthesis/chipboard/walnut
	name = "Walnut Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/walnut = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic     = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	chipboard_type = /decl/material/solid/organic/wood/chipboard/walnut

/decl/chemical_reaction/synthesis/chipboard/yew
	name = "Yew Chipboard"
	required_reagents = list(
		/decl/material/solid/organic/wood/yew = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2),
		/decl/material/solid/organic/plastic    = (REAGENT_UNITS_PER_MATERIAL_SHEET / 2)
	)
	chipboard_type = /decl/material/solid/organic/wood/chipboard/yew
