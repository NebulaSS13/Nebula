/obj/item/firearm_component/barrel
	name = "barrel"
	desc = "A long tube forming the barrel of a firearm."
	icon_state = "world-barrel"
	firearm_component_category = FIREARM_COMPONENT_BARREL
	var/screen_shake = 0
	var/space_recoil = 0
	var/combustion =   0

/obj/item/firearm_component/barrel/proc/get_relative_projectile_size(var/obj/item/projectile/projectile)
	return 1

/obj/item/firearm_component/barrel/proc/get_caliber()
	return

/obj/item/firearm_component/barrel/proc/set_caliber(var/_caliber)
	return
