/obj/item/holder/diona
	origin_tech = "{'magnets':3,'biotech':5}"
	slot_flags = SLOT_HEAD | SLOT_OVER_BODY | SLOT_HOLSTER
	armor = list(
		ARMOR_BIO = ARMOR_BIO_RESISTANT,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)

// Yes, you can wear a nymph on your head instead of a radiation mask.
/obj/item/holder/diona/equipped(var/mob/living/user, var/slot)
	if(slot in user.get_held_item_slots())
		body_parts_covered = SLOT_ARMS
	else if(slot == slot_head_str)
		body_parts_covered = SLOT_HEAD
	else if(slot == slot_wear_suit_str)
		body_parts_covered = SLOT_UPPER_BODY
	. = ..()