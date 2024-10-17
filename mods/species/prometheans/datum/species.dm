/decl/bodytype/shapeshifter/promethean
	name = "protean form"
	uid = "bodytype_promethean"
	valid_transform_bodytypes = list(
		SPECIES_SKRELL,
		SPECIES_LIZARD,
		SPECIES_TAJARA,
		SPECIES_AVIAN,
		SPECIES_MONKEY
	)

/decl/species/shapeshifter/promethean
	name = SPECIES_PROMETHEAN
	name_plural = "Prometheans"
	description = "Prometheans (Macrolimus artificialis) are a species of artificially-created gelatinous humanoids, \
	chiefly characterized by their primarily liquid bodies and ability to change their bodily shape and color in order to  \
	mimic many forms of life. Derived from the Aetolian giant slime (Macrolimus vulgaris) inhabiting the warm, tropical planet \
	of Aetolus, they are a relatively new lab-created sapient species, and as such many things about them have yet to be comprehensively studied. \
	What has Science done?"
	hidden_from_codex = FALSE

	available_bodytypes = list(
		/decl/bodytype/shapeshifter/promethean
	)

	show_ssd = "totally quiescent"
	death_message = "rapidly loses cohesion, splattering across the ground..."
	knockout_message = "collapses inward, forming a disordered puddle of goo."
	remains_type = /obj/effect/decal/cleanable/ash

//	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	hunger_factor = DEFAULT_HUNGER_FACTOR * 4
	thirst_factor = 0
//	mob_size = MOB_SIZE_SMALL
	bump_flag = MONKEY
	swap_flags = MONKEY|SIMPLE_ANIMAL
	push_flags = MONKEY|SIMPLE_ANIMAL
//	flags =
//	appearance_flags =
	spawn_flags = SPECIES_CAN_JOIN //| SPECIES_IS_WHITELISTED
//	health_hud_intensity = 2
//	num_alternate_languages = 3
//	species_language = LANGUAGE_PROMETHEAN
//	secondary_langs = list(LANGUAGE_PROMETHEAN, LANGUAGE_SOL_COMMON)	// For some reason, having this as their species language does not allow it to be chosen.
//	assisted_langs = list(LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)	// Prometheans are weird, let's just assume they can use basically any language.

//	blood_name = "gelatinous ooze"

	brute_mod = 0.75
	burn_mod = 2
	oxy_mod = 0
	blood_oxy = 1
	shock_vulnerability = 0.8

	unarmed_attacks = list(/decl/natural_attack/slime_glomp)

	gluttonous = GLUT_TINY
	body_temperature = T20C

	rarity_value = 5

	breath_type = null
	poison_types = list(
		/decl/material/liquid/water
	)

	default_emotes = list(
	//	/decl/emote/audible/squish,
		/decl/emote/audible/chirp,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate
	)

/decl/species/shapeshifter/promethean/get_species_blood_color(mob/living/human/H)
	return (H ? H.get_skin_colour() : ..())

/decl/species/shapeshifter/promethean/get_species_flesh_color(mob/living/human/H)
	return (H ? H.get_skin_colour() : ..())




