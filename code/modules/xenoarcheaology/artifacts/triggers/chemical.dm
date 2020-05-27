/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		required_chemicals = list(pick(/decl/material/chem/acid, /decl/material/chem/toxin, /decl/material/gas/water))

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
	required_chemicals = list(
		/decl/material/gas/water,
		/decl/material/gas/water/boiling,
		/decl/material/gas/water/ice
	)

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		/decl/material/chem/acid,
		/decl/material/chem/acid/polyacid
	)

/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		/decl/material/chem/toxin/phoron,
		/decl/material/chem/fuel
	)

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"
	required_chemicals = list(
		/decl/material/chem/toxin,
		/decl/material/chem/toxin/cyanide,
		/decl/material/chem/toxin/amatoxin,
		/decl/material/chem/toxin/venom,
		/decl/material/chem/toxin/chlorine
	)
