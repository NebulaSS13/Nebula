/datum/appearance_descriptor/age/adherent
	chargen_min_index = 3
	chargen_max_index = 5
	standalone_value_descriptors = list(
		"newly minted" =                 1,
		"showing some wear" =          500,
		"worn" =                      4000,
		"antique" =                   8000,
		"unfathomably old" =         12000,
		"ancient beyond measure" =  100000
	)

/decl/species/adherent
	name = SPECIES_ADHERENT
	name_plural = "Adherents"
	base_prosthetics_model = null

	description = "The Vigil is a loose collection of floating squid-like machines made of a crystalline composite. \
	They once served their creators faithfully, but were left orphaned by a stellar apocalypse."
	hidden_from_codex = FALSE
	silent_steps = TRUE

	meat_type = null
	bone_material = null
	skin_material = null

	blood_types = list(/decl/blood_type/coolant)
	vital_organs = list(
		BP_BRAIN,
		BP_CELL
	)
	available_pronouns = list(/decl/pronouns)
	available_bodytypes = list(
		/decl/bodytype/adherent,
		/decl/bodytype/adherent/emerald,
		/decl/bodytype/adherent/amethyst,
		/decl/bodytype/adherent/sapphire,
		/decl/bodytype/adherent/ruby,
		/decl/bodytype/adherent/topaz,
		/decl/bodytype/adherent/quartz,
		/decl/bodytype/adherent/jet
	)
	cyborg_noun =             null

	siemens_coefficient =     0
	rarity_value =            6

	age_descriptor = /datum/appearance_descriptor/age/adherent

	warning_low_pressure =    50
	hazard_low_pressure =     -1
	mob_size =                MOB_SIZE_LARGE
	strength =                STR_HIGH

	base_eye_color = COLOR_LIME

	speech_sounds = list('mods/species/bayliens/adherent/sound/chime.ogg')
	speech_chance = 25

	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3

	species_flags = SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_CRYSTALLINE
	spawn_flags =   SPECIES_CAN_JOIN

	appearance_flags = HAS_EYE_COLOR
	flesh_color = "#90edeb"
	slowdown = -1
	hud_type = /datum/hud_data/adherent

	available_cultural_info = list(
		TAG_CULTURE = list(
			/decl/cultural_info/culture/adherent
		),
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/adherent,
			/decl/cultural_info/location/adherent/monument
		),
		TAG_FACTION = list(
			/decl/cultural_info/faction/adherent,
			/decl/cultural_info/faction/adherent/loyalists,
			/decl/cultural_info/faction/adherent/separatists
		),
		TAG_RELIGION =  list(/decl/cultural_info/religion/other)
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/crystal),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/crystal),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/crystal),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/crystal),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/crystal),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crystal),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crystal),
		BP_L_LEG =  list("path" = /obj/item/organ/external/tendril),
		BP_R_LEG =  list("path" = /obj/item/organ/external/tendril/two),
		BP_L_FOOT = list("path" = /obj/item/organ/external/tendril/three),
		BP_R_FOOT = list("path" = /obj/item/organ/external/tendril/four)
	)

	has_organ = list(
		BP_BRAIN =        /obj/item/organ/internal/brain/adherent,
		BP_EYES =         /obj/item/organ/internal/eyes/adherent,
		BP_JETS =         /obj/item/organ/internal/powered/jets,
		BP_FLOAT =        /obj/item/organ/internal/powered/float,
		BP_CELL =         /obj/item/organ/internal/cell/adherent,
		BP_COOLING_FINS = /obj/item/organ/internal/powered/cooling_fins
		)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake
	max_players = 3
	blood_volume = 0

/decl/species/adherent/can_overcome_gravity(var/mob/living/carbon/human/H)
	. = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.get_internal_organs())
			if(float.active && float.is_usable())
				. = TRUE
				break

/decl/species/adherent/can_fall(var/mob/living/carbon/human/H)
	. = !can_overcome_gravity(H)

/decl/species/adherent/get_slowdown(var/mob/living/carbon/human/H)
	return slowdown

/decl/species/adherent/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)
	var/float_is_usable = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.get_internal_organs())
			if(float.is_usable())
				float_is_usable = TRUE
				break
	if(float_is_usable)
		if(istype(landing, /turf/simulated/open))
			H.visible_message("\The [H] descends from \the [landing].", "You descend regally.")
		else
			H.visible_message("\The [H] floats gracefully down from \the [landing].", "You land gently on \the [landing].")
		return TRUE
	return FALSE

/decl/species/adherent/skills_from_age(age)
	switch(age)
		if(0 to 1000)    . = -4
		if(1000 to 2000) . =  0
		if(2000 to 8000) . =  4
		else             . =  8

/decl/species/adherent/get_additional_examine_text(var/mob/living/carbon/human/H)
	if(can_overcome_gravity(H)) return "\nThey are floating on a cloud of shimmering distortion."

/datum/hud_data/adherent
	has_internals = FALSE
	inventory_slots = list(
		/datum/inventory_slot/handcuffs,
		/datum/inventory_slot/ear/adherent,
		/datum/inventory_slot/head/adherent,
		/datum/inventory_slot/back,
		/datum/inventory_slot/id,
		/datum/inventory_slot/belt
	)

/decl/species/adherent
	var/static/list/apply_encased = list(
		BP_CHEST,
		BP_GROIN,
		BP_HEAD
	)

/decl/species/adherent/apply_species_organ_modifications(var/obj/item/organ/org)
	..()
	org.robotize(/decl/prosthetics_manufacturer/adherent, FALSE, TRUE, /decl/material/solid/gemstone/crystal, BODYTYPE_ADHERENT, SPECIES_ADHERENT)
	if(istype(org, /obj/item/organ/external))
		var/obj/item/organ/external/E = org
		E.arterial_bleed_severity = 0
		if(E.organ_tag in apply_encased)
			E.encased = "ceramic hull"

/datum/inventory_slot/ear/adherent
	ui_loc = ui_iclothing
/datum/inventory_slot/head/adherent
	ui_loc = ui_glasses

