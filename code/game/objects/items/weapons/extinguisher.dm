/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items/fire_extinguisher.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	item_flags = ITEM_FLAG_HOLLOW
	throwforce = 10
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 10
	force = 10.0
	material = /decl/material/solid/metal/steel
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/spray_particles = 3
	var/spray_amount = 120	//units of liquid per spray - 120 -> same as splashing them with a bucket per spray
	var/max_water = 2000
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"

/obj/item/extinguisher/mini
	name = "mini fire extinguisher"
	desc = "A light and compact fiberglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	force = 3.0
	spray_amount = 80
	max_water = 1000
	sprite_name = "miniFE"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/extinguisher/Initialize()
	. = ..()
	initialize_reagents()

/obj/item/extinguisher/initialize_reagents(populate = TRUE)
	create_reagents(max_water)
	. = ..()

/obj/item/extinguisher/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/water, reagents.maximum_volume)

/obj/item/extinguisher/empty/populate_reagents()
	return

/obj/item/extinguisher/mini/empty/populate_reagents()
	return

/obj/item/extinguisher/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		to_chat(user, "[html_icon(src)] [name] contains [reagents.total_volume] units of water!")

/obj/item/extinguisher/attack_self(mob/user)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/extinguisher/attack(var/mob/living/M, var/mob/user)
	if(user.a_intent == I_HELP)
		if(src.safety || (world.time < src.last_use + 20)) // We still catch help intent to not randomly attack people
			return
		if(src.reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))
			return

		src.last_use = world.time
		reagents.splash(M, min(reagents.total_volume, spray_amount))

		user.visible_message(SPAN_NOTICE("\The [user] sprays \the [M] with \the [src]."))
		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		return 1 // No afterattack
	return ..()

/obj/item/extinguisher/proc/propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored) return

	var/obj/structure/bed/chair/C
	if(istype(O, /obj/structure/bed/chair))
		C = O

	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C) C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])

	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)

/obj/item/extinguisher/resolve_attackby(obj/structure/O, mob/user, click_params)
	. = (istype(O) && fill_from_pressurized_fluid_source(O, user)) || ..()

/obj/item/extinguisher/fill_from_pressurized_fluid_source(obj/source, mob/user)
	var/last_fill = reagents?.total_volume
	. = ..()
	if(. && reagents?.total_volume > last_fill)
		playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)

/obj/item/extinguisher/afterattack(var/atom/target, var/mob/user, var/flag)
	if(safety)
		return ..()
	if (src.reagents.total_volume < 1)
		to_chat(usr, SPAN_NOTICE("\The [src] is empty."))
		return
	if (world.time < src.last_use + 20)
		return
	src.last_use = world.time
	playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
	var/direction = get_dir(target,src)
	if(user.buckled && isobj(user.buckled))
		addtimer(CALLBACK(src, .proc/propel_object, user.buckled, user, direction), 0)
	addtimer(CALLBACK(src, .proc/do_spray, target), 0)
	if(!user.check_space_footing())
		step(user, direction)

/obj/item/extinguisher/proc/do_spray(var/atom/Target)
	var/turf/T = get_turf(Target)
	var/per_particle = min(spray_amount, reagents.total_volume)/spray_particles
	for(var/a = 1 to spray_particles)
		if(!src || !reagents.total_volume) return

		var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(src))
		W.create_reagents(per_particle)
		reagents.trans_to_obj(W, per_particle)
		W.set_color()
		W.set_up(T)