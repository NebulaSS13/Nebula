/obj/item/gun
	var/obj/item/firearm_component/barrel/barrel

/obj/item/gun/proc/check_projectile_size_against_barrel(var/obj/item/projectile/projectile)
	return barrel.get_relative_projectile_size(projectile)

/obj/item/gun/Initialize()
	if(ispath(barrel))
		barrel = new barrel(src)
	. = ..()

/obj/item/gun/proc/get_caliber()
	return barrel?.get_caliber()

/obj/item/gun/proc/set_caliber(var/caliber)
	return barrel?.set_caliber(caliber)
