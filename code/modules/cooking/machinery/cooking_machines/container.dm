//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/chems/cooking_container
	icon = 'icons/obj/cooking_machines.dmi'
	var/shortname
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	volume = 80//Maximum units of reagents
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	var/list/insertable = list(
		/obj/item/chems/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/flame/candle,
		/obj/item/stack/material/rods,
		/obj/item/organ/internal/brain
		)
	var/appliancetype // Bitfield, uses the same as appliances
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/stainlesssteel

/obj/item/chems/cooking_container/examine(var/mob/user)
	. = ..()
	if(length(contents))
		to_chat(user, SPAN_NOTICE(get_content_info()))
	if(reagents.total_volume)
		to_chat(user, SPAN_NOTICE(get_reagent_info()))

// So we can smack people with frying pans.
/obj/item/chems/cooking_container/attack(var/mob/M, var/mob/user, var/def_zone)
	if(can_operate(M) && do_surgery(M, user, src))
		return
	if(!reagents.total_volume && user.a_intent == I_HURT)
		return ..()

/obj/item/chems/cooking_container/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!ATOM_IS_OPEN_CONTAINER(src) || !proximity) //Is the container open & are they next to whatever they're clicking?
		return TRUE //If not, do nothing.
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return TRUE
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return TRUE
	if(standard_feed_mob(user, target))
		return TRUE
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user,target))
			return TRUE
		if(reagents?.total_volume)
			to_chat(user, SPAN_NOTICE("You splash the contents of \the [src] onto [target].")) //They are on harm intent, aka wanting to spill it.
			reagents.splash(target, reagents.total_volume)
			return TRUE
	. = ..()

/obj/item/chems/cooking_container/proc/get_content_info()
	var/string = "It contains:</br><ul><li>"
	string += jointext(contents, "</li></br><li>") + "</li></ul>"
	return string

/obj/item/chems/cooking_container/proc/get_reagent_info()
	return "It contains [reagents.total_volume] units of reagents."

/obj/item/chems/cooking_container/MouseEntered(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && get_dist(usr, src) <= 2)
		params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
		var/description
		if(length(contents))
			description = get_content_info()
		if(reagents.total_volume)
			if(!description)
				description = ""
			description += get_reagent_info()
		openToolTip(usr, src, params, name, description)

/obj/item/chems/cooking_container/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/chems/cooking_container/attackby(var/obj/item/I, var/mob/user)
	if(is_type_in_list(I, insertable))
		if (!can_fit(I))
			to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
			return FALSE

		if(!user.unEquip(I))
			return
		I.forceMove(src)
		to_chat(user, SPAN_NOTICE("You put [I] into [src]."))
		return
	return ..()

