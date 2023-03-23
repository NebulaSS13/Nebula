
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

	var/contaminant_guard = 0
	var/eye_colour = COLOR_BLACK
	var/innate_flash_protection = FLASH_PROTECTION_NONE
	var/eye_icon = 'icons/mob/human_races/species/default_eyes.dmi'
	var/apply_eye_colour = TRUE
	var/tmp/last_cached_eye_colour
	var/tmp/last_eye_cache_key
	var/flash_mod
	var/darksight_range
	var/eye_blend = ICON_ADD

/obj/item/organ/internal/eyes/robot
	name = "optical sensor"
	organ_properties = ORGAN_PROP_PROSTHETIC
	icon = 'icons/obj/robot_component.dmi'
	flash_mod = 1
	darksight_range = 2
	material = /decl/material/solid/metal/steel

/obj/item/organ/internal/eyes/robot/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color
	verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow

/obj/item/organ/internal/eyes/robot/robotize(var/company, var/skip_prosthetics = 0, var/keep_organs = 0, var/apply_material = /decl/material/solid/metal/steel, var/check_bodytype, var/check_species)
	return

/obj/item/organ/internal/eyes/proc/get_eye_cache_key()
	last_cached_eye_colour = eye_colour
	last_eye_cache_key = "[type]-[eye_icon]-[last_cached_eye_colour]-[bodytype.eye_offset]"
	return last_eye_cache_key

/obj/item/organ/internal/eyes/proc/get_onhead_icon()
	var/cache_key = get_eye_cache_key()
	if(!human_icon_cache[cache_key])
		var/icon/eyes_icon = icon(icon = eye_icon, icon_state = "")
		if(bodytype.eye_offset)
			eyes_icon.Shift(NORTH, bodytype.eye_offset)
		if(apply_eye_colour)
			eyes_icon.Blend(last_cached_eye_colour, eye_blend)
		human_icon_cache[cache_key] = eyes_icon
	return human_icon_cache[cache_key]

/obj/item/organ/internal/eyes/proc/get_special_overlay()
	var/icon/I = get_onhead_icon()
	if(I)
		var/cache_key = "[last_eye_cache_key]-glow"
		if(!human_icon_cache[cache_key])
			human_icon_cache[cache_key] = emissive_overlay(I, "")
		return human_icon_cache[cache_key]

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	if(owner.has_chemical_effect(CE_GLOWINGEYES, 1))
		eye_colour = "#75bdd6" // blue glow, hardcoded for now.
	else
		eye_colour = owner.eye_colour

/obj/item/organ/internal/eyes/take_internal_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	. = ..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, "<span class='danger'>You go blind!</span>")

/obj/item/organ/internal/eyes/Process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.set_status(STAT_BLURRY, 20)
	if(is_broken())
		owner.set_status(STAT_BLIND, 20)

/obj/item/organ/internal/eyes/set_species(species_name)
	. = ..()
	flash_mod 		= species.flash_mod
	darksight_range = species.darksight_range

/obj/item/organ/internal/eyes/proc/get_total_protection(var/flash_protection = FLASH_PROTECTION_NONE)
	return (flash_protection + innate_flash_protection)

/obj/item/organ/internal/eyes/proc/additional_flash_effects(var/intensity)
	return -1

/obj/item/organ/internal/eyes/do_install(mob/living/carbon/human/target, affected, in_place, update_icon, detached)
	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.eye_colour = eye_colour
		target.update_eyes()
	if(owner && BP_IS_PROSTHETIC(src))
		verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color
		verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
	. = ..()

/obj/item/organ/internal/eyes/do_uninstall(in_place, detach, ignore_children, update_icon)
	. = ..()
	verbs -= /obj/item/organ/internal/eyes/proc/change_eye_color
	verbs -= /obj/item/organ/internal/eyes/proc/toggle_eye_glow

/obj/item/organ/internal/eyes/robotize(var/company = /decl/prosthetics_manufacturer/basic_human, var/skip_prosthetics = 0, var/keep_organs = 0, var/apply_material = /decl/material/solid/metal/steel, var/check_bodytype, var/check_species)
	. = ..()
	name = "optical sensor"
	icon = 'icons/obj/robot_component.dmi'
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color
	verbs |= /obj/item/organ/internal/eyes/proc/toggle_eye_glow
	update_colour()
	flash_mod = 1
	darksight_range = 2

/obj/item/organ/internal/eyes/get_mechanical_assisted_descriptor()
	return "retinal overlayed [name]"

/obj/item/organ/internal/eyes/proc/change_eye_color()
	set name = "Change Eye Color"
	set desc = "Changes your robotic eye color."
	set category = "IC"
	set src in usr

	if(!owner || !BP_IS_PROSTHETIC(src))
		verbs -= /obj/item/organ/internal/eyes/proc/change_eye_color
		return

	if(owner.incapacitated())
		return

	var/new_eyes = input("Please select eye color.", "Eye Color", owner.eye_colour) as color|null
	if(new_eyes && do_after(owner, 10) && owner.change_eye_color(new_eyes))
		update_colour()
		// Finally, update the eye icon on the mob.
		owner.refresh_visible_overlays()
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
		owner.refresh_visible_overlays()
