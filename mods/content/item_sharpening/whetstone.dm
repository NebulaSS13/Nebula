/obj/item/whetstone
	name = "whetstone"
	desc = "A worn-down lozenge used to sharpen blades."
	icon = 'icons/obj/items/striker.dmi' // TODO unique icon?
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_TINY
	material_alteration = MAT_FLAG_ALTERATION_ALL
	material = /decl/material/solid/quartz
	color = /decl/material/solid/quartz::color

/obj/item/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/whetstone) && try_sharpen_with(user, used_item))
		return TRUE
	return ..()

/decl/loadout_option/utility/whetstone
	name = "whetstone"
	path = /obj/item/whetstone
	loadout_flags = null
	uid = "gear_utility_whetstone"
