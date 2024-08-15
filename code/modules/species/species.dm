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
	var/poison_types = list(/decl/material/gas/chlorine = TRUE) // Noticeably poisonous air - ie. updates the toxins indicator on the HUD.
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

/decl/species/proc/build_codex_strings()

	if(!codex_description)
		codex_description = description

	// Generate OOC info.
	var/list/codex_traits = list()
	if(spawn_flags & SPECIES_CAN_JOIN)
		codex_traits += "<li>Often present among humans.</li>"
	if(spawn_flags & SPECIES_IS_WHITELISTED)
		codex_traits += "<li>Whitelist restricted.</li>"
	if(!default_bodytype.has_organ[BP_HEART])
		codex_traits += "<li>Does not have blood.</li>"
	if(!default_bodytype.breathing_organ)
		codex_traits += "<li>Does not breathe.</li>"
	if(default_bodytype.body_flags & BODY_FLAG_NO_PAIN)
		codex_traits += "<li>Does not feel pain.</li>"
	if(default_bodytype.body_flags & BODY_FLAG_NO_DNA)
		codex_traits += "<li>Does not have DNA.</li>"
	if(default_bodytype.body_flags & BODY_FLAG_NO_EAT)
		codex_traits += "<li>Lacks a mouth capable of eating.</li>"
	if(species_flags & SPECIES_FLAG_NO_MINOR_CUT)
		codex_traits += "<li>Has thick skin/scales.</li>"
	if(species_flags & SPECIES_FLAG_NO_SLIP)
		codex_traits += "<li>Has excellent traction.</li>"
	if(species_flags & SPECIES_FLAG_NO_POISON)
		codex_traits += "<li>Immune to most poisons.</li>"
	if(species_flags & SPECIES_FLAG_IS_PLANT)
		codex_traits += "<li>Has a plantlike physiology.</li>"

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

	if(!base_internal_prosthetics_model)
		// internal bodytypes don't care about icons so this is safe, and also necessary for the default map species
		base_internal_prosthetics_model = base_external_prosthetics_model || /decl/bodytype/prosthetic/basic_human

	// Populate blood type table.
	for(var/blood_type in blood_types)
		var/decl/blood_type/blood_decl = GET_DECL(blood_type)
		blood_types -= blood_type
		blood_types[blood_decl.name] = blood_decl.random_weighting

	for(var/bodytype in available_bodytypes)
		available_bodytypes -= bodytype
		available_bodytypes += GET_DECL(bodytype)

	// Update sprite accessory lists for these species.
	for(var/accessory_type in allow_specific_sprite_accessories)
		var/decl/sprite_accessory/accessory = GET_DECL(accessory_type)
		// If this accessory is species restricted, add us to the list.
		if(accessory.species_allowed)
			accessory.species_allowed |= name
		if(!isnull(accessory.body_flags_allowed))
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.body_flags_allowed |= bodytype.body_flags
		if(!isnull(accessory.body_flags_denied))
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.body_flags_denied &= ~bodytype.body_flags
		if(accessory.bodytype_categories_allowed)
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.bodytype_categories_allowed |= bodytype.bodytype_category
		if(accessory.bodytype_categories_denied)
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.bodytype_categories_allowed -= bodytype.bodytype_category

	for(var/accessory_type in disallow_specific_sprite_accessories)
		var/decl/sprite_accessory/accessory = GET_DECL(accessory_type)
		if(accessory.species_allowed)
			accessory.species_allowed -= name
		if(!isnull(accessory.body_flags_allowed))
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.body_flags_allowed &= ~bodytype.body_flags
		if(!isnull(accessory.body_flags_denied))
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.body_flags_denied |= bodytype.body_flags
		if(accessory.bodytype_categories_allowed)
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.bodytype_categories_allowed -= bodytype.bodytype_category
		if(accessory.bodytype_categories_denied)
			for(var/decl/bodytype/bodytype in available_bodytypes)
				accessory.bodytype_categories_allowed |= bodytype.bodytype_category

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

	if(species_hud)
		species_hud = new species_hud
	else
		species_hud = new

	build_codex_strings()

/decl/species/validate()
	. = ..()

	for(var/trait_type in traits)
		var/trait_level = traits[trait_type]
		var/decl/trait/trait = GET_DECL(trait_type)
		if(!trait.validate_level(trait_level))
			. += "invalid levels for species trait [trait_type]"
		if(name in trait.blocked_species)
			. += "trait [trait.name] prevents this species from taking it"
		if(trait.permitted_species && !(name in trait.permitted_species))
			. += "trait [trait.name] does not permit this species to take it"

	if(!length(blood_types))
		. += "missing at least one blood type"
	if(default_bodytype && !(default_bodytype in available_bodytypes))
		. += "default bodytype is not in available bodytypes list"
	if(!length(available_bodytypes))
		. += "missing at least one bodytype"

	if(taste_sensitivity < 0)
		. += "taste_sensitivity ([taste_sensitivity]) was negative"

