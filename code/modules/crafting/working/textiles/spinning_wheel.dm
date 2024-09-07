/obj/structure/working/spinning_wheel

	name         = "spinning wheel"
	desc         = "A pedal-operated wheel for spinning plant fibers into thread."
	icon         = 'icons/obj/structures/spinning_wheel.dmi'
	product_type = /obj/item/stack/material/thread
	work_sound   = /datum/composite_sound/spinning_wheel_working

	var/const/MAX_LOADED = 10
	var/list/loaded

/obj/structure/working/spinning_wheel/Destroy()
	QDEL_NULL_LIST(loaded)
	return ..()

/obj/structure/working/spinning_wheel/apply_working_overlays()
	if(length(loaded))
		var/obj/item/thing = loaded[1]
		var/image/I = image(icon, "[icon_state]-loaded")
		I.color = thing.get_color()
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/structure/working/spinning_wheel/proc/can_process(obj/item/thing)
	return istype(thing) && thing.has_textile_fibers()

/obj/structure/working/spinning_wheel/try_take_input(obj/item/W, mob/user)

	if(istype(W.storage))
		var/list/loading_growns = list()
		for(var/obj/item/thing in W.get_stored_inventory())
			if(can_process(thing))
				loading_growns += thing

		if(!length(loading_growns))
			to_chat(user, SPAN_WARNING("Nothing in \the [W] is suitable for processing on \the [src]."))
			return TRUE

		if(length(loaded) >= MAX_LOADED)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stocked and ready for spinning."))
			return TRUE

		var/loaded_items = 0
		for(var/obj/item/thing as anything in loading_growns)
			if(W.storage.remove_from_storage(thing, src, TRUE))
				loaded_items++
				LAZYADD(loaded, thing)
				if(length(loaded) >= MAX_LOADED)
					break
		if(loaded_items)
			W.storage.finish_bulk_removal()
			to_chat(user, SPAN_NOTICE("You prepare \the [src] with [loaded_items] items from \the [W]."))
			update_icon()
		return TRUE

	if(can_process(W))
		if(length(loaded) >= MAX_LOADED)
			to_chat(user, SPAN_WARNING("\The [src] is already fully stocked and ready for spinning."))
			return TRUE
		if(user.try_unequip(W, src))
			LAZYADD(loaded, W)
			to_chat(user, SPAN_NOTICE("You prepare \the [src] with \the [W]."))
			update_icon()
		return TRUE
	return TRUE

/obj/structure/working/spinning_wheel/proc/is_thread_material(decl/material/mat)
	return istype(mat) && mat.has_textile_fibers

/obj/structure/working/spinning_wheel/try_start_working(mob/user)

	if(!length(loaded))
		to_chat(user, SPAN_WARNING("\The [src] needs to be prepared with fibers before you can spin anything."))
		return TRUE

	start_working()
	var/processed = 0
	while(length(loaded) && user.do_skilled(2 SECONDS, work_skill, src))
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
				if(is_thread_material(check_material))
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

	stop_working()
	return TRUE

/obj/structure/working/spinning_wheel/try_unload_material(mob/user)
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
	return FALSE

/obj/structure/working/spinning_wheel/ebony
	material = /decl/material/solid/organic/wood/ebony
	color    = /decl/material/solid/organic/wood/ebony::color