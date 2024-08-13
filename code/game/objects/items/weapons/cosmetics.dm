/obj/item/cosmetics
	gender = PLURAL
	name = "abstract makeup"
	desc = "An unbranded tube of makeup."
	obj_flags = OBJ_FLAG_HOLLOW
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	color = COLOR_SILVER
	material = /decl/material/solid/organic/plastic
	abstract_type = /obj/item/cosmetics

	var/base_icon_state
	var/apply_marking_to_limb = BP_HEAD
	var/apply_to_zone = BP_MOUTH
	var/cosmetic_type
	var/makeup_color
	var/color_desc
	var/open = FALSE

/obj/item/cosmetics/Initialize()
	. = ..()
	if(!cosmetic_type)
		PRINT_STACK_TRACE("Cosmetic item initialized with no cosmetic_type set!")
		return INITIALIZE_HINT_QDEL
	if(color_desc)
		name = "[color_desc] [name]"
		desc += " This one is in [color_desc]."
	update_icon()

//'lipstick' and 'key' are both coloured by var color
/obj/item/cosmetics/on_update_icon()
	. = ..()
	if(open)
		icon_state = "[base_icon_state]_open"
		add_overlay(overlay_image(icon, "[base_icon_state]_extended", makeup_color, RESET_COLOR))
	else
		icon_state = "[base_icon_state]_closed"
		add_overlay(overlay_image(icon, "[base_icon_state]_key", makeup_color, RESET_COLOR))

/obj/item/cosmetics/attack_self(mob/user)
	open = !open
	show_open_message(user)
	update_icon()

/obj/item/cosmetics/proc/show_open_message(mob/user)
	return

/obj/item/cosmetics/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(!open || !ishuman(target))
		return ..()

	if(istype(target, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = target
		head.write_on(user, src)
		return TRUE

	var/obj/item/organ/external/limb = user.get_organ(apply_marking_to_limb, /obj/item/organ/external/head)
	if(!limb)
		return ..()
	var/target_zone = user.get_target_zone()
	if(user.a_intent == I_HELP && target_zone != apply_to_zone && istype(limb, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = limb
		head.write_on(user, name)
		return TRUE

	if(!istype(target) || target_zone != apply_to_zone)
		return ..()

	var/decl/sprite_accessory/cosmetics/lip_decl = GET_DECL(cosmetic_type)
	if(!lip_decl?.accessory_is_available(user, limb.species, limb.bodytype, user.get_traits()))
		to_chat(user, SPAN_WARNING("You can't wear this makeup!"))
		return TRUE

	if(user == target)
		if(target.get_organ_sprite_accessory_metadata(cosmetic_type, apply_marking_to_limb))	//if they already have lipstick on
			to_chat(user, SPAN_WARNING("You need to wipe off your old makeup first!"))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] does their makeup with \the [src]."),
			SPAN_NOTICE("You take a moment to apply \the [src]. Perfect!")
		)
		user.set_organ_sprite_accessory(cosmetic_type, SAC_COSMETICS, list(SAM_COLOR = makeup_color), apply_marking_to_limb)
		return TRUE

	if(target.get_organ_sprite_accessory_metadata(cosmetic_type, apply_marking_to_limb))	//if they already have lipstick on
		to_chat(user, SPAN_WARNING("You need to wipe off the old makeup first!"))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] begins to do \the [target]'s makeup with \the [src]."),
		SPAN_NOTICE("You begin to apply \the [src] to \the [target].")
	)
	if(do_after(user, 2 SECONDS, target))
		user.visible_message(
			SPAN_NOTICE("\The [user] does \the [target]'s makeup with \the [src]."),
			SPAN_NOTICE("You apply \the [src] to \the [target].")
		)
		if(target.get_organ_sprite_accessory_metadata(cosmetic_type, apply_marking_to_limb))
			return TRUE
		target.set_organ_sprite_accessory(cosmetic_type, SAC_COSMETICS, list(SAM_COLOR = makeup_color), apply_marking_to_limb)
	return TRUE

