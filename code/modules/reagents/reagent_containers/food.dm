///////////
// Foods //
///////////
//Subtypes of /obj/item/chems/food are food items that people consume whole. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Food can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want an effect, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use regenerative serum).

/obj/item/chems/food
	name = "snack"
	desc = "Yummy!"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	randpixel = 6
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	item_flags = null
	material = /decl/material/liquid/nutriment
	possible_transfer_amounts = null
	volume = 50
	center_of_mass = @'{"x":16,"y":16}'
	w_class = ITEM_SIZE_SMALL
	abstract_type = /obj/item/chems/food

	var/cooked_food = FALSE // Indicates the food should give a positive stress effect on eating. This is set to true if the food is created by a recipe.
	var/bitesize = 1
	var/bitecount = 0
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/nutriment_amt = 0
	var/nutriment_type = /decl/material/liquid/nutriment // Used to determine which base nutriment type is spawned for this item.
	var/list/nutriment_desc = list("food" = 1)    // List of flavours and flavour strengths. The flavour strength text is determined by the ratio of flavour strengths in the snack.
	var/list/eat_sound = 'sound/items/eatfood.ogg'
	var/filling_color = "#ffffff" //Used by sandwiches.
	var/trash
	var/obj/item/plate/plate
	var/list/attack_products //Items you can craft together. Like bomb making, but with food and less screwdrivers.
	// Uses format list(ingredient = result_type). The ingredient can be a typepath or a kitchen_tag string (used for mobs or plants)

/obj/item/chems/food/can_be_injected_by(var/atom/injector)
	return TRUE

/obj/item/chems/food/standard_pour_into(mob/user, atom/target)
	return FALSE

/obj/item/chems/food/update_container_name()
	return FALSE

/obj/item/chems/food/update_container_desc()
	return FALSE

/obj/item/chems/food/Initialize()
	.=..()
	amount_per_transfer_from_this = bitesize
	if(ispath(plate))
		plate = new plate(src)

/obj/item/chems/food/attack_self(mob/user)
	attack(user, user)

/obj/item/chems/food/dragged_onto(var/mob/user)
	attack(user, user)

/obj/item/chems/food/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(plate)
		to_chat(user, SPAN_NOTICE("\The [src] has been arranged on \a [plate]."))
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten by someone!"))
	else if (bitecount<=3)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten [bitecount] time\s!"))
	else
		to_chat(user, SPAN_NOTICE("\The [src] was bitten multiple times!"))

