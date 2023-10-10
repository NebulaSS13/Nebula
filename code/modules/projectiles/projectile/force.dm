/obj/item/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ice_1"
	damage = 20
	damage_type = BURN
	damage_flags = 0

/obj/item/projectile/forcebolt/strong
	name = "force bolt"

/obj/item/projectile/forcebolt/on_hit(var/atom/movable/target, var/blocked = 0)
	if(istype(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return 1

/obj/item/projectile/firebolt
	name = "fireball"
	icon_state = "fireball"
	fire_sound = 'sound/magic/fireball.ogg'
	damage = 20
	damage_type = BURN
	damage_flags = 0

	var/ex_severe = -1
	var/ex_heavy =  -1
	var/ex_light =   1
	var/ex_flash =   2

/obj/item/projectile/firebolt/on_impact(var/atom/A)
	. = ..()
	explosion(A, ex_severe, ex_heavy, ex_light, ex_flash)
