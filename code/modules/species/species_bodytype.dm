var/global/list/bodytypes_by_category = list()

/decl/bodytype
	decl_flags = DECL_FLAG_MANDATORY_UID
	abstract_type = /decl/bodytype
	/// Name used in general.
	var/name = "default"
	/// Name used in preference bodytype selection. Defaults to name.
	var/pref_name
	/// Seen when examining a prosthetic limb, if non-null.
	var/desc
	var/icon_base
	var/icon_deformed
	var/cosmetics_icon
	var/bandages_icon
	var/bodytype_flag = BODY_FLAG_HUMANOID
	var/bodytype_category = BODYTYPE_OTHER
	var/limb_icon_intensity = 1.5
	var/blood_overlays
	var/vulnerable_location = BP_GROIN //organ tag that can be kicked for increased pain, previously `sexybits_location`.
	var/limb_blend = ICON_ADD
	var/damage_overlays = 'icons/mob/human_races/species/default_damage_overlays.dmi'
	var/husk_icon =       'icons/mob/human_races/species/default_husk.dmi'
	var/skeletal_icon =   'icons/mob/human_races/species/human/skeleton.dmi'
	var/icon_template =   'icons/mob/human_races/species/template.dmi' // Used for mob icon generation for non-32x32 species.
	var/ignited_icon =    'icons/mob/OnFire.dmi'
	var/associated_gender
	var/appearance_flags = 0 // Appearance/display related features.

	/// Used when filing your nails.
	var/nail_noun
	/// What tech levels should limbs of this type use/need?
	var/limb_tech = @'{"biotech":2}'
	var/icon_cache_uid
	/// Determines if eyes should render on heads using this bodytype.
	var/has_eyes = TRUE
	/// Prefixed to the initial name of the limb, if non-null.
	var/modifier_string
	/// Modifies min and max broken damage for the limb.
	var/hardiness = 1
	/// Applies a slowdown value to this limb.
	var/movement_slowdown = 0
	/// Determines if this bodytype can be repaired by nanopaste, sparks when damaged, can malfunction, and can take EMP damage.
	var/is_robotic = FALSE
	/// For hands, determines the dexterity value passed to get_manual_dexterity(). If null, defers to species.
	var/manual_dexterity = null
	/// Determines how the limb behaves with regards to manual attachment/detachment.
	var/modular_limb_tier = MODULAR_BODYPART_INVALID
	// Expected organ types per category, used only for stance checking at time of writing.
	var/list/organs_by_category = list()
	// Expected organ tags per category, used only for stance checking at time of writing.
	var/list/organ_tags_by_category = list()

	var/list/onmob_state_modifiers
	var/health_hud_intensity = 1

	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.
	var/pixel_offset_z = 0                    // Used for offsetting large icons.

	var/antaghud_offset_x = 0                 // As above, but specifically for the antagHUD indicator.
	var/antaghud_offset_y = 0                 // As above, but specifically for the antagHUD indicator.

	var/eye_offset = 0                        // Amount to shift eyes on the Y axis to correct for non-32px height.

	var/z_flags = 0

	var/list/prone_overlay_offset = list(0, 0) // amount to shift overlays when lying

	// Per-bodytype per-zone message strings, see /mob/proc/get_hug_zone_messages
	var/list/default_hug_message
	var/list/hug_messages = list(
		BP_L_HAND = list(
			"$USER$ shakes $TARGET$'s hand.",
			"You shake $TARGET$'s hand."
		),
		BP_R_HAND = list(
			"$USER$ shakes $TARGET$'s hand.",
			"You shake $TARGET$'s hand."
		),
		BP_L_ARM = list(
			"$USER$ pats $TARGET$ on the shoulder.",
			"You pat $TARGET$ on the shoulder."
		),
		BP_R_ARM = list(
			"$USER$ pats $TARGET$ on the shoulder.",
			"You pat $TARGET$ on the shoulder."
		)
	)

	var/list/override_emote_sounds = list(
		"cough" = list(
			'sound/voice/emotes/f_cougha.ogg',
			'sound/voice/emotes/f_coughb.ogg'
		),
		"sneeze" = list(
			'sound/voice/emotes/f_sneeze.ogg'
		)
	)
	var/list/emote_sounds = list(
		"whistle"  = list('sound/voice/emotes/longwhistle.ogg'),
		"qwhistle" = list('sound/voice/emotes/shortwhistle.ogg'),
		"wwhistle" = list('sound/voice/emotes/wolfwhistle.ogg'),
		"swhistle" = list('sound/voice/emotes/summon_whistle.ogg')
	)
	var/list/broadcast_emote_sounds = list(
		"swhistle" = list('sound/voice/emotes/summon_whistle.ogg')
	)
	var/list/bodyfall_sounds = list(
		'sound/foley/meat1.ogg',
		'sound/foley/meat2.ogg'
	)

	// Used for initializing prefs/preview
	var/base_color =      COLOR_BLACK
	var/base_eye_color =  COLOR_BLACK

	/// Used to initialize organ material
	var/material =        /decl/material/solid/organic/meat
	/// Used to initialize organ matter
	var/list/matter =     null
	/// The reagent organs are filled with, which currently affects what mobs that eat the organ will receive.
	/// TODO: Remove this in a later matter edibility refactor.
	var/edible_reagent =  /decl/material/solid/organic/meat
	/// A bitfield representing various bodytype-specific features.
	var/body_flags = 0
	/// Used to modify the arterial_bleed_severity of organs.
	var/arterial_bleed_multiplier = 1
	/// Associative list of organ_tag = "encased value". If set, sets the organ's encased var to the corresponding value; used in surgery.
	/// If the list is set, organ tags not present in the list will get encased set to null.
	var/list/apply_encased
	/// Associative list of organ_tag = organ_data.
	/// Organ data currently supports setting "path" and "descriptor", while "has_children" is automatically set.
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
	/// An associative list of target zones (ex. BP_CHEST, BP_MOUTH) mapped to all possible keys associated
	/// with the zone. Used for species with body layouts that do not map directly to a standard humanoid body.
	var/list/limb_mapping
	/// This list is merged into has_limbs in bodytype initialization.
	/// Used for species that only need to change one or two entries in has_limbs.
	var/list/override_limb_types
	/// Associative list of organ tags (ex. BP_HEART) to paths.
	/// Used to initialize organs and to check if a bodytype 'should have' (this can mean 'can have' or 'needs') an organ.
	var/list/has_organ = list(
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

	var/age_descriptor = /datum/appearance_descriptor/age
	var/list/appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1,
		/datum/appearance_descriptor/build =  1
	)

	/// Losing an organ from this list will give a grace period of `vital_organ_failure_death_delay` then kill the mob.
	var/list/vital_organs = list(BP_BRAIN)
	/// The grace period before mob death when an organ in `vital_organs` is lost
	var/vital_organ_failure_death_delay = 25 SECONDS
	var/mob_size = MOB_SIZE_MEDIUM

	var/list/default_sprite_accessories

	// Darksight handling
	/// Fractional multiplier (0 to 1) for the base alpha of the darkness overlay. A value of 1 means darkness is completely invisible.
	var/eye_base_low_light_vision = 0
	/// The lumcount (turf luminosity) threshold under which adaptive low light vision will begin processing.
	var/eye_low_light_vision_threshold = 0.3
	/// Fractional multiplier for the overall effectiveness of low light vision for this species. Caps the final alpha value of the darkness plane.
	var/eye_low_light_vision_effectiveness = 0
	/// The rate at which low light vision adjusts towards the final value, as a fractional multiplier of the difference between the current and target alphas. ie. set to 0.15 for a 15% shift towards the target value each tick.
	var/eye_low_light_vision_adjustment_speed = 0.15

	// Other eye vars.
	var/eye_contaminant_guard = 0
	var/eye_innate_flash_protection = FLASH_PROTECTION_NONE
	var/eye_icon = 'icons/mob/human_races/species/default_eyes.dmi'
	var/apply_eye_colour = TRUE
	var/eye_darksight_range = 2
	var/eye_blend = ICON_ADD
	/// Stun from blindness modifier.
	var/eye_flash_mod = 1

	// Bodytype temperature damage thresholds.
	var/cold_level_1 = 243  // Cold damage level 1 below this point. -30 Celsium degrees
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.
	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 3 above this point.

	// Temperature comfort levels and strings.
	var/heat_discomfort_level = 315
	var/cold_discomfort_level = 285
	/// Aesthetic messages about feeling warm.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
	)
	/// Aesthetic messages about feeling chilly.
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
	)

	/// Add emotes to this list to remove them from defaults (ie. blinking for a species with no eyes)
	var/list/removed_emotes
	/// Add emotes to this list to add them to the defaults (ie. a humanoid species that also has a purr)
	var/list/additional_emotes
	/// Generalized emote list available to mobs with this bodytype.
	var/list/default_emotes = list(
		/decl/emote/visible/blink,
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny,
		/decl/emote/visible/nod,
		/decl/emote/visible/shake,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/audible/gasp,
		/decl/emote/audible/sneeze,
		/decl/emote/audible/sniff,
		/decl/emote/audible/snore,
		/decl/emote/audible/whimper,
		/decl/emote/audible/yawn,
		/decl/emote/audible/clap,
		/decl/emote/audible/chuckle,
		/decl/emote/audible/cough,
		/decl/emote/audible/cry,
		/decl/emote/audible/sigh,
		/decl/emote/audible/laugh,
		/decl/emote/audible/mumble,
		/decl/emote/audible/grumble,
		/decl/emote/audible/groan,
		/decl/emote/audible/moan,
		/decl/emote/audible/grunt,
		/decl/emote/audible/slap,
		/decl/emote/audible/deathgasp,
		/decl/emote/audible/giggle,
		/decl/emote/audible/scream,
		/decl/emote/visible/airguitar,
		/decl/emote/visible/blink_r,
		/decl/emote/visible/bow,
		/decl/emote/visible/salute,
		/decl/emote/visible/flap,
		/decl/emote/visible/aflap,
		/decl/emote/visible/drool,
		/decl/emote/visible/eyebrow,
		/decl/emote/visible/twitch,
		/decl/emote/visible/dance,
		/decl/emote/visible/twitch_v,
		/decl/emote/visible/faint,
		/decl/emote/visible/frown,
		/decl/emote/visible/blush,
		/decl/emote/visible/wave,
		/decl/emote/visible/glare,
		/decl/emote/visible/stare,
		/decl/emote/visible/look,
		/decl/emote/visible/point,
		/decl/emote/visible/raise,
		/decl/emote/visible/grin,
		/decl/emote/visible/shrug,
		/decl/emote/visible/smile,
		/decl/emote/visible/pale,
		/decl/emote/visible/tremble,
		/decl/emote/visible/wink,
		/decl/emote/visible/hug,
		/decl/emote/visible/dap,
		/decl/emote/visible/signal,
		/decl/emote/visible/handshake,
		/decl/emote/visible/afold,
		/decl/emote/visible/alook,
		/decl/emote/visible/eroll,
		/decl/emote/visible/hbow,
		/decl/emote/visible/hip,
		/decl/emote/visible/holdup,
		/decl/emote/visible/hshrug,
		/decl/emote/visible/crub,
		/decl/emote/visible/erub,
		/decl/emote/visible/fslap,
		/decl/emote/visible/ftap,
		/decl/emote/visible/hrub,
		/decl/emote/visible/hspread,
		/decl/emote/visible/pocket,
		/decl/emote/visible/rsalute,
		/decl/emote/visible/rshoulder,
		/decl/emote/visible/squint,
		/decl/emote/visible/tfist,
		/decl/emote/visible/tilt,
		/decl/emote/visible/spin,
		/decl/emote/visible/sidestep,
		/decl/emote/visible/vomit,
		/decl/emote/audible/whistle,
		/decl/emote/audible/whistle/quiet,
		/decl/emote/audible/whistle/wolf,
		/decl/emote/audible/whistle/summon
	)
	/// Set to FALSE if the mob will update prone icon based on state rather than transform.
	var/rotate_on_prone = TRUE

