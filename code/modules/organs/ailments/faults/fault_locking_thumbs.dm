/datum/ailment/fault/locking_thumbs
	name = "self-locking thumbs"
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ makes a grinding sound when you move the joints."
	applies_to_organ = list(
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND
	)

/datum/ailment/fault/locking_thumbs/proc/resolve_tag_to_slot(organ_tag)
	switch(organ_tag)
		if(BP_L_ARM, BP_L_HAND)
			return BP_L_HAND
		if(BP_R_ARM, BP_R_HAND)
			return BP_R_HAND

/datum/ailment/fault/locking_thumbs/on_ailment_event()
	var/slot = resolve_tag_to_slot(organ.organ_tag)
	var/obj/item/thing = organ.owner.get_equipped_item(slot)
	if(thing && organ.owner.try_unequip(thing))
		var/decl/pronouns/pronouns = organ.owner.get_pronouns()
		organ.owner.visible_message( \
			"<B>\The [organ.owner]</B> drops what [pronouns.he] [pronouns.is] holding, [pronouns.his] [organ.name] malfunctioning!", \
			"Your [organ.name] malfunctions, causing you to drop what you were holding.")
