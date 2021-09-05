/decl/species/resomi
	name              = SPECIES_RESOMI
	name_plural       = "Resomii"
	description       = "A race of feathered raptors who developed on a cold world, almost \
	outside of the Goldilocks zone. Extremely fragile, they developed hunting skills \
	that emphasized taking out their prey without themselves getting hit."
	hidden_from_codex = FALSE

	available_bodytypes = list(/decl/bodytype/resomi)

	meat_type = /obj/item/chems/food/meat/chicken

	age_descriptor = /datum/appearance_descriptor/age/resomi

	spawn_flags       = SPECIES_CAN_JOIN
	appearance_flags  = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_A_SKIN_TONE | HAS_LIPS
	bump_flag         = MONKEY
	swap_flags        = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags        = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	preview_icon      = 'mods/species/resomi/icons/preview.dmi'

	base_color        = "#001144"
	flesh_color       = "#5f7bb0"
	blood_color       = "#d514f7"

	darksight_range   = 7
	flash_mod         = 2

	total_health      = 150
	slowdown          = -1.5
	brute_mod         = 1.4
	burn_mod          =  1.4
	metabolism_mod    = 2.0
	mob_size          = MOB_SIZE_SMALL
	holder_type       = /obj/item/holder/human/resomi
	breath_pressure   = 8

	blood_volume      = 280
	body_temperature  = 314.15

	unarmed_attacks   = list(
		/decl/natural_attack/bite/sharp,
		/decl/natural_attack/claws,
		/decl/natural_attack/punch,
		/decl/natural_attack/stomp/weak
	)

	move_trail        = /obj/effect/decal/cleanable/blood/tracks/paw

	cold_level_1      = 180
	cold_level_2      = 130
	cold_level_3      = 70
	heat_level_1      = 320
	heat_level_2      = 370
	heat_level_3      = 600

	heat_discomfort_level = 294
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
	)
	cold_discomfort_level = 200
	cold_discomfort_strings = list(
		"You can't feel your paws because of the cold.",
		"You feel sluggish and cold.",
		"Your feathers bristle against the cold."
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/resomi_sonar_ping,
		/mob/living/proc/toggle_pass_table
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 0.6,
		/datum/appearance_descriptor/build =  0.6
	)

	available_cultural_info = list(
		TAG_CULTURE = list(
			/decl/cultural_info/culture/resomi/eremus,
			/decl/cultural_info/culture/resomi/asranda,
			/decl/cultural_info/culture/resomi/refugee,
			/decl/cultural_info/culture/resomi/newgeneration,
			/decl/cultural_info/culture/resomi/lost_colony_rich,
			/decl/cultural_info/culture/resomi/lost_colony_poor,
			/decl/cultural_info/culture/other
		),
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/birdcage,
			/decl/cultural_info/location/eremus,
			/decl/cultural_info/location/asranda,
			/decl/cultural_info/location/saveel,
			/decl/cultural_info/location/resomi_lost_colony,
			/decl/cultural_info/location/resomi_refuge_colony,
			/decl/cultural_info/location/resomi_homeless,
			/decl/cultural_info/location/other
		),
		TAG_RELIGION =  list(
			/decl/cultural_info/religion/chosen,
			/decl/cultural_info/religion/emperor,
			/decl/cultural_info/religion/mountain,
			/decl/cultural_info/religion/skies,
			/decl/cultural_info/religion/other
		)
	)

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes
	)

	override_organ_types = list(
		BP_EYES = /obj/item/organ/internal/eyes/resomi
	)

/decl/species/resomi/skills_from_age(age)
	switch(age)
		if(0 to 17)  . = -4
		if(18 to 25) . = 0
		if(26 to 35) . = 4
		else		 . = 8

/decl/species/resomi/get_surgery_overlay_icon(var/mob/living/carbon/human/H)
	return 'mods/species/resomi/icons/surgery.dmi'

/obj/item/holder/human/resomi
	icon = 'mods/species/resomi/icons/holder.dmi'
	w_class = ITEM_SIZE_LARGE

/obj/item/organ/internal/eyes/resomi
	eye_icon = 'mods/species/resomi/icons/eyes.dmi'
	icon_state = "eyes"

/decl/species/resomi/handle_post_species_pref_set(var/datum/preferences/pref)
	if(!pref) return
	LAZYINITLIST(pref.body_markings)
	if(!pref.body_markings["Feathers"]) pref.body_markings["Feathers"] = "#8888cc"

/decl/species/resomi/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/resomi/simple, slot_w_uniform_str)

/datum/appearance_descriptor/age/resomi
	chargen_min_index = 3
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"a hatchling" =     1,
		"an fledgeling" =   7,
		"a young adult" =  15,
		"an adult" =       26,
		"middle-aged" =    34,
		"aging" =          51,
		"elderly" =        65
	)
