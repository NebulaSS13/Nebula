/decl/reagent/crystal/do_material_check(var/mob/living/carbon/M)
	. = (M.psi || (M.mind && GLOB.wizards.is_antagonist(M.mind))) ? MAT_NULLGLASS : ..()
	
/decl/reagent/glowsap/gleam/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	if(M.psi)
		M.psi.check_latency_trigger(30, "a [name] overdose")

/datum/chemical_reaction/synthesis/nullglass
	name = "Soulstone"
	result = null
	required_reagents = list(/decl/reagent/blood = 15, /decl/reagent/crystal = 1)
	result_amount = 1

/datum/chemical_reaction/synthesis/nullglass/get_reaction_flags(var/datum/reagents/holder)
	var/list/blood_data = REAGENT_DATA(holder, /decl/reagent/blood)
	var/weakref/donor_ref = LAZYACCESS(blood_data, "donor")
	var/mob/living/donor = donor_ref?.resolve()
	. = (istype(donor) && (donor.psi || (donor.mind && GLOB.wizards.is_antagonist(donor.mind))))

/datum/chemical_reaction/synthesis/nullglass/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	var/location = get_turf(holder.my_atom)
	if(reaction_flags)
		for(var/i = 1, i <= created_volume, i++)
			new /obj/item/soulstone(location)
	else
		for(var/i = 1, i <= created_volume*2, i++)
			new /obj/item/material/shard(location, MAT_CRYSTAL)