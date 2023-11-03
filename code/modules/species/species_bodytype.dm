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

	// Used for initializing prefs/preview
	var/base_color =      COLOR_BLACK
	var/base_eye_color =  COLOR_BLACK
	var/base_hair_color = COLOR_BLACK

	/// Used to initialize organ material
	var/material =        /decl/material/solid/organic/meat
	/// Used to initialize organ matter
	var/list/matter =     null
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

	/// Losing an organ from this list will give a grace period of `vital_organ_failure_death_delay` then kill the mob.
	var/list/vital_organs = list(BP_BRAIN)
	/// The grace period before mob death when an organ in `vital_organs` is lost
	var/vital_organ_failure_death_delay = 25 SECONDS
	var/mob_size = MOB_SIZE_MEDIUM

	var/default_h_style = /decl/sprite_accessory/hair/bald
	var/default_f_style = /decl/sprite_accessory/facial_hair/shaved

	var/list/base_markings

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

/decl/bodytype/Initialize()
	. = ..()
	icon_deformed ||= icon_base

	LAZYDISTINCTADD(global.bodytypes_by_category[bodytype_category], src)
	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES
	//If the species has lungs, they are the default breathing organ
	if(!breathing_organ && has_organ[BP_LUNGS])
		breathing_organ = BP_LUNGS

	if(config.grant_default_darksight)
		eye_darksight_range = max(eye_darksight_range, config.default_darksight_range)
		eye_low_light_vision_effectiveness = max(eye_low_light_vision_effectiveness, config.default_darksight_effectiveness)

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

/decl/bodytype/proc/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	return applying

/decl/bodytype/proc/check_dismember_type_override(var/disintegrate)
	return disintegrate

/decl/bodytype/proc/get_hug_zone_messages(var/zone)
	return LAZYACCESS(hug_messages, zone)

/decl/bodytype/validate()
	. = ..()

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
	if(isnull(default_h_style))
		. += "null default_h_style (use a bald/hairless hairstyle if 'no hair' is intended)"
	if(isnull(default_f_style))
		. += "null default_f_style (use a shaved/hairless facial hair style if 'no facial hair' is intended)"

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
/decl/bodytype/proc/create_missing_organs(mob/living/carbon/human/H, fully_replace = FALSE)
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
		var/obj/item/organ/external/E = new limb_path(H, null, H.dna, src) //explicitly specify the dna and bodytype
		if(E.parent_organ)
			var/list/parent_organ_data = has_limbs[E.parent_organ]
			parent_organ_data["has_children"]++
		H.add_organ(E, GET_EXTERNAL_ORGAN(H, E.parent_organ), FALSE, FALSE)

	//Create missing internal organs
	for(var/organ_tag in has_organ)
		if(GET_INTERNAL_ORGAN(H, organ_tag)) //Skip existing
			continue
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H, null, H.dna, src)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.add_organ(O, GET_EXTERNAL_ORGAN(H, O.parent_organ), FALSE, FALSE)

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

/decl/bodytype/proc/check_vital_organ_missing(mob/living/carbon/H)
	if(length(vital_organs))
		for(var/organ_tag in vital_organs)
			var/obj/item/organ/O = H.get_organ(organ_tag, /obj/item/organ)
			if(!O || (O.status & ORGAN_DEAD))
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

/decl/bodytype/proc/set_default_hair(mob/living/carbon/human/organism, override_existing = TRUE, defer_update_hair = FALSE)
	if(!organism.h_style || (override_existing && (organism.h_style != default_h_style)))
		organism.h_style = default_h_style
		. = TRUE
	if(!organism.h_style || (override_existing && (organism.f_style != default_f_style)))
		organism.f_style = default_f_style
		. = TRUE
	if(. && !defer_update_hair)
		organism.update_hair()

/decl/bodytype/proc/customize_preview_mannequin(mob/living/carbon/human/dummy/mannequin/mannequin)
	if(length(base_markings))
		for(var/mark_type in base_markings)
			var/decl/sprite_accessory/marking/mark_decl = GET_DECL(mark_type)
			for(var/bodypart in mark_decl.body_parts)
				var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(mannequin, bodypart)
				if(O && !LAZYACCESS(O.markings, mark_type))
					LAZYSET(O.markings, mark_type, base_markings[mark_type])

	for(var/obj/item/organ/external/E in mannequin.get_external_organs())
		E.skin_colour = base_color

	mannequin.eye_colour = base_eye_color
	mannequin.hair_colour = base_hair_color
	mannequin.facial_hair_colour = base_hair_color
	set_default_hair(mannequin)

	mannequin.force_update_limbs()
	mannequin.update_mutations(0)
	mannequin.update_body(0)
	mannequin.update_underwear(0)
	mannequin.update_hair(0)
	mannequin.update_icon()

/decl/species/proc/customize_preview_mannequin(mob/living/carbon/human/dummy/mannequin/mannequin)
	if(preview_outfit)
		var/decl/hierarchy/outfit/outfit = outfit_by_type(preview_outfit)
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
	for(var/organ_tag in replacing_organs)
		var/organ_type = replacing_organs[organ_tag]
		var/obj/item/organ/internal/new_innard = new organ_type(limb.owner, null, limb.owner.dna, src)
		limb.owner.add_organ(new_innard, GET_EXTERNAL_ORGAN(limb.owner, new_innard.parent_organ), FALSE, FALSE)
