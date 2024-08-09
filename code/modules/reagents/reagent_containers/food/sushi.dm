/obj/item/food/sushi
	name = "sushi"
	desc = "A small, neatly wrapped morsel. Itadakimasu!"
	icon = 'icons/obj/sushi.dmi'
	icon_state = "sushi_rice"
	bitesize = 1
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
			topping.reagents.trans_to(src, topping.reagents.total_volume)

		var/mob/M = topping.loc
		if(istype(M)) M.drop_from_inventory(topping)
		qdel(topping)

	if(istype(rice))
		if(rice.reagents)
			rice.reagents.trans_to(src, 1)
		if(!rice.reagents || !rice.reagents.total_volume)
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

/obj/item/food/sashimi/attackby(var/obj/item/I, var/mob/user)
	if(!(locate(/obj/structure/table) in loc))
		return ..()

	// Add more slices.
	if(istype(I, /obj/item/food/sashimi))
		var/obj/item/food/sashimi/other_sashimi = I
		if(slices + other_sashimi.slices > 5)
			to_chat(user, "<span class='warning'>Show some restraint, would you?</span>")
			return
		if(!user.try_unequip(I))
			return
		slices += other_sashimi.slices
		bitesize = slices
		update_icon()
		if(I.reagents)
			I.reagents.trans_to(src, I.reagents.total_volume)
		qdel(I)
		return

	// Make sushi.
	if(istype(I, /obj/item/food/boiledrice))
		if(slices > 1)
			to_chat(user, "<span class='warning'>Putting more than one slice of fish on your sushi is just greedy.</span>")
		else
			if(!user.try_unequip(I))
				return
			new /obj/item/food/sushi(get_turf(src), null, TRUE, I, src)
		return
	. = ..()

 // Used for turning rice into sushi.
/obj/item/food/boiledrice/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc))
		if(istype(I, /obj/item/food/sashimi))
			var/obj/item/food/sashimi/sashimi = I
			if(sashimi.slices > 1)
				to_chat(user, "<span class='warning'>Putting more than one slice of fish on your sushi is just greedy.</span>")
			else
				new /obj/item/food/sushi(get_turf(src), null, TRUE, src, I)
			return
		var/static/list/sushi_types = list(
			/obj/item/food/friedegg,
			/obj/item/food/tofu,
			/obj/item/food/butchery/cutlet,
			/obj/item/food/butchery/cutlet/raw,
			/obj/item/food/spider,
			/obj/item/food/butchery/meat/chicken
		)
		if(is_type_in_list(I, sushi_types))
			new /obj/item/food/sushi(get_turf(src), null, TRUE, src, I)
			return
	. = ..()
// Used for turning other food into sushi.
/obj/item/food/friedegg/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/food/boiledrice))
		new /obj/item/food/sushi(get_turf(src), null, TRUE, I, src)
		return
	. = ..()
/obj/item/food/tofu/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/food/boiledrice))
		new /obj/item/food/sushi(get_turf(src), null, TRUE, I, src)
		return
	. = ..()
/obj/item/food/butchery/cutlet/raw/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/food/boiledrice))
		new /obj/item/food/sushi(get_turf(src), null, TRUE, I, src)
		return
	. = ..()
/obj/item/food/butchery/cutlet/attackby(var/obj/item/I, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(I, /obj/item/food/boiledrice))
		new /obj/item/food/sushi(get_turf(src), null, TRUE, I, src)
		return
	. = ..()
// End non-fish sushi.
