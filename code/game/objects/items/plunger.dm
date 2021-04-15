/obj/item/plunger
	name = "plunger"
	desc = "This is possibly the least sanitary object around."
	icon = 'icons/obj/items/plunger.dmi'
	icon_state = ICON_STATE_WORLD
	attack_verb = list("plunged")
	force = 1
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_HEAD | SLOT_FACE
	body_parts_covered = SLOT_HEAD
	hitsound = 'sound/effects/plunger.ogg'
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)

/obj/item/plunger/equipped(mob/user, slot)
	switch(slot)
		if(SLOT_FACE)
			body_parts_covered = SLOT_FACE|SLOT_EYES
		if(SLOT_HEAD)
			body_parts_covered = initial(body_parts_covered)
	return ..()

