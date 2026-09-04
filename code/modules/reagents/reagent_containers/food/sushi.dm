/obj/item/food/sushi
	name = "sushi"
	desc = "A small, neatly wrapped morsel. Itadakimasu!"
	icon = 'icons/obj/sushi.dmi'
	icon_state = "sushi_rice"
	bitesize = 1
	allergen_flags = ALLERGEN_FISH
	var/fish_type = "fish"

/obj/item/food/sushi/Initialize(mapload, material_key, skip_plate = FALSE, obj/item/food/rice, obj/item/food/topping)
	. = ..(mapload, material_key, skip_plate)

	if(istype(topping))
		for(var/taste_thing in topping.nutriment_desc)
			if(!nutriment_desc[taste_thing]) nutriment_desc[taste_thing] = 0
			nutriment_desc[taste_thing] += topping.nutriment_desc[taste_thing]
		if(istype(topping, /obj/item/food/sashimi))
			var/obj/item/food/sashimi/sashimi = topping
			fish_type = sashimi.fish_type
		else if(istype(topping, /obj/item/food/butchery))
			var/obj/item/food/butchery/meat = topping
			fish_type = meat.meat_name
		else if(istype(topping, /obj/item/food/friedegg))
			fish_type = "egg"
		else if(istype(topping, /obj/item/food/tofu))
			fish_type = "tofu"

		if(topping.reagents)
			topping.reagents.trans_to(src, REAGENT_TOTAL_VOLUME(topping.reagents))

		var/mob/M = topping.loc
		if(istype(M)) M.drop_from_inventory(topping)
		qdel(topping)

	if(istype(rice))
		if(rice.reagents)
			rice.reagents.trans_to(src, 1)
		if(!rice.reagents || !REAGENT_TOTAL_VOLUME(rice.reagents))
			var/mob/M = rice.loc
			if(istype(M)) M.drop_from_inventory(rice)
			qdel(rice)
	update_icon()

/obj/item/food/sushi/on_update_icon()
	. = ..()
	name = "[fish_type] sushi"
	add_overlay(list("[fish_type]", "nori"))

/obj/item/food/sushi/apply_filling_overlay()
	return //Bypass searching through the whole icon file for a filling icon

/////////////
// SASHIMI //
/////////////
/obj/item/food/sashimi
	name = "sashimi"
	icon = 'icons/obj/sushi.dmi'
	desc = "Thinly sliced raw fish. Tasty."
	icon_state = "sashimi"
	gender = PLURAL
	bitesize = 1
	slice_num = 1
	slice_path = /obj/item/food/butchery/chopped
	allergen_flags = ALLERGEN_FISH
	var/fish_type = "fish"
	var/slices = 1

/obj/item/food/sashimi/Initialize(mapload, material_key, skip_plate = FALSE, _fish_type)
	. = ..(mapload, material_key, skip_plate)
	if(_fish_type)
		fish_type = _fish_type
	name = "[fish_type] sashimi"
	update_icon()

/obj/item/food/sashimi/on_update_icon()
	. = ..()
	icon_state = "sashimi_base"
	var/list/adding = list()
	var/slice_offset = (slices-1)*2
	for(var/slice = 1 to slices)
		var/offset = slice_offset-((slice-1)*4)
		adding += image(icon = icon, icon_state = "sashimi", pixel_x = offset, pixel_y = offset)
	add_overlay(adding)

/obj/item/food/sashimi/attackby(var/obj/item/used_item, var/mob/user)
	if(!(locate(/obj/structure/table) in loc))
		return ..()

	// Add more slices.
	if(istype(used_item, /obj/item/food/sashimi))
		var/obj/item/food/sashimi/other_sashimi = used_item
		if(slices + other_sashimi.slices > 5)
			to_chat(user, SPAN_WARNING("Show some restraint, would you?"))
			return TRUE
		if(!user.try_unequip(used_item))
			return TRUE
		slices += other_sashimi.slices
		bitesize = slices
		update_icon()
		if(used_item.reagents)
			used_item.reagents.trans_to(src, REAGENT_TOTAL_VOLUME(used_item.reagents))
		qdel(used_item)
		return TRUE

	// Make sushi.
	if(istype(used_item, /obj/item/food/boiledrice))
		if(!user.try_unequip(used_item))
			return TRUE
		var/obj/item/food/boiledrice/used_rice = used_item
		if(used_rice.try_make_sushi(src, user))
			return TRUE
		return TRUE
	. = ..()

/obj/item/food/sashimi/handle_utensil_cutting(obj/item/tool, mob/user)
	slice_num = slices // to avoid wasting it
	. = ..()
	if(length(.))
		for(var/obj/item/food/food in .)
			food.cooked_food = cooked_food
			food.add_allergen_flags(allergen_flags)
		if(fish_type)
			for(var/obj/item/food/butchery/meat in .)
				meat.set_meat_name(fish_type)

 // Used for turning rice into sushi.
/obj/item/food/boiledrice/attackby(var/obj/item/used_item, var/mob/user)
	if(try_make_sushi(used_item, user, reference_item = src)) // since we're the thing being clicked, we want to be the reference item
		return TRUE
	return ..()

// Used for turning other food into sushi.
/obj/item/food/boiledrice/resolve_attackby(atom/attacked_object, mob/user, click_params)
	if(try_make_sushi(attacked_object, user))
		return TRUE
	return ..()

// reference_item is the item whose loc and pixel offsets we're using
/obj/item/food/boiledrice/proc/try_make_sushi(obj/item/food/used_item, mob/user, obj/item/reference_item = used_item)
	var/static/list/non_fish_sushi_typecache
	if(!non_fish_sushi_typecache)
		non_fish_sushi_typecache = typecacheof(list(
			/obj/item/food/friedegg,
			/obj/item/food/tofu,
			/obj/item/food/butchery/cutlet,
			/obj/item/food/spider,
			/obj/item/food/butchery/meat/chicken
		))
	// before you get confused like i did: yes, raw chicken sushi exists
	// it's called torisashi and it's... dubiously safe
	// raw beef could also be used i guess, like tataki or etc, or carpaccio/crudo instead of sashimi
	// you could just check the cooked_food var for non-fish butchery items but i decided against it
	if(!used_item || !(locate(/obj/structure/table) in reference_item.loc))
		return FALSE
	if(istype(used_item, /obj/item/food/sashimi))
		var/obj/item/food/sashimi/used_sashimi = used_item
		if(used_sashimi.slices > 1)
			to_chat(user, SPAN_WARNING("Putting more than one slice of fish on your sushi is just greedy."))
			return TRUE
	else if(!is_type_in_typecache(used_item, non_fish_sushi_typecache))
		return FALSE
	var/obj/item/food/sushi/result = new /obj/item/food/sushi(get_turf(reference_item), null, TRUE, src, used_item)
	// copy offsets from the item on the table, so it doesn't jump around
	// todo: a helper for this that takes into account center_of_mass?
	result.pixel_x = reference_item.pixel_x
	result.pixel_y = reference_item.pixel_y
	result.pixel_z = reference_item.pixel_z
	return TRUE
