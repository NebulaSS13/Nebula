/obj/structure/divider
	name                = "room divider"
	desc                = "A thin, somewhat flimsy folding room divider."
	icon                = 'icons/obj/structures/divider.dmi'
	icon_state          = ICON_STATE_WORLD + "-closed"
	material            = /decl/material/solid/organic/wood/bamboo
	color               = /decl/material/solid/organic/wood/bamboo::color
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	var/extended        = FALSE

/obj/structure/divider/extended
	icon_state          = ICON_STATE_WORLD
	extended            = TRUE

/obj/structure/divider/wood
	material            = /decl/material/solid/organic/wood/oak
	color               = /decl/material/solid/organic/wood/oak::color

/obj/structure/divider/extended/wood
	material            = /decl/material/solid/organic/wood/oak
	color               = /decl/material/solid/organic/wood/oak::color


/obj/structure/divider/extended/wood/ebony
	material            = /decl/material/solid/organic/wood/ebony
	color               = /decl/material/solid/organic/wood/ebony::color

/obj/structure/divider/attack_hand(mob/user)
	if(user.check_intent(I_FLAG_HELP) && user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, silent = TRUE))
		extended = !extended
		if(material.dooropen_noise)
			playsound(loc, material.dooropen_noise, 50, 1)
		update_divider()
		visible_message(SPAN_NOTICE("\The [user] [extended ? "extends" : "collapses"] \the [src]."))
		return TRUE
	. = ..()

/obj/structure/divider/Initialize()
	. = ..()
	update_divider()

/obj/structure/divider/proc/update_divider()
	anchored = extended
	density  = extended
	opacity  = extended || (material.opacity < 0.5)
	update_icon()

/obj/structure/divider/on_update_icon()
	. = ..()
	if(extended)
		icon_state = ICON_STATE_WORLD
	else
		icon_state = ICON_STATE_WORLD + "-closed"
