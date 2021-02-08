#define FIREARM_COMPONENT_BARREL "barrel"

/obj/item/firearm_component
	var/firearm_component_category

/obj/item/firearm_component/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/firearm_component/on_update_icon()
	var/obj/item/gun/holder = loc
	icon = istype(holder) ? holder.icon : initial(icon)
	icon_state = "[get_world_inventory_state()]-[firearm_component_category || "misc"]"