/*
	var/codex_description
	var/roleplay_summary
	var/ooc_codex_information
	var/cyborg_noun = "Cyborg"
	var/hidden_from_codex = FALSE
	var/secret_codex_info
	var/holder_icon
	var/list/available_bodytypes = list()
	var/decl/bodytype/default_bodytype
	var/base_external_prosthetics_model = /decl/bodytype/prosthetic/basic_human
	var/base_internal_prosthetics_model
	/// Set to true to blacklist this species from all map jobs it is not explicitly whitelisted for.
	var/job_blacklist_by_default = FALSE
	// A list of customization categories made available in character preferences.
	var/list/available_accessory_categories = list(
		SAC_HAIR,
		SAC_FACIAL_HAIR,
		SAC_EARS,
		SAC_TAIL,
		SAC_COSMETICS,
		SAC_MARKINGS
	)
	// Lists of accessory types for modpack modification of accessory restrictions.
	// These lists are pretty broad and indiscriminate in application, don't use
	// them for fine detail restriction/allowing if you can avoid it.
	var/list/allow_specific_sprite_accessories
	var/list/disallow_specific_sprite_accessories
	var/list/accessory_styles
	var/list/blood_types = list(
		/decl/blood_type/aplus,
		/decl/blood_type/aminus,
		/decl/blood_type/bplus,
		/decl/blood_type/bminus,
		/decl/blood_type/abplus,
		/decl/blood_type/abminus,
		/decl/blood_type/oplus,
		/decl/blood_type/ominus
	)
	var/flesh_color = "#ffc896"             // Pink.
	var/blood_oxy = 1
	// Preview in prefs positioning. If null, uses defaults set on a static list in preferences.dm.
	var/list/character_preview_screen_locs
	var/organs_icon		//species specific internal organs icons
	var/strength = STR_MEDIUM
	var/show_ssd = "fast asleep"
	var/short_sighted                         // Permanent weldervision.
	var/light_sensitive                       // Ditto, but requires sunglasses to fix
	var/blood_volume = SPECIES_BLOOD_DEFAULT  // Initial blood volume.
	var/hunger_factor = DEFAULT_HUNGER_FACTOR // Multiplier for hunger.
	var/thirst_factor = DEFAULT_THIRST_FACTOR // Multiplier for thirst.
	var/taste_sensitivity = TASTE_NORMAL      // How sensitive the species is to minute tastes.
	var/silent_steps
	// Speech vars.
	var/assisted_langs    = list()            // The languages the species can't speak without an assisted organ.
	var/unspeakable_langs = list()            // The languages the species can't speak at all.
	var/list/speech_sounds                    // A list of sounds to potentially play when speaking.
	var/list/speech_chance                    // The likelihood of a speech sound playing.
	var/scream_verb_1p = "scream"
	var/scream_verb_3p = "screams"
	// Combat vars.
	var/total_health = DEFAULT_SPECIES_HEALTH  // Point at which the mob will enter crit.
	var/list/unarmed_attacks = list(           // Possible unarmed attacks that the mob will use in combat,
		/decl/natural_attack,
		/decl/natural_attack/bite
		)
	var/list/natural_armour_values            // Armour values used if naked.
	var/brute_mod =      1                    // Physical damage multiplier.
	var/burn_mod =       1                    // Burn damage multiplier.
	var/toxins_mod =     1                    // Toxloss modifier
	var/radiation_mod =  1                    // Radiation modifier
	var/oxy_mod =        1                    // Oxyloss modifier
	var/metabolism_mod = 1                    // Reagent metabolism modifier
	var/stun_mod =       1                    // Stun period modifier.
	var/paralysis_mod =  1                    // Paralysis period modifier.
	var/weaken_mod =     1                    // Weaken period modifier.
	var/vision_flags = SEE_SELF               // Same flags as glasses.
	// Death vars.
	var/butchery_data = /decl/butchery_data/humanoid
	var/remains_type =  /obj/item/remains/xeno
	var/gibbed_anim =   "gibbed-h"
	var/dusted_anim =   "dust-h"
	/// A modifier applied to move delay when walking on snow.
	var/snow_slowdown_mod = 0
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "collapses, having been knocked unconscious."
	var/halloss_message = "slumps over, too weak to continue fighting..."
	var/halloss_message_self = "The pain is too severe for you to keep going..."
	var/sniff_message_3p = "sniffs the air."
	var/sniff_message_1p = "You sniff the air."
	// Environment tolerance/life processes vars.
	var/breath_pressure = 16                                    // Minimum partial pressure safe for breathing, kPa
	var/breath_type = /decl/material/gas/oxygen                 // Non-oxygen gas breathed, if any.
	var/poison_types = list(                                    // Noticeably poisonous air - ie. updates the toxins indicator on the HUD.
		/decl/material/solid/phoron = TRUE,
		/decl/material/gas/chlorine = TRUE
		)
	var/exhale_type = /decl/material/gas/carbon_dioxide         // Exhaled gas type.
	var/blood_reagent = /decl/material/liquid/blood
	var/max_pressure_diff = 60                                  // Maximum pressure difference that is safe for lungs
	var/passive_temp_gain = 0		                            // Species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE             // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE           // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE             // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE               // Dangerously low pressure.
	var/body_temperature = 310.15	                            // Species will try to stabilize at this temperature.
	                                                            // (also affects temperature processing)
	var/water_soothe_amount
	// HUD data vars.
	var/datum/hud_data/species_hud
	var/grab_type = /decl/grab/normal/passive // The species' default grab type.
	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/shock_vulnerability = 1   // The lower, the thicker the skin and better the insulation.
	var/species_flags = 0         // Various specific features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	// Move intents. Earlier in list == default for that type of movement.
	var/list/move_intents = list(
		/decl/move_intent/walk,
		/decl/move_intent/run,
		/decl/move_intent/creep
	)
	var/primitive_form            // Lesser form, if any (ie. monkey for humans)
	var/holder_type
	var/gluttonous = 0            // Can eat some mobs. Values can be GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING, GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT
	var/stomach_capacity = 5      // How much stuff they can stick in their stomach
	var/rarity_value = 1          // Relative rarity/collector value for this species.
	                              // Determines the organs that the species spawns with and
	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // What marks are left when walking
	var/decl/pronouns/default_pronouns
	var/list/available_pronouns = list(
		/decl/pronouns,
		/decl/pronouns/neuter/person,
		/decl/pronouns/female,
		/decl/pronouns/male
	)
	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?
	var/pass_flags = 0
	var/breathing_sound = 'sound/voice/monkey.ogg'
	var/list/base_auras
	var/job_skill_buffs = list()				// A list containing jobs (/datum/job), with values the extra points that job recieves.
	var/standing_jump_range = 2
	var/list/maneuvers = list(/decl/maneuver/leap)
	var/list/available_background_info =            list()
	var/list/force_background_info =                list()
	var/list/default_background_info =              list()
	var/list/additional_available_background_info = list()
	var/max_players
	// Order matters, higher pain level should be higher up
	var/list/pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 10,
	)
	var/manual_dexterity = DEXTERITY_FULL
	var/datum/mob_controller/ai						// Type abused. Define with path and will automagically create. Determines behaviour for clientless mobs. This will override mob AIs.
	var/exertion_emote_chance =    5
	var/exertion_effect_chance =   0
	var/exertion_hydration_scale = 0
	var/exertion_nutrition_scale = 0
	var/exertion_charge_scale =    0
	var/exertion_reagent_scale =   0
	var/exertion_reagent_path
	var/list/exertion_emotes_biological
	var/list/exertion_emotes_synthetic
	var/list/traits = list() // An associative list of /decl/traits and trait level - See individual traits for valid levels
	// Preview icon gen/tracking vars.
	var/icon/preview_icon
	var/preview_icon_width = 64
	var/preview_icon_height = 64
	var/preview_icon_path
	var/preview_outfit = /decl/outfit/job/generic/assistant
	/// List of emote types that this species can use by default.
	var/list/default_emotes
*/
/*
	breath_type = null
	poison_type = null
	speech_bubble_appearance = "slime"
	male_cough_sounds = list('sound/effects/slime_squish.ogg')
	female_cough_sounds = list('sound/effects/slime_squish.ogg')
	min_age =		1
	max_age =		24
	economic_modifier = 3
	gluttonous =	1
	virus_immune =	1
	blood_volume =	560
	brute_mod =		0.75
	burn_mod =		2
	oxy_mod =		0
	flash_mod =		0.5 //No centralized, lensed eyes.
	item_slowdown_mod = 1.33
	cloning_modifier = /datum/modifier/cloning_sickness/promethean
	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120
	heat_level_1 = 320 //Default 360
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000
	body_temperature = T20C	// Room temperature
	rarity_value = 5
	shock_vulnerability = 0.8
	water_resistance = 0
	water_damage_mod = 0.3
	genders = list(MALE, FEMALE, NEUTER, PLURAL)
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	has_organ =     list(O_BRAIN = /obj/item/organ/internal/brain/slime,
						O_HEART = /obj/item/organ/internal/heart/grey/colormatch/slime,
						O_REGBRUTE = /obj/item/organ/internal/regennetwork,
						O_REGBURN = /obj/item/organ/internal/regennetwork/burn,
						O_REGOXY = /obj/item/organ/internal/regennetwork/oxy,
						O_REGTOX = /obj/item/organ/internal/regennetwork/tox)
	dispersed_eyes = TRUE
	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/slime),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/slime),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/slime),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/slime),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/slime),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/slime),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/slime),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/slime),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/slime),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/slime),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/slime)
		)
	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")
	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate
		)
	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY)
	var/heal_rate = 0.5 // Temp. Regen per tick.
	default_emotes = list(
		/decl/emote/audible/squish,
		/decl/emote/audible/chirp,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate
	)
*/