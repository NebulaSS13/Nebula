/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/
var/global/const/DEFAULT_SPECIES_HEALTH = 200

/decl/species
	abstract_type = /decl/species

	// Descriptors and strings.
	var/name
	var/name_plural                           // Pluralized name (since "[name]s" is not always valid)
	var/description
	var/codex_description
	var/roleplay_summary
	var/ooc_codex_information
	var/cyborg_noun = "Cyborg"
	var/hidden_from_codex = TRUE
	var/secret_codex_info

	var/holder_icon
	var/list/available_bodytypes = list()
	var/decl/bodytype/default_bodytype
	var/base_prosthetics_model = /decl/prosthetics_manufacturer/basic_human

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

	// Darksight handling
	/// Fractional multiplier (0 to 1) for the base alpha of the darkness overlay. A value of 1 means darkness is completely invisible.
	var/base_low_light_vision = 0
	/// The lumcount (turf luminosity) threshold under which adaptive low light vision will begin processing.
	var/low_light_vision_threshold = 0.3
	/// Fractional multiplier for the overall effectiveness of low light vision for this species. Caps the final alpha value of the darkness plane.
	var/low_light_vision_effectiveness = 0
	/// The rate at which low light vision adjusts towards the final value, as a fractional multiplier of the difference between the current and target alphas. ie. set to 0.15 for a 15% shift towards the target value each tick.
	var/low_light_vision_adjustment_speed = 0.15

	// Used for initializing prefs/preview
	var/base_color =      COLOR_BLACK
	var/base_eye_color =  COLOR_BLACK
	var/base_hair_color = COLOR_BLACK
	var/list/base_markings

	var/static/list/hair_styles
	var/static/list/facial_hair_styles

	var/organs_icon		//species specific internal organs icons

	var/default_h_style = /decl/sprite_accessory/hair/bald
	var/default_f_style = /decl/sprite_accessory/facial_hair/shaved

	var/mob_size = MOB_SIZE_MEDIUM
	var/strength = STR_MEDIUM
	var/show_ssd = "fast asleep"
	var/short_sighted                         // Permanent weldervision.
	var/light_sensitive                       // Ditto, but requires sunglasses to fix
	var/blood_volume = SPECIES_BLOOD_DEFAULT  // Initial blood volume.
	var/hunger_factor = DEFAULT_HUNGER_FACTOR // Multiplier for hunger.
	var/thirst_factor = DEFAULT_THIRST_FACTOR // Multiplier for thirst.
	var/taste_sensitivity = TASTE_NORMAL      // How sensitive the species is to minute tastes.
	var/silent_steps

	var/age_descriptor = /datum/appearance_descriptor/age

	// Speech vars.
	var/assisted_langs = list()               // The languages the species can't speak without an assisted organ.
	var/list/speech_sounds                    // A list of sounds to potentially play when speaking.
	var/list/speech_chance                    // The likelihood of a speech sound playing.

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
	var/flash_mod =      1                    // Stun from blindness modifier.
	var/metabolism_mod = 1                    // Reagent metabolism modifier
	var/stun_mod =       1                    // Stun period modifier.
	var/paralysis_mod =  1                    // Paralysis period modifier.
	var/weaken_mod =     1                    // Weaken period modifier.

	var/vision_flags = SEE_SELF               // Same flags as glasses.

	// Death vars.
	var/meat_type =     /obj/item/chems/food/meat/human
	var/meat_amount =   3
	var/skin_material = /decl/material/solid/skin
	var/skin_amount =   3
	var/bone_material = /decl/material/solid/bone
	var/bone_amount =   3
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
	var/poison_types = list(/decl/material/gas/chlorine = TRUE) // Noticeably poisonous air - ie. updates the toxins indicator on the HUD.
	var/exhale_type = /decl/material/gas/carbon_dioxide         // Exhaled gas type.
	var/blood_reagent = /decl/material/liquid/blood

	var/max_pressure_diff = 60                                  // Maximum pressure difference that is safe for lungs
	var/cold_level_1 = 243                                      // Cold damage level 1 below this point. -30 Celsium degrees
	var/cold_level_2 = 200                                      // Cold damage level 2 below this point.
	var/cold_level_3 = 120                                      // Cold damage level 3 below this point.
	var/heat_level_1 = 360                                      // Heat damage level 1 above this point.
	var/heat_level_2 = 400                                      // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                                     // Heat damage level 3 above this point.
	var/passive_temp_gain = 0		                            // Species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE             // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE           // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE             // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE               // Dangerously low pressure.
	var/body_temperature = 310.15	                            // Species will try to stabilize at this temperature.
	                                                            // (also affects temperature processing)
	var/heat_discomfort_level = 315                             // Aesthetic messages about feeling warm.
	var/cold_discomfort_level = 285                             // Aesthetic messages about feeling chilly.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	var/water_soothe_amount

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type

	var/grab_type = /decl/grab/normal/passive // The species' default grab type.

	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight_range = 2       // Native darksight distance.
	var/species_flags = 0         // Various specific features.
	var/appearance_flags = 0      // Appearance/display related features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	var/slowdown = 0              // Passive movement speed malus (or boost, if negative)
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
	var/list/has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes
		)

	var/vision_organ              // If set, this organ is required for vision.
	var/breathing_organ           // If set, this organ is required for breathing.

	var/list/override_organ_types // Used for species that only need to change one or two entries in has_organ.

	// Losing an organ from the list below will give a grace period (also below) then kill the mob.
	var/list/vital_organs = list(BP_BRAIN)
	var/vital_organ_failure_death_delay = 25 SECONDS

	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // What marks are left when walking

	// An associative list of target zones (ex. BP_CHEST, BP_MOUTH) mapped to all possible keys associated
	// with the zone. Used for species with body layouts that do not map directly to a standard humanoid body.
	var/list/limb_mapping

	var/list/has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
	)

	var/list/override_limb_types // Used for species that only need to change one or two entries in has_limbs.

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

	var/list/appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1,
		/datum/appearance_descriptor/build =  1
	)

	var/standing_jump_range = 2
	var/list/maneuvers = list(/decl/maneuver/leap)

	var/list/available_cultural_info =            list()
	var/list/force_cultural_info =                list()
	var/list/default_cultural_info =              list()
	var/list/additional_available_cultural_info = list()
	var/max_players

	// Order matters, higher pain level should be higher up
	var/list/pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 10,
	)

	var/manual_dexterity = DEXTERITY_FULL

	var/datum/ai/ai						// Type abused. Define with path and will automagically create. Determines behaviour for clientless mobs. This will override mob AIs.

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
	var/preview_outfit = /decl/hierarchy/outfit/job/generic/assistant

