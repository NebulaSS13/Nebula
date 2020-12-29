/obj/item/holder/ascent_nymph
	origin_tech = "{'magnets':3,'biotech':5}"
	slot_flags = SLOT_HEAD | SLOT_OVER_BODY | SLOT_HOLSTER
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

// Yes, you can wear a nymph on your head instead of a radiation mask.
/obj/item/holder/ascent_nymph/equipped(var/mob/living/user, var/slot)
	if(slot == BP_L_HAND || slot == BP_R_HAND)
		body_parts_covered = SLOT_ARMS
	else if(slot == slot_head_str)
		body_parts_covered = SLOT_HEAD
	else if(slot == slot_wear_suit_str)
		body_parts_covered = SLOT_UPPER_BODY
	. = ..()