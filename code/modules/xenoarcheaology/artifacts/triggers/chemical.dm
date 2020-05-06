/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		required_chemicals = list(pick(MAT_ACID_SULPHURIC, /decl/material/toxin, MAT_WATER))

/datum/artifact_trigger/chemical/copy()
	var/datum/artifact_trigger/chemical/C = ..()
	C.required_chemicals = required_chemicals.Copy()

/datum/artifact_trigger/chemical/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/chems))
		for(var/reagent in required_chemicals)
			if(O.reagents.remove_reagent(reagent, 5))
				return TRUE

/datum/artifact_trigger/chemical/water
	name = "presence of water"
	required_chemicals = list(MAT_WATER)

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		MAT_ACID_SULPHURIC,
		MAT_ACID_HYDROCHLORIC,
		MAT_ACID_POLYTRINIC
	)

/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		MAT_PHORON,
		MAT_FUEL
	)

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"
	required_chemicals = list(
		/decl/material/toxin,
		/decl/material/toxin/cyanide,
		/decl/material/toxin/amatoxin,
		/decl/material/toxin/venom,
		MAT_CHLORINE
	)
