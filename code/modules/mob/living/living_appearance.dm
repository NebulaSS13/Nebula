/mob/living
	var/list/mob_overlays[TOTAL_OVER_LAYERS]
	var/list/mob_underlays[TOTAL_UNDER_LAYERS]

/mob/living/update_icon()
	..()
	compile_overlays()

/mob/living/on_update_icon()
	SHOULD_CALL_PARENT(TRUE)
	..()
	cut_overlays()
	try_refresh_visible_overlays()

/mob/living/proc/set_organ_sprite_accessory(var/accessory_type, var/accessory_category, var/accessory_metadata, var/organ_tag, var/skip_update = FALSE)
	if(!accessory_category || !organ_tag)
		return
	var/obj/item/organ/external/organ = organ_tag && GET_EXTERNAL_ORGAN(src, organ_tag)
	if(!organ)
		return
	if(!accessory_type)
		accessory_type = organ.get_sprite_accessory_by_category(accessory_category)
	if(accessory_type)
		return organ.set_sprite_accessory(accessory_type, accessory_category, accessory_metadata, skip_update)

/mob/living/proc/get_organ_sprite_accessory_metadata(var/accessory_type, var/organ_tag, var/metadata_tag)
	var/obj/item/organ/external/organ = organ_tag && GET_EXTERNAL_ORGAN(src, organ_tag)
	return organ?.get_sprite_accessory_metadata(accessory_type, metadata_tag)

/mob/living/proc/get_organ_sprite_accessory_by_category(var/accessory_category, var/organ_tag)
	var/obj/item/organ/external/organ = organ_tag && GET_EXTERNAL_ORGAN(src, organ_tag)
	return organ?.get_sprite_accessory_by_category(accessory_category)

/mob/living/proc/set_organ_sprite_accessory_by_category(var/accessory_type, var/accessory_category, var/accessory_metadata, var/preserve_colour = TRUE, var/preserve_type = TRUE, var/organ_tag, var/skip_update = FALSE)
	var/obj/item/organ/external/organ = organ_tag && GET_EXTERNAL_ORGAN(src, organ_tag)
	return organ?.set_sprite_accessory_by_category(accessory_type, accessory_category, accessory_metadata, preserve_colour, preserve_type, skip_update)

/mob/living/proc/get_skin_colour()
	return

/mob/living/proc/set_skin_colour(var/new_color, var/skip_update = FALSE)
	return get_skin_colour() != new_color

/mob/living/proc/get_eye_colour()
	return COLOR_WHITE

/mob/living/proc/set_eye_colour(var/new_color, var/skip_update = FALSE)
	return get_eye_colour() != new_color

/mob/living/get_all_current_mob_overlays()
	return mob_overlays

/mob/living/set_current_mob_overlay(var/overlay_layer, var/image/overlay, var/redraw_mob = TRUE)
	mob_overlays[overlay_layer] = overlay
	..()

/mob/living/get_current_mob_overlay(var/overlay_layer)
	return mob_overlays[overlay_layer]

/mob/living/get_all_current_mob_underlays()
	return mob_underlays

/mob/living/set_current_mob_underlay(var/underlay_layer, var/image/underlay, var/redraw_mob = TRUE)
	mob_underlays[underlay_layer] = underlay
	..()

/mob/living/get_current_mob_underlay(var/underlay_layer)
	return mob_underlays[underlay_layer]

/mob/living/refresh_visible_overlays()
	. = ..()
	var/list/modifier_overlays = null
	for(var/decl/mob_modifier/archetype in _mob_modifiers)
		var/image/status_overlay = archetype.get_modifier_mob_overlay(src)
		if(status_overlay)
			LAZYADD(modifier_overlays, status_overlay)
	set_current_mob_overlay(HO_EFFECT_LAYER, modifier_overlays, FALSE)

/decl/mob_modifier/proc/get_modifier_mob_overlay(mob/living/_owner)
	if(!mob_overlay_icon || !mob_overlay_state || !istype(_owner))
		return null
	var/image/mob_overlay = overlay_image(mob_overlay_icon, mob_overlay_state, COLOR_WHITE, RESET_COLOR)
	var/decl/bodytype/owner_bodytype = _owner.get_bodytype()
	if(owner_bodytype)
		if(owner_bodytype.pixel_offset_x)
			mob_overlay.pixel_x += -(owner_bodytype.pixel_offset_x)
		if(owner_bodytype.pixel_offset_y)
			mob_overlay.pixel_y += -(owner_bodytype.pixel_offset_y)
	return mob_overlay
