/obj/structure/hand_cart
	name = "handcart"
	desc = "A wheeled cart used to make heavy things less difficult to move through the power of lever-arm and the wheel."
	icon = 'icons/obj/structures/handcart.dmi'
	icon_state = "cart"
	anchored = 0
	density = 1
	atom_flags = ATOM_FLAG_WHEELED
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_NO_CONTAINER
	var/pixel_y_offset = 4
	var/pixel_x_offset = 4
	var/atom/movable/C
	var/min_object_size = ITEM_SIZE_NORMAL

/obj/structure/hand_cart/on_update_icon()
	underlays.Cut()
	cut_overlays()
	var/image/W = image(icon, "cart_wheel")
	underlays += W
	var/image/I = image(icon, "handcart_layer_north")
	I.layer = STRUCTURE_LAYER + 0.02
	I.color = color
	add_overlay(I)

/obj/structure/hand_cart/grab_attack(var/obj/item/grab/G)
	if(G.affecting && istype(G.affecting, /obj/))
		to_chat(G.assailant, SPAN_NOTICE("You start loading \the [G.affecting] onto \the [src]."))
		if(load_item(G.affecting, G.assailant))
			qdel(G)

/obj/structure/hand_cart/attack_hand(mob/user)
	. = ..()
	if(C)
		unload_item(user)

/obj/structure/hand_cart/proc/load_item(var/obj/A, var/user)
	if(!A.anchored && (A.w_class > min_object_size))
		if(do_after(user, 2 SECONDS, src))
			A.pixel_y = pixel_y_offset
			A.pixel_x = pixel_x_offset
			A.plane = plane
			A.layer = layer + 0.01 //just above STRUCTURE_LAYER
			add_overlay(A)
			A.pixel_y = initial(A.pixel_y)
			A.pixel_x = initial(A.pixel_x)
			A.reset_plane_and_layer()
			A.forceMove(src)
			C = A
			to_chat(user, SPAN_NOTICE("You load \the [A] onto \the [src]."))
			return TRUE
	return FALSE

/obj/structure/hand_cart/proc/unload_item(var/user)
	if(C)
		C.forceMove(get_turf(user))
		to_chat(user, SPAN_NOTICE("You unload \the [C] from \the [src]."))
		C = null
		update_icon()
