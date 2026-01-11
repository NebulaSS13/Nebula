/*
 * Trailer bits and bobs.
 */
/obj/vehicle/train/trolley/trailer
	name = "all terrain trailer"
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quadtrailer"
	anchored = FALSE
	passenger_allowed = 1
	buckle_lying = 1
	locked = 0
	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 13
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 16)
	pixel_x = -16
	paint_color = "#ffffff"
	var/mob_offset_y = 16

/obj/vehicle/train/trolley/trailer/random/Initialize()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	. = ..()

/obj/vehicle/train/trolley/trailer/proc/update_load()
	if(load)
		var/y_offset = load_offset_y
		if(istype(load, /mob/living))
			y_offset = mob_offset_y
		load.pixel_x = (initial(load.pixel_x) + 16 + load_offset_x + pixel_x) //Base location for the sprite, plus 16 to center it on the 'base' sprite of the trailer, plus the x shift of the trailer, then shift it by the same pixel_x as the trailer to track it.
		load.pixel_y = (initial(load.pixel_y) + y_offset + pixel_y) //Same as the above.
		return 1
	return 0
/obj/vehicle/train/trolley/trailer/Initialize()
	. = ..()
	update_icon()

/obj/vehicle/train/trolley/trailer/Move()
	var/atom/old_loc = loc
	if((. = ..()))
		update_trolley_offset(old_loc)

/obj/vehicle/train/trolley/trailer/forceMove()
	var/atom/old_loc = loc
	if((. = ..()))
		update_trolley_offset(old_loc)

/obj/vehicle/train/trolley/trailer/proc/update_trolley_offset(var/atom/old_loc)
	if(lead)
		switch(dir) //Due to being a Big Boy sprite, it has to have special pixel shifting to look 'normal'.
			if(1)
				default_pixel_y = -10
				default_pixel_x = -16
			if(2)
				default_pixel_y = 0
				default_pixel_x = -16
			if(4)
				default_pixel_y = 0
				default_pixel_x = -25
			if(8)
				default_pixel_y = 0
				default_pixel_x = -5
	else
		default_pixel_x = initial(default_pixel_x)
		default_pixel_y = initial(default_pixel_y)
	reset_offsets(0)
	update_load()

/obj/vehicle/train/trolley/trailer/Bump(atom/Obstacle)
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
		M.apply_effects(1, 1)
		M.apply_damages(8 / move_delay)
		if(load)
			M.apply_damages(4/move_delay)
		var/list/throw_dirs = all_throw_dirs.Copy()
		if(!emagged)
			throw_dirs -= dir
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		if(isliving(load))
			var/mob/living/D = load
			to_chat(D, SPAN_DANGER("You hit \the [M]!"))
			admin_attack_log(D, M, "Ran over with \the [src]")

/obj/vehicle/train/trolley/trailer/on_update_icon()
	..()
	var/image/Bodypaint = new(icon = icon, icon_state = "[initial(icon_state)]_a", layer = src.layer)
	Bodypaint.color = paint_color
	set_overlays(Bodypaint)

/obj/vehicle/train/trolley/trailer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && open)
		var/new_paint = input("Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()
