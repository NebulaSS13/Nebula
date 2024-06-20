#define FLASHLIGHT_ALWAYS_ON 1
#define FLASHLIGHT_SINGLE_USE 2

/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting/flashlight.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	action_button_name = "Toggle Flashlight"
	light_wedge = LIGHT_WIDE
	var/on = FALSE
	var/activation_sound = 'sound/effects/flashlight.ogg'
	var/flashlight_range = 4 // range of light when on, can be negative
	var/flashlight_power     // brightness of light when on
	var/flashlight_flags = 0 // FLASHLIGHT_ bitflags
	var/spawn_dir // a way for mappers to force which way a flashlight faces upon spawning
	var/offset_on_overlay_x = 0
	var/offset_on_overlay_y = 0

/obj/item/flashlight/Initialize()
	. = ..()
	set_flashlight()
	update_icon()
	update_held_icon()

/obj/item/flashlight/proc/get_emissive_overlay_color()
	return COLOR_WHITE // Icons are usually coloured already.

/obj/item/flashlight/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(on)
		icon_state = "[icon_state]-on"
		var/emissive_state = "[icon_state]-over"
		if(check_state_in_icon(emissive_state, icon))
			var/image/I = mutable_appearance(icon, emissive_state, get_emissive_overlay_color()) //emissive_overlay(icon, emissive_state) // Uncomment when emissive clipping is in.
			I.appearance_flags |= RESET_COLOR
			I.pixel_x = offset_on_overlay_x
			I.pixel_y = offset_on_overlay_y
			I.pixel_w = 0
			I.pixel_z = 0
			I.plane = FLOAT_PLANE
			I.layer = FLOAT_LAYER
			add_overlay(I)

/obj/item/flashlight/attack_self(mob/user)
	if(user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		if (flashlight_flags & FLASHLIGHT_ALWAYS_ON)
			to_chat(user, SPAN_WARNING("You cannot toggle \the [src]."))
			return TRUE
		if ((flashlight_flags & FLASHLIGHT_SINGLE_USE) && on)
			to_chat(user, SPAN_WARNING("\The [src] is already on."))
			return TRUE
		on = !on
		if(on && activation_sound)
			playsound(get_turf(src), activation_sound, 75, 1)
		set_flashlight(set_direction = FALSE)
		update_icon()
		user.update_action_buttons()
		return TRUE
	return ..()

/obj/item/flashlight/proc/set_flashlight(var/set_direction = TRUE)
	if(light_wedge && set_direction)
		set_dir(spawn_dir || pick(global.cardinal))
	if(on)
		set_light(flashlight_range, flashlight_power, light_color)
	else
		set_light(0)

/obj/item/flashlight/examine(mob/user, distance)
	. = ..()
	if(light_wedge && isturf(loc))
		to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] is facing [dir2text(dir)].")))

/obj/item/flashlight/dropped(mob/user)
	. = ..()
	if(light_wedge)
		set_dir(user.dir)
		update_light()
	update_icon()

/obj/item/flashlight/equipped(mob/user, slot)
	. = ..()
	update_icon()

/obj/item/flashlight/throw_at()
	. = ..()
	if(light_wedge)
		set_dir(pick(global.cardinal))
		update_light()

/obj/item/flashlight/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(on && user.get_target_zone() == BP_EYES && target.should_have_organ(BP_HEAD))

		add_fingerprint(user)
		if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		for(var/slot in global.standard_headgear_slots)
			var/obj/item/clothing/C = target.get_equipped_item(slot)
			if(istype(C) && (C.body_parts_covered & SLOT_EYES))
				to_chat(user, SPAN_WARNING("You're going to need to remove [C] first."))
				return TRUE

		var/obj/item/organ/vision
		var/decl/bodytype/root_bodytype = target.get_bodytype()
		var/vision_organ_tag = target.get_vision_organ_tag()
		if(!vision_organ_tag || !target.should_have_organ(vision_organ_tag))
			to_chat(user, SPAN_WARNING("You can't find anything on \the [target] to direct \the [src] into!"))
			return TRUE

		vision = GET_INTERNAL_ORGAN(target, vision_organ_tag)
		if(!vision)
			vision = root_bodytype.has_organ[vision_organ_tag]
			var/decl/pronouns/G = target.get_pronouns()
			to_chat(user, SPAN_WARNING("\The [target] is missing [G.his] [initial(vision.name)]!"))
			return TRUE

		user.visible_message(
			SPAN_NOTICE("\The [user] directs [src] into [target]'s [vision.name]."),
			SPAN_NOTICE("You direct [src] into [target]'s [vision.name].")
		)
		inspect_vision(vision, user)

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
		target.flash_eyes()
		return TRUE

	return ..()

/obj/item/flashlight/proc/inspect_vision(obj/item/organ/vision, mob/living/user)
	var/mob/living/human/H = vision.owner

	if(H == user)	//can't look into your own eyes buster
		return

	if(!BP_IS_PROSTHETIC(vision))

		if(vision.owner.stat == DEAD || H.is_blind())	//mob is dead or fully blind
			to_chat(user, SPAN_WARNING("\The [H]'s pupils do not react to the light!"))
			return
		if(H.has_genetic_condition(GENE_COND_XRAY))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils give an eerie glow!"))
		if(vision.damage)
			to_chat(user, SPAN_WARNING("There's visible damage to [H]'s [vision.name]!"))
		else if(HAS_STATUS(H, STAT_BLURRY))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils react slower than normally."))
		if(H.get_damage(BRAIN) > 15)
			to_chat(user, SPAN_NOTICE("There's visible lag between left and right pupils' reactions."))

		var/static/list/pinpoint = list(
			/decl/material/liquid/painkillers/strong = 5,
			/decl/material/liquid/amphetamines = 1
		)
		var/static/list/dilating = list(
			/decl/material/liquid/psychoactives = 5,
			/decl/material/liquid/hallucinogenics = 1,
			/decl/material/liquid/adrenaline = 1
		)

		var/datum/reagents/ingested = H.get_ingested_reagents()
		if(H.reagents.has_any_reagent(pinpoint) || ingested?.has_any_reagent(pinpoint))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils are already pinpoint and cannot narrow any more."))
		else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || ingested?.has_any_reagent(dilating))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils narrow slightly, but are still very dilated."))
		else
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils narrow."))

	//if someone wants to implement inspecting robot eyes here would be the place to do it.

/obj/item/flashlight/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && on)
		var/icon_state_on = "[overlay.icon_state]-on"
		if(check_state_in_icon(icon_state_on, overlay.icon))
			var/image/I = mutable_appearance(overlay.icon, icon_state_on, get_emissive_overlay_color()) //emissive_overlay(overlay.icon, icon_state_on) // Uncomment when emissive clipping is in.
			I.appearance_flags |= RESET_COLOR
			overlay.overlays += I
	. = ..()
