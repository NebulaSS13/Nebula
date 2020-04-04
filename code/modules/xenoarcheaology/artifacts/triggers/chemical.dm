/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		required_chemicals = list(pick(/datum/reagent/acid, /datum/reagent/toxin, /datum/reagent/water))

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
		/datum/reagent/water,
		/datum/reagent/water/boiling,
		/datum/reagent/drink/ice
	)

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		/datum/reagent/acid,
		/datum/reagent/acid/polyacid
	)

/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		/datum/reagent/toxin/phoron,
		/datum/reagent/fuel
	)

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"
	required_chemicals = list(
		/datum/reagent/toxin,
		/datum/reagent/toxin/cyanide,
		/datum/reagent/toxin/amatoxin,
		/datum/reagent/toxin/venom,
		/datum/reagent/toxin/chlorine
	)
