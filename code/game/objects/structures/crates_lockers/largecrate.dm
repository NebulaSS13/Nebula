/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/shipping_crates.dmi'
	icon_state = "densecrate"
	density = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	material = /decl/material/solid/wood

/obj/structure/largecrate/Initialize()
	. = ..()
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || !I.simulated)
			continue
		I.forceMove(src)

/obj/structure/largecrate/attack_hand(mob/user)
	to_chat(user, SPAN_WARNING("You need a crowbar to pry this open!"))

/obj/structure/largecrate/attackby(obj/item/W, mob/user)
	if(IS_CROWBAR(W))
		user.visible_message(
			SPAN_NOTICE("\The [user] pries \the [src] open."),
			SPAN_NOTICE("You pry open \the [src]."),
			SPAN_NOTICE("You hear splitting wood.")
		)
		physically_destroyed()
		return TRUE
	return attack_hand(user)
