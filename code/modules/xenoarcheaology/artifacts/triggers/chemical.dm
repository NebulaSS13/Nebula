/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		required_chemicals = list(pick(/decl/reagent/acid, /decl/reagent/toxin, /decl/reagent/water))

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
		/decl/reagent/water,
		/decl/reagent/water/boiling,
		/decl/reagent/drink/ice
	)

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		/decl/reagent/acid,
		/decl/reagent/acid/polyacid
	)

/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		/decl/reagent/toxin/phoron,
		/decl/reagent/fuel
	)

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"
	required_chemicals = list(
		/decl/reagent/toxin,
		/decl/reagent/toxin/cyanide,
		/decl/reagent/toxin/amatoxin,
		/decl/reagent/toxin/venom,
		/decl/reagent/toxin/chlorine
	)
