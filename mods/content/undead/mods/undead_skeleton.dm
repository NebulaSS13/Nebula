/datum/mob_controller/aggressive/skeleton

// SKELETONS
// Immune to blind or deaf, but weak to physical damage.
/mob/living/human/proc/make_skeleton()
	set_trait(/decl/trait/metabolically_inert, TRAIT_LEVEL_EXISTS)
	set_trait(/decl/trait/undead, TRAIT_LEVEL_MODERATE)

	if(istype(ai))
		QDEL_NULL(ai)
	ai = new /datum/mob_controller/aggressive/skeleton(src)
	faction = "undead"

	if(!istype(skillset, /datum/skillset/undead) && !ispath(skillset, /datum/skillset/undead))
		if(istype(skillset))
			QDEL_NULL(skillset)
		skillset = new /datum/skillset/undead(src)

	for(var/obj/item/organ/external/limb in get_external_organs())
		if(!BP_IS_PROSTHETIC(limb))
			limb.skeletonize()

	for(var/obj/item/organ/internal/organ in get_internal_organs())
		remove_organ(organ, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE)
		qdel(organ)

	set_max_health(round(species.total_health / 3))
	vessel?.clear_reagents()
	SET_HAIR_STYLE(src, /decl/sprite_accessory/hair/bald, FALSE)
	update_body()

/mob/living/human/skeleton
	skillset = /datum/skillset/undead

/mob/living/human/skeleton/post_setup(species_uid, datum/mob_snapshot/supplied_appearance)
	. = ..()
	make_skeleton()
	grant_basic_undead_equipment()

/mob/living/human/skeleton/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/human::uid
	. = ..()
