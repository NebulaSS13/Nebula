/obj/item/pen/retractable
	desc     = "It's a retractable pen."
	icon     = 'icons/obj/items/pens/pen_retractable.dmi'
	pen_flag = PEN_FLAG_TOGGLEABLE

/obj/item/pen/retractable/blue
	stroke_color      = "blue"
	stroke_color_name = "blue"
	icon              = 'icons/obj/items/pens/pen_retractable_blue.dmi'

/obj/item/pen/retractable/red
	stroke_color      = "red"
	stroke_color_name = "red"
	icon              = 'icons/obj/items/pens/pen_retractable_red.dmi'

/obj/item/pen/retractable/green
	stroke_color      = "green"
	stroke_color_name = "green"
	icon              = 'icons/obj/items/pens/pen_retractable_green.dmi'

/obj/item/pen/retractable/Initialize()
	. = ..()
	desc = "It's a retractable [stroke_color_name] [medium_name] pen."

/obj/item/pen/retractable/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(pen_flag & PEN_FLAG_ACTIVE)
		icon_state = "[icon_state]-on"

/obj/item/pen/retractable/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(!(pen_flag & PEN_FLAG_ACTIVE))
		toggle()
	return ..()

/obj/item/pen/retractable/attack_self(mob/user)
	toggle()
