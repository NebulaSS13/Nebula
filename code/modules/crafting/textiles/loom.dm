/obj/structure/loom
	name = "loom"
	icon = 'icons/obj/structures/loom.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	density = TRUE
	material = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/tmp/working = FALSE
	var/obj/item/stack/loaded_thread
	var/product_type = /obj/item/stack/material/bolt
	var/weaving_type
	var/weaving_progress = 0

/obj/structure/loom/Destroy()
	QDEL_NULL(loaded_thread)
	return ..()

/obj/structure/loom/physically_destroyed()
	if(loaded_thread)
		loaded_thread.dropInto(loc)
		loaded_thread = null
	if(weaving_type)
		clear_in_progress_weaving()
	return ..()

/obj/structure/loom/proc/clear_in_progress_weaving()
	if(weaving_type && weaving_progress > 0)
		var/obj/item/scrap_material/scraps = new(loc, weaving_type)
		var/decl/material/scrap_material = GET_DECL(weaving_type)
		scraps.matter = list(weaving_type, weaving_progress)
		scraps.name = "[scrap_material.solid_name] scraps"
		. = scraps
	weaving_type = null
	weaving_progress = 0

/obj/structure/loom/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

	if(istype(W, /obj/item/stack/material/thread))
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
			weaving_type = loaded_thread.material
			to_chat(user, SPAN_NOTICE("You wind thread onto \the [src]."))
			update_icon()
			return TRUE

	return ..()

/obj/structure/loom/on_update_icon()
	..()

	icon_state = initial(icon_state)

	if(loaded_thread)
		var/image/I = image(icon, "[icon_state]-loaded")
		I.color = loaded_thread.get_color()
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

	if(working)
		icon_state = "[icon_state]-working"

/obj/structure/loom/attack_hand(mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(working)
		to_chat(user, SPAN_WARNING("\The [src] is currently in use, please wait for it to be finished."))
		return TRUE

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

	if(!loaded_thread)
		to_chat(user, SPAN_WARNING("\The [src] needs to be wound with thread before you can weave anything."))
		return TRUE

	working = TRUE
	update_icon()
	var/processed = 0
	while(!QDELETED(loaded_thread) && user.do_skilled(2 SECONDS, SKILL_CONSTRUCTION, src))
		if(QDELETED(loaded_thread) || QDELETED(src) || QDELETED(user) || !weaving_type || !(weaving_type in loaded_thread.matter_per_piece))
			break

		weaving_progress += loaded_thread.matter_per_piece[weaving_type]
		var/obj/item/stack/material/product_ref = product_type
		var/matter_per_product = initial(product_ref.matter_multiplier) * SHEET_MATERIAL_AMOUNT
		if(weaving_progress > matter_per_product)
			var/produced = round(weaving_progress / matter_per_product)
			if(produced)
				processed += produced
				weaving_progress -= produced * matter_per_product
				var/obj/item/stack/cloth = new product_type(get_turf(src), produced, weaving_type)
				if(isitem(cloth))
					if(loaded_thread.paint_color)
						cloth.set_color(loaded_thread.paint_color)
					if(istype(cloth))
						cloth.add_to_stacks(user, TRUE)

		loaded_thread.use(1)
		if(QDELETED(loaded_thread))
			loaded_thread = null

		update_icon()

	if(processed && !QDELETED(user))
		to_chat(user, SPAN_NOTICE("You finish working at \the [src], having woven [processed] length\s of cloth."))

	working = FALSE
	update_icon()
	return TRUE
