/datum/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/decl/material/chem/frostoil = 2, /decl/material/chem/cleaner = 5)
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
	result = /decl/material/chem/luminol
	required_reagents = list(/decl/material/chem/fuel/hydrazine = 2, /decl/material/chem/carbon = 2, /decl/material/chem/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/datum/chemical_reaction/oxyphoron
	name = "Oxyphoron"
	result = /decl/material/chem/toxin/phoron/oxygen
	required_reagents = list(/decl/material/gas/water = 1, /decl/material/chem/toxin/phoron = 1)
	result_amount = 2
	mix_message = "The solution boils violently, shedding wisps of vapor."

/datum/chemical_reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(/decl/material/gas/water = 10)
	catalysts = list(/decl/material/chem/toxin/phoron/oxygen = 5)
	result_amount = 1
	mix_message = "The solution makes a loud cracking sound as it crystalizes."

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

/datum/chemical_reaction/nanoblood
	name = "Nanoblood"
	result = /decl/material/chem/nanoblood
	required_reagents = list(/decl/material/chem/nanitefluid = 1, /decl/material/iron = 1, /decl/material/chem/blood = 1)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."

/datum/chemical_reaction/anfo
	name = "EZ-ANFO"
	result = /decl/material/chem/anfo
	required_reagents = list(/decl/material/chem/toxin/fertilizer/eznutrient=20, /decl/material/chem/fuel=10)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo2
	name = "Left 4 ANFO"
	result = /decl/material/chem/anfo
	required_reagents = list(/decl/material/chem/toxin/fertilizer/left4zed=10, /decl/material/chem/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo3
	name = "Robust ANFO"
	result = /decl/material/chem/anfo
	required_reagents = list(/decl/material/chem/toxin/fertilizer/robustharvest=15, /decl/material/chem/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo4
	name = "Chemlab ANFO"
	result = /decl/material/chem/anfo
	required_reagents = list(/decl/material/chem/ammonia=10, /decl/material/chem/fuel=5)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo_plus
	name = "ANFO+"
	result = /decl/material/chem/anfo/plus
	required_reagents = list(/decl/material/chem/anfo=15, /decl/material/aluminium=5)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/crystal_agent
	result = /decl/material/chem/crystal_agent
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/tungsten = 1, /decl/material/chem/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/datum/chemical_reaction/paint
	name = "Paint"
	result = /decl/material/chem/narcotics
	required_reagents = list(/decl/material/chem/toxin/plasticide = 1, /decl/material/gas/water = 3)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy sheen."
