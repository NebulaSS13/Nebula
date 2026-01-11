/obj/vehicle/train/engine/quadbike //It's a train engine, so it can tow trailers.
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quad"
	on = 0
	powered = 1
	locked = 0
	load_item_visible = 1
	load_offset_x = 0
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 5)
	pixel_x = -16
	base_speed = 0.45
	car_limit = 1	//It gets a trailer. That's about it.
	active_engines = 1
	key_type = /obj/item/key/quadbike
	paint_color = "#ffffff"
	layer = OBJ_LAYER
	vehicle_transit_type = VEHICLE_QUADBIKE

	var/frame_state = "quad" //Custom-item proofing!
	var/paint_base = 'icons/obj/vehicles_64x64.dmi'
	var/custom_frame = FALSE
	var/datum/composite_sound/vehicle_engine/soundloop

/obj/vehicle/train/engine/quadbike/Initialize()
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	soundloop = new(list(src), FALSE)
	. = ..()
	turn_off()
	update_icon()

/obj/vehicle/train/engine/quadbike/built/Initialize()
	key = new key_type(src)
	. = ..()
	turn_off()

/obj/vehicle/train/engine/quadbike/random/Initialize()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	. = ..()

/obj/vehicle/train/engine/quadbike/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/key/quadbike
	name = "key"
	desc = "A keyring with a small steel key, and a blue fob reading \"ZOOM!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "quad_keys"
	w_class = ITEM_SIZE_TINY

/obj/vehicle/train/engine/quadbike/forceMove(turf/destination)
	var/atom/old_loc = loc
	if((. = ..()))
		update_vehicle_move_delay(old_loc)
		handle_vehicle_icon()

/obj/vehicle/train/engine/quadbike/Move(turf/destination)
	var/atom/old_loc = loc
	if((. = ..()))
		update_vehicle_move_delay(old_loc)
		handle_vehicle_icon()

/obj/vehicle/train/engine/quadbike/update_vehicle_move_delay(atom/prev_loc)
	..()
	update_car(train_length, active_engines)

/obj/vehicle/train/engine/quadbike/proc/handle_vehicle_icon()
	switch(dir) //Due to being a Big Boy sprite, it has to have special pixel shifting to look 'normal' when being driven.
		if(1)
			pixel_y = -6
		if(2)
			pixel_y = -6
		if(4)
			pixel_y = 0
		if(8)
			pixel_y = 0

/obj/vehicle/train/engine/quadbike/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/multitool) && open)
		var/new_paint = input("Please select a paint color.", "Trailer Color", paint_color) as color|null
		if(new_paint && !QDELETED(src) && !QDELETED(used_item) && !QDELETED(user) && !user.incapacitated() && user.get_active_held_item() == used_item)
			paint_color = new_paint
			update_icon()
		return TRUE
	return ..()

/obj/vehicle/train/engine/quadbike/on_update_icon()
	..()
	cut_overlays()

	if(custom_frame)
		var/image/Bodypaint = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_a")
		Bodypaint.layer = layer
		Bodypaint.color = paint_color
		add_overlay(Bodypaint)

		var/image/Overmob = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay") //over mobs
		var/image/Overmob_color = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay_a") //over the over mobs, gives the color.
		Overmob.layer = layer + 0.2
		Overmob_color.layer = layer + 0.2
		Overmob_color.color = paint_color
		add_overlay(Overmob)
		add_overlay(Overmob_color)
		return

	var/image/Bodypaint = new(icon = paint_base, icon_state = "[frame_state]_a", layer = src.layer)
	Bodypaint.color = paint_color
	add_overlay(Bodypaint)

	var/image/Overmob = new(icon = paint_base, icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
	var/image/Overmob_color = new(icon = paint_base, icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
	Overmob.layer = ABOVE_HUMAN_LAYER
	Overmob_color.layer = ABOVE_HUMAN_LAYER
	Overmob_color.color = paint_color

	add_overlay(Overmob)
	add_overlay(Overmob_color)

/obj/vehicle/train/engine/quadbike/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		visible_message(SPAN_DANGER("\The [src] knocks over \the [M]!"))
		M.apply_effects(2, 2)				// Knock people down for a short moment
		M.apply_damages(8 / move_delay)		// Smaller amount of damage than a tug, since this will always be possible because Quads don't have safeties.
		var/list/throw_dirs = all_throw_dirs.Copy()
		if(!emagged)						// By the power of Bumpers TM, it won't throw them ahead of the quad's path unless it's emagged or the person turns.
			take_damage(round(M.mob_size / 2))
			throw_dirs -= dir
			throw_dirs -= get_dir(M, src) //Don't throw it AT the quad either.
		else
			take_damage(round(M.mob_size / 4)) // Less damage if they actually put the point in to emag it.
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		if(isliving(load))
			var/mob/living/D = load
			to_chat(D, SPAN_DANGER("You hit \the [M]!"))
			admin_attack_log(D, M, "Ran over with [src.name]")

/obj/vehicle/train/engine/quadbike/crossed_mob(mob/living/victim)
	. = ..()
	var/list/throw_dirs = all_throw_dirs.Copy()
	if(!emagged)
		throw_dirs -= dir
		if(tow)
			throw_dirs -= get_dir(victim, tow) //Don't throw it at the trailer either.
	var/turf/T = get_step(victim, pick(throw_dirs))
	victim.throw_at(T, 1, 1, src)

/obj/vehicle/train/engine/quadbike/turn_on()
	..()
	if(on)
		visible_message(SPAN_NOTICE("\The [src] rumbles to life."), "You hear something rumble deeply.")
		soundloop.start()

/obj/vehicle/train/engine/quadbike/turn_off()
	if(on)
		visible_message(SPAN_NOTICE("\The [src] putters before turning off."), "You hear something putter slowly.")
		soundloop.stop()
	..()

/obj/vehicle/train/engine/quadbike/snowmobile
	name = "snowmobile"
	desc = "An electric snowmobile for traversing snow and ice with ease! Other terrain, not so much."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "snowmobile"
	load_item_visible = 1
	base_speed = 0.6
	car_limit = 0
	key_type = /obj/item/key/snowmobile
	frame_state = "snowmobile"
	paint_base = 'icons/obj/vehicles.dmi'
	pixel_x = 0
	water_delay = 6

/obj/item/key/snowmobile
	name = "key"
	desc = "A keyring with an ice-blue fob reading \"CHILL\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "sno_keys"

/obj/vehicle/train/engine/quadbike/snowmobile/random/Initialize()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	. = ..()

/obj/vehicle/train/engine/quadbike/snowmobile/handle_vehicle_icon()
	return