/obj/item/chems/cooking_container/verb/empty()
	set src in oview(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."

	do_empty(usr)

/obj/item/chems/cooking_container/proc/do_empty(mob/user)
	if (!isliving(user))
		//Here we only check for ghosts. Animals are intentionally allowed to remove things from oven trays so they can eat it
		return

	if (user.stat || user.restrained() || user.incapacitated())
		to_chat(user, "<span class='notice'>You are in no fit state to do this.</span>")
		return

	if (!Adjacent(user))
		to_chat(user, "You can't reach [src] from here.")
		return

	if (!length(contents))
		to_chat(user, SPAN_WARNING("There's nothing in [src] you can remove!"))
		return

	for (var/contained in contents)
		var/atom/movable/AM = contained
		AM.forceMove(get_turf(src))

	to_chat(user, SPAN_NOTICE("You remove all the solid items from [src]."))

/obj/item/chems/cooking_container/proc/check_contents()
	if (!length(contents))
		if (!reagents?.total_volume)
			return CONTAINER_EMPTY
	else if (length(contents) == 1)
		if (!reagents?.total_volume)
			return CONTAINER_SINGLE
	return CONTAINER_MANY

/obj/item/chems/cooking_container/AltClick(var/mob/user)
	do_empty(user)

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/chems/cooking_container/proc/clear()
	QDEL_NULL_LIST(contents)
	reagents.clear_reagents()

/obj/item/chems/cooking_container/proc/label(var/number, var/CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (CT)
		return . + CT
	else if (LAZYLEN(contents))
		var/obj/O = locate() in contents
		return . + O.name //Just append the name of the first object
	else if (reagents.total_volume > 0)
		var/decl/material/M = reagents.get_primary_reagent_decl()
		return . + M.name//Append name of most voluminous reagent
	return . + "empty"


/obj/item/chems/cooking_container/proc/can_fit(var/obj/item/I)
	var/total = 0
	for (var/contained in contents)
		var/obj/item/J = contained
		total += J.w_class

	if((max_space - total) >= I.w_class)
		return TRUE


//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/chems/cooking_container/proc/soak_reagent(var/datum/reagents/holder)
	var/total = 0
	var/list/weights = list()
	for (var/contained in contents)
		var/obj/item/I = contained
		if (I.reagents && I.reagents.total_volume)
			total += I.reagents.total_volume
			weights[I] = I.reagents.total_volume

	if (total > 0)
		for (var/contained in contents)
			var/obj/item/I = contained
			if (weights[I])
				holder.trans_to(I, weights[I] / total)


/obj/item/chems/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "ovendish"
	max_space = 30
	volume = 120
	appliancetype = OVEN
	material = /decl/material/solid/stone/ceramic

/obj/item/chems/cooking_container/skillet
	name = "skillet"
	shortname = "skillet"
	desc = "Chuck ingredients in this to fry something on the stove."
	icon_state = "skillet"
	volume = 30
	force = 11
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = SKILLET

/obj/item/chems/cooking_container/saucepan
	name = "saucepan"
	shortname = "saucepan"
	desc = "Is it a pot? Is it a pan? It's a saucepan!"
	icon_state = "pan"
	volume = 90
	slot_flags = SLOT_HEAD
	force = 8
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = SAUCEPAN

/obj/item/chems/cooking_container/pot
	name = "cooking pot"
	shortname = "pot"
	desc = "Boil things with this. Maybe even stick 'em in a stew."
	icon_state = "pot"
	max_space = 50
	volume = 180
	force = 8
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = POT
	w_class = ITEM_SIZE_LARGE

/obj/item/chems/cooking_container/fryer
	name = "fryer basket"
	shortname = "basket"
	desc = "Put ingredients in this; designed for use with a deep fryer. Warranty void if used."
	icon_state = "basket"
	appliancetype = FRYER

/obj/item/chems/cooking_container/grill_grate/can_fit()
	if(length(contents) >= 3)
		return FALSE
	return TRUE

/obj/item/chems/cooking_container/plate
	name = "serving plate"
	shortname = "plate"
	desc = "A plate. You plate foods on this plate."
	icon_state = "plate"
	appliancetype = MIX
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	volume = 15 // for things like jelly sandwiches etc
	max_space = 25
	material = /decl/material/solid/stone/ceramic

/obj/item/chems/cooking_container/plate/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/kitchen/utensil))
		if(do_mix())
			user.visible_message("<b>\The [user]</b> stirs \the [src] with \the [I].", SPAN_NOTICE("You stir \the [src] with \the [I]."))
			return
	return ..()

/obj/item/chems/cooking_container/plate/proc/do_mix()
	if(!(length(contents) || reagents?.total_volume))
		return FALSE
	var/decl/recipe/recipe = select_recipe(src, appliance = appliancetype)
	if(!recipe)
		return FALSE
	var/list/results = recipe.make_food(src)
	var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
	for (var/result in results)
		var/atom/movable/AM = result
		AM.forceMove(temp)

	//making multiple copies of a recipe from one container. For example, tons of fries
	while (select_recipe(src, appliance = appliancetype) == recipe)
		var/list/TR = list()
		TR += recipe.make_food(src)
		for (var/result in TR) //Move results to buffer
			var/atom/movable/AM = result
			AM.forceMove(temp)
		results += TR

	for (var/r in results)
		var/obj/item/chems/food/snacks/R = r
		R.forceMove(src) //Move everything from the buffer back to the container

	QDEL_NULL(temp) //delete buffer object
	return TRUE

/obj/item/chems/cooking_container/plate/bowl
	name = "serving bowl"
	shortname = "bowl"
	desc = "A bowl. You bowl foods... wait, what?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	center_of_mass = list("x" = 17,"y" = 7)
	max_space = 30
	matter = list(DEFAULT_WALL_MATERIAL = 300)
	volume = 90
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60, 90]"