//types
/obj/item/cosmetics/lipstick
	name = "lipstick"
	desc = "An unbranded tube of lipstick."
	icon = 'icons/obj/items/cosmetics/lipstick.dmi'
	icon_state = "lipstick_closed"
	cosmetic_type = /decl/sprite_accessory/cosmetics/lipstick
	abstract_type = /obj/item/cosmetics/lipstick
	base_icon_state = "lipstick"

/obj/item/cosmetics/lipstick/show_open_message(mob/user)
	if(open)
		to_chat(user, SPAN_NOTICE("You remove the cap and twist \the [src] open."))
	else
		to_chat(user, SPAN_NOTICE("You twist \the [src] closed and replace the cap."))

/obj/item/cosmetics/lipstick/red
	makeup_color = "#e00606"
	color_desc = "ruby"

/obj/item/cosmetics/lipstick/yellow
	makeup_color = "#dfdb0a"
	color_desc = "topaz"

/obj/item/cosmetics/lipstick/orange
	makeup_color = "#db7d11"
	color_desc = "agate"

/obj/item/cosmetics/lipstick/green
	makeup_color = "#218c17"
	color_desc = "emerald"

/obj/item/cosmetics/lipstick/turquoise
	makeup_color = "#0098f0"
	color_desc = "turquoise"

/obj/item/cosmetics/lipstick/blue
	makeup_color = "#0024f0"
	color_desc = "sapphire"

/obj/item/cosmetics/lipstick/violet
	makeup_color = "#d55cd0"
	color_desc = "amethyst"

/obj/item/cosmetics/lipstick/white
	makeup_color = "#d8d5d5"
	color_desc = "moonstone"

/obj/item/cosmetics/lipstick/purple
	makeup_color = "#440044"
	color_desc = "garnet"

/obj/item/cosmetics/lipstick/black
	makeup_color = "#2b2a2a"
	color_desc = "onyx"

/obj/item/cosmetics/eyeshadow
	name = "eyeshadow"
	abstract_type = /obj/item/cosmetics/eyeshadow
	desc = "An unbranded tube of eyeshadow."
	icon = 'icons/obj/items/cosmetics/eyeshadow.dmi'
	icon_state = "eyeshadow_closed"
	cosmetic_type = /decl/sprite_accessory/cosmetics/eyeshadow
	apply_to_zone = BP_EYES
	base_icon_state = "eyeshadow"

/obj/item/cosmetics/eyeshadow/show_open_message(mob/user)
	if(open)
		to_chat(user, SPAN_NOTICE("You pop \the [src] open and remove the brush."))
	else
		to_chat(user, SPAN_NOTICE("You snap \the [src] closed and replace the brush."))

/obj/item/cosmetics/eyeshadow/red
	makeup_color = "#e00606"
	color_desc = "ruby"

/obj/item/cosmetics/eyeshadow/yellow
	makeup_color = "#dfdb0a"
	color_desc = "topaz"

/obj/item/cosmetics/eyeshadow/orange
	makeup_color = "#db7d11"
	color_desc = "agate"

/obj/item/cosmetics/eyeshadow/green
	makeup_color = "#218c17"
	color_desc = "emerald"

/obj/item/cosmetics/eyeshadow/turquoise
	makeup_color = "#0098f0"
	color_desc = "turquoise"

/obj/item/cosmetics/eyeshadow/blue
	makeup_color = "#0024f0"
	color_desc = "sapphire"

/obj/item/cosmetics/eyeshadow/violet
	makeup_color = "#d55cd0"
	color_desc = "amethyst"

/obj/item/cosmetics/eyeshadow/white
	makeup_color = "#d8d5d5"
	color_desc = "moonstone"

/obj/item/cosmetics/eyeshadow/purple
	makeup_color = "#440044"
	color_desc = "garnet"

/obj/item/cosmetics/eyeshadow/black
	makeup_color = "#2b2a2a"
	color_desc = "onyx"

/obj/item/cosmetics/eyeshadow/black
	name = "onyx eyeshadow"
	makeup_color = "#2b2a2a"
	color_desc = "onyx"