/decl/bodytype/Initialize()
	. = ..()
	icon_deformed ||= icon_base

	if(length(removed_emotes))
		LAZYREMOVE(default_emotes, removed_emotes)

	if(length(additional_emotes))
		LAZYDISTINCTADD(default_emotes, additional_emotes)

	if(length(override_emote_sounds))
		for(var/emote_cat in override_emote_sounds)
			emote_sounds[emote_cat] = override_emote_sounds[emote_cat]

	if(!pref_name)
		pref_name = name

	LAZYDISTINCTADD(global.bodytypes_by_category[bodytype_category], src)
	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES
	//If the species has lungs, they are the default breathing organ
	if(!breathing_organ && has_organ[BP_LUNGS])
		breathing_organ = BP_LUNGS

	if(get_config_value(/decl/config/toggle/grant_default_darksight))
		eye_darksight_range = max(eye_darksight_range, get_config_value(/decl/config/num/default_darksight_range))
		eye_low_light_vision_effectiveness = max(eye_low_light_vision_effectiveness, get_config_value(/decl/config/num/default_darksight_effectiveness))

	// Modify organ lists if necessary.
	if(islist(override_organ_types))
		for(var/ltag in override_organ_types)
			has_organ[ltag] = override_organ_types[ltag]

	if(islist(override_limb_types))
		for(var/ltag in override_limb_types)
			has_limbs[ltag] = list("path" = override_limb_types[ltag])

	//Build organ descriptors
	for(var/organ_tag in has_limbs)
		var/list/organ_data = has_limbs[organ_tag]
		var/obj/item/organ/organ = organ_data["path"]
		organ_data["descriptor"] = initial(organ.name)
		var/organ_cat = initial(organ.organ_category)
		if(organ_cat)
			LAZYADD(organs_by_category[organ_cat], organ)
			LAZYADD(organ_tags_by_category[organ_cat], organ_tag)

	for(var/organ_tag in has_organ)
		var/obj/item/organ/organ = has_organ[organ_tag]
		var/organ_cat = initial(organ.organ_category)
		if(organ_cat)
			LAZYADD(organs_by_category[organ_cat], organ)
			LAZYADD(organ_tags_by_category[organ_cat], organ_tag)

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

