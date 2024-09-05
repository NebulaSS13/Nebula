//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/box/bodybags
	name       = "body bags"
	desc       = "This box contains body bags."
	icon_state = "bodybags"

/obj/item/box/bodybags/WillContain()
	return list(/obj/item/bodybag = 7)

/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	closet_appearance = null
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_SIZE_MEDIUM * 2) - 1
	var/contains_body = FALSE

/obj/structure/closet/body_bag/Initialize()
	. = ..()
	set_extension(src, /datum/extension/labels/single) //Set the label extension to a single allowed label

/obj/structure/closet/body_bag/SetName(new_name)
	. = ..()
	update_icon() //Since adding a label updates the name, this handles updating the label overlay

/obj/structure/closet/body_bag/can_install_lock()
	// It is a plastic bag
	return FALSE

/obj/structure/closet/body_bag/on_update_icon()
	if(opened)
		icon_state = "open"
	else
		icon_state = "closed_unlocked"

	..()
	var/datum/extension/labels/lbls = get_extension(src, /datum/extension/labels)
	if(LAZYLEN(lbls?.labels))
		add_overlay("bodybag_label")

/obj/structure/closet/body_bag/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/hand_labeler))
		return //Prevent the labeler from opening the bag when trying to apply a label
	. = ..()

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close(mob/user)
	. = ..()
	if(.)
		set_density(0)
		return TRUE
	return FALSE

/obj/structure/closet/body_bag/proc/fold(var/user)
	if(!(ishuman(user) || isrobot(user)))	return 0
	if(opened)	return 0
	if(contents.len)	return 0
	visible_message("[user] folds up \the [src]")
	. = new item_path(get_turf(src))
	qdel(src)

/obj/structure/closet/body_bag/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && (in_range(src, user) || (src in user.contents)))
		fold(user)
		return TRUE
	. = ..()

/obj/item/robot_rack/body_bag
	name = "stasis bag rack"
	desc = "A rack for carrying folded stasis bags and body bags."
	icon = 'icons/obj/closets/cryobag.dmi'
	icon_state = "bodybag_folded"
	object_type = /obj/item/bodybag
	interact_type = /obj/structure/closet/body_bag
	capacity = 3