/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food/containers/pizzabox.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/cardboard

	var/const/RISKY_PIZZA_STACK = 6
	var/const/MAXIMUM_PIZZA_STACK = 15
	var/open = FALSE // Is the box open?
	var/image/messy_overlay
	var/obj/item/food/sliceable/pizza/pizza
	var/list/stacked_boxes
	var/box_tag
	var/box_tag_color = COLOR_BLACK

/obj/item/pizzabox/Initialize(ml, material_key)
	. = ..()
	if(ispath(pizza))
		pizza = new pizza(src)
	if(open)
		open = FALSE
		toggle_open()
	else if(box_tag || pizza)
		update_strings()
		update_icon()
	// We care about our own moved event in case of structural failure.
	events_repository.register(/decl/observ/moved, src, src, PROC_REF(check_stack_failure))

/obj/item/pizzabox/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && length(stacked_boxes))
		var/i = 1
		for(var/obj/item/pizzabox/box in stacked_boxes)
			var/image/I = box.get_mob_overlay(user_mob, slot, bodypart, use_fallback_if_icon_missing, TRUE)
			if(I)
				I.pixel_y = i * 3
				I.pixel_x = pick(-1,0,1)
				overlay.overlays += I
				i++
	. = ..()

// Tossing a pizza around can have terrible effects...
/obj/item/pizzabox/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	..()
	return FALSE

/obj/item/pizzabox/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && user?.a_intent == I_HURT && user != target)
		jostle_pizza()
		explode_stack()

/obj/item/pizzabox/proc/jostle_pizza()
	if(pizza && !pizza.ruined && prob(20))
		pizza.ruin()
	if(!open && prob(30))
		toggle_open()
	else
		if(open)
			update_icon()
		update_strings()

/obj/item/pizzabox/proc/explode_stack()
	var/turf/our_turf = get_turf(src)
	if(!our_turf || !LAZYLEN(stacked_boxes))
		return
	while(LAZYLEN(stacked_boxes))
		var/obj/item/pizzabox/top_box = stacked_boxes[LAZYLEN(stacked_boxes)]
		LAZYREMOVE(stacked_boxes, top_box)
		top_box.throw_at(get_edge_target_turf(our_turf, pick(global.alldirs)), 1, 1) // just enough to bonk people
	update_strings()
	update_icon()
	if(ismob(loc))
		var/mob/owner = loc
		owner.update_inhand_overlays()

// This is disgusting, but I can't work out a good way to catch
// the end of a throw regardless of whether or not it hit something.
/obj/item/pizzabox/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = ..()
	wait_for_throw_end_then_spill()

/obj/item/pizzabox/proc/wait_for_throw_end_then_spill()
	set waitfor = FALSE
	while(!QDELETED(throwing))
		sleep(1)
		if(QDELETED(src))
			return
	jostle_pizza()
	explode_stack()

/obj/item/pizzabox/proc/check_stack_failure()

	if(isobj(loc) || LAZYLEN(stacked_boxes)+1 < RISKY_PIZZA_STACK)
		return // no stack, no worries

	var/fell_off = 0
	var/turf/our_turf = get_turf(src)
	if(!isturf(our_turf))
		return // shouldn't happen due to checks above

	var/mob/mover = loc
	var/moving_deliberately = ismob(mover) && MOVING_DELIBERATELY(mover)
	while(LAZYLEN(stacked_boxes)+1 > RISKY_PIZZA_STACK)
		var/danger_zone = ((LAZYLEN(stacked_boxes)+1)-RISKY_PIZZA_STACK) * 10
		if(moving_deliberately)
			danger_zone *= 0.5
		if(danger_zone <= 0 || !prob(danger_zone))
			break // we are safe... for now...
		var/obj/item/pizzabox/top_box = stacked_boxes[LAZYLEN(stacked_boxes)]
		LAZYREMOVE(stacked_boxes, top_box)
		top_box.dropInto(our_turf)
		top_box.throw_at(get_edge_target_turf(our_turf, pick(global.alldirs)), 1, 1) // just enough to bonk people
		fell_off++
	if(fell_off > 0)
		our_turf.visible_message(SPAN_DANGER("[fell_off] [fell_off == 1 ? "pizza" : "pizzas"] [fell_off == 1 ? "falls" : "fall"] off the stack!"))
		update_strings()
		update_icon()
		if(ismob(mover))
			mover.update_inhand_overlays()
	else if(prob(15) && ismob(mover))
		to_chat(loc, SPAN_WARNING("The stack of pizza boxes sways alarmingly..."))

