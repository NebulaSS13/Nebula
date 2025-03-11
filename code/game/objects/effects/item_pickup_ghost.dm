/obj/effect/temporary/item_pickup_ghost
	is_spawnable_type = FALSE
	var/lifetime = 0.2 SECONDS

/obj/effect/temporary/item_pickup_ghost/Initialize(var/mapload, var/obj/item/picked_up)
	. = ..(mapload, lifetime, null, null)
	appearance = picked_up.appearance

/obj/effect/temporary/item_pickup_ghost/proc/animate_towards(var/atom/target)
	var/new_pixel_x = pixel_x + (target.x - src.x) * 32
	var/new_pixel_y = pixel_y + (target.y - src.y) * 32
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix()*0, time = lifetime)