/obj/item/chems/food/attackby(obj/item/W, mob/living/user)
	if(!istype(user))
		return
	if(istype(W,/obj/item/storage))
		..()// -> item/attackby()
		return

	// Plating food.
	if(istype(W, /obj/item/plate))
		var/obj/item/plate/plate = W
		plate.try_plate_food(src, user)
		return TRUE

	// Eating with forks
	if(istype(W,/obj/item/kitchen/utensil))
		var/obj/item/kitchen/utensil/U = W
		if(U.scoop_food)
			if(!U.reagents)
				U.create_reagents(5)

			if (U.reagents.total_volume > 0)
				to_chat(user, "<span class='warning'>You already have something on your [U].</span>")
				return

			user.visible_message( \
				"\The [user] scoops up some [src] with \the [U]!", \
				"<span class='notice'>You scoop up some [src] with \the [U]!</span>" \
			)

			src.bitecount++
			U.overlays.Cut()
			U.loaded = "[src]"
			var/image/I = new(U.icon, "loadedfood")
			I.color = src.filling_color
			U.overlays += I

			if(!reagents)
				PRINT_STACK_TRACE("A snack [type] failed to have a reagent holder when attacked with a [W.type]. It was [QDELETED(src) ? "" : "not"] being deleted.")
			else
				reagents.trans_to_obj(U, min(reagents.total_volume,5))
				if (reagents.total_volume <= 0)
					qdel(src)
			return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/storage/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W) || istype(W,/obj/item/chems/condiment))
				return
			if(!user.try_unequip(W, src))
				return

			to_chat(user, "<span class='warning'>You slip \the [W] inside \the [src].</span>")
			add_fingerprint(user)
			W.forceMove(src)
			return

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, "<span class='warning'>You cannot slice \the [src] here! You need a table or at least a tray to do it.</span>")
				return

			var/slices_lost = 0
			if (W.w_class > ITEM_SIZE_NORMAL)
				user.visible_message("<span class='notice'>\The [user] crudely slices \the [src] with [W]!</span>", "<span class='notice'>You crudely slice \the [src] with your [W]!</span>")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message("<span class='notice'>\The [user] slices \the [src]!</span>", "<span class='notice'>You slice \the [src]!</span>")

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
			qdel(src)
			return

	var/create_type
	for(var/key in attack_products)
		if(ispath(key) && !istype(W, key))
			continue
		if(istext(key))
			if(!istype(W, /obj/item/chems/food/grown))
				continue
			var/obj/item/chems/food/grown/G = W
			if(G.seed.kitchen_tag && G.seed.kitchen_tag != key)
				continue
		create_type = attack_products[key]
	if (!ispath(create_type))
		return
	if(!user.canUnEquip(src))
		return

	var/obj/item/chems/food/result = new create_type()
	//If the snack was in your hands, the result will be too
	if (src in user.get_held_item_slots())
		user.drop_from_inventory(src)
		user.put_in_hands(result)
	else
		result.dropInto(loc)

	qdel(W)
	qdel(src)
	to_chat(user, SPAN_NOTICE("You make \the [result]!"))

/obj/item/chems/food/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/chems/food/proc/on_dry(var/atom/newloc)
	drop_plate(get_turf(newloc))
	if(dried_type == type)
		SetName("dried [name]")
		color = "#a38463"
		dry = TRUE
		if(isloc(newloc))
			forceMove(newloc)
		return src
	. = new dried_type(newloc || get_turf(src))
	qdel(src)

/obj/item/chems/food/proc/drop_plate(var/drop_loc)
	if(istype(plate))
		plate.dropInto(drop_loc || loc)
		plate.make_dirty(src)
	plate = null

/obj/item/chems/food/physically_destroyed()
	drop_plate()
	return ..()

/obj/item/chems/food/Destroy()
	QDEL_NULL(plate)
	trash = null
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

/obj/item/chems/food/proc/update_food_appearance_from(var/obj/item/donor, var/food_color, var/copy_donor_appearance = TRUE)
	filling_color = food_color
	if(copy_donor_appearance)
		appearance = donor
		color = food_color
		if(istype(donor, /obj/item/holder))
			var/matrix/M = matrix()
			M.Turn(90)
			M.Translate(1,-6)
			transform = M
	update_icon()

/obj/item/chems/food/on_update_icon()
	underlays.Cut()
	. = ..()
	//Since other things that don't have filling override this, slap it into its own proc to avoid the overhead of scanning through the icon file
	apply_filling_overlay() //#TODO: Maybe generalise food item icons.
	// If we have a plate, add it to our icon.
	if(plate)
		var/image/I = new
		I.appearance = plate
		I.layer = FLOAT_LAYER
		I.plane = FLOAT_PLANE
		I.pixel_x = 0
		I.pixel_y = 0
		I.pixel_z = 0
		I.pixel_w = 0
		I.appearance_flags |= RESET_TRANSFORM|RESET_COLOR
		underlays += list(I)

/obj/item/chems/food/proc/apply_filling_overlay()
	if(check_state_in_icon("[icon_state]_filling", icon))
		add_overlay(overlay_image(icon, "[icon_state]_filling", filling_color))

//Since we automatically create some reagents types for the nutriments, make sure we call this proc when overriding it
/obj/item/chems/food/populate_reagents()
	. = ..()
	SHOULD_CALL_PARENT(TRUE)
	if(nutriment_amt)
		reagents.add_reagent(nutriment_type, nutriment_amt, nutriment_desc)
