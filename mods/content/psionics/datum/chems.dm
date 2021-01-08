/decl/material/liquid/crystal_agent/do_material_check(var/mob/living/carbon/M)
	var/decl/special_role/wizard/wizards = decls_repository.get_decl(/decl/special_role/wizard)
	. = (M.psi || (M.mind && wizards.is_antagonist(M.mind))) ? MAT_NULLGLASS : ..()
	
/decl/material/liquid/glowsap/gleam/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	if(M.psi)
		M.psi.check_latency_trigger(30, "a [name] overdose")

/datum/chemical_reaction/synthesis/nullglass
	name = "Soulstone"
	result = null
	required_reagents = list(/decl/material/liquid/blood = 15, /decl/material/liquid/crystal_agent = 1)
	result_amount = 1

/datum/chemical_reaction/synthesis/nullglass/get_reaction_flags(var/datum/reagents/holder)
	var/list/blood_data = REAGENT_DATA(holder, /decl/material/liquid/blood)
	var/weakref/donor_ref = LAZYACCESS(blood_data, "donor")
	var/mob/living/donor = donor_ref?.resolve()
	var/decl/special_role/wizard/wizards = decls_repository.get_decl(/decl/special_role/wizard)
	. = (istype(donor) && (donor.psi || (donor.mind && wizards.is_antagonist(donor.mind))))

/datum/chemical_reaction/synthesis/nullglass/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	var/location = get_turf(holder.my_atom)
	if(reaction_flags)
		for(var/i = 1, i <= created_volume, i++)
			new /obj/item/soulstone(location)
	else
		for(var/i = 1, i <= created_volume*2, i++)
			new /obj/item/shard(location, /decl/material/solid/gemstone/crystal)