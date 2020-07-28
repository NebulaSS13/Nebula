/* Solidification */
/datum/chemical_reaction/synthesis
	result = null
	result_amount = 1
	mix_message = "The solution hardens and begins to crystallize."

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
			var/solidifying = Floor(REAGENT_VOLUME(holder, rtype) / REAGENT_UNITS_PER_MATERIAL_SHEET)
			if(solidifying)
				new /obj/item/stack/material/generic(get_turf(holder.my_atom), solidifying, rtype)
				removing_reagents[rtype] = solidifying * REAGENT_UNITS_PER_MATERIAL_SHEET
	for(var/rtype in removing_reagents)
		holder.remove_reagent(rtype, removing_reagents[rtype])

/datum/chemical_reaction/synthesis/plastication
	name = "Plastic"
	required_reagents = list(/decl/material/liquid/acid/polyacid = 1, /decl/material/liquid/plasticide = 2)
	mix_message = "The solution solidifies into a grey-white mass."

/datum/chemical_reaction/synthesis/plastication/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

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
		var/create_stacks = Floor(created_volume)
		if(create_stacks > 0)
			new /obj/item/stack/medical/resin/handmade(T, create_stacks)
