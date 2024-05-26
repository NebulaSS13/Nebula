/obj/item/plate
	name                = "plate"
	desc                = "A small plate, suitable for serving food."
	material            = /decl/material/solid/stone/ceramic
	icon                = 'icons/obj/food/plates/small_plate.dmi'
	icon_state          = ICON_STATE_WORLD
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class             = ITEM_SIZE_SMALL
	var/is_dirty

/obj/item/plate/Destroy()
	if(istype(loc, /obj/item/chems/food))
		var/obj/item/chems/food/food = loc
		if(food.plate == src)
			food.plate = null
	return ..()

/obj/item/plate/proc/make_dirty(obj/item/chems/food/food)
	if(!is_dirty)
		is_dirty = food?.filling_color || COLOR_WHITE
		update_icon()

/obj/item/plate/clean(clean_forensics = TRUE)
	. = ..()
	if(is_dirty)
		is_dirty = null
		update_icon()

/obj/item/plate/on_update_icon()
	. = ..()
	if(is_dirty)
		var/image/I = image(icon, "[icon_state]-dirty")
		I.appearance_flags |= RESET_COLOR
		I.color = is_dirty
		add_overlay(I)

/obj/item/plate/proc/try_plate_food(obj/item/chems/food/food, mob/user)
	if(food.plate)
		to_chat(user, SPAN_WARNING("\The [food] has already been plated."))
		return
	if(ismob(loc))
		var/mob/M = loc
		if(!M.try_unequip(src))
			return
	forceMove(food)
	food.plate = src
	user?.visible_message(SPAN_NOTICE("\The [user] places \the [food] on \the [src]."))
	food.update_icon()

/obj/item/plate/attackby(obj/item/W, mob/living/user)
	// Plating food.
	if(istype(W, /obj/item/chems/food))
		if(!user.try_unequip(W))
			return TRUE
		try_plate_food(W, user)
		return TRUE
	return ..()

/obj/item/plate/platter
	name     = "platter"
	desc     = "A large white platter, suitable for serving cakes or other large food."
	icon     = 'icons/obj/food/plates/platter.dmi'
	material = /decl/material/solid/glass
	w_class  = ITEM_SIZE_NORMAL

/obj/item/plate/tray
	name     = "tray"
	desc     = "A large tray, suitable for serving several servings of food."
	icon     = 'icons/obj/food/plates/tray.dmi'
	material = /decl/material/solid/organic/plastic
	w_class  = ITEM_SIZE_NORMAL
