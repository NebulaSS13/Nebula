/obj/item/towel
	name = "towel"
	icon = 'icons/obj/items/towel.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_IS_BELT
	slot_flags = SLOT_HEAD | SLOT_LOWER_BODY | SLOT_OVER_BODY
	force = 0.5
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	material = /decl/material/solid/organic/cloth

/obj/item/towel/attack_self(mob/user)
	if(user.a_intent == I_GRAB)
		lay_out()
		return
	user.visible_message(SPAN_NOTICE("[user] uses [src] to towel themselves off."))
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)

/obj/item/towel/random/Initialize()
	. = ..()
	color = get_random_colour()

/obj/item/towel/gold
	name = "gold towel"
	color = "#ffd700"

/obj/item/towel/red
	name = "red towel"
	color = "#ff0000"

/obj/item/towel/purple
	name = "purple towel"
	color = "#800080"

/obj/item/towel/cyan
	name = "cyan towel"
	color = "#00ffff"

/obj/item/towel/orange
	name = "orange towel"
	color = "#ff8c00"

/obj/item/towel/pink
	name = "pink towel"
	color = "#ff6666"

/obj/item/towel/light_blue
	name = "light blue towel"
	color = "#3fc0ea"

/obj/item/towel/black
	name = "black towel"
	color = "#222222"
	material = /decl/material/solid/organic/cloth/black

/obj/item/towel/brown
	name = "black towel"
	color = "#854636"
	material = /decl/material/solid/organic/cloth/beige

/obj/item/towel/fleece // loot from the king of goats. it's a golden towel
	name = "golden fleece"
	desc = "The legendary Golden Fleece of Jason made real."
	color = "#ffd700"
	force = 1
	attack_verb = list("smote")
	material = /decl/material/solid/metal/gold

/obj/item/towel/verb/lay_out()
	set name = "Lay Out Towel"
	set category = "Object"

	if(usr.incapacitated())
		return

	if(usr.drop_from_inventory(src))
		usr.visible_message(
			SPAN_NOTICE("[usr] lay out \the [src] on the ground."),
			SPAN_NOTICE("You lay out \the [src] on the ground."))
		icon = 'icons/obj/items/towel_flat.dmi'
		pixel_x = 0
		pixel_y = 0
		pixel_z = 0

/obj/item/towel/on_picked_up(mob/user)
	..()
	if(icon != initial(icon))
		icon = initial(icon)
		user.visible_message(
			SPAN_NOTICE("[user] rolled up \the [src]."),
			SPAN_NOTICE("You pick up and fold \the [src]."))
