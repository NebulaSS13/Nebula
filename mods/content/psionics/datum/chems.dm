/decl/material/liquid/crystal_agent/do_material_check(var/mob/living/M)
	var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
	. = (M.get_ability_handler(/datum/ability_handler/psionics) || (M.mind && wizards.is_antagonist(M.mind))) ? MAT_NULLGLASS : ..()

/decl/material/liquid/glowsap/gleam/affect_overdose(mob/living/M, total_dose)
	..()
	var/datum/ability_handler/psionics/psi = M.get_ability_handler(/datum/ability_handler/psionics)
	psi?.check_latency_trigger(30, "a [name] overdose")

/decl/chemical_reaction/synthesis/nullglass
	name = "Soulstone"
	result = null
	required_reagents = list(/decl/material/liquid/blood = 15, /decl/material/liquid/crystal_agent = 1)
	result_amount = 1

// TODO: #if defined(GAMEMODE_PACK_CULT) && defined(GAMEMODE_PACK_WIZARD)
// once wizard is modpacked
#ifdef GAMEMODE_PACK_CULT
/decl/chemical_reaction/synthesis/nullglass/get_alternate_reaction_indicator(var/datum/reagents/holder)
	var/list/blood_data = REAGENT_DATA(holder, /decl/material/liquid/blood)
	var/weakref/donor_ref = LAZYACCESS(blood_data, "donor")
	var/mob/living/donor = donor_ref?.resolve()
	var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
	. = (istype(donor) && (!!donor.get_ability_handler(/datum/ability_handler/psionics) || (donor.mind && wizards.is_antagonist(donor.mind))))
#endif

/decl/chemical_reaction/synthesis/nullglass/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(reaction_flags)
		#ifdef GAMEMODE_PACK_CULT
		for(var/i = 1, i <= created_volume, i++)
			new /obj/item/soulstone(location)
		#else
		CRASH("Nullglass alternate reaction triggered in [holder.my_atom] without cult modpack loaded!")
		#endif
	else
		for(var/i = 1, i <= created_volume*2, i++)
			new /obj/item/shard(location, /decl/material/solid/gemstone/crystal)