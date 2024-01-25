#define ROBOT_MODULE_ONE   "first hardpoint"
#define ROBOT_MODULE_TWO   "second hardpoint"
#define ROBOT_MODULE_THREE "third hardpoint"

// Borgs can't equip most items to hand slots, except if they're coming to or from their module.
/mob/living/silicon/robot/equip_to_slot_if_possible(obj/item/W, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, force = FALSE, delete_old_item = TRUE, ignore_equipped = FALSE)
	if(W && (slot in get_held_item_slots()))
		if(!(W in module.equipment))
			return FALSE
		// TODO check if the module can hold the item
	return ..()

/datum/inventory_slot/gripper/robot_module
	hand_overlay = "blank"
	abstract_type = /datum/inventory_slot/gripper/robot_module

// TODO: store unequipped module item back inside the module
/datum/inventory_slot/gripper/robot_module/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	. = ..()
	if(isrobot(user) && !QDELETED(prop))
		var/mob/living/silicon/robot/user_bot = user
		if(user_bot.module && (prop in user_bot.module.equipment))
			prop.forceMove(user_bot.module)

/datum/inventory_slot/gripper/robot_module/one
	slot_name = "Primary Hardpoint"
	slot_id = ROBOT_MODULE_ONE
	ui_loc = ui_inv1
	hand_sort_priority = 1
	ui_label = "1"

/datum/inventory_slot/gripper/robot_module/two
	slot_name = "Secondary Hardpoint"
	slot_id = ROBOT_MODULE_TWO
	ui_loc = ui_inv2
	hand_sort_priority = 2
	ui_label = "2"

/datum/inventory_slot/gripper/robot_module/three
	slot_name = "Tertiary Hardpoint"
	slot_id = ROBOT_MODULE_THREE
	ui_loc = ui_inv3
	hand_sort_priority = 3
	ui_label = "3"
