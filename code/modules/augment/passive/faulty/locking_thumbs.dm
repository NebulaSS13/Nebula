/obj/item/organ/internal/augment/faulty/locking_thumbs
	name = "self-locking thumbs"
	desc = "An augment that was badly installed. Now featuring self-locking thumbs, which would otherwise be convenient but now just makes you drop things."
	allowed_organs = list(BP_AUGMENT_R_HAND, BP_AUGMENT_L_HAND)

/obj/item/organ/internal/augment/faulty/locking_thumbs/on_malfunction()
	var/slot = null
	switch (limb.organ_tag)
		if (BP_L_ARM, BP_L_HAND)
			slot = BP_L_HAND
		if (BP_R_ARM, BP_R_HAND)
			slot = BP_R_HAND
	var/obj/item/thing = owner.get_equipped_item(slot)
	if(thing && owner.unEquip(thing))
		owner.visible_message("<B>\The [owner]</B> drops what they were holding, \his [limb] malfunctioning!", "Your [limb] malfunctions, causing you to drop what you were holding.")