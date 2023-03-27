var/global/list/bodytypes_by_category = list()

/decl/bodytype
	var/name = "default"
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
	var/icon_cache_uid

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
			. += "torso state present in icon_base"
		if(!check_state_in_icon(BP_CHEST, icon_base))
			. += "chest state not present in icon_base"
	if(icon_deformed && icon_deformed != icon_base)
		if(check_state_in_icon("torso", icon_deformed))
			. += "torso state present in icon_deformed"
		if(!check_state_in_icon(BP_CHEST, icon_deformed))
			. += "chest state not present in icon_deformed"
