/decl/species/grafadreka
	uid = "species_grafadreka"
	name = "Grafadreka"
	name_plural = "Grafadreka"
	description = "The reclusive grafadreka (Icelandic, lit. 'digging dragon'), also known as the snow drake, is a large reptillian pack predator similar in size and morphology to old Earth hyenas. \
	They commonly dig shallow dens in dirt, snow or foliage, sometimes using them for concealment prior to an ambush. \
	Biological cousins to the elusive kururak, they have heavy, low-slung bodies and powerful jaws suited to hunting land prey rather than fishing. \
	Colonization and subsequent expansion have displaced many populations from their tundral territories into colder areas; as a result, their diet of Sivian prey animals has pivoted to a diet of giant spider meat."
	hidden_from_codex = FALSE
	available_bodytypes = list(
		/decl/bodytype/quadruped/grafadreka,
		/decl/bodytype/quadruped/grafadreka/hatchling
	)
	base_external_prosthetics_model = null // no robolimbs for dogs
	preview_outfit = null                  // no pants for dogs
	snow_slowdown_mod = -0.5
	gluttonous = GLUT_TINY
	available_pronouns = list(
		/decl/pronouns/pseudoplural,
		/decl/pronouns/neuter,
		/decl/pronouns/male,
		/decl/pronouns/female
	)

	available_background_info = list(
		/decl/background_category/citizenship = list(
			/decl/background_detail/citizenship/other
		),
		/decl/background_category/heritage = list(
			/decl/background_detail/heritage/grafadreka
		),
		/decl/background_category/homeworld = list(
			/decl/background_detail/location/grafadreka
		),
		/decl/background_category/faction = list(
			/decl/background_detail/faction/grafadreka
		),
		/decl/background_category/religion = list(
			/decl/background_detail/religion/grafadreka
		)
	)
	force_background_info = list(
		/decl/background_category/citizenship = /decl/background_detail/citizenship/other,
		/decl/background_category/heritage    = /decl/background_detail/heritage/grafadreka,
		/decl/background_category/homeworld   = /decl/background_detail/location/grafadreka,
		/decl/background_category/faction     = /decl/background_detail/faction/grafadreka,
		/decl/background_category/religion    = /decl/background_detail/religion/grafadreka
	)
	species_hud = /datum/hud_data/grafadreka
	inherent_verbs = list(
		/mob/living/human/proc/drake_sit
	)
	traits = list(
		/decl/trait/sivian_biochemistry = TRAIT_LEVEL_EXISTS
	)
	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	// Drakes must be whitelisted for jobs to be able to join as them, see maps.dm.
	job_blacklist_by_default = TRUE
	spawn_flags = SPECIES_CAN_JOIN

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

/decl/species/grafadreka/handle_post_spawn(var/mob/living/human/H)
	. = ..()
	H.default_attack = GET_DECL(/decl/natural_attack/claws/strong/drake)

// Stub for muscle memory of the Sit verb on Polaris.
/mob/living/human/proc/drake_sit()
	set name = "Sit"
	set category = "IC"
	set src = usr
	lay_down(block_posture = /decl/posture/lying)

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
