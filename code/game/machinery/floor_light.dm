var/global/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = ABOVE_TILE_LAYER
	anchored = 0
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT
	)
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	var/damaged
	var/default_light_power = 0.75
	var/default_light_range = 3
	var/default_light_color = "#ffffff"

/obj/machinery/floor_light/prebuilt
	anchored = 1

/obj/machinery/floor_light/Initialize()
	. = ..()
	update_icon()

/obj/machinery/floor_light/attackby(var/obj/item/W, var/mob/user)

	if(IS_SCREWDRIVER(W))
		anchored = !anchored
		if(use_power)
			update_use_power(POWER_USE_OFF)
		visible_message(SPAN_NOTICE("\The [user] has [anchored ? "attached" : "detached"] \the [src]."))
		return TRUE

	if(IS_WELDER(W) && (damaged || (stat & BROKEN)))
		var/obj/item/weldingtool/WT = W
		if(!WT.weld(0, user))
			to_chat(user, SPAN_WARNING("\The [src] must be on to complete this task."))
			return TRUE
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 20, src) && !QDELETED(src) && WT.isOn())
			visible_message(SPAN_NOTICE("\The [user] has repaired \the [src]."))
			set_broken(FALSE)
			damaged = null
		return TRUE

	if(IS_WRENCH(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		to_chat(user, SPAN_NOTICE("You dismantle the floor light."))
		SSmaterials.create_object(/decl/material/solid/metal/steel, loc, 1)
		SSmaterials.create_object(/decl/material/solid/glass, loc, 1)
		qdel(src)
		return TRUE

	if(W.force && user.a_intent == I_HURT)
		return physical_attack_hand(user)

	return ..()

/obj/machinery/floor_light/physical_attack_hand(var/mob/user)
	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !(stat & BROKEN))
			visible_message(SPAN_DANGER("\The [user] smashes \the [src]!"))
			playsound(src, "shatter", 70, 1)
			set_broken(TRUE)
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src]!"))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			if(isnull(damaged))
				damaged = 0
		return TRUE

/obj/machinery/floor_light/interface_interact(var/mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(!anchored)
		to_chat(user, SPAN_WARNING("\The [src] must be screwed down first."))
		return TRUE

	var/on = (use_power == POWER_USE_ACTIVE)
	update_use_power(on ? POWER_USE_OFF : POWER_USE_ACTIVE)
	visible_message(SPAN_NOTICE("\The [user] turns \the [src] [!on ? "on" : "off"]."))
	return TRUE

/obj/machinery/floor_light/set_broken(new_state)
	. = ..()
	if(. && (stat & BROKEN))
		update_use_power(POWER_USE_OFF)

/obj/machinery/floor_light/power_change(new_state)
	. = ..()
	if(. && (stat & NOPOWER))
		update_use_power(POWER_USE_OFF)

/obj/machinery/floor_light/proc/update_brightness()
	if((use_power == POWER_USE_ACTIVE) && !(stat & (NOPOWER | BROKEN)))
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_color)
			set_light(default_light_range, default_light_power, default_light_color)
			change_power_consumption((light_range + light_power) * 20, POWER_USE_ACTIVE)
	else
		if(light_range || light_power)
			set_light(0)

/obj/machinery/floor_light/on_update_icon()
	cut_overlays()
	if((use_power == POWER_USE_ACTIVE) && !(stat & (NOPOWER | BROKEN)))
		if(isnull(damaged))
			var/cache_key = "floorlight-[default_light_color]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_color
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			add_overlay(floor_light_cache[cache_key])
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_color]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_color
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			add_overlay(floor_light_cache[cache_key])
	update_brightness()

/obj/machinery/floor_light/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src))
		if(severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5)))
			physically_destroyed()
		else
			if(severity == 2 && prob(20))
				set_broken(TRUE)
			if(isnull(damaged))
				damaged = 0