/decl/species/proc/build_codex_strings()

	if(!codex_description)
		codex_description = description

	// Generate OOC info.
	var/list/codex_traits = list()
	if(spawn_flags & SPECIES_CAN_JOIN)
		codex_traits += "<li>Often present among humans.</li>"
	if(spawn_flags & SPECIES_IS_WHITELISTED)
		codex_traits += "<li>Whitelist restricted.</li>"
	if(!has_organ[BP_HEART])
		codex_traits += "<li>Does not have blood.</li>"
	if(!breathing_organ)
		codex_traits += "<li>Does not breathe.</li>"
	if(species_flags & SPECIES_FLAG_NO_SCAN)
		codex_traits += "<li>Does not have DNA.</li>"
	if(species_flags & SPECIES_FLAG_NO_PAIN)
		codex_traits += "<li>Does not feel pain.</li>"
	if(species_flags & SPECIES_FLAG_NO_MINOR_CUT)
		codex_traits += "<li>Has thick skin/scales.</li>"
	if(species_flags & SPECIES_FLAG_NO_SLIP)
		codex_traits += "<li>Has excellent traction.</li>"
	if(species_flags & SPECIES_FLAG_NO_POISON)
		codex_traits += "<li>Immune to most poisons.</li>"
	if(appearance_flags & HAS_A_SKIN_TONE)
		codex_traits += "<li>Has a variety of skin tones.</li>"
	if(appearance_flags & HAS_SKIN_COLOR)
		codex_traits += "<li>Has a variety of skin colours.</li>"
	if(appearance_flags & HAS_EYE_COLOR)
		codex_traits += "<li>Has a variety of eye colours.</li>"
	if(species_flags & SPECIES_FLAG_IS_PLANT)
		codex_traits += "<li>Has a plantlike physiology.</li>"
	if(slowdown)
		codex_traits += "<li>Moves [slowdown > 0 ? "slower" : "faster"] than most.</li>"

	var/list/codex_damage_types = list(
		"physical trauma" = brute_mod,
		"burns" = burn_mod,
		"lack of air" = oxy_mod,
	)
	for(var/kind in codex_damage_types)
		if(codex_damage_types[kind] > 1)
			codex_traits += "<li>Vulnerable to [kind].</li>"
		else if(codex_damage_types[kind] < 1)
			codex_traits += "<li>Resistant to [kind].</li>"
	if(breath_type)
		var/decl/material/mat = GET_DECL(breath_type)
		codex_traits += "<li>They breathe [mat.gas_name].</li>"
	if(exhale_type)
		var/decl/material/mat = GET_DECL(exhale_type)
		codex_traits += "<li>They exhale [mat.gas_name].</li>"
	if(LAZYLEN(poison_types))
		var/list/poison_names = list()
		for(var/g in poison_types)
			var/decl/material/mat = GET_DECL(exhale_type)
			poison_names |= mat.gas_name
		codex_traits += "<li>[capitalize(english_list(poison_names))] [LAZYLEN(poison_names) == 1 ? "is" : "are"] poisonous to them.</li>"

	if(length(codex_traits))
		var/trait_string = "They have the following notable traits:<br><ul>[jointext(codex_traits, null)]</ul>"
		if(ooc_codex_information)
			ooc_codex_information += "<br><br>[trait_string]"
		else
			ooc_codex_information = trait_string