/decl/species/proc/equip_survival_gear(var/mob/living/human/H, var/box_type = /obj/item/box/survival)
	var/obj/item/backpack/backpack = H.get_equipped_item(slot_back_str)
	if(istype(backpack))
		H.equip_to_slot_or_del(new box_type(backpack), slot_in_backpack_str)
	else
		H.put_in_hands_or_del(new box_type(H))

/decl/species/proc/get_manual_dexterity(var/mob/living/human/H)
	. = manual_dexterity

/decl/species/proc/add_base_auras(var/mob/living/human/H)
	if(base_auras)
		for(var/type in base_auras)
			H.add_aura(new type(H), skip_icon_update = TRUE)

/decl/species/proc/remove_base_auras(var/mob/living/human/H)
	if(base_auras)
		var/list/bcopy = base_auras.Copy()
		for(var/a in H.auras)
			var/obj/aura/A = a
			if(is_type_in_list(a, bcopy))
				bcopy -= A.type
				H.remove_aura(A)
				qdel(A)

/decl/species/proc/remove_inherent_verbs(var/mob/living/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/decl/species/proc/add_inherent_verbs(var/mob/living/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/decl/species/proc/handle_post_spawn(var/mob/living/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	add_base_auras(H)
	handle_movement_flags_setup(H)

/decl/species/proc/handle_pre_spawn(var/mob/living/human/H)
	return

/decl/species/proc/handle_death(var/mob/living/human/H) //Handles any species-specific death events.
	return

/decl/species/proc/handle_sleeping(var/mob/living/human/H)
	if(prob(2) && !H.failed_last_breath && !H.isSynthetic())
		if(!HAS_STATUS(H, STAT_PARA))
			H.emote(/decl/emote/audible/snore)
		else
			H.emote(/decl/emote/audible/groan)

/decl/species/proc/handle_environment_special(var/mob/living/human/H)
	return

/decl/species/proc/handle_movement_delay_special(var/mob/living/human/H)
	return 0

// Used to update alien icons for aliens.
/decl/species/proc/handle_login_special(var/mob/living/human/H)
	return

// As above.
/decl/species/proc/handle_logout_special(var/mob/living/human/H)
	return

/decl/species/proc/can_overcome_gravity(var/mob/living/human/H)
	return FALSE

// Used for any extra behaviour when falling and to see if a species will fall at all.
/decl/species/proc/can_fall(var/mob/living/human/H)
	return TRUE

// Used to override normal fall behaviour. Use only when the species does fall down a level.
/decl/species/proc/handle_fall_special(var/mob/living/human/H, var/turf/landing)
	return FALSE

//Used for swimming
/decl/species/proc/can_float(var/mob/living/human/H)
	if(!H.is_physically_disabled())
		return TRUE //We could tie it to stamina
	return FALSE

// Called when using the shredding behavior.
/decl/species/proc/can_shred(var/mob/living/human/H, var/ignore_intent, var/ignore_antag)

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

/decl/species/proc/handle_vision(var/mob/living/human/H)
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
		SET_STATUS_MAX(H, STAT_BLIND, 2)

	if(!H.client)//no client, no screen to update
		return 1

	H.set_fullscreen(GET_STATUS(H, STAT_BLIND) && !H.equipment_prescription, "blind", /obj/screen/fullscreen/blind)
	H.set_fullscreen(H.stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)

	if(get_config_value(/decl/config/toggle/on/welder_vision))
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

/decl/species/proc/get_how_nearsighted(var/mob/living/human/H)
	var/prescriptions = short_sighted
	if(H.has_genetic_condition(GENE_COND_NEARSIGHTED))
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

/decl/species/proc/handle_additional_hair_loss(var/mob/living/human/H, var/defer_body_update = TRUE)
	return FALSE

/decl/species/proc/get_blood_decl(var/mob/living/human/H)
	if(istype(H) && H.isSynthetic())
		return GET_DECL(/decl/blood_type/coolant)
	return get_blood_type_by_name(blood_types[1])

/decl/species/proc/get_blood_name(var/mob/living/human/H)
	var/decl/blood_type/blood = get_blood_decl(H)
	return istype(blood) ? blood.splatter_name : "blood"

/decl/species/proc/get_species_blood_color(var/mob/living/human/H)
	var/decl/blood_type/blood = get_blood_decl(H)
	return istype(blood) ? blood.splatter_colour : COLOR_BLOOD_HUMAN

// Impliments different trails for species depending on if they're wearing shoes.
/decl/species/proc/get_move_trail(var/mob/living/human/H)
	if(H.current_posture.prone)
		return /obj/effect/decal/cleanable/blood/tracks/body
	var/obj/item/clothing/suit = H.get_equipped_item(slot_wear_suit_str)
	if(istype(suit) && (suit.body_parts_covered & SLOT_FEET))
		return suit.move_trail
	var/obj/item/clothing/shoes = H.get_equipped_item(slot_shoes_str)
	if(istype(shoes))
		return shoes.move_trail
	return move_trail

/decl/species/proc/handle_trail(var/mob/living/human/H, var/turf/T)
	return

/decl/species/proc/update_skin(var/mob/living/human/H)
	return

/decl/species/proc/disarm_attackhand(var/mob/living/human/attacker, var/mob/living/human/target)
	attacker.do_attack_animation(target)

	var/obj/item/uniform = target.get_equipped_item(slot_w_uniform_str)
	if(uniform)
		uniform.add_fingerprint(attacker)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, ran_zone(attacker.get_target_zone(), target = target))

	var/list/holding = list(target.get_active_held_item() = 60)
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

/decl/species/proc/disfigure_msg(var/mob/living/human/H) //Used for determining the message a disfigured face has on examine. To add a unique message, just add this onto a specific species and change the "return" message.
	var/decl/pronouns/G = H.get_pronouns()
	return SPAN_DANGER("[G.His] face is horribly mangled!\n")

/decl/species/proc/get_available_accessories(var/decl/bodytype/bodytype, accessory_category)
	. = list()
	for(var/accessory in get_available_accessory_types(bodytype, accessory_category))
		. += GET_DECL(accessory)

/decl/species/proc/get_available_accessory_types(decl/bodytype/bodytype, accessory_category)
	if(!bodytype)
		bodytype = default_bodytype
	var/list/available_accessories = accessory_styles?[bodytype.type]?[accessory_category]
	if(!available_accessories)
		available_accessories = list()
		LAZYINITLIST(accessory_styles)
		LAZYSET(accessory_styles[bodytype.type], accessory_category, available_accessories)
		var/decl/sprite_accessory_category/accessory_category_decl = GET_DECL(accessory_category)
		var/list/all_accessories = decls_repository.get_decls_of_subtype(accessory_category_decl.base_accessory_type)
		for(var/accessory_style in all_accessories)
			var/decl/sprite_accessory/check_accessory = all_accessories[accessory_style]
			if(!check_accessory || !check_accessory.accessory_is_available(null, src, bodytype, FALSE))
				continue
			ADD_SORTED(available_accessories, accessory_style, /proc/cmp_text_asc)
			available_accessories[accessory_style] = check_accessory
	return available_accessories

/decl/species/proc/skills_from_age(age)	//Converts an age into a skill point allocation modifier. Can be used to give skill point bonuses/penalities not depending on job.
	switch(age)
		if(0 to 22) 	. = -4
		if(23 to 30) 	. = 0
		if(31 to 45)	. = 4
		else			. = 8

/decl/species/proc/check_no_slip(var/mob/living/human/H)
	if(can_overcome_gravity(H))
		return TRUE
	return (species_flags & SPECIES_FLAG_NO_SLIP)

// This assumes you've already checked that their bodytype can feel pain.
/decl/species/proc/get_pain_emote(var/mob/living/human/H, var/pain_power)
	for(var/pain_emotes in pain_emotes_with_pain_level)
		var/pain_level = pain_emotes_with_pain_level[pain_emotes]
		if(pain_level >= pain_power)
			// This assumes that if a pain-level has been defined it also has a list of emotes to go with it
			return pick(pain_emotes)

/decl/species/proc/handle_post_move(var/mob/living/human/H)
	handle_exertion(H)

/decl/species/proc/handle_exertion(mob/living/human/H)
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

/decl/species/proc/get_holder_color(var/mob/living/human/H)
	return

//Called after a mob's species is set, organs were created, and we're about to update the icon, color, and etc of the mob being created.
//Consider this might be called post-init
/decl/species/proc/apply_appearance(var/mob/living/human/H)
	H.icon_state = lowertext(src.name)

/decl/species/proc/get_preview_icon()
	if(!preview_icon)

		// TODO: generate an icon based on all available bodytypes.

		var/mob/living/human/dummy/mannequin/mannequin = get_mannequin("#species_[ckey(name)]")
		if(mannequin)

			mannequin.change_species(name) // handles species/bodytype init
			default_bodytype.customize_preview_mannequin(mannequin) // handles body colors/styles setup
			customize_preview_mannequin(mannequin) // handles 'cultural' things like default outfit

			preview_icon = icon(mannequin?.get_bodytype().icon_template)
			var/mob_width = preview_icon.Width()
			preview_icon.Scale((mob_width * 2)+16, preview_icon.Height()+16)

			preview_icon.Blend(getFlatIcon(mannequin, defdir = SOUTH, always_use_defdir = TRUE), ICON_OVERLAY, 8, 8)
			preview_icon.Blend(getFlatIcon(mannequin, defdir = WEST,  always_use_defdir = TRUE), ICON_OVERLAY, mob_width+8, 8)

			preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2)
			preview_icon_width = preview_icon.Width()
			preview_icon_height = preview_icon.Height()
			preview_icon_path = "species_preview_[ckey(name)].png"

	return preview_icon

/decl/species/proc/handle_movement_flags_setup(var/mob/living/human/H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/decl/species/proc/modify_preview_appearance(mob/living/human/dummy/mannequin)
	return mannequin