/obj/item/pizzabox/proc/toggle_open()
	if(LAZYLEN(stacked_boxes))
		return FALSE
	open = !open
	if(open && pizza && !messy_overlay)
		var/mess_state = "[pizza.icon_state]_mess"
		if(check_state_in_icon(mess_state, pizza.icon))
			messy_overlay = image(pizza.icon, mess_state)
	update_icon()
	compile_overlays() // to avoid our tags and messy state flickering
	return TRUE

/obj/item/pizzabox/proc/update_strings()
	name = initial(name)
	var/list/desc_strings = list(initial(desc))
	if(open && pizza)
		desc_strings += "It appears to have \a [pizza] inside."
	else if(length(stacked_boxes))
		name = "stack of pizza boxes"
		desc_strings += "A pile of boxes suited for pizzas. There appears to be [length(stacked_boxes)+1] boxes in the pile."
		var/obj/item/pizzabox/topbox = stacked_boxes[length(stacked_boxes)]
		if(topbox?.box_tag)
			desc_strings += "The box on top has a tag reading: '[topbox.box_tag]'."
	else if(box_tag)
		desc_strings += "The box has a tag reading: '[box_tag]'."
	desc = jointext(desc_strings, " ")

/obj/item/pizzabox/on_update_icon()
	. = ..()
	// Update our own appearance.
	icon_state = get_world_inventory_state()
	if(open)
		icon_state = "[icon_state]_open"
		if(messy_overlay)
			add_overlay(messy_overlay)
		if(pizza)
			var/mutable_appearance/pizzaimg = new(pizza)
			pizzaimg.layer = FLOAT_LAYER
			pizzaimg.plane = FLOAT_PLANE
			pizzaimg.pixel_x = 0
			pizzaimg.pixel_y = -3
			pizzaimg.pixel_z = 0
			pizzaimg.pixel_w = 0
			add_overlay(pizzaimg)
		return

	// If we're closed, draw our tag and all the pizzas in the stack.
	if(box_tag)
		add_overlay(overlay_image(icon, "[icon_state]_tag", box_tag_color, RESET_COLOR))

	// Add all the boxes in the stack.
	var/i = 1
	for(var/obj/item/pizzabox/pizza_box in stacked_boxes)
		var/mutable_appearance/box_img = new(pizza_box)
		box_img.layer = FLOAT_LAYER
		box_img.plane = FLOAT_PLANE
		box_img.pixel_y = i * 3 + pick(-1,0,1)
		box_img.pixel_x = pick(-1,0,1)
		box_img.pixel_z = 0
		box_img.pixel_w = 0
		add_overlay(box_img)
		i++

/obj/item/pizzabox/attack_hand(mob/user)

	if(open && pizza && user.a_intent != I_GRAB)
		if(user.check_dexterity(DEXTERITY_HOLD_ITEM))
			user.put_in_hands(pizza)
			to_chat(user, SPAN_NOTICE("You take \the [pizza] out of \the [src]."))
			pizza = null
			update_icon()
		return TRUE

	var/box_count = LAZYLEN(stacked_boxes)
	if(box_count && user.is_holding_offhand(src) && user.check_dexterity(DEXTERITY_HOLD_ITEM))
		var/obj/item/pizzabox/box = stacked_boxes[box_count]
		LAZYREMOVE(stacked_boxes, box)
		user.put_in_hands(box)
		to_chat(user, SPAN_WARNING("You remove the topmost [src] from your hand."))

		if((LAZYLEN(stacked_boxes)+1) == (RISKY_PIZZA_STACK-1))
			to_chat(user, SPAN_NOTICE("The stack looks a bit more stable. It's probably safe to carry now."))

		box.update_icon()
		box.update_strings()
		update_icon()
		update_strings()
		return TRUE

	return ..()

/obj/item/pizzabox/attack_self(mob/user)
	if(toggle_open())
		return TRUE
	return ..()

