/obj/structure/wall_sconce
	name                = "wall sconce"
	desc                = "A simple metal loop suitable for holding a torch, lantern or candle."
	icon                = 'icons/obj/structures/wall_sconce.dmi'
	icon_state          = ICON_STATE_WORLD
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material            = /decl/material/solid/metal/iron
	max_health          = 100
	directional_offset  = @'{"NORTH":{"y":16}, "EAST":{"x":10}, "WEST":{"x":-10}}'
	/// Reference to the currently attached item.
	var/obj/item/flame/light_source

/obj/structure/wall_sconce/lantern
	light_source        = /obj/item/flame/fuelled/lantern/filled

/obj/structure/wall_sconce/candle
	light_source        = /obj/item/flame/candle

/obj/structure/wall_sconce/Initialize()

	if(ispath(light_source))
		light_source = new light_source(src)
		light_source.light(null, no_message = TRUE)

	. = ..()

	if(isturf(loc))
		for(var/step_dir in global.cardinal)
			var/turf/neighbor = get_step_resolving_mimic(loc, step_dir)
			if(istype(neighbor) && neighbor.density)
				set_dir(step_dir)
				break

/obj/structure/wall_sconce/Destroy()
	QDEL_NULL(light_source)
	return ..()

/obj/structure/wall_sconce/physically_destroyed()
	if(light_source)
		light_source.dropInto(loc)
		light_source = null
	return ..()

/obj/structure/wall_sconce/attack_hand(mob/user)

	if(light_source)
		user.put_in_hands(light_source)
		user.visible_message(SPAN_NOTICE("\The [user] takes \the [light_source] from \the [src]."))
		light_source = null
		update_icon()
		return TRUE

	return ..()

/obj/structure/wall_sconce/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(istype(W, /obj/item/flame))
		var/obj/item/flame/flame = W

		if(flame.lit && light_source && light_source.can_manually_light)
			light_source.attackby(flame, user)
			update_icon()
			return TRUE

		if(flame.sconce_can_hold)

			if(light_source)
				to_chat(user, SPAN_WARNING("\The [src] is already occupied by \the [light_source]."))
				return TRUE

			if(user.try_unequip(flame, src))
				user.visible_message(SPAN_NOTICE("\The [user] puts \the [flame] into \the [src]."))
				light_source = flame
				update_icon()
			return TRUE

	if(W.isflamesource() && light_source && !light_source.lit)
		light_source.attackby(W, user)
		return TRUE

	return ..()

/obj/structure/wall_sconce/on_update_icon()
	. = ..()
	var/sconce_overlay = istype(light_source) ? light_source.get_sconce_overlay() : null
	if(sconce_overlay)
		add_overlay(sconce_overlay)