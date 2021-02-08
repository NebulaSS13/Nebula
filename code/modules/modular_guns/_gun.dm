#define FIREARM_CATEGORY_NONE      "default"
#define FIREARM_COMPONENT_BARREL   "barrel"
#define FIREARM_COMPONENT_GRIP     "grip"
#define FIREARM_COMPONENT_STOCK    "stock"
#define FIREARM_COMPONENT_RECEIVER "receiver"
#define FIREARM_COMPONENT_FRAME    "frame"

/obj/item/gun
	var/obj/item/firearm_component/barrel/barrel
	var/obj/item/firearm_component/grip/grip
	var/obj/item/firearm_component/receiver
	var/obj/item/firearm_component/stock

/obj/item/gun/proc/check_projectile_size_against_barrel(var/obj/item/projectile/projectile)
	return barrel.get_relative_projectile_size(projectile)

/obj/item/gun/Initialize()
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/fcomppath = firearm_components[fcomp]
		if(fcomppath)
			new fcomppath(src)
	. = ..()

/obj/item/gun/on_update_icon()
	force_icon_debug()

/obj/item/gun/proc/force_icon_debug()
	cut_overlays()
	var/base_icon_state = get_world_inventory_state()
	icon_state = "[base_icon_state]-[FIREARM_COMPONENT_FRAME]"
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp))
			var/image/I = comp.get_holder_overlay(base_icon_state)
			if(I)
				add_overlay(I)

/obj/item/gun/proc/get_modular_component_list()
	. = list(
		"[FIREARM_COMPONENT_BARREL]" =   barrel,
		"[FIREARM_COMPONENT_GRIP]" =     grip,
		"[FIREARM_COMPONENT_RECEIVER]" = receiver,
		"[FIREARM_COMPONENT_STOCK]" =    stock
	)

/obj/item/gun/proc/get_caliber()
	return barrel?.get_caliber()

/obj/item/gun/proc/set_caliber(var/caliber)
	return barrel?.set_caliber(caliber)
