/obj/item/firearm_component
	var/bulk = 0
	var/firearm_component_category = FIREARM_CATEGORY_NONE
	var/one_hand_penalty = 0

/obj/item/firearm_component/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/firearm_component/proc/show_examine_info(var/mob/user)
	return

/obj/item/firearm_component/on_update_icon()
	var/obj/item/gun/holder = loc
	icon = istype(holder) ? holder.icon : initial(icon)
	icon_state = "[get_world_inventory_state()]-[firearm_component_category || FIREARM_CATEGORY_NONE]"

/obj/item/firearm_component/proc/get_holder_overlay(var/holder_state = ICON_STATE_WORLD)
	return image(icon, "[holder_state]-[firearm_component_category || FIREARM_CATEGORY_NONE]")

/obj/item/firearm_component/proc/holder_attack_self(var/mob/user)
	return

/obj/item/firearm_component/proc/holder_attackby(var/obj/item/W, var/mob/user)
	return

/obj/item/firearm_component/proc/holder_attack_hand(var/mob/user)
	return