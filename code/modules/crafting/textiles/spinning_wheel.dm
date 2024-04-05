/obj/structure/textiles/spinning_wheel

	name                 = "spinning wheel"
	icon                 = 'icons/obj/structures/spindle.dmi'
	product_type         = /obj/item/stack/material/thread

	var/const/MAX_LOADED = 5
	var/list/loaded

/obj/structure/textiles/spinning_wheel/Destroy()
	QDEL_NULL_LIST(loaded)
	return ..()

/obj/structure/textiles/spinning_wheel/on_update_icon()
	..()

	icon_state = initial(icon_state)

	if(length(loaded))
		var/obj/item/thing = loaded[1]
		var/image/I = image(icon, "[icon_state]-loaded")
		I.color = thing.get_color()
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

	if(working)
		icon_state = "[icon_state]-working"

/obj/structure/textiles/spinning_wheel/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

	if(W.has_textile_fibers(W))
		if(length(loaded) >= MAX_LOADED)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stocked and ready for spinning."))
			return TRUE

		if(user.try_unequip(W, src))
			LAZYADD(loaded, W)
			to_chat(user, SPAN_NOTICE("You prepare \the [src] with \the [W]."))
			update_icon()
		return TRUE

	return ..()

/obj/structure/textiles/spinning_wheel/attack_hand(mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

	if(user.a_intent == I_GRAB)
		if(!length(loaded))
			to_chat(user, SPAN_WARNING("\The [src] has no fibers to remove."))
		else
			var/obj/item/thing = loaded[1]
			to_chat(user, SPAN_NOTICE("You remove \the [thing] from \the [src]."))
			thing.dropInto(loc)
			user.put_in_hands(thing)
			LAZYREMOVE(loaded, thing)
			update_icon()
		return TRUE

	if(!length(loaded))
		to_chat(user, SPAN_WARNING("\The [src] needs to be prepared with fibers before you can spin anything."))
		return TRUE

	working = TRUE
	update_icon()
	var/processed = 0
	while(length(loaded) && user.do_skilled(5 SECONDS, work_skill, src))
		if(!length(loaded) || QDELETED(src) || QDELETED(user))
			break

		var/obj/item/loaded_fiber = loaded[1]
		LAZYREMOVE(loaded, loaded_fiber)

		if(loaded_fiber)

			// TODO: handle blended yarn?
			var/list/total_waste   = list()
			var/list/total_fibers  = list()
			var/list/loaded_fibers = loaded_fiber.get_contained_matter()
			for(var/mat in loaded_fibers)
				var/decl/material/check_material = GET_DECL(mat)
				if(check_material.has_textile_fibers)
					total_fibers[check_material] += loaded_fibers[mat]
				else
					total_waste[check_material.type] += loaded_fibers[mat]

			for(var/decl/material/fiber_mat as anything in total_fibers)
				var/obj/item/stack/material/product_ref = product_type
				var/produced = max(1, round(total_fibers[fiber_mat] / (initial(product_ref.matter_multiplier) * SHEET_MATERIAL_AMOUNT)))
				var/obj/item/stack/thread = new product_type(get_turf(src), produced, fiber_mat.type)
				if(isitem(thread))
					if(loaded_fiber.paint_color)
						thread.set_color(loaded_fiber.paint_color)
					if(istype(thread))
						thread.add_to_stacks(user, TRUE)

			if(length(total_waste))
				var/obj/item/debris/scraps/scraps = new(get_turf(src))
				scraps.matter = total_waste
				scraps.update_primary_material()

		processed++
		QDEL_NULL(loaded_fiber)
		update_icon()

	if(processed && !QDELETED(user))
		to_chat(user, SPAN_NOTICE("You finish working at \the [src], having spun [processed] length\s of thread."))

	working = FALSE
	update_icon()
	return TRUE
