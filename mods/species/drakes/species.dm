/decl/species/grafadreka
	name = SPECIES_GRAFADREKA
	name_plural = SPECIES_GRAFADREKA
	description = "The reclusive grafadreka (Icelandic, lit. 'digging dragon'), also known as the snow drake, is a large reptillian pack predator similar in size and morphology to old Earth hyenas. \
	They commonly dig shallow dens in dirt, snow or foliage, sometimes using them for concealment prior to an ambush. \
	Biological cousins to the elusive kururak, they have heavy, low-slung bodies and powerful jaws suited to hunting land prey rather than fishing. \
	Colonization and subsequent expansion have displaced many populations from their tundral territories into colder areas; as a result, their diet of Sivian prey animals has pivoted to a diet of giant spider meat."
	available_bodytypes = list(
		/decl/bodytype/quadruped/grafadreka,
		/decl/bodytype/quadruped/grafadreka/hatchling
	)
	base_external_prosthetics_model = null // no robolimbs for dogs
	preview_outfit = null                  // no pants for dogs
	snow_slowdown_mod = -0.5
	gluttonous = GLUT_TINY
	available_pronouns = list(
		/decl/pronouns,
		/decl/pronouns/neuter,
		/decl/pronouns/male,
		/decl/pronouns/female
	)
	unarmed_attacks = list(
		/decl/natural_attack/bite/sharp/drake,
		/decl/natural_attack/claws/strong/drake
	)
	available_cultural_info = list(
		TAG_CULTURE   = list(/decl/cultural_info/culture/grafadreka),
		TAG_HOMEWORLD = list(/decl/cultural_info/location/grafadreka),
		TAG_FACTION   = list(/decl/cultural_info/faction/grafadreka),
		TAG_RELIGION  = list(/decl/cultural_info/religion/grafadreka)
	)
	force_cultural_info = list(
		TAG_CULTURE   = /decl/cultural_info/culture/grafadreka,
		TAG_HOMEWORLD = /decl/cultural_info/location/grafadreka,
		TAG_FACTION   = /decl/cultural_info/faction/grafadreka,
		TAG_RELIGION  = /decl/cultural_info/religion/grafadreka
	)
	species_hud = /datum/hud_data/grafadreka
	inherent_verbs = list(
		/mob/living/human/proc/drake_sit
	)
	traits = list(
		/decl/trait/sivian_biochemistry = TRAIT_LEVEL_EXISTS
	)

	// Drakes must be whitelisted for jobs to be able to join as them, see maps.dm.
	job_blacklist_by_default = TRUE
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	preview_screen_locs = list(
		"1" = "character_preview_map:1,4:36",
		"2" = "character_preview_map:1,3:31",
		"4" = "character_preview_map:1,2:26",
		"8" = "character_preview_map:1,1:21"
	)

	var/list/adult_pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/drake_huff, /decl/emote/audible/drake_rattle) = 20
	)
	var/list/hatchling_pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/drake_hatchling_whine, /decl/emote/audible/drake_hatchling_yelp) = 20
	)

// TODO: move pain onto a behavior datum or bodytype.
/decl/species/grafadreka/get_pain_emote(var/mob/living/human/H, var/pain_power)
	if(H?.get_bodytype()?.type == /decl/bodytype/quadruped/grafadreka/hatchling)
		pain_emotes_with_pain_level = hatchling_pain_emotes_with_pain_level
	else
		pain_emotes_with_pain_level = adult_pain_emotes_with_pain_level
	return ..()

/decl/species/grafadreka/get_surgery_overlay_icon(var/mob/living/human/H)
	return null // todo: 'mods/species/drakes/icons/surgery.dmi'

// Stub for muscle memory of the Sit verb on Polaris.
/mob/living/human/proc/drake_sit()
	set name = "Sit"
	set category = "IC"
	set src = usr
	lay_down()

/datum/hud_data/grafadreka
	inventory_slots = list(
		/datum/inventory_slot/head/grafadreka,
		/datum/inventory_slot/back/grafadreka,
		/datum/inventory_slot/id/grafadreka
	)

/datum/inventory_slot/head/grafadreka
	ui_loc = "LEFT:8,BOTTOM:5"
	can_be_hidden = FALSE
/datum/inventory_slot/back/grafadreka
	ui_loc = "LEFT:8,BOTTOM+1:7"
/datum/inventory_slot/id/grafadreka
	ui_loc = "LEFT:8,BOTTOM+2:9"
