// ZOMBIES
// Dead and rotting, but still mobile and aggressive.

/datum/mob_controller/aggressive/zombie

/mob/living/human/proc/make_zombie()
	set_trait(/decl/trait/metabolically_inert, TRAIT_LEVEL_EXISTS)
	set_trait(/decl/trait/undead, TRAIT_LEVEL_MINOR)

	if(istype(ai))
		QDEL_NULL(ai)
	ai = new /datum/mob_controller/aggressive/zombie(src)
	faction = "undead"

	if(!istype(skillset, /datum/skillset/undead) && !ispath(skillset, /datum/skillset/undead))
		if(istype(skillset))
			QDEL_NULL(skillset)
		skillset = new /datum/skillset/undead(src)

	for(var/obj/item/organ/organ in get_organs())
		organ.die()
		organ.germ_level = INFECTION_LEVEL_THREE

	// die() sets to max damage
	for(var/obj/item/organ/internal/organ in get_internal_organs())
		organ.set_organ_damage(0)
	for(var/obj/item/organ/external/limb in get_internal_organs())
		limb.brute_dam = 0
		limb.burn_dam  = 0

	// Set this so nonhumans look appropriately gross.
	reset_hair()
	if(get_bodytype()?.appearance_flags & HAS_SKIN_COLOR)
		_skin_colour = pick(COLOR_GRAY, COLOR_GRAY15, COLOR_GRAY20, COLOR_GRAY40, COLOR_GRAY80, COLOR_WHITE)
		SET_HAIR_COLOR(src, _skin_colour, TRUE)
		SET_FACIAL_HAIR_COLOR(src, _skin_colour, TRUE)

	var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
	if(istype(head))
		head.glowing_eyes = TRUE
	set_eye_colour(COLOR_RED)

	for(var/obj/item/organ/external/limb in get_external_organs())
		if(!BP_IS_PROSTHETIC(limb))
			limb.sync_colour_to_human(src)
			if(prob(10))
				limb.skeletonize()
			else if(prob(15))
				if(prob(75))
					limb.createwound(CUT, rand(limb.max_damage * 0.25, limb.max_damage * 0.5))
				else
					limb.createwound(BURN, rand(limb.max_damage * 0.25, limb.max_damage * 0.5))

	set_max_health(round(species.total_health / 2))
	vessel.remove_any(vessel.total_volume * rand(0.2, 0.5))
	update_body()

/mob/living/human/zombie
	skillset = /datum/skillset/undead

/mob/living/human/zombie/post_setup(species_uid, datum/mob_snapshot/supplied_appearance)
	. = ..()
	make_zombie()
	grant_basic_undead_equipment()

/mob/living/human/zombie/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/human::uid
	. = ..()
