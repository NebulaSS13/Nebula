/datum/inventory_slot/gripper/mouth/diona
	slot_name = "Mouth"
	ui_loc = "CENTER-1:16,BOTTOM:5"
	ui_label = null

/datum/inventory_slot/head/diona
	ui_loc = "LEFT:5,BOTTOM:5"
	slot_state = "hat"
	can_be_hidden = FALSE
	requires_organ_tag = null

/mob/living/carbon/alien/diona/Initialize(var/mapload, var/flower_chance = 15)
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/diona)
	add_inventory_slot(new /datum/inventory_slot/head/diona)
	. = ..()

// Makes it so that the held item's screen_loc isn't unset.
/mob/living/carbon/alien/diona/item_should_have_screen_presence(obj/item/item, slot)
	return item == get_equipped_item(BP_MOUTH) || ..()
