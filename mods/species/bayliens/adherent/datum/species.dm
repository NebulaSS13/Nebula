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
	base_external_prosthetics_model = null

	description = "The Vigil is a loose collection of floating squid-like machines made of a crystalline composite. \
	They once served their creators faithfully, but were left orphaned by a stellar apocalypse."
	hidden_from_codex = FALSE
	silent_steps = TRUE

	butchery_data = /decl/butchery_data/crystal

	blood_types = list(/decl/blood_type/coolant)

	available_pronouns = list(/decl/pronouns)
	available_bodytypes = list(
		/decl/bodytype/crystalline/adherent,
		/decl/bodytype/crystalline/adherent/emerald,
		/decl/bodytype/crystalline/adherent/amethyst,
		/decl/bodytype/crystalline/adherent/sapphire,
		/decl/bodytype/crystalline/adherent/ruby,
		/decl/bodytype/crystalline/adherent/topaz,
		/decl/bodytype/crystalline/adherent/quartz,
		/decl/bodytype/crystalline/adherent/jet
	)
	cyborg_noun =             null

	shock_vulnerability =     0
	rarity_value =            6

	warning_low_pressure =    50
	hazard_low_pressure =     -1
	strength =                STR_HIGH

	speech_sounds = list('mods/species/bayliens/adherent/sound/chime.ogg')
	speech_chance = 25

	species_flags = SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags =   SPECIES_CAN_JOIN

	flesh_color = "#90edeb"
	species_hud = /datum/hud_data/adherent

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

	move_trail = /obj/effect/decal/cleanable/blood/tracks/snake
	max_players = 3
	blood_volume = 0

/decl/species/adherent/can_overcome_gravity(var/mob/living/human/H)
	. = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.get_internal_organs())
			if(float.active && float.is_usable())
				. = TRUE
				break

/decl/species/adherent/can_fall(var/mob/living/human/H)
	. = !can_overcome_gravity(H)

/decl/species/adherent/handle_fall_special(var/mob/living/human/H, var/turf/landing)
	var/float_is_usable = FALSE
	if(H && H.stat == CONSCIOUS)
		for(var/obj/item/organ/internal/powered/float/float in H.get_internal_organs())
			if(float.is_usable())
				float_is_usable = TRUE
				break
	if(float_is_usable)
		if(landing.is_open())
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

/decl/species/adherent/get_additional_examine_text(var/mob/living/human/H)
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
/datum/inventory_slot/ear/adherent
	ui_loc = ui_iclothing
/datum/inventory_slot/head/adherent
	ui_loc = ui_glasses

