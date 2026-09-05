/mob/living/simple_animal/passive/sakimm
	name = "sakimm"
	desc = "What appears to be an oversized rodent with hands."
	icon = 'mods/content/polaris/icons/wildlife/sakimm.dmi'
	ai = /datum/mob_controller/passive/sakimm
	max_health = 50
	base_movement_delay = -1

	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_KNIVES,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_MINOR,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)

/*
	melee_damage_lower = 5
	melee_damage_upper = 15
	base_attack_cooldown = 1 SECOND
	attacktext = list("nipped", "bit", "cut", "clawed")
*/

/mob/living/simple_animal/passive/sakimm/Initialize()
	. = ..()
	add_held_item_slot(new /datum/inventory_slot/gripper/left_hand/no_organ)
	add_held_item_slot(new /datum/inventory_slot/gripper/right_hand/no_organ)
	add_inventory_slot(new /datum/inventory_slot/head/simple)

/datum/mob_controller/passive/sakimm
	emote_speech = list("Shurr.", "|R|rr?", "Hss.")
	emote_see    = list("sniffs","looks around", "rubs its hands")
	emote_hear   = list("chitters", "clicks")
