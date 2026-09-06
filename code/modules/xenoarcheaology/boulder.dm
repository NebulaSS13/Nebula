/obj/structure/boulder
	name = "boulder"
	desc = "A large boulder, somewhat bigger than a small boulder."
	icon = 'icons/obj/structures/boulder.dmi'
	icon_state = ICON_STATE_WORLD
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	material = /decl/material/solid/stone/sandstone
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/excavation_level = 0
	var/datum/artifact_find/artifact_find

/obj/structure/boulder/excavated
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."

/obj/structure/boulder/basalt
	material = /decl/material/solid/stone/basalt
	color = /decl/material/solid/stone/basalt::color

/obj/structure/boulder/sandstone
	material = /decl/material/solid/stone/sandstone
	color = /decl/material/solid/stone/sandstone::color

/obj/structure/boulder/create_dismantled_products(turf/T)
	new /obj/item/stack/material/ore(T, rand(3,5), material?.type)
	matter = null
	material = null
	return ..()

/obj/structure/boulder/Initialize(var/ml, var/_mat, var/coloration)
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,6)]"
	if(coloration)
		color = coloration
	excavation_level = rand(5, 50)

/obj/structure/boulder/Destroy()
	QDEL_NULL(artifact_find)
	return ..()

/obj/structure/boulder/attackby(var/obj/item/used_item, var/mob/user)

	if(istype(used_item, /obj/item/depth_scanner))
		var/obj/item/depth_scanner/C = used_item
		C.scan_atom(user, src)
		return TRUE

	if(istype(used_item, /obj/item/measuring_tape))
		var/obj/item/measuring_tape/P = used_item
		user.visible_message(
			SPAN_NOTICE("\The [user] extends \the [P] towards \the [src]."),
			SPAN_NOTICE("You extend \the [P] towards \the [src].")
		)
		if(do_after(user, 15))
			to_chat(user, SPAN_NOTICE("\The [src] has been excavated to a depth of [src.excavation_level]cm."))
		return TRUE

	if(used_item.do_tool_interaction(TOOL_PICK, user, src, 3 SECONDS, set_cooldown = TRUE))
		excavation_level += used_item.get_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH)
		if(excavation_level > 200)
			user.visible_message(
				SPAN_DANGER("\The [src] suddenly crumbles away."),
				SPAN_DANGER("\The [src] has disintegrated under your onslaught. Any secrets it was holding are long gone.")
			)
			physically_destroyed()
			return TRUE

		if(prob(excavation_level))
			//success
			if(artifact_find)
				var/spawn_type = artifact_find.artifact_find_type
				var/obj/O = new spawn_type(get_turf(src))
				if(istype(O, /obj/structure/artifact))
					var/obj/structure/artifact/X = O
					if(X.my_effect)
						X.my_effect.artifact_id = artifact_find.artifact_id
				visible_message(SPAN_DANGER("\The [src] suddenly crumbles away."))
			else
				user.visible_message(
					SPAN_DANGER("\The [src] suddenly crumbles away."),
					SPAN_DANGER("\The [src] has been whittled away under your careful excavation, but there was nothing of interest inside.")
				)
			physically_destroyed()
		return TRUE

	return ..()

/obj/structure/boulder/Bumped(AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/user = AM
		var/obj/item/equipped_item = user.get_active_held_item()
		if(istype(equipped_item) && IS_PICK(equipped_item))
			attackby(equipped_item, user)
