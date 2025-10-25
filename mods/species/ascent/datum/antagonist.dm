/decl/special_role/hunter
	name = "Hunter"
	name_plural = "Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You are a gyne of the Ascent, and command a brood of alates. Your task is to \
	take control of this sector so that you may found a new fortress-nest. Identify and capture local resources, \
	and remove anything that might threaten your progeny."
	welcome_text = "You are an alate of the Ascent, tasked with ridding this sector of whatever your matriarch directs you to, \
	preparing it for the foundation of a new fortress-nest. Obey your gyne and bring prosperity to your nest-lineage."
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 10
	hard_cap_round = 10
	initial_spawn_req = 4
	initial_spawn_target = 6
	rig_type = /obj/item/rig/mantid

/decl/special_role/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..()
	var/lineage = create_gyne_name()
	if(ishuman(player.current))
		var/mob/living/human/H = player.current
		set_gyne_lineage(H, lineage) // This makes all antag ascent have the same lineage on get_random_cultural_name().
		var/species_uid = H.get_species()?.uid
		if(!leader && is_species_whitelisted(player.current, /decl/species/mantid/gyne::uid))
			leader = player
			if(species_uid != /decl/species/mantid/gyne::uid)
				H.set_species(/decl/species/mantid/gyne::uid)
			H.set_gender(FEMALE)
		else
			if(species_uid != /decl/species/mantid::uid)
				H.set_species(/decl/species/mantid::uid)
			H.set_gender(MALE)
		var/decl/background_detail/heritage/ascent/background = GET_DECL(/decl/background_detail/heritage/ascent)
		H.real_name = background.get_random_cultural_name(H, H.gender, H.get_species())
		H.name = H.real_name

/decl/special_role/hunter/equip_role(var/mob/living/human/player)
	if(player?.get_species()?.uid == /decl/species/mantid::uid)
		rig_type = /obj/item/rig/mantid/gyne
	else
		rig_type = initial(rig_type)
	. = ..()
	if(.)
		player.put_in_hands(new /obj/item/gun/energy/particle)

/decl/special_role/hunter/equip_rig(rig_type, mob/living/human/player)
	var/obj/item/rig/mantid/rig = ..()
	if(rig)
		rig.visible_name = player.real_name
		return rig
