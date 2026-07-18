/obj/structure/flora
	/// Percentage chance of trying to spawn an insect hive here, if appropriate.
	var/insect_hive_chance = 20

/obj/structure/flora/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(insect_hive_chance && length(get_supported_insects()))
		return INITIALIZE_HINT_LATELOAD

/obj/structure/flora/LateInitialize()
	..()
	if(prob(insect_hive_chance) && !has_extension(src, /datum/extension/insect_hive))
		var/list/insects = get_supported_insects()
		if(length(insects))
			insects = insects.Copy() // don't mutate the static list.
			for(var/species_type in insects)
				var/decl/insect_species/species = GET_DECL(species_type)
				if(!species.can_spawn_in_flora(src))
					insects -= species_type
			if(length(insects))
				set_extension(src, /datum/extension/insect_hive, pickweight(insects))
				update_icon()

// Insect species that can hive in this flora.
/obj/structure/flora/proc/get_supported_insects()
	return

/obj/structure/flora/tree/get_supported_insects()
	var/static/list/_insects = list(
		/decl/insect_species/honeybees = 10,
		///decl/insect_species/wasps     = 1
	)
	return _insects

/obj/structure/flora/stump/get_supported_insects()
	var/static/list/_insects = list(
		/decl/insect_species/honeybees = 10,
		///decl/insect_species/wasps     = 1
	)
	return _insects
