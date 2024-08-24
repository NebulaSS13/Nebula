/mob/living/simple_animal/passive
	possession_candidate = TRUE
	abstract_type        = /mob/living/simple_animal/passive
	ai                   = /datum/mob_controller/passive
	see_in_dark          = 6
	minbodytemp          = 223
	maxbodytemp          = 323
	base_movement_delay  = -1

/mob/living/simple_animal/passive/Initialize()
	. = ..()
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/simple)
