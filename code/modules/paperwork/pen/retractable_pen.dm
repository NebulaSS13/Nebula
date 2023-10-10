/obj/item/pen/retractable
	desc     = "It's a retractable pen."
	icon     = 'icons/obj/items/pens/pen_retractable.dmi'
	pen_flag = PEN_FLAG_TOGGLEABLE

/obj/item/pen/retractable/blue
	stroke_colour      = "blue"
	stroke_colour_name = "blue"
	icon = 'icons/obj/items/pens/pen_retractable_blue.dmi'

/obj/item/pen/retractable/red
	stroke_colour      = "red"
	stroke_colour_name = "red"
	icon = 'icons/obj/items/pens/pen_retractable_red.dmi'

/obj/item/pen/retractable/green
	stroke_colour      = "green"
	stroke_colour_name = "green"
	icon = 'icons/obj/items/pens/pen_retractable_green.dmi'

/obj/item/pen/retractable/Initialize()
	. = ..()
	desc = "It's a retractable [stroke_colour_name] [medium_name] pen."

/obj/item/pen/retractable/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(pen_flag & PEN_FLAG_ACTIVE)
		icon_state = "[icon_state]-on"

/obj/item/pen/retractable/attack(atom/A, mob/user, target_zone)
	if(!(pen_flag & PEN_FLAG_ACTIVE))
		toggle()
	..()

/obj/item/pen/retractable/attack_self(mob/user)
	toggle()