/decl/bodytype/proc/get_expected_organ_count_for_categories(var/list/categories)
	. = 0
	for(var/category in categories)
		if(category && (category in organs_by_category))
			. += length(organs_by_category[category])

/decl/bodytype/proc/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	return applying

/decl/bodytype/proc/check_dismember_type_override(var/disintegrate)
	return disintegrate

/decl/bodytype/proc/get_hug_zone_messages(var/zone)
	return LAZYACCESS(hug_messages, zone)

/decl/bodytype/validate()
	. = ..()

	// TODO: Maybe make age descriptors optional, in case someone wants a 'timeless entity' species?
	if(isnull(age_descriptor))
		. += "age descriptor was unset"
	else if(!ispath(age_descriptor, /datum/appearance_descriptor/age))
		. += "age descriptor was not a /datum/appearance_descriptor/age subtype"

	var/damage_icon = get_damage_overlays()
	if(damage_icon)
		for(var/brute = 0 to 3)
			for(var/burn = 0 to 3)
				var/damage_state = "[brute][burn]"
				if(!check_state_in_icon(damage_state, damage_icon))
					. += "missing state '[damage_state]' in icon '[damage_icon]'"
		if(!check_state_in_icon("", damage_icon))
			. += "missing default empty state in icon '[damage_icon]'"
	else
		. += "null damage overlay icon"

	if(eye_base_low_light_vision > 1)
		. += "base low light vision is greater than 1 (over 100%)"
	else if(eye_base_low_light_vision < 0)
		. += "base low light vision is less than 0 (below 0%)"

	if(eye_low_light_vision_threshold > 1)
		. += "low light vision threshold is greater than 1 (over 100%)"
	else if(eye_low_light_vision_threshold < 0)
		. += "low light vision threshold is less than 0 (below 0%)"

	if(eye_low_light_vision_effectiveness > 1)
		. += "low light vision effectiveness is greater than 1 (over 100%)"
	else if(eye_low_light_vision_effectiveness < 0)
		. += "low light vision effectiveness is less than 0 (below 0%)"

	if(eye_low_light_vision_adjustment_speed > 1)
		. += "low light vision adjustment speed is greater than 1 (over 100%)"
	else if(eye_low_light_vision_adjustment_speed < 0)
		. += "low light vision adjustment speed is less than 0 (below 0%)"

	if(icon_base || icon_deformed)

		var/list/limb_tags = list()
		for(var/limb in has_limbs)
			limb_tags |= limb
		for(var/limb in override_limb_types)
			limb_tags |= limb

		if(icon_base)
			if(check_state_in_icon("torso", icon_base))
				. += "deprecated \"torso\" state present in icon_base"
			for(var/limb in limb_tags)
				if(!check_state_in_icon(limb, icon_base))
					. += "missing required state in [icon_base]: [limb]"

		if(icon_deformed && icon_deformed != icon_base)
			if(check_state_in_icon("torso", icon_deformed))
				. += "deprecated \"torso\" state present in icon_deformed"
			for(var/limb in limb_tags)
				if(!check_state_in_icon(limb, icon_deformed))
					. += "missing required state in [icon_deformed]: [limb]"

	if((appearance_flags & HAS_SKIN_COLOR) && isnull(base_color))
		. += "uses skin color but missing base_color"
	if((appearance_flags & HAS_EYE_COLOR) && isnull(base_eye_color))
		. += "uses eye color but missing base_eye_color"

	for(var/accessory_category in default_sprite_accessories)
		var/decl/sprite_accessory_category/acc_cat = GET_DECL(accessory_category)
		if(!istype(acc_cat))
			. += "invalid sprite accessory category entry: [accessory_category || "null"]"
			continue
		var/accessories = default_sprite_accessories[accessory_category]
		for(var/accessory in accessories)
			var/decl/sprite_accessory/acc_decl = GET_DECL(accessory)
			if(!istype(acc_decl))
				. += "invalid sprite accessory in category [accessory_category]: [accessory || "null"]"
				continue
			if(acc_decl.accessory_category != acc_cat.type)
				. += "accessory category [acc_decl.accessory_category || "null"] does not match [acc_cat.type]"
			if(!istype(acc_decl, acc_cat.base_accessory_type))
				. += "accessory type [acc_decl.type] does not align with category base accessory: [acc_cat.base_accessory_type || "null"]"
			if(!islist(accessories[accessory]))
				. += "non-list default metadata for [acc_decl.type]: [accessories[accessory] || "NULL"]"

	var/list/tail_data = has_limbs[BP_TAIL]
	if(tail_data)
		var/obj/item/organ/external/tail/tail_organ = LAZYACCESS(tail_data, "path")
		if(ispath(tail_organ, /obj/item/organ/external/tail))
			var/decl/species/use_species = get_user_species_for_validation()
			if(use_species)
				var/datum/mob_snapshot/dummy_appearance = new
				dummy_appearance.root_species  = use_species
				dummy_appearance.root_bodytype = src
				tail_organ = new tail_organ(null, null, dummy_appearance)
				var/tail_icon  = tail_organ.get_tail_icon()
				var/tail_state = tail_organ.get_tail()
				if(tail_icon && tail_state)
					if(!check_state_in_icon(tail_state, tail_icon))
						. += "base tail state '[tail_state]' not present in icon '[tail_icon]'"
					var/tail_states = tail_organ.get_tail_animation_states()
					if(tail_states)
						var/static/list/animation_modifiers = list(
							"_idle",
							"_slow",
							"_loop",
							"_once"
						)
						for(var/modifier in animation_modifiers)
							var/modified_state = "[tail_state][modifier]"
							for(var/i = 1 to tail_states)
								if(!check_state_in_icon("[modified_state][i]", tail_icon))
									. += "animated tail state '[modified_state][i]' not present in icon '[tail_icon]'"
				else
					if(!tail_icon)
						. += "missing tail icon"
					if(!tail_state)
						. += "missing tail state"
				qdel(tail_organ)
				qdel(dummy_appearance)
			else
				. += "could not find a species with this bodytype available for tail organ validation"
		else
			. += "invalid BP_TAIL type: got [tail_organ], expected /obj/item/organ/external/tail"

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

