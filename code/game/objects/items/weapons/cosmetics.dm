/obj/item/lipstick //this is the base type and its red
	gender = PLURAL
	name = "ruby lipstick"
	desc = "An unbranded tube of lipstick."
	icon = 'icons/obj/items/lipstick.dmi'
	icon_state = "lipstick_0"
	obj_flags = OBJ_FLAG_HOLLOW
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	color = "#e00606"
	material = /decl/material/solid/organic/plastic
	var/color_desc = "ruby"
	var/open = FALSE

/obj/item/lipstick/Initialize()
	. = ..()
	if(color_desc)
		desc += " This one is in [color_desc]."
	update_icon()

//'lipstick' and 'key' are both coloured by var color
/obj/item/lipstick/on_update_icon()
	. = ..()
	if(open)
		icon_state = "the_stick"
	else
		icon_state = ""

	add_overlay(list(
		overlay_image(icon, "lipstick_[open]", flags=RESET_COLOR),
		overlay_image(icon, "key")
	))

/obj/item/lipstick/attack_self(mob/user)
	open = !open
	if(open)
		to_chat(user, SPAN_NOTICE("You remove the cap and twist \the [src] open."))
	else
		to_chat(user, SPAN_NOTICE("You twist \the [src] closed and replace the cap."))
	update_icon()

/obj/item/lipstick/attack(atom/A, mob/user, target_zone)
	if(!open)	return

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD, /obj/item/organ/external/head)

		if(!head)
			return

		if(user.a_intent == I_HELP && target_zone == BP_HEAD)
			head.write_on(user, src.name)
		else if(head.has_lips)
			if(H.lip_style)	//if they already have lipstick on
				to_chat(user, "<span class='notice'>You need to wipe off the old lipstick first!</span>")
				return
			if(H == user)
				user.visible_message("<span class='notice'>[user] does their lips with \the [src].</span>", \
									 "<span class='notice'>You take a moment to apply \the [src]. Perfect!</span>")
				H.lip_style = color
				H.update_body()
			else
				user.visible_message("<span class='warning'>[user] begins to do [H]'s lips with \the [src].</span>", \
									 "<span class='notice'>You begin to apply \the [src].</span>")
				if(do_after(user, 20, H) && do_after(H, 20, check_holding = 0, progress = 0, incapacitation_flags = INCAPACITATION_NONE))	//user needs to keep their active hand, H does not.
					user.visible_message("<span class='notice'>[user] does [H]'s lips with \the [src].</span>", \
										 "<span class='notice'>You apply \the [src].</span>")
					H.lip_style = color
					H.update_body()
	else if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, src)

//types
/obj/item/lipstick/yellow
	name = "topaz lipstick"
	color = "#dfdb0a"
	color_desc = "topaz"

/obj/item/lipstick/orange
	name = "agate lipstick"
	color = "#db7d11"
	color_desc = "agate"

/obj/item/lipstick/green
	name = "emerald lipstick"
	color = "#218c17"
	color_desc = "emerald"

/obj/item/lipstick/turquoise
	name = "turquoise lipstick"
	color = "#0098f0"
	color_desc = "turquoise"

/obj/item/lipstick/blue
	name = "sapphire lipstick"
	color = "#0024f0"
	color_desc = "sapphire"

/obj/item/lipstick/violet
	name = "amethyst lipstick"
	color = "#d55cd0"
	color_desc = "amethyst"

/obj/item/lipstick/white
	name = "moonstone lipstick"
	color = "#d8d5d5"
	color_desc = "moonstone"

/obj/item/lipstick/purple
	name = "garnet lipstick"
	color = "#440044"
	color_desc = "garnet"

/obj/item/lipstick/black
	name = "onyx lipstick"
	color = "#2b2a2a"
	color_desc = "onyx"