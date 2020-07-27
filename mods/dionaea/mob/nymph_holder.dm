/obj/item/holder/diona
	origin_tech = "{'magnets':3,'biotech':5}"
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
	)

// Yes, you can wear a nymph on your head instead of a radiation mask.
/obj/item/holder/diona/equipped(var/mob/living/user, var/slot)
	if(slot == slot_l_hand_str || slot == slot_r_hand_str)
		body_parts_covered = ARMS
	else if(slot == slot_head_str)
		body_parts_covered = HEAD
	else if(slot == slot_wear_suit_str)
		body_parts_covered = UPPER_TORSO
	. = ..()