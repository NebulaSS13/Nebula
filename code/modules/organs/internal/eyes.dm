
/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	prosthetic_icon = "camera"
	prosthetic_dead_icon = "camera_broken"
	gender = PLURAL
	organ_tag = BP_EYES
	parent_organ = BP_HEAD
	surface_accessible = TRUE
	relative_size = 5
	max_damage = 45
	z_flags = ZMM_MANGLE_PLANES

	var/eye_colour = COLOR_BLACK
	var/tmp/last_cached_eye_colour
	var/tmp/last_eye_cache_key

/obj/item/organ/internal/eyes/proc/get_innate_flash_protection()
	return bodytype.eye_innate_flash_protection

/obj/item/organ/internal/eyes/proc/get_flash_mod()
	return bodytype.eye_flash_mod

/obj/item/organ/internal/eyes/proc/get_flash_burn()
	return bodytype.eye_flash_burn

/obj/item/organ/internal/eyes/proc/get_darksight_range()
	return bodytype.eye_darksight_range

/obj/item/organ/internal/eyes/robot
	name = "optical sensor"
	bodytype = /decl/bodytype/prosthetic/basic_human
	organ_properties = ORGAN_PROP_PROSTHETIC
	icon = 'icons/obj/robot_component.dmi'

/obj/item/organ/internal/eyes/robot/Initialize(mapload, material_key, datum/mob_snapshot/supplied_appearance, decl/bodytype/new_bodytype)
	. = ..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
	verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow

/obj/item/organ/external/eyes/set_organ_appearance_bodytype(decl/bodytype/new_bodytype, update_sprite_accessories = TRUE, skip_owner_update = FALSE)
	. = ..()
	if(. && owner && !skip_owner_update)
		owner.update_eyes()

/obj/item/organ/internal/eyes/proc/get_onhead_icon()
	var/decl/bodytype/icon_bodytype = get_organ_appearance_bodytype()
	var/modifier = owner?.get_overlay_state_modifier()
	var/eye_state = modifier ? "eyes[modifier]" : "eyes"
	last_cached_eye_colour = eye_colour
	last_eye_cache_key = "[type]-[icon_bodytype.eye_icon]-[last_cached_eye_colour]-[icon_bodytype.eye_offset]-[eye_state]"
	if(!icon_bodytype.eye_icon)
		return
	if(!global.eye_icon_cache[last_eye_cache_key])
		var/icon/eyes_icon = icon(icon = icon_bodytype.eye_icon, icon_state = eye_state)
		if(icon_bodytype.eye_offset)
			eyes_icon.Shift(NORTH, icon_bodytype.eye_offset)
		if(icon_bodytype.apply_eye_colour)
			eyes_icon.Blend(last_cached_eye_colour, icon_bodytype.eye_blend)
		global.eye_icon_cache[last_eye_cache_key] = eyes_icon
	return global.eye_icon_cache[last_eye_cache_key]

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	// Update our eye colour.
	var/new_eye_colour
	if(owner.has_chemical_effect(CE_GLOWINGEYES, 1))
		new_eye_colour = "#75bdd6" // blue glow, hardcoded for now.
	else
		new_eye_colour = owner.get_eye_colour()

	if(new_eye_colour && eye_colour != new_eye_colour)
		eye_colour = new_eye_colour
		// Clear the head cache key so they can update their cached icon.
		var/obj/item/organ/external/head/head = GET_EXTERNAL_ORGAN(owner, BP_HEAD)
		if(istype(head))
			head._icon_cache_key = null

/obj/item/organ/internal/eyes/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	var/oldbroken = is_broken()
	. = ..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, "<span class='danger'>You go blind!</span>")

/obj/item/organ/internal/eyes/Process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		SET_STATUS_MAX(owner, STAT_BLURRY, 20)
	if(is_broken())
		SET_STATUS_MAX(owner, STAT_BLIND, 20)

/obj/item/organ/internal/eyes/proc/get_total_protection(var/flash_protection = FLASH_PROTECTION_NONE)
	return (flash_protection + get_innate_flash_protection())

/obj/item/organ/internal/eyes/proc/additional_flash_effects(var/intensity)
	return -1

/obj/item/organ/internal/eyes/do_install(mob/living/human/target, affected, in_place, update_icon, detached)
	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.set_eye_colour(eye_colour, skip_update = TRUE)
		target.update_eyes(update_icons = update_icon)
	if(owner && BP_IS_PROSTHETIC(src))
		verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
		verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
	. = ..()

/obj/item/organ/internal/eyes/do_uninstall(in_place, detach, ignore_children, update_icon)
	. = ..()
	verbs -= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
	verbs -= /obj/item/organ/internal/eyes/proc/toggle_eye_glow

// TODO: FIND A BETTER WAY TO DO THIS
// MAYBE JUST REMOVE IT ENTIRELY?
/obj/item/organ/internal/eyes/reset_status()
	. = ..()
	if(BP_IS_PROSTHETIC(src))
		name = "optical sensor"
		icon = 'icons/obj/robot_component.dmi'
		verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
		verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
	else
		name = initial(name)
		icon = initial(icon)
		verbs -= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
		verbs -= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
	update_colour()

/obj/item/organ/internal/eyes/proc/change_eye_color_verb()
	set name = "Change Eye Color"
	set desc = "Changes your robotic eye color."
	set category = "IC"
	set src in usr

	if(!owner || !BP_IS_PROSTHETIC(src))
		verbs -= /obj/item/organ/internal/eyes/proc/change_eye_color_verb
		return

	if(owner.incapacitated())
		return

	var/new_eyes = input("Please select eye color.", "Eye Color", owner.get_eye_colour()) as color|null
	if(new_eyes && do_after(owner, 10) && owner.set_eye_colour(new_eyes))
		update_colour()
		// Finally, update the eye icon on the mob.
		owner.try_refresh_visible_overlays()
		owner.visible_message(SPAN_NOTICE("\The [owner] changes their eye color."),SPAN_NOTICE("You change your eye color."),)

/obj/item/organ/internal/eyes/proc/toggle_eye_glow()

	set name = "Toggle Eye Glow"
	set desc = "Toggles your robotic eye glow."
	set category = "IC"
	set src in usr

	if(!owner || !BP_IS_PROSTHETIC(src))
		verbs -= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
		return

	if(owner.incapacitated())
		return

	var/obj/item/organ/external/head/head = owner.get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(head)
		head.glowing_eyes = !head.glowing_eyes
		owner.try_refresh_visible_overlays()
