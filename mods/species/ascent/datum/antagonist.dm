/decl/special_role/hunter
	name = "Hunter"
	name_plural = "Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You are a gyne of the Ascent, and command a brood of alates. Your task is to \
	take control of this sector so that you may found a new fortress-nest. Identify and capture local resources, \
	and remove anything that might threaten your progeny."
	welcome_text = "You are an alate of the Ascent, tasked with ridding this sector of whatever your matriarch directs you to, \
	preparing it for the foundation of a new fortress-nest. Obey your gyne and bring prosperity to your nest-lineage."
	leader_welcome_text
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 10
	hard_cap_round = 10
	initial_spawn_req = 4
	initial_spawn_target = 6
	rig_type = /obj/item/rig/mantid

/decl/special_role/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..()
	var lineage = create_gyne_name();
	if(ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		H.dna.lineage = lineage; // This makes all antag ascent have the same lineage on get_random_name.
		if(!leader && is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
			leader = player
			if(H.species.get_root_species_name() != SPECIES_MANTID_GYNE)
				H.set_species(SPECIES_MANTID_GYNE)
			H.gender = FEMALE
		else
			if(H.species.get_root_species_name() != SPECIES_MANTID_ALATE)
				H.set_species(SPECIES_MANTID_ALATE)
			H.gender = MALE
		var/decl/cultural_info/culture/ascent/ascent_culture = SSlore.get_culture(CULTURE_ASCENT)
		H.real_name = ascent_culture.get_random_name(H, H.gender)
		H.name = H.real_name

/decl/special_role/hunter/equip(var/mob/living/carbon/human/player)
	if(player?.species.get_root_species_name(player) == SPECIES_MANTID_GYNE)
		rig_type = /obj/item/rig/mantid/gyne
	else
		rig_type = initial(rig_type)
	. = ..()
	if(.)
		player.put_in_hands(new /obj/item/gun/energy/particle)

/decl/special_role/hunter/equip_rig(rig_type, mob/living/carbon/human/player)
	var/obj/item/rig/mantid/rig = ..()
	if(rig)
		rig.visible_name = player.real_name
		return rig
