var/global/list/bodytypes_by_category = list()

/decl/bodytype
	var/name = "default"
	/// Seen when examining a prosthetic limb, if non-null.
	var/desc
	var/icon_base
	var/icon_deformed
	var/lip_icon
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

	/// What tech levels should limbs of this type use/need?
	var/limb_tech = "{'biotech':2}"
	var/icon_cache_uid
	/// Determines if eyes should render on heads using this bodytype.
	var/has_eyes = TRUE
	/// Determines if heads with this bodytype can ingest food/drink.
	var/can_eat = TRUE
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
	/// Modifies the return from human can_feel_pain().
	var/can_feel_pain = TRUE

	var/uniform_state_modifier
	var/health_hud_intensity = 1

	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.
	var/pixel_offset_z = 0                    // Used for offsetting large icons.

	var/antaghud_offset_x = 0                 // As above, but specifically for the antagHUD indicator.
	var/antaghud_offset_y = 0                 // As above, but specifically for the antagHUD indicator.

	var/eye_offset = 0                        // Amount to shift eyes on the Y axis to correct for non-32px height.

	var/list/prone_overlay_offset = list(0, 0) // amount to shift overlays when lying

	// Per-bodytype per-zone message strings, see /mob/proc/get_hug_zone_messages
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

	var/list/bodyfall_sounds = list(
		'sound/foley/meat1.ogg',
		'sound/foley/meat2.ogg'
	)

	var/list/synthetic_bodyfall_sounds = list(
		'sound/foley/metal1.ogg'
	)

	// Used for initializing prefs/preview
	var/base_color =      COLOR_BLACK
	var/base_eye_color =  COLOR_BLACK
	var/base_hair_color = COLOR_BLACK

	/// Used to initialize organ material
	var/material =        /decl/material/solid/meat
	/// Used to initialize organ matter
	var/matter =          null
	/// The reagent organs are filled with, which currently affects what mobs that eat the organ will receive.
	/// TODO: Remove this in a later matter edibility refactor.
	var/edible_reagent =  /decl/material/liquid/nutriment/protein
	/// A bitfield representing various bodytype-specific features.
	var/body_flags = 0
	/// Used to modify the arterial_bleed_severity of organs.
	var/arterial_bleed_multiplier = 1
	/// Associative list of organ_tag = "encased value". If set, sets the organ's encased var to the corresponding value; used in surgery.
	/// If the list is set, organ tags not present in the list will get encased set to null.
	var/list/apply_encased

/decl/bodytype/Initialize()
	. = ..()
	if(!icon_deformed)
		icon_deformed = icon_base
	LAZYDISTINCTADD(global.bodytypes_by_category[bodytype_category], src)

/decl/bodytype/proc/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	return applying

/decl/bodytype/proc/check_dismember_type_override(var/disintegrate)
	return disintegrate

/decl/bodytype/proc/get_hug_zone_messages(var/zone)
	return LAZYACCESS(hug_messages, zone)

/decl/bodytype/validate()
	. = ..()
	if(icon_base)
		if(check_state_in_icon("torso", icon_base))
			. += "deprecated \"torso\" state present in icon_base"
		if(!check_state_in_icon(BP_CHEST, icon_base))
			. += "\"[BP_CHEST]\" state not present in icon_base"
	if(icon_deformed && icon_deformed != icon_base)
		if(check_state_in_icon("torso", icon_deformed))
			. += "deprecated \"torso\" state present in icon_deformed"
		if(!check_state_in_icon(BP_CHEST, icon_deformed))
			. += "\"[BP_CHEST]\" state not present in icon_deformed"
	if((appearance_flags & HAS_SKIN_COLOR) && isnull(base_color))
		. += "uses skin color but missing base_color"
	if((appearance_flags & HAS_HAIR_COLOR) && isnull(base_hair_color))
		. += "uses hair color but missing base_hair_color"
	if((appearance_flags & HAS_EYE_COLOR) && isnull(base_eye_color))
		. += "uses eye color but missing base_eye_color"

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