/obj/item/pizzabox/attackby(obj/item/I, mob/user)

	// Stacking pizza boxes.
	if(istype(I, /obj/item/pizzabox))
		var/obj/item/pizzabox/box = I
		if(box.open)
			to_chat(user, SPAN_WARNING("You need to close \the [box] first!"))
			return TRUE

		if(open)
			to_chat(user, SPAN_WARNING("You need to close \the [src] first!"))
			return TRUE

		var/stack_count = (LAZYLEN(stacked_boxes) + LAZYLEN(box.stacked_boxes) + 2)
		if(stack_count > MAXIMUM_PIZZA_STACK)
			to_chat(user, SPAN_WARNING("That pizza stack would be too high!"))
			return TRUE

		if(!user.try_unequip(box, src))
			return TRUE

		LAZYDISTINCTADD(stacked_boxes, box)
		if(box.stacked_boxes)
			LAZYDISTINCTADD(stacked_boxes, box.stacked_boxes)
			LAZYCLEARLIST(box.stacked_boxes)
		update_icon()
		update_strings()
		box.update_icon()
		box.update_strings()

		user.visible_message(SPAN_NOTICE("\The [user] stacks \the [box] on top of \the [src]."))
		if(stack_count == RISKY_PIZZA_STACK)
			to_chat(user, SPAN_WARNING("The stack sags a bit. You have a bad feeling about carrying it..."))

		return TRUE

	// Putting a pizza back in the box.
	if(istype(I, /obj/item/food/sliceable/pizza))

		if(!open)
			to_chat(user, SPAN_WARNING("Open \the [src] first!"))
			return TRUE

		if(pizza)
			to_chat(user, SPAN_WARNING("\The [src] already has \the [pizza] inside!"))
			return TRUE

		if(!user.try_unequip(I, src))
			return TRUE

		pizza = I
		update_strings()
		update_icon()
		user.visible_message(SPAN_NOTICE("\The [user] slides \the [I] into \the [src]."))
		return TRUE

	// Appending to the tag.
	if(IS_PEN(I))

		if(open)
			to_chat(user, SPAN_WARNING("Close \the [src] first!"))
			return TRUE

		var/tag_string = sanitize(input("Enter what you want to add to the tag.", "Write", null, null) as text|null, 30)
		if(!CanPhysicallyInteract(user) || !tag_string || open)
			return TRUE

		var/box_count = LAZYLEN(stacked_boxes)
		var/obj/item/pizzabox/tagging_box = (box_count > 0) ? stacked_boxes[box_count] : src
		tagging_box.box_tag = copytext("[tagging_box.box_tag][tag_string]", 1, 30)
		tagging_box.box_tag_color = I.get_tool_property(TOOL_PEN, TOOL_PROP_COLOR) || COLOR_BLACK
		user.visible_message(SPAN_NOTICE("\The [user] writes something on \the [src]."))
		update_strings()
		update_icon()
		return TRUE

	return ..()

/obj/item/pizzabox/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/open_pizza_box)

/decl/interaction_handler/open_pizza_box
	expected_target_type = /obj/item/pizzabox

/decl/interaction_handler/open_pizza_box/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/obj/item/pizzabox/box = target
		. = LAZYLEN(box.stacked_boxes) <= 0

/decl/interaction_handler/open_pizza_box/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/pizzabox/box = target
	box.toggle_open()

// Subtypes below.
/obj/item/pizzabox/margherita
	pizza = /obj/item/food/sliceable/pizza/margherita
	box_tag = "Margherita Deluxe"
	box_tag_color = COLOR_DARK_RED

/obj/item/pizzabox/vegetable
	pizza = /obj/item/food/sliceable/pizza/vegetablepizza
	box_tag = "Gourmet Vegetable"
	box_tag_color = COLOR_PAKISTAN_GREEN

/obj/item/pizzabox/mushroom
	pizza = /obj/item/food/sliceable/pizza/mushroompizza
	box_tag = "Mushroom Special"
	box_tag_color = COLOR_PURPLE_GRAY

/obj/item/pizzabox/meat
	pizza = /obj/item/food/sliceable/pizza/meatpizza
	box_tag = "Meatlover's Supreme"
	box_tag_color = COLOR_BROWN_ORANGE
