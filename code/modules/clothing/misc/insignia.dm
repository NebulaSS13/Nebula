/obj/item/clothing/insignia
	abstract_type = /obj/item/clothing/insignia
	accessory_slot = ACCESSORY_SLOT_INSIGNIA
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/gold
	fallback_slot = slot_w_uniform_str

/obj/item/clothing/insignia/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down
	)
	return initial_accessory_hide_on_states
