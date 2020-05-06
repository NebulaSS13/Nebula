/datum/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/decl/material/frostoil = 2, /decl/material/cleaner = 5)
	hidden_from_codex = TRUE
	var/strength = 3

/datum/chemical_reaction/soap_key/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/soap))
		return ..()
	return 0

/datum/chemical_reaction/soap_key/on_reaction(var/datum/reagents/holder)
	var/obj/item/soap/S = holder.my_atom
	if(S.key_data)
		var/obj/item/key/soap/key = new(get_turf(holder.my_atom), S.key_data)
		key.uses = strength
	..()

/datum/chemical_reaction/luminol
	name = "Luminol"
	result = /decl/material/luminol
	required_reagents = list(
		MAT_HYDRAZINE = 2, 
		MAT_GRAPHITE = 2, 
		MAT_AMMONIA = 2
	)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/datum/chemical_reaction/oxyphoron
	name = "Oxyphoron"
	result = MAT_OXYPHORON
	required_reagents = list(MAT_WATER = 1, MAT_PHORON = 1)
	result_amount = 2
	mix_message = "The solution boils violently, shedding wisps of vapor."

/datum/chemical_reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(MAT_WATER = 10)
	catalysts = list(MAT_OXYPHORON = 5)
	result_amount = 1
	mix_message = "The solution makes a loud cracking sound as it crystalizes."

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

/datum/chemical_reaction/nanoblood
	name = "Nanoblood"
	result = /decl/material/nanoblood
	required_reagents = list(
		/decl/material/nanitefluid = 1, 
		MAT_IRON = 1, 
		/decl/material/blood = 1
	)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."

/datum/chemical_reaction/anfo
	name = "EZ-ANFO"
	result = /decl/material/anfo
	required_reagents = list(
		/decl/material/toxin/fertilizer/eznutrient = 20, 
		MAT_FUEL = 10
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo2
	name = "Left 4 ANFO"
	result = /decl/material/anfo
	required_reagents = list(
		/decl/material/toxin/fertilizer/left4zed = 10,
		MAT_FUEL = 5
	)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo3
	name = "Robust ANFO"
	result = /decl/material/anfo
	required_reagents = list(
		/decl/material/toxin/fertilizer/robustharvest = 15,
		MAT_FUEL = 5
	)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo4
	name = "Chemlab ANFO"
	result = /decl/material/anfo
	required_reagents = list(
		MAT_AMMONIA = 10, 
		MAT_FUEL = 5
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo_plus
	name = "ANFO+"
	result = /decl/material/anfo/plus
	required_reagents = list(
		/decl/material/anfo = 15,
		MAT_ALUMINIUM = 5
	)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/crystal_agent
	result = MAT_CRYSTAL_AGENT
	required_reagents = list(
		MAT_SILICON = 1, 
		MAT_TUNGSTEN = 1, 
		MAT_ACID_POLYTRINIC = 1
	)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/datum/chemical_reaction/paint
	name = "Paint"
	result = /decl/material/paint
	required_reagents = list(
		/decl/material/toxin/plasticide = 1, 
		MAT_WATER = 3
	)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy sheen."
