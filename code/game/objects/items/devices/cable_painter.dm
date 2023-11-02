/obj/item/cable_painter
	name = "cable painter"
	desc = "A device for repainting cables."
	icon = 'icons/obj/items/hand_labeler.dmi'
	icon_state = ICON_STATE_WORLD
	var/color_selection
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic

/obj/item/cable_painter/Initialize()
	. = ..()
	color_selection = pick(get_global_cable_colors())

/obj/item/cable_painter/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The color is currently set to [lowertext(color_selection)].")

/obj/item/cable_painter/attack_self(mob/user)
	var/new_color_selection = input("What color would you like to use?", "Choose a Color", color_selection) as null|anything in get_global_cable_colors()
	if(new_color_selection && !user.incapacitated() && (src in user))
		color_selection = new_color_selection
		to_chat(user, "<span class='notice'>You change the paint mode to [lowertext(color_selection)].</span>")

/obj/item/cable_painter/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity)
		return ..()

	if(istype(A, /obj/structure/cable))
		var/list/possible_cable_colours = get_global_cable_colors()
		var/picked_color = possible_cable_colours[color_selection]
		if(!picked_color || A.color == picked_color)
			return
		A.color = picked_color
		to_chat(user, "<span class='notice'>You set \the [A]'s color to [lowertext(color_selection)].</span>")
		return

	if(istype(A, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/c = A
		c.set_cable_color(color_selection, user)
		return

	. = ..()
