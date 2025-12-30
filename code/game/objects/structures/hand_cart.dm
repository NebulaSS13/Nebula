/obj/structure/hand_cart
	name = "handcart"
	desc = "A wheeled cart used to make heavy things less difficult to move through the power of lever-arm and the wheel."
	icon = 'icons/obj/structures/handcart.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	movable_flags = MOVABLE_FLAG_WHEELED
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_STRUCTURE
	color = COLOR_ORANGE
	var/pixel_y_offset = 4
	var/atom/movable/carrying
	var/min_object_size = ITEM_SIZE_NORMAL

/obj/structure/hand_cart/on_update_icon()
	underlays.Cut()
	..()
	underlays += "cart_wheel"
	var/image/I = image(icon, "handcart_layer_north")
	I.layer = STRUCTURE_LAYER + 0.02
	I.color = BlendHSV(color, material.color, 0.5)
	add_overlay(I)
	if(carrying)
		var/image/CA = image(carrying.icon, carrying.icon_state)
		CA.pixel_y = pixel_y_offset
		CA.plane = plane
		CA.layer = layer + 0.01 //just above STRUCTURE_LAYER
		add_overlay(CA)

/obj/structure/hand_cart/Destroy()
	. = ..()
	if(carrying)
		carrying.forceMove(get_turf(src))
		carrying = null

/obj/structure/hand_cart/grab_attack(obj/item/grab/grab, mob/user)
	if(isobj(grab.affecting))
		to_chat(user, SPAN_NOTICE("You start loading \the [grab.affecting] onto \the [src]."))
		if(load_item(grab.affecting, user))
			qdel(grab)
		return TRUE
	. = ..()

/obj/structure/hand_cart/attack_hand(mob/user)
	if(!carrying || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	unload_item(user)
	return TRUE

/obj/structure/hand_cart/proc/load_item(var/obj/A, var/user)
	if(!A.anchored && (A.w_class > min_object_size))
		if(do_after(user, 2 SECONDS, src))
			var/image/I = image(A.icon, A.icon_state)
			I.pixel_y = pixel_y_offset
			I.plane = plane
			I.layer = layer + 0.01 //just above STRUCTURE_LAYER
			add_overlay(I)
			A.forceMove(src)
			carrying = A
			to_chat(user, SPAN_NOTICE("You load \the [A] onto \the [src]."))
			return TRUE
	return FALSE

/obj/structure/hand_cart/proc/unload_item(var/user)
	if(carrying)
		carrying.forceMove(get_turf(user))
		to_chat(user, SPAN_NOTICE("You unload \the [carrying] from \the [src]."))
		carrying = null
		update_icon()
