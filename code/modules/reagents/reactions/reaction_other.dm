/datum/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/datum/reagent/frostoil = 2, /datum/reagent/cleaner = 5)
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
	result = /datum/reagent/luminol
	required_reagents = list(/datum/reagent/fuel/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/datum/chemical_reaction/oxyphoron
	name = "Oxyphoron"
	result = /datum/reagent/toxin/phoron/oxygen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/toxin/phoron = 1)
	result_amount = 2
	mix_message = "The solution boils violently, shedding wisps of vapor."

/datum/chemical_reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(/datum/reagent/water = 10)
	catalysts = list(/datum/reagent/toxin/phoron/oxygen = 5)
	result_amount = 1
	mix_message = "The solution makes a loud cracking sound as it crystalizes."

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

/datum/chemical_reaction/nanoblood
	name = "Nanoblood"
	result = /datum/reagent/nanoblood
	required_reagents = list(/datum/reagent/nanitefluid = 1, /datum/reagent/iron = 1, /datum/reagent/blood = 1)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."

/datum/chemical_reaction/anfo
	name = "EZ-ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/eznutrient=20, /datum/reagent/fuel=10)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo2
	name = "Left 4 ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/left4zed=10, /datum/reagent/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo3
	name = "Robust ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/robustharvest=15, /datum/reagent/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo4
	name = "Chemlab ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/ammonia=10, /datum/reagent/fuel=5)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo_plus
	name = "ANFO+"
	result = /datum/reagent/anfo/plus
	required_reagents = list(/datum/reagent/anfo=15, /datum/reagent/aluminium=5)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/crystal_agent
	result = /datum/reagent/crystal
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/tungsten = 1, /datum/reagent/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/datum/chemical_reaction/paint
	name = "Paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy sheen."

/datum/chemical_reaction/paint/send_data(datum/reagents/holder)
	var/datum/reagent/pigment/pigment = locate() in holder.reagent_list
	return pigment && pigment.color

/datum/chemical_reaction/paint/can_happen(datum/reagents/holder)
	. = ..() && (locate(/datum/reagent/pigment) in holder.reagent_list)
