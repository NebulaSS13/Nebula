var/global/list/bodytypes_by_category = list()

/decl/bodytype
	var/name = "default"
	var/prosthetic_limb_desc = "It's some kind of generic limb."
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
	var/max_skin_tone = 220
	var/body_appearance_flags = 0      // Appearance/display related features.
	var/body_flags = BODY_FLAG_CAN_INGEST_REAGENTS

	var/manual_dexterity = DEXTERITY_FULL

	var/uniform_state_modifier
	var/health_hud_intensity = 1

	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.
	var/pixel_offset_z = 0                    // Used for offsetting large icons.

	var/antaghud_offset_x = 0                 // As above, but specifically for the antagHUD indicator.
	var/antaghud_offset_y = 0                 // As above, but specifically for the antagHUD indicator.

	var/limb_tech = "{'biotech':1}" // What tech levels should limbs of this type use/need?

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

	// Order matters, higher pain level should be higher up
	var/list/pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 10,
	)
	var/is_robotic = FALSE

/decl/bodytype/Initialize()
	. = ..()

	if(is_abstract())
		return

	if(!icon_deformed)
		icon_deformed = icon_base

	LAZYDISTINCTADD(global.bodytypes_by_category[bodytype_category], src)
	setup_organs()

/decl/bodytype/proc/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	return applying

/decl/bodytype/proc/check_dismember_type_override(var/disintegrate)
	return disintegrate

/decl/bodytype/proc/get_hug_zone_messages(var/zone)
	return LAZYACCESS(hug_messages, zone)

/decl/bodytype/proc/get_manual_dexterity(var/mob/living/carbon/human/H)
	. = manual_dexterity

/decl/bodytype/proc/get_pain_emote(var/mob/living/carbon/human/H, var/pain_power)
	if(!(body_flags & BODY_FLAG_NO_PAIN))
		return
	for(var/pain_emotes in pain_emotes_with_pain_level)
		var/pain_level = pain_emotes_with_pain_level[pain_emotes]
		if(pain_level >= pain_power)
			// This assumes that if a pain-level has been defined it also has a list of emotes to go with it
			var/decl/emote/E = GET_DECL(pick(pain_emotes))
			return E.key
