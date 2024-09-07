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

/decl/chemical_reaction/soap_key/on_reaction(datum/reagents/holder, created_volume, reaction_flags, list/reaction_data)
	var/obj/item/soap/S = holder.get_reaction_loc(chemical_reaction_flags)
	if(istype(S) && S.key_data)
		new /obj/item/key/temporary(get_turf(S), /decl/material/liquid/cleaner, S.key_data, strength)
	..()
