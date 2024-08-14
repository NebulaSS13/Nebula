/decl/species/starlight
	abstract_type = /decl/species/starlight
	butchery_data = null
	spawn_flags = SPECIES_IS_RESTRICTED
	available_pronouns = list(/decl/pronouns/neuter)
	force_cultural_info = list(
		TAG_CULTURE = /decl/cultural_info/culture/other
	)

/decl/bodytype/starlight
	abstract_type = /decl/bodytype/starlight
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)
	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/starlight
	)

/obj/item/organ/internal/brain/starlight
	name = "essence of fire"
	desc = "A fancy name for ash. Still, it does look a bit different from the regular stuff."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"

/decl/bodytype/starlight/starborn
	name                    = "starborn"
	desc                    = "A blazing mass of light."
	icon_base               = 'icons/mob/human_races/species/starborn/body.dmi'
	icon_deformed           = 'icons/mob/human_races/species/starborn/body.dmi'
	husk_icon               = 'icons/mob/human_races/species/starborn/husk.dmi'
	body_flags              = BODY_FLAG_NO_DNA | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	uid                     = "bodytype_starlight_starborn"
	cold_level_1            = 260
	cold_level_2            = 250
	cold_level_3            = 235
	heat_level_1            = 20000
	heat_level_2            = 30000
	heat_level_3            = 40000
	cold_discomfort_level   = 300
	cold_discomfort_strings = list(
		"You feel your fire dying out...",
		"Your fire begins to shrink away from the cold.",
		"You feel slow and sluggish from the cold."
	)
	heat_discomfort_level   = 10000
	heat_discomfort_strings = list(
		"Surprisingly, you start burning!",
		"You're... burning!?!"
	)

/decl/blood_type/starstuff
	name = "starstuff"
	antigen_category = "starstuff"
	splatter_name = "starstuff"
	splatter_desc = "A puddle of starstuff."
	splatter_colour = "#ffff00"

/decl/species/starlight/handle_death(var/mob/living/human/H)
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, dust)),0)

/decl/species/starlight/starborn
	name = "Starborn"
	name_plural = "Starborn"
	description = "Beings of fire and light, split off from a sun deity of unbelievable power."
	available_bodytypes = list(/decl/bodytype/starlight/starborn)

	blood_types = list(
		/decl/blood_type/starstuff
	)
	flesh_color = "#ffff00"

	unarmed_attacks = list(/decl/natural_attack/punch/starborn)

	warning_low_pressure = 50
	hazard_low_pressure = 0
	shock_vulnerability = 0
	hunger_factor = 0
	thirst_factor = 0
	death_message = "dissolves into pure flames!"
	breath_type = null


	total_health = 250
	body_temperature = T0C + 500 //We are being of fire and light.
	species_flags = SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE

	base_auras = list(
		/obj/aura/starborn
	)

/decl/species/starlight/starborn/handle_death(var/mob/living/human/H)
	..()
	var/turf/T = get_turf(H)
	T.add_to_reagents(/decl/material/liquid/fuel, 20)
	T.hotspot_expose(FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE)

/decl/bodytype/starlight/blueforged
	name                 = "blueforged"
	desc                 = "A mass of carved and shaped spacetime."
	icon_base            = 'icons/mob/human_races/species/blueforged/body.dmi'
	icon_deformed        = 'icons/mob/human_races/species/blueforged/body.dmi'
	eye_icon             = 'icons/mob/human_races/species/blueforged/eyes.dmi'
	body_flags           = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	override_organ_types = list(BP_EYES = /obj/item/organ/internal/eyes/blueforged)
	uid                  = "bodytype_starlight_blueforged"

/decl/blood_type/spacestuff
	name = "spacestuff"
	antigen_category = "spacestuff"
	splatter_name = "spacestuff"
	splatter_desc = "A puddle of spacestuff."
	splatter_colour = "#2222ff"

/decl/species/starlight/blueforged
	name = "Blueforged"
	name_plural = "Blueforged"
	description = "Living chunks of spacetime, carved out of the original dimension and given life by a being of unbelievable power."
	available_bodytypes = list(/decl/bodytype/starlight/blueforged)

	flesh_color = "#2222ff"

	warning_low_pressure = 50
	hazard_low_pressure = 0
	hunger_factor = 0
	thirst_factor = 0
	breath_type = null

	burn_mod = 10
	brute_mod = 0
	oxy_mod = 0
	toxins_mod = 0
	radiation_mod = 0
	species_flags = SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE

/decl/species/starlight/blueforged/handle_death(var/mob/living/human/H)
	..()
	new /obj/effect/temporary(get_turf(H),11, 'icons/mob/mob.dmi', "liquify")

/obj/item/organ/internal/eyes/blueforged
	name = "bluespace prism"
	desc = "You can see an endless blue plane when looking through it. Your eyes tingle if you stare too hard."
	icon = 'icons/mob/human_races/species/blueforged/organs.dmi'
