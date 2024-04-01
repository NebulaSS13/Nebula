/obj/structure/spindle
	name = "spindle"
	icon = 'icons/obj/structures/spindle.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	density = TRUE
	material = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/tmp/working = FALSE
	var/list/loaded
	var/product_type = /obj/item/stack/material/thread
	var/const/MAX_LOADED = 5

/obj/structure/spindle/Destroy()
	QDEL_NULL_LIST(loaded)
	return ..()

/obj/structure/spindle/on_update_icon()
	..()

	icon_state = initial(icon_state)

	if(length(loaded))
		var/obj/item/thing = loaded[1]
		var/image/I = image(icon, "[icon_state]-loaded")
		I.color = thing.material?.color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

	if(working)
		icon_state = "[icon_state]-working"

/obj/structure/spindle/attackby(obj/item/W, mob/user)

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

/obj/structure/spindle/attack_hand(mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(!length(loaded))
		to_chat(user, SPAN_WARNING("\The [src] needs to be prepared with fibers before you can spin thread."))
		return TRUE

	working = TRUE
	update_icon()
	var/processed = 0
	while(length(loaded) && user.do_skilled(5 SECONDS, SKILL_CONSTRUCTION, src))
		if(!length(loaded) || QDELETED(src) || QDELETED(user))
			break

		var/obj/item/loaded_fiber = loaded[1]
		LAZYREMOVE(loaded, loaded_fiber)

		if(loaded_fiber && loaded_fiber.material && LAZYACCESS(loaded_fiber.matter, loaded_fiber.material.type))
			var/obj/item/stack/material/product_ref = product_type
			var/produced = max(1, round(loaded_fiber.matter[loaded_fiber.material?.type] / (initial(product_ref.matter_multiplier) * SHEET_MATERIAL_AMOUNT)))
			var/obj/item/stack/thread = new product_type(get_turf(src), produced, loaded_fiber.material?.type)
			if(istype(thread))
				thread.add_to_stacks(user, TRUE)

		processed++
		QDEL_NULL(loaded_fiber)
		update_icon()

	if(processed && !QDELETED(user))
		to_chat(user, SPAN_NOTICE("You finish working at \the [src], having spun [processed] lengths of thread."))

	working = FALSE
	update_icon()
	return TRUE
