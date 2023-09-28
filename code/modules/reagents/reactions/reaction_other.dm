/decl/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/decl/material/liquid/frostoil = 2, /decl/material/liquid/cleaner = 5)
	hidden_from_codex = TRUE
	var/strength = 3

/decl/chemical_reaction/soap_key/can_happen(var/datum/reagents/holder)
	if(istype(holder.get_reaction_loc(chemical_reaction_flags), /obj/item/soap))
		return ..()
	return 0

/decl/chemical_reaction/soap_key/on_reaction(var/datum/reagents/holder)
	var/obj/item/soap/S = holder.get_reaction_loc(chemical_reaction_flags)
	if(istype(S) && S.key_data)
		var/obj/item/key/soap/key = new(get_turf(S), S.key_data)
		key.uses = strength
	..()

/decl/chemical_reaction/luminol
	name = "Luminol"
	result = /decl/material/liquid/luminol
	required_reagents = list(/decl/material/liquid/fuel/hydrazine = 2, /decl/material/solid/carbon = 2, /decl/material/gas/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/decl/chemical_reaction/nanoblood
	name = "Nanoblood"
	result = /decl/material/liquid/nanoblood
	required_reagents = list(/decl/material/liquid/nanitefluid = 1, /decl/material/solid/metal/iron = 1, /decl/material/liquid/blood = 1)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."

/decl/chemical_reaction/anfo
	name = "Fertilizer ANFO"
	result = /decl/material/liquid/anfo
	required_reagents = list(
		/decl/material/liquid/fertilizer = 20,
		/decl/material/liquid/fuel = 10
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/anfo4
	name = "Chemlab ANFO"
	result = /decl/material/liquid/anfo
	required_reagents = list(
		/decl/material/gas/ammonia = 10,
		/decl/material/liquid/fuel = 5
	)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/anfo_plus
	name = "ANFO+"
	result = /decl/material/liquid/anfo/plus
	required_reagents = list(
		/decl/material/liquid/anfo = 15,
		/decl/material/solid/metal/aluminium = 5
	)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/decl/chemical_reaction/crystal_agent
	name = "Crystallizing Agent"
	result = /decl/material/liquid/crystal_agent
	required_reagents = list(/decl/material/solid/silicon = 1, /decl/material/solid/metal/tungsten = 1, /decl/material/liquid/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/decl/chemical_reaction/paint
	name = "Paint"
	result = /decl/material/liquid/paint
	required_reagents = list(/decl/material/liquid/plasticide = 1, /decl/material/liquid/water = 3)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy sheen."
