/obj/item/plunger
	name = "plunger"
	desc = "This is possibly the least sanitary object around."
	icon = 'icons/obj/items/plunger.dmi'
	icon_state = ICON_STATE_WORLD
	attack_verb = list("plunged")
	_base_attack_force = 1
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_HEAD | SLOT_FACE
	body_parts_covered = SLOT_HEAD
	hitsound = 'sound/effects/plunger.ogg'
	material = /decl/material/solid/organic/plastic

/obj/item/plunger/equipped(mob/user, slot)
	switch(slot)
		if(SLOT_FACE)
			body_parts_covered = SLOT_FACE|SLOT_EYES
		if(SLOT_HEAD)
			body_parts_covered = initial(body_parts_covered)
	return ..()

/obj/item/plunger/unbreakable
	max_health = ITEM_HEALTH_NO_DAMAGE
