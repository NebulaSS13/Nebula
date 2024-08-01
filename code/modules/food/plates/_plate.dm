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
	if(istype(loc, /obj/item/food))
		var/obj/item/food/food = loc
		if(food.plate == src)
			food.plate = null
	return ..()

/obj/item/plate/proc/make_dirty(obj/item/food/food)
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

// Return TRUE to terminate attacky past this proc.
/obj/item/plate/proc/try_plate_food(obj/item/food/food, mob/user)
	if(!istype(food))
		return FALSE
	if(food.plate)
		to_chat(user, SPAN_WARNING("\The [food] has already been plated."))
		return TRUE
	if(ismob(loc))
		var/mob/M = loc
		if(!M.try_unequip(src))
			return FALSE
	if(user && !user.try_unequip(food))
		return FALSE
	forceMove(food)
	food.plate = src
	user?.visible_message(SPAN_NOTICE("\The [user] places \the [food] on \the [src]."))
	food.update_icon()
	return TRUE

/obj/item/plate/attackby(obj/item/W, mob/living/user)
	// Plating food.
	if(try_plate_food(W, user))
		return TRUE
	return ..()

/obj/item/plate/platter
	name     = "platter"
	desc     = "A large white platter, suitable for serving cakes or other large food."
	icon     = 'icons/obj/food/plates/platter.dmi'
	material = /decl/material/solid/glass
	w_class  = ITEM_SIZE_NORMAL