/decl/species/Initialize()

	. = ..()

	if(config.grant_default_darksight)
		darksight_range = max(darksight_range, config.default_darksight_range)
		low_light_vision_effectiveness = max(low_light_vision_effectiveness, config.default_darksight_effectiveness)

	// Populate blood type table.
	for(var/blood_type in blood_types)
		var/decl/blood_type/blood_decl = GET_DECL(blood_type)
		blood_types -= blood_type
		blood_types[blood_decl.name] = blood_decl.random_weighting

	for(var/bodytype in available_bodytypes)
		available_bodytypes -= bodytype
		available_bodytypes += GET_DECL(bodytype)

	if(ispath(default_bodytype))
		default_bodytype = GET_DECL(default_bodytype)
	else if(length(available_bodytypes) && !default_bodytype)
		default_bodytype = available_bodytypes[1]

	for(var/pronoun in available_pronouns)
		available_pronouns -= pronoun
		available_pronouns += GET_DECL(pronoun)

	if(ispath(default_pronouns))
		default_pronouns = GET_DECL(default_pronouns)
	else if(length(available_pronouns) && !default_pronouns)
		default_pronouns = available_pronouns[1]

	for(var/token in ALL_CULTURAL_TAGS)

		var/force_val = force_cultural_info[token]
		if(force_val)
			default_cultural_info[token] = force_val
			available_cultural_info[token] = list(force_val)

		else if(additional_available_cultural_info[token])
			if(!available_cultural_info[token])
				available_cultural_info[token] = list()
			available_cultural_info[token] |= additional_available_cultural_info[token]

		else if(!LAZYLEN(available_cultural_info[token]))
			var/list/map_systems = global.using_map.available_cultural_info[token]
			available_cultural_info[token] = map_systems.Copy()

		if(LAZYLEN(available_cultural_info[token]) && !default_cultural_info[token])
			var/list/avail_systems = available_cultural_info[token]
			default_cultural_info[token] = avail_systems[1]

		if(!default_cultural_info[token])
			default_cultural_info[token] = global.using_map.default_cultural_info[token]

	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	if(LAZYLEN(appearance_descriptors))
		for(var/desctype in appearance_descriptors)
			var/datum/appearance_descriptor/descriptor = new desctype(appearance_descriptors[desctype])
			appearance_descriptors -= desctype
			appearance_descriptors[descriptor.name] = descriptor

	if(!(/datum/appearance_descriptor/age in appearance_descriptors))
		LAZYINITLIST(appearance_descriptors)
		var/datum/appearance_descriptor/age/age = new age_descriptor(1)
		appearance_descriptors.Insert(1, age.name)
		appearance_descriptors[age.name] = age

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES
	//If the species has lungs, they are the default breathing organ
	if(!breathing_organ && has_organ[BP_LUNGS])
		breathing_organ = BP_LUNGS

	// Modify organ lists if necessary.
	if(islist(override_organ_types))
		for(var/ltag in override_organ_types)
			has_organ[ltag] = override_organ_types[ltag]

	if(islist(override_limb_types))
		for(var/ltag in override_limb_types)
			has_limbs[ltag] = list("path" = override_limb_types[ltag])

	//Build organ descriptors
	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/obj/item/organ/limb_path = organ_data["path"]
		organ_data["descriptor"] = initial(limb_path.name)

	build_codex_strings()

