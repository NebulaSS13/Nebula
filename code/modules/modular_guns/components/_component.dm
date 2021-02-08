/obj/item/firearm_component
	var/firearm_component_category = FIREARM_CATEGORY_NONE

/obj/item/firearm_component/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/firearm_component/on_update_icon()
	var/obj/item/gun/holder = loc
	icon = istype(holder) ? holder.icon : initial(icon)
	icon_state = "[get_world_inventory_state()]-[firearm_component_category || FIREARM_CATEGORY_NONE]"

/obj/item/firearm_component/proc/get_holder_overlay(var/holder_state = ICON_STATE_WORLD)
	return image(icon, "[holder_state]-[firearm_component_category || FIREARM_CATEGORY_NONE]")
