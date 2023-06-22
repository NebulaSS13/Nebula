var/global/list/standard_clothing_slots = list(
	slot_head_str,
	slot_wear_mask_str,
	slot_wear_suit_str,
	slot_w_uniform_str,
	slot_gloves_str,
	slot_shoes_str
)

var/global/list/standard_headgear_slots = list(
	slot_head_str,
	slot_wear_mask_str,
	slot_glasses_str
)

var/global/list/ear_slots = list(
	slot_l_ear_str,
	slot_r_ear_str
)

var/global/list/pocket_slots = list(
	slot_l_store_str,
	slot_r_store_str
)

var/global/list/airtight_slots = list(
	slot_wear_mask_str,
	slot_head_str
)

var/global/list/equipped_slots = list(
	slot_belt_str,
	slot_l_ear_str,
	slot_r_ear_str,
	slot_glasses_str,
	slot_gloves_str,
	slot_head_str,
	slot_shoes_str,
	slot_wear_id_str,
	slot_wear_suit_str,
	slot_w_uniform_str
)

//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
var/global/list/slot_equipment_priority = list(
	slot_back_str,
	slot_wear_id_str,
	slot_w_uniform_str,
	slot_wear_suit_str,
	slot_wear_mask_str,
	slot_head_str,
	slot_shoes_str,
	slot_gloves_str,
	slot_l_ear_str,
	slot_r_ear_str,
	slot_glasses_str,
	slot_belt_str,
	slot_s_store_str,
	slot_tie_str,
	slot_l_store_str,
	slot_r_store_str
)

var/global/list/carried_slots = list(
	slot_l_store_str,
	slot_r_store_str,
	slot_handcuffed_str,
	slot_s_store_str
)

var/global/list/persistent_inventory_slots = list(
	slot_s_store_str,
	slot_wear_id_str,
	slot_belt_str,
	slot_back_str,
	slot_l_store_str,
	slot_r_store_str
)

var/global/list/hidden_inventory_slots = list(
	slot_head_str,
	slot_shoes_str,
	slot_l_ear_str,
	slot_r_ear_str,
	slot_gloves_str,
	slot_glasses_str,
	slot_w_uniform_str,
	slot_wear_suit_str,
	slot_wear_mask_str
)

var/global/list/abstract_inventory_slots = list(
	slot_in_backpack_str,
	slot_tie_str,
	slot_undershirt_str,
	slot_underpants_str,
	slot_socks_str
)