/decl/bodytype/proc/max_skin_tone()
	if(appearance_flags & HAS_SKIN_TONE_GRAV)
		return 100
	if(appearance_flags & HAS_SKIN_TONE_SPCR)
		return 165
	if(appearance_flags & HAS_SKIN_TONE_TRITON)
		return 80
	return 220

/decl/bodytype/proc/apply_bodytype_organ_modifications(obj/item/organ/org)
	if(istype(org, /obj/item/organ/external))
		var/obj/item/organ/external/E = org
		E.arterial_bleed_severity *= arterial_bleed_multiplier
		if(islist(apply_encased))
			E.encased = apply_encased[E.organ_tag]

//fully_replace: If true, all existing organs will be discarded. Useful when doing mob transformations, and not caring about the existing organs
/decl/bodytype/proc/create_missing_organs(mob/living/human/H, fully_replace = FALSE)
	if(fully_replace)
		H.delete_organs()

	//Clear invalid limbs
	if(H.has_external_organs())
		for(var/obj/item/organ/external/E in H.get_external_organs())
			if(!is_default_limb(E))
				H.remove_organ(E, FALSE, FALSE, TRUE, TRUE, FALSE, skip_health_update = TRUE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(E)

	//Clear invalid internal organs
	if(H.has_internal_organs())
		for(var/obj/item/organ/O in H.get_internal_organs())
			if(!is_default_organ(O))
				H.remove_organ(O, FALSE, FALSE, TRUE, TRUE, FALSE, skip_health_update = TRUE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(O)

	//Create missing limbs
	var/datum/mob_snapshot/supplied_data = H.get_mob_snapshot(force = TRUE)
	supplied_data.root_bodytype = src // This may not have been set on the target mob torso yet.

	for(var/limb_type in has_limbs)
		if(GET_EXTERNAL_ORGAN(H, limb_type)) //Skip existing
			continue
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/external/E = new limb_path(H, null, supplied_data) //explicitly specify the dna and bodytype
		if(E.parent_organ)
			var/list/parent_organ_data = has_limbs[E.parent_organ]
			parent_organ_data["has_children"]++
		H.add_organ(E, GET_EXTERNAL_ORGAN(H, E.parent_organ), FALSE, FALSE, skip_health_update = TRUE)

	//Create missing internal organs
	for(var/organ_tag in has_organ)
		if(GET_INTERNAL_ORGAN(H, organ_tag)) //Skip existing
			continue
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H, null, supplied_data)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.add_organ(O, GET_EXTERNAL_ORGAN(H, O.parent_organ), FALSE, FALSE, skip_health_update = TRUE)
	H.update_health()

//Checks if an existing organ is the bodytype default
/decl/bodytype/proc/is_default_organ(obj/item/organ/internal/O)
	return has_organ[O.organ_tag] && istype(O, has_organ[O.organ_tag]) && (O.bodytype == src)

//Checks if an existing limb is the bodytype default
/decl/bodytype/proc/is_default_limb(obj/item/organ/external/E)
	var/list/organ_data = has_limbs[E.organ_tag]
	if(organ_data && istype(E, organ_data["path"]) && (E.bodytype == src))
		return TRUE
	return FALSE

/decl/bodytype/proc/get_limb_from_zone(limb)
	. = length(LAZYACCESS(limb_mapping, limb)) ? pick(limb_mapping[limb]) : limb

/decl/bodytype/proc/check_vital_organ_missing(mob/living/patient)
	if(length(vital_organs))
		for(var/organ_tag in vital_organs)
			var/obj/item/organ/vital_organ = patient.get_organ(organ_tag, /obj/item/organ)
			if(!vital_organ || (vital_organ.status & ORGAN_DEAD))
				return TRUE
	return FALSE

/decl/bodytype/proc/get_resized_organ_w_class(var/organ_w_class)
	. = clamp(organ_w_class + mob_size_difference(mob_size, MOB_SIZE_MEDIUM), ITEM_SIZE_TINY, ITEM_SIZE_GARGANTUAN)

/decl/bodytype/proc/resize_organ(obj/item/organ/organ)
	if(!istype(organ))
		return
	organ.w_class = get_resized_organ_w_class(initial(organ.w_class))
	if(!istype(organ, /obj/item/organ/external))
		return
	var/obj/item/organ/external/limb = organ
	for(var/bp_tag in has_organ)
		var/obj/item/organ/internal/I = has_organ[bp_tag]
		if(initial(I.parent_organ) == organ.organ_tag)
			limb.cavity_max_w_class = max(limb.cavity_max_w_class, get_resized_organ_w_class(initial(I.w_class)))

/decl/bodytype/proc/set_default_sprite_accessories(var/mob/living/setting)
	if(!istype(setting))
		return
	for(var/obj/item/organ/external/E in setting.get_external_organs())
		E.skin_colour = base_color
		E.clear_sprite_accessories(skip_update = TRUE)
	if(!length(default_sprite_accessories))
		return
	for(var/accessory_category in default_sprite_accessories)
		for(var/accessory in default_sprite_accessories[accessory_category])
			var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
			var/accessory_metadata = default_sprite_accessories[accessory_category][accessory]
			for(var/bodypart in accessory_decl.body_parts)
				var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(setting, bodypart)
				if(O)
					O.set_sprite_accessory(accessory, null, accessory_metadata, skip_update = TRUE)

/decl/bodytype/proc/customize_preview_mannequin(mob/living/human/dummy/mannequin/mannequin)
	set_default_sprite_accessories(mannequin)
	mannequin.set_eye_colour(base_eye_color, skip_update = TRUE)
	mannequin.force_update_limbs()
	mannequin.update_genetic_conditions(0)
	mannequin.update_body(0)
	mannequin.update_underwear(0)
	mannequin.update_hair(0)
	mannequin.update_icon()

/decl/species/proc/customize_preview_mannequin(mob/living/human/dummy/mannequin/mannequin)
	if(preview_outfit)
		var/decl/outfit/outfit = GET_DECL(preview_outfit)
		outfit.equip_outfit(mannequin, equip_adjustments = (OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR|OUTFIT_ADJUSTMENT_SKIP_BACKPACK))
		mannequin.update_icon()
	mannequin.update_transform()

/decl/bodytype/proc/rebuild_internal_organs(var/obj/item/organ/external/limb, var/override_material)

	if(!limb.owner)
		return

	// Work out what we want to have in this organ.
	var/list/replacing_organs = list()
	for(var/organ_tag in has_organ)
		var/obj/item/organ/internal/organ_prototype = has_organ[organ_tag]
		if(initial(organ_prototype.parent_organ) == limb.organ_tag)
			replacing_organs[organ_tag] = organ_prototype

	// No organs, just delete everything.
	if(!length(replacing_organs))
		for(var/obj/item/organ/internal/innard in limb.internal_organs)
			limb.owner.remove_organ(innard, FALSE, FALSE, TRUE, TRUE, FALSE)
			qdel(innard)
		return

	// Check what we already have that matches.
	for(var/obj/item/organ/internal/innard in limb.internal_organs)
		var/obj/item/organ/internal/organ_prototype = replacing_organs[innard.organ_tag]
		if(organ_prototype && istype(innard, organ_prototype))
			innard.set_bodytype(type, override_material || material)
			replacing_organs -= innard.organ_tag
		else
			limb.owner.remove_organ(innard, FALSE, FALSE, TRUE, TRUE, FALSE)
			qdel(innard)

	// Install any necessary new organs.
	var/datum/mob_snapshot/supplied_data = limb.owner.get_mob_snapshot(force = TRUE)
	supplied_data.root_bodytype = src
	for(var/organ_tag in replacing_organs)
		var/organ_type = replacing_organs[organ_tag]
		var/obj/item/organ/internal/new_innard = new organ_type(limb.owner, null, supplied_data)
		limb.owner.add_organ(new_innard, GET_EXTERNAL_ORGAN(limb.owner, new_innard.parent_organ), FALSE, FALSE)

/decl/bodytype/proc/get_body_temperature_threshold(var/threshold)
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

/decl/bodytype/proc/get_environment_discomfort(var/mob/living/human/H, var/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	var/held_items = H.get_held_items()
	for(var/obj/item/clothing/clothes in H)
		if(clothes in held_items)
			continue
		if((clothes.body_parts_covered & SLOT_UPPER_BODY) && (clothes.body_parts_covered & SLOT_LOWER_BODY))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered && length(cold_discomfort_strings))
				to_chat(H, SPAN_DANGER(pick(cold_discomfort_strings)))
		if("heat")
			if(covered && length(heat_discomfort_strings))
				to_chat(H, SPAN_DANGER(pick(heat_discomfort_strings)))

/decl/bodytype/proc/get_user_species_for_validation()
	for(var/species_name in get_all_species())
		var/decl/species/species = get_species_by_key(species_name)
		if(src in species.available_bodytypes)
			return species

// Defined as a global so modpacks can add to it.
var/global/list/limbs_with_nails = list(
	BP_L_HAND,
	BP_R_HAND,
	BP_M_HAND,
	BP_L_FOOT,
	BP_R_FOOT
)

/decl/bodytype/proc/get_default_grooming_results(obj/item/organ/external/limb, obj/item/grooming/tool)
	if(nail_noun && (tool.grooming_flags & GROOMABLE_FILE) && (limb?.organ_tag in limbs_with_nails))
		return list(
			"success"    = GROOMING_RESULT_SUCCESS,
			"descriptor" = nail_noun
		)
	return null

/decl/bodytype/proc/get_movement_slowdown(var/mob/living/human/H)
	return movement_slowdown
