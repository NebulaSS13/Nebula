/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		required_chemicals = list(pick(/decl/material/liquid/acid, /decl/material/liquid/bromide, /decl/material/liquid/water))
		var/decl/material/M = GET_DECL(required_chemicals[1])
		name = "presence of [M.name]"

/datum/artifact_trigger/chemical/copy()
	var/datum/artifact_trigger/chemical/C = ..()
	C.required_chemicals = required_chemicals.Copy()

/datum/artifact_trigger/chemical/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/chems))
		for(var/reagent in required_chemicals)
			if(O.remove_from_reagents(reagent, 1))
				return TRUE

/datum/artifact_trigger/chemical/water
	name = "presence of water"
	required_chemicals = list(
		/decl/material/liquid/water,
		/decl/material/solid/ice
	)

/datum/artifact_trigger/chemical/on_fluid_act(datum/reagents/fluids)
	for(var/reagent in required_chemicals)
		if(fluids.remove_reagent(reagent, 5))
			return TRUE
	return ..()

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		/decl/material/liquid/acid,
		/decl/material/liquid/acid/hydrochloric,
		/decl/material/liquid/acid/polyacid
	)

/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		/decl/material/liquid/fuel
	)

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"
	required_chemicals = list(
		/decl/material/liquid/bromide,
		/decl/material/liquid/cyanide,
		/decl/material/liquid/amatoxin,
		/decl/material/liquid/venom,
		/decl/material/gas/chlorine
	)