/decl/species/validate()
	. = ..()

	for(var/decl/bodytype/bodytype in available_bodytypes)
		var/bodytype_base_icon = bodytype.get_base_icon()
		var/deformed_base_icon = bodytype.get_base_icon(get_deform = TRUE)
		for(var/organ_tag in has_limbs)
			if(organ_tag == BP_TAIL) // Tails are handled specially due to overlays and animations, will not be present in the base bodytype icon(s).
				continue
			if(bodytype_base_icon && !check_state_in_icon(organ_tag, bodytype_base_icon))
				. += "missing state \"[organ_tag]\" from base icon [bodytype_base_icon] on bodytype [bodytype.type]"
			if(deformed_base_icon && bodytype_base_icon != deformed_base_icon && !check_state_in_icon(organ_tag, deformed_base_icon))
				. += "missing state \"[organ_tag]\" from deformed icon [deformed_base_icon] on bodytype [bodytype.type]"

	for(var/organ_tag in vital_organs)
		if(!(organ_tag in has_organ) && !(organ_tag in has_limbs))
			. += "vital organ \"[organ_tag]\" not present in organ/limb lists"

	for(var/trait_type in traits)
		var/trait_level = traits[trait_type]
		var/decl/trait/T = GET_DECL(trait_type)
		if(!T.validate_level(trait_level))
			. += "invalid levels for species trait [trait_type]"

	if(base_low_light_vision > 1)
		. += "base low light vision is greater than 1 (over 100%)"
	else if(base_low_light_vision < 0)
		. += "base low light vision is less than 0 (below 0%)"

	if(low_light_vision_threshold > 1)
		. += "low light vision threshold is greater than 1 (over 100%)"
	else if(low_light_vision_threshold < 0)
		. += "low light vision threshold is less than 0 (below 0%)"

	if(low_light_vision_effectiveness > 1)
		. += "low light vision effectiveness is greater than 1 (over 100%)"
	else if(low_light_vision_effectiveness < 0)
		. += "low light vision effectiveness is less than 0 (below 0%)"

	if(low_light_vision_adjustment_speed > 1)
		. += "low light vision adjustment speed is greater than 1 (over 100%)"
	else if(low_light_vision_adjustment_speed < 0)
		. += "low light vision adjustment speed is less than 0 (below 0%)"

	if((appearance_flags & HAS_SKIN_COLOR) && isnull(base_color))
		. += "uses skin color but missing base_color"
	if((appearance_flags & HAS_HAIR_COLOR) && isnull(base_hair_color))
		. += "uses hair color but missing base_hair_color"
	if((appearance_flags & HAS_EYE_COLOR) && isnull(base_eye_color))
		. += "uses eye color but missing base_eye_color"
	if(isnull(default_h_style))
		. += "null default_h_style (use a bald/hairless hairstyle if 'no hair' is intended)"
	if(isnull(default_f_style))
		. += "null default_f_style (use a shaved/hairless facial hair style if 'no facial hair' is intended)"
	if(!length(blood_types))
		. += "missing at least one blood type"
	if(default_bodytype && !(default_bodytype in available_bodytypes))
		. += "default bodytype is not in available bodytypes list"
	if(!length(available_bodytypes))
		. += "missing at least one bodytype"
	// TODO: Maybe make age descriptors optional, in case someone wants a 'timeless entity' species?
	if(isnull(age_descriptor))
		. += "age descriptor was unset"
	else if(!ispath(age_descriptor, /datum/appearance_descriptor/age))
		. += "age descriptor was not a /datum/appearance_descriptor/age subtype"

	if(cold_level_3)
		if(cold_level_2)
			if(cold_level_3 > cold_level_2)
				. += "cold_level_3 ([cold_level_3]) was not lower than cold_level_2 ([cold_level_2])"
			if(cold_level_1)
				if(cold_level_3 > cold_level_1)
					. += "cold_level_3 ([cold_level_3]) was not lower than cold_level_1 ([cold_level_1])"
	if(cold_level_2 && cold_level_1)
		if(cold_level_2 > cold_level_1)
			. += "cold_level_2 ([cold_level_2]) was not lower than cold_level_1 ([cold_level_1])"

	if(heat_level_3 != INFINITY)
		if(heat_level_2 != INFINITY)
			if(heat_level_3 < heat_level_2)
				. += "heat_level_3 ([heat_level_3]) was not higher than heat_level_2 ([heat_level_2])"
			if(heat_level_1 != INFINITY)
				if(heat_level_3 < heat_level_1)
					. += "heat_level_3 ([heat_level_3]) was not higher than heat_level_1 ([heat_level_1])"
	if((heat_level_2 != INFINITY) && (heat_level_1 != INFINITY))
		if(heat_level_2 < heat_level_1)
			. += "heat_level_2 ([heat_level_2]) was not higher than heat_level_1 ([heat_level_1])"

	if(min(heat_level_1, heat_level_2, heat_level_3) <= max(cold_level_1, cold_level_2, cold_level_3))
		. += "heat and cold damage level thresholds overlap"

	if(taste_sensitivity < 0)
		. += "taste_sensitivity ([taste_sensitivity]) was negative"

/decl/species/proc/equip_survival_gear(var/mob/living/carbon/human/H, var/box_type = /obj/item/storage/box/survival)
	var/obj/item/storage/backpack/backpack = H.get_equipped_item(slot_back_str)
	if(istype(backpack))
		H.equip_to_slot_or_del(new box_type(backpack), slot_in_backpack_str)
	else
		H.put_in_hands_or_del(new box_type(H))

/decl/species/proc/get_manual_dexterity(var/mob/living/carbon/human/H)
	. = manual_dexterity

//Checks if an existing organ is the species default
/decl/species/proc/is_default_organ(var/obj/item/organ/O)
	for(var/tag in has_organ)
		if(O.organ_tag == tag)
			if(ispath(O.type, has_organ[tag]))
				return TRUE
	return FALSE

//Checks if an existing limbs is the species default
/decl/species/proc/is_default_limb(var/obj/item/organ/external/E)
	// Crystalline/synthetic species should only count crystalline/synthetic limbs as default.
	// DO NOT change to (species_flags & SPECIES_FLAG_X) && !BP_IS_X(E)
	if(!(species_flags & SPECIES_FLAG_CRYSTALLINE) != !BP_IS_CRYSTAL(E))
		return FALSE
	if(!(species_flags & SPECIES_FLAG_SYNTHETIC) != !BP_IS_PROSTHETIC(E))
		return FALSE
	for(var/tag in has_limbs)
		if(E.organ_tag == tag)
			var/list/organ_data = has_limbs[tag]
			if(ispath(E.type, organ_data["path"]))
				return TRUE
	return FALSE

