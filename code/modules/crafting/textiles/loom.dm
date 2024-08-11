/obj/structure/textiles/loom

	name         = "loom"
	desc         = "A complex, articulated device for weaving threads into cloth."
	icon         = 'icons/obj/structures/loom.dmi'
	product_type = /obj/item/stack/material/bolt
	work_sound   = /datum/composite_sound/loom_working

	var/weaving_progress = 0
	var/weaving_type
	var/weaving_color
	var/obj/item/stack/loaded_thread

/obj/structure/textiles/loom/Destroy()
	QDEL_NULL(loaded_thread)
	QDEL_NULL(work_sound)
	return ..()

/obj/structure/textiles/loom/physically_destroyed()
	if(loaded_thread)
		loaded_thread.dropInto(loc)
		loaded_thread = null
	if(weaving_type)
		clear_in_progress_weaving()
	return ..()

/obj/structure/textiles/loom/proc/clear_in_progress_weaving()
	if(weaving_type && weaving_progress > 0)
		var/obj/item/debris/scraps/scraps = new(loc)
		scraps.matter = list(weaving_type = weaving_progress)
		scraps.update_primary_material()
		. = scraps
	weaving_color = null
	weaving_type = null
	weaving_progress = 0

/obj/structure/textiles/loom/try_take_input(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/material/thread))

		if(!W.material.has_textile_fibers)
			to_chat(user, SPAN_WARNING("\The [W] isn't suitable for making cloth."))
			return TRUE

		var/loaded = FALSE
		if(loaded_thread)
			if(!loaded_thread.can_merge_stacks(W))
				to_chat(user, SPAN_WARNING("\The [src] is already wound with \the [loaded_thread]."))
				return TRUE
			var/obj/item/stack/feeding = W
			feeding.transfer_to(loaded_thread)
			loaded = TRUE
		else if(user.try_unequip(W, src))
			loaded_thread = W
			loaded = TRUE
		if(loaded)
			weaving_color = loaded_thread.get_color()
			weaving_type = loaded_thread.material.type
			to_chat(user, SPAN_NOTICE("You wind thread onto \the [src]."))
			update_icon()
			return TRUE
	return FALSE

/obj/structure/textiles/loom/apply_textiles_overlays()
	if(loaded_thread)
		var/image/I = image(icon, "[icon_state]-thread")
		I.color = loaded_thread.get_color()
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
	if(weaving_progress)
		var/image/I = image(icon, "[icon_state]-weaving")
		I.color = weaving_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/structure/textiles/loom/try_unload_material(mob/user)
	if(user.a_intent == I_GRAB)
		if(loaded_thread)
			to_chat(user, SPAN_NOTICE("You remove \the [loaded_thread] from \the [src]."))
			loaded_thread.dropInto(loc)
			user.put_in_hands(loaded_thread)
			loaded_thread = null
			update_icon()
		else if(weaving_type)
			to_chat(user, SPAN_NOTICE("You remove and discard the half-finished weaving."))
			var/obj/item/scraps = clear_in_progress_weaving()
			if(scraps)
				user.put_in_hands(scraps)
		else
			to_chat(user, SPAN_WARNING("\The [src] has no thread to remove."))
		return TRUE
	return FALSE

/obj/structure/textiles/loom/try_start_working(mob/user)

	if(!loaded_thread)
		to_chat(user, SPAN_WARNING("\The [src] needs to be wound with thread before you can weave anything."))
		return TRUE

	start_working()
	var/processed = 0
	var/last_completion_descriptor = null
	while(!QDELETED(loaded_thread) && user.do_skilled(1.5 SECONDS, work_skill, src))
		if(QDELETED(loaded_thread) || QDELETED(src) || QDELETED(user) || !weaving_type || !(weaving_type in loaded_thread.matter_per_piece))
			break

		weaving_progress += loaded_thread.matter_per_piece[weaving_type]
		var/obj/item/stack/material/product_ref = product_type
		var/matter_per_product = ceil(initial(product_ref.matter_multiplier) * SHEET_MATERIAL_AMOUNT)
		if(weaving_progress > matter_per_product)
			var/produced = round(weaving_progress / matter_per_product)
			processed += produced
			weaving_progress -= produced * matter_per_product
			var/obj/item/stack/cloth = new product_type(get_turf(src), produced, weaving_type)
			if(isitem(cloth))
				if(loaded_thread.paint_color)
					cloth.set_color(weaving_color)
				if(istype(cloth))
					cloth.add_to_stacks(user, TRUE)
			to_chat(user, SPAN_NOTICE("You finish weaving \a [cloth]."))
			last_completion_descriptor = null
		else
			var/completion_descriptor
			switch(weaving_progress / matter_per_product)
				if(-(INFINITY) to 0.25)
					completion_descriptor = "barely started"
				if(0.25 to 0.5)
					completion_descriptor = "half finished"
				if(0.5 to 0.75)
					completion_descriptor = "three-quarters complete"
				else
					completion_descriptor = "almost finished"
			if(completion_descriptor != last_completion_descriptor)
				to_chat(user, SPAN_NOTICE("You work at \the [src]. The weaving looks [completion_descriptor]."))
			last_completion_descriptor = completion_descriptor

		loaded_thread.use(1)
		if(QDELETED(loaded_thread))
			loaded_thread = null

		update_icon()

	if(processed && !QDELETED(user))
		to_chat(user, SPAN_NOTICE("You finish working at \the [src], having woven [processed] length\s of cloth."))

	stop_working()
	return TRUE

/obj/structure/textiles/loom/ebony
	material = /decl/material/solid/organic/wood/ebony
