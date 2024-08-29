/obj/item/nuclear_cylinder
	name = "\improper nuclear cylinder"
	desc = "This cylinder is used in the self destruct system of the ship."
	icon = 'icons/obj/items/nuclear_cylinder.dmi'
	icon_state = "nuclear_cylinder"
	item_state = "nuclear"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_HUGE
	throw_speed = 2
	throw_range = 4
	origin_tech = @'{"materials":3,"engineering":4}'
	max_health = ITEM_HEALTH_NO_DAMAGE
	_base_attack_force = 10