//fully_replace: If true, all existing organs will be discarded. Useful when doing mob transformations, and not caring about the existing organs
/decl/species/proc/create_missing_organs(var/mob/living/carbon/human/H, var/fully_replace = FALSE)
	if(fully_replace)
		H.delete_organs()

	//Clear invalid limbs
	if(H.has_external_organs())
		for(var/obj/item/organ/external/E in H.get_external_organs())
			if(!is_default_limb(E))
				H.remove_organ(E, FALSE, FALSE, TRUE, TRUE, FALSE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(E)

	//Clear invalid internal organs
	if(H.has_internal_organs())
		for(var/obj/item/organ/O in H.get_internal_organs())
			if(!is_default_organ(O))
				H.remove_organ(O, FALSE, FALSE, TRUE, TRUE, FALSE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(O)

	//Create missing limbs
	for(var/limb_type in has_limbs)
		if(GET_EXTERNAL_ORGAN(H, limb_type)) //Skip existing
			continue
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/external/E = new limb_path(H, null, H.dna) //explicitly specify the dna
		if(E.parent_organ)
			var/list/parent_organ_data = has_limbs[E.parent_organ]
			parent_organ_data["has_children"]++
		H.add_organ(E, null, FALSE, FALSE)

	//Create missing internal organs
	for(var/organ_tag in has_organ)
		if(GET_INTERNAL_ORGAN(H, organ_tag)) //Skip existing
			continue
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H, null, H.dna)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.add_organ(O, GET_EXTERNAL_ORGAN(H, O.parent_organ), FALSE, FALSE)

/decl/species/proc/add_base_auras(var/mob/living/carbon/human/H)
	if(base_auras)
		for(var/type in base_auras)
			H.add_aura(new type(H))

/decl/species/proc/remove_base_auras(var/mob/living/carbon/human/H)
	if(base_auras)
		var/list/bcopy = base_auras.Copy()
		for(var/a in H.auras)
			var/obj/aura/A = a
			if(is_type_in_list(a, bcopy))
				bcopy -= A.type
				H.remove_aura(A)
				qdel(A)

/decl/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/decl/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/decl/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	add_base_auras(H)
	handle_movement_flags_setup(H)

/decl/species/proc/handle_pre_spawn(var/mob/living/carbon/human/H)
	return

/decl/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events.
	return

/decl/species/proc/handle_new_grab(var/mob/living/carbon/human/H, var/obj/item/grab/G)
	return

/decl/species/proc/handle_sleeping(var/mob/living/carbon/human/H)
	if(prob(2) && !H.failed_last_breath && !H.isSynthetic())
		if(!HAS_STATUS(H, STAT_PARA))
			H.emote("snore")
		else
			H.emote("groan")

/decl/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

/decl/species/proc/handle_movement_delay_special(var/mob/living/carbon/human/H)
	return 0

// Used to update alien icons for aliens.
/decl/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/decl/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/decl/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

/decl/species/proc/can_overcome_gravity(var/mob/living/carbon/human/H)
	return FALSE

// Used for any extra behaviour when falling and to see if a species will fall at all.
/decl/species/proc/can_fall(var/mob/living/carbon/human/H)
	return TRUE

// Used to override normal fall behaviour. Use only when the species does fall down a level.
/decl/species/proc/handle_fall_special(var/mob/living/carbon/human/H, var/turf/landing)
	return FALSE

//Used for swimming
/decl/species/proc/can_float(var/mob/living/carbon/human/H)
	if(!H.is_physically_disabled())
		return TRUE //We could tie it to stamina
	return FALSE

// Called when using the shredding behavior.
/decl/species/proc/can_shred(var/mob/living/carbon/human/H, var/ignore_intent, var/ignore_antag)

	if((!ignore_intent && H.a_intent != I_HURT) || H.pulling_punches)
		return 0

	if(!ignore_antag && H.mind && !player_is_antag(H.mind))
		return 0

	for(var/attack_type in unarmed_attacks)
		var/decl/natural_attack/attack = GET_DECL(attack_type)
		if(!istype(attack) || !attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1
	return 0

/decl/species/proc/handle_vision(var/mob/living/carbon/human/H)
	var/list/vision = H.get_accumulated_vision_handlers()
	H.update_sight()
	H.set_sight(H.sight|get_vision_flags(H)|H.equipment_vision_flags|vision[1])

	if(H.stat == DEAD)
		return 1

	if(!HAS_STATUS(H, STAT_DRUGGY))
		H.set_see_in_dark((H.sight == (SEE_TURFS|SEE_MOBS|SEE_OBJS)) ? 8 : min(H.get_darksight_range() + H.equipment_darkness_modifier, 8))
		if(H.equipment_see_invis)
			H.set_see_invisible(max(min(H.see_invisible, H.equipment_see_invis), vision[2]))

	if(H.equipment_tint_total >= TINT_BLIND)
		SET_STATUS_MAX(H, STAT_BLIND, 1)

	if(!H.client)//no client, no screen to update
		return 1

	H.set_fullscreen(GET_STATUS(H, STAT_BLIND) && !H.equipment_prescription, "blind", /obj/screen/fullscreen/blind)
	H.set_fullscreen(H.stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)

	if(config.welder_vision)
		H.set_fullscreen(H.equipment_tint_total, "welder", /obj/screen/fullscreen/impaired, H.equipment_tint_total)
	var/how_nearsighted = get_how_nearsighted(H)
	H.set_fullscreen(how_nearsighted, "nearsighted", /obj/screen/fullscreen/oxy, how_nearsighted)
	H.set_fullscreen(GET_STATUS(H, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
	H.set_fullscreen(GET_STATUS(H, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)
	if(HAS_STATUS(H, STAT_DRUGGY))
		H.add_client_color(/datum/client_color/oversaturated)
	else
		H.remove_client_color(/datum/client_color/oversaturated)

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	return 1

/decl/species/proc/get_how_nearsighted(var/mob/living/carbon/human/H)
	var/prescriptions = short_sighted
	if(H.disabilities & NEARSIGHTED)
		prescriptions += 7
	if(H.equipment_prescription)
		prescriptions -= H.equipment_prescription

	var/light = light_sensitive
	if(light)
		if(H.eyecheck() > FLASH_PROTECTION_NONE)
			light = 0
		else
			var/turf_brightness = 1
			var/turf/T = get_turf(H)
			if(T && T.lighting_overlay)
				turf_brightness = min(1, T.get_lumcount())
			if(turf_brightness < 0.33)
				light = 0
			else
				light = round(light * turf_brightness)
				if(H.equipment_light_protection)
					light -= H.equipment_light_protection
	return clamp(max(prescriptions, light), 0, 7)

/decl/species/proc/set_default_hair(mob/living/carbon/human/organism, override_existing = TRUE, defer_update_hair = FALSE)
	if(!organism.h_style || (override_existing && (organism.h_style != default_h_style)))
		organism.h_style = default_h_style
		. = TRUE
	if(!organism.h_style || (override_existing && (organism.f_style != default_f_style)))
		organism.f_style = default_f_style
		. = TRUE
	if(. && !defer_update_hair)
		organism.update_hair()

/decl/species/proc/handle_additional_hair_loss(var/mob/living/carbon/human/H, var/defer_body_update = TRUE)
	return FALSE

/decl/species/proc/get_blood_decl(var/mob/living/carbon/human/H)
	if(istype(H) && H.isSynthetic())
		return GET_DECL(/decl/blood_type/coolant)
	return get_blood_type_by_name(blood_types[1])

/decl/species/proc/get_blood_name(var/mob/living/carbon/human/H)
	var/decl/blood_type/blood = get_blood_decl(H)
	return istype(blood) ? blood.splatter_name : "blood"

/decl/species/proc/get_blood_color(var/mob/living/carbon/human/H)
	var/decl/blood_type/blood = get_blood_decl(H)
	return istype(blood) ? blood.splatter_colour : COLOR_BLOOD_HUMAN

// Impliments different trails for species depending on if they're wearing shoes.
/decl/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if(H.lying)
		return /obj/effect/decal/cleanable/blood/tracks/body
	var/obj/item/clothing/suit = H.get_equipped_item(slot_wear_suit_str)
	if(istype(suit) && (suit.body_parts_covered & SLOT_FEET))
		return suit.move_trail
	var/obj/item/clothing/shoes = H.get_equipped_item(slot_shoes_str)
	if(istype(shoes))
		return shoes.move_trail
	return move_trail

/decl/species/proc/handle_trail(var/mob/living/carbon/human/H, var/turf/simulated/T)
	return

/decl/species/proc/update_skin(var/mob/living/carbon/human/H)
	return

/decl/species/proc/disarm_attackhand(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/target)
	attacker.do_attack_animation(target)

	var/obj/item/uniform = target.get_equipped_item(slot_w_uniform_str)
	if(uniform)
		uniform.add_fingerprint(attacker)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, ran_zone(attacker.get_target_zone(), target = target))

	var/list/holding = list(target.get_active_hand() = 60)
	for(var/thing in target.get_inactive_held_items())
		holding[thing] = 30

	var/skill_mod = 10 * attacker.get_skill_difference(SKILL_COMBAT, target)
	var/state_mod = attacker.melee_accuracy_mods() - target.melee_accuracy_mods()
	var/push_mod = min(max(1 + attacker.get_skill_difference(SKILL_COMBAT, target), 1), 3)
	if(target.a_intent == I_HELP)
		state_mod -= 30
	//Handle unintended consequences
	for(var/obj/item/I in holding)
		var/hurt_prob = max(holding[I] - 2*skill_mod + state_mod, 0)
		if(prob(hurt_prob) && I.on_disarm_attempt(target, attacker))
			return

	var/randn = rand(1, 100) - skill_mod + state_mod
	if(!(check_no_slip(target)) && randn <= 25)
		var/armor_check = 100 * target.get_blocked_ratio(affecting, BRUTE, damage = 20)
		target.apply_effect(push_mod, WEAKEN, armor_check)
		playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(armor_check < 100)
			target.visible_message("<span class='danger'>[attacker] has pushed [target]!</span>")
		else
			target.visible_message("<span class='warning'>[attacker] attempted to push [target]!</span>")
		return

	if(randn <= 60)
		//See about breaking grips or pulls
		if(target.break_all_grabs(attacker))
			playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return

		//Actually disarm them
		for(var/obj/item/I in holding)
			if(I && target.try_unequip(I))
				target.visible_message("<span class='danger'>[attacker] has disarmed [target]!</span>")
				playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return

	playsound(target.loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	target.visible_message("<span class='danger'>[attacker] attempted to disarm \the [target]!</span>")

/decl/species/proc/disfigure_msg(var/mob/living/carbon/human/H) //Used for determining the message a disfigured face has on examine. To add a unique message, just add this onto a specific species and change the "return" message.
	var/decl/pronouns/G = H.get_pronouns()
	return SPAN_DANGER("[G.His] face is horribly mangled!\n")

/decl/species/proc/max_skin_tone()
	if(appearance_flags & HAS_SKIN_TONE_GRAV)
		return 100
	if(appearance_flags & HAS_SKIN_TONE_SPCR)
		return 165
	if(appearance_flags & HAS_SKIN_TONE_TRITON)
		return 80
	return 220

/decl/species/proc/get_hair_style_types(var/gender = NEUTER, var/check_gender = TRUE)
	if(!check_gender)
		gender = NEUTER
	var/list/hair_styles_by_species = LAZYACCESS(hair_styles, type)
	if(!hair_styles_by_species)
		hair_styles_by_species = list()
		LAZYSET(hair_styles, type, hair_styles_by_species)
	var/list/hair_style_by_gender = hair_styles_by_species[gender]
	if(!hair_style_by_gender)
		hair_style_by_gender = list()
		LAZYSET(hair_styles_by_species, gender, hair_style_by_gender)
		var/list/all_hairstyles = decls_repository.get_decls_of_subtype(/decl/sprite_accessory/hair)
		for(var/hairstyle in all_hairstyles)
			var/decl/sprite_accessory/S = all_hairstyles[hairstyle]
			if(!S.accessory_is_available(null, src, null, (check_gender && gender)))
				continue
			ADD_SORTED(hair_style_by_gender, hairstyle, /proc/cmp_text_asc)
			hair_style_by_gender[hairstyle] = S
	return hair_style_by_gender

/decl/species/proc/get_hair_styles(var/gender = NEUTER, var/check_gender = TRUE)
	. = list()
	for(var/hair in get_hair_style_types(gender, check_gender))
		. += GET_DECL(hair)

/decl/species/proc/get_facial_hair_style_types(var/gender, var/check_gender = TRUE)
	if(!check_gender)
		gender = NEUTER
	var/list/facial_hair_styles_by_species = LAZYACCESS(facial_hair_styles, type)
	if(!facial_hair_styles_by_species)
		facial_hair_styles_by_species = list()
		LAZYSET(facial_hair_styles, type, facial_hair_styles_by_species)
	var/list/facial_hair_style_by_gender = facial_hair_styles_by_species[gender]
	if(!facial_hair_style_by_gender)
		facial_hair_style_by_gender = list()
		LAZYSET(facial_hair_styles_by_species, gender, facial_hair_style_by_gender)
		var/list/all_facial_styles = decls_repository.get_decls_of_subtype(/decl/sprite_accessory/facial_hair)
		for(var/facialhairstyle in all_facial_styles)
			var/decl/sprite_accessory/S = all_facial_styles[facialhairstyle]
			if(!S.accessory_is_available(null, src, null, (check_gender && gender)))
				continue
			ADD_SORTED(facial_hair_style_by_gender, facialhairstyle, /proc/cmp_text_asc)
			facial_hair_style_by_gender[facialhairstyle] = S
	return facial_hair_style_by_gender

/decl/species/proc/get_facial_hair_styles(var/gender, var/check_gender = TRUE)
	. = list()
	for(var/hair in get_facial_hair_style_types(gender, check_gender))
		. += GET_DECL(hair)

/decl/species/proc/skills_from_age(age)	//Converts an age into a skill point allocation modifier. Can be used to give skill point bonuses/penalities not depending on job.
	switch(age)
		if(0 to 22) 	. = -4
		if(23 to 30) 	. = 0
		if(31 to 45)	. = 4
		else			. = 8

// This should only ever be called via the species set on the organ; calling it across species will cause weirdness.
/decl/species/proc/apply_species_organ_modifications(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)
	if(species_flags & SPECIES_FLAG_CRYSTALLINE)
		org.status |= ORGAN_BRITTLE
		org.organ_properties |= ORGAN_PROP_CRYSTAL

/decl/species/proc/check_no_slip(var/mob/living/carbon/human/H)
	if(can_overcome_gravity(H))
		return TRUE
	return (species_flags & SPECIES_FLAG_NO_SLIP)

/decl/species/proc/get_pain_emote(var/mob/living/carbon/human/H, var/pain_power)
	if(!(species_flags & SPECIES_FLAG_NO_PAIN))
		return
	for(var/pain_emotes in pain_emotes_with_pain_level)
		var/pain_level = pain_emotes_with_pain_level[pain_emotes]
		if(pain_level >= pain_power)
			// This assumes that if a pain-level has been defined it also has a list of emotes to go with it
			var/decl/emote/E = GET_DECL(pick(pain_emotes))
			return E.key

/decl/species/proc/handle_post_move(var/mob/living/carbon/human/H)
	handle_exertion(H)

/decl/species/proc/handle_exertion(mob/living/carbon/human/H)
	if (!exertion_effect_chance)
		return
	var/chance = max((100 - H.stamina), exertion_effect_chance * H.encumbrance())
	if (chance && prob(H.skill_fail_chance(SKILL_HAULING, chance)))
		var/synthetic = H.isSynthetic()
		if (synthetic)
			if (exertion_charge_scale)
				var/obj/item/organ/internal/cell/cell = H.get_organ(BP_CELL, /obj/item/organ/internal/cell)
				if (cell)
					cell.use(cell.get_power_drain() * exertion_charge_scale)
		else
			if (exertion_hydration_scale)
				H.adjust_hydration(-DEFAULT_THIRST_FACTOR * exertion_hydration_scale)
			if (exertion_nutrition_scale)
				H.adjust_nutrition(-DEFAULT_HUNGER_FACTOR * exertion_nutrition_scale)
			if (exertion_reagent_scale && !isnull(exertion_reagent_path))
				H.make_reagent(REM * exertion_reagent_scale, exertion_reagent_path)
		if(prob(exertion_emote_chance))
			var/list/active_emotes = synthetic ? exertion_emotes_synthetic : exertion_emotes_biological
			if(length(active_emotes))
				var/decl/emote/exertion_emote = GET_DECL(pick(active_emotes))
				exertion_emote.do_emote(H)

/decl/species/proc/get_default_name()
	return "[lowertext(name)] ([random_id(name, 100, 999)])"

/decl/species/proc/get_holder_color(var/mob/living/carbon/human/H)
	return

//Called after a mob's species is set, organs were created, and we're about to update the icon, color, and etc of the mob being created.
//Consider this might be called post-init
/decl/species/proc/apply_appearance(var/mob/living/carbon/human/H)
	H.icon_state = lowertext(src.name)
	H.skin_colour = src.base_color
	update_appearance_descriptors(H)

/decl/species/proc/update_appearance_descriptors(var/mob/living/carbon/human/H)
	if(!LAZYLEN(src.appearance_descriptors))
		H.appearance_descriptors = null
		return

	var/list/new_descriptors = list()
	//Add missing descriptors, and sanitize any existing ones
	for(var/desctype in src.appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = src.appearance_descriptors[desctype]
		if(H.appearance_descriptors && H.appearance_descriptors[descriptor.name])
			new_descriptors[descriptor.name] = descriptor.sanitize_value(H.appearance_descriptors[descriptor.name])
		else
			new_descriptors[descriptor.name] = descriptor.default_value
	//Make sure only supported descriptors are left
	H.appearance_descriptors = new_descriptors

/decl/species/proc/get_preview_icon()
	if(!preview_icon)

		// TODO: generate an icon based on all available bodytypes.

		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#species_[ckey(name)]")
		if(mannequin)

			mannequin.change_species(name)
			customize_preview_mannequin(mannequin)

			preview_icon = icon(mannequin.bodytype.icon_template)
			var/mob_width = preview_icon.Width()
			preview_icon.Scale((mob_width * 2)+16, preview_icon.Height()+16)

			preview_icon.Blend(getFlatIcon(mannequin, defdir = SOUTH, always_use_defdir = TRUE), ICON_OVERLAY, 8, 8)
			preview_icon.Blend(getFlatIcon(mannequin, defdir = WEST,  always_use_defdir = TRUE), ICON_OVERLAY, mob_width+8, 8)

			preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2)
			preview_icon_width = preview_icon.Width()
			preview_icon_height = preview_icon.Height()
			preview_icon_path = "species_preview_[ckey(name)].png"

	return preview_icon

/decl/species/proc/handle_movement_flags_setup(var/mob/living/carbon/human/H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/decl/species/proc/check_vital_organ_missing(var/mob/living/carbon/H)
	if(length(vital_organs))
		for(var/organ_tag in vital_organs)
			var/obj/item/organ/O = H.get_organ(organ_tag, /obj/item/organ)
			if(!O || (O.status & ORGAN_DEAD))
				return TRUE
	return FALSE

/decl/species/proc/get_species_temperature_threshold(var/threshold)
	switch(threshold)
		if(COLD_LEVEL_1)
			return cold_level_1
		if(COLD_LEVEL_2)
			return cold_level_2
		if(COLD_LEVEL_3)
			return cold_level_3
		if(HEAT_LEVEL_1)
			return heat_level_1
		if(HEAT_LEVEL_2)
			return heat_level_2
		if(HEAT_LEVEL_3)
			return heat_level_3
		else
			CRASH("get_species_temperature_threshold() called with invalid threshold value.")
