/obj/item/fleece
	name        = "fleece"
	desc        = "The shorn fleece of some animal, ready for spinning."
	icon        = 'icons/obj/items/fleece.dmi'
	icon_state  = ICON_STATE_WORLD
	item_flags  = ITEM_FLAG_IS_BELT
	slot_flags  = SLOT_HEAD | SLOT_LOWER_BODY | SLOT_OVER_BODY
	w_class     = ITEM_SIZE_HUGE // an entire fleece is quite large in terms of volume
	attack_verb = list("slapped")
	hitsound    = 'sound/weapons/towelwhip.ogg'
	material    = /decl/material/solid/organic/cloth/wool
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	_base_attack_force  = 1

/obj/item/fleece/Initialize(ml, material_key, mob/living/donor)
	. = ..()
	if(donor)
		name = "[donor.name]'s fleece"

/obj/item/fleece/has_textile_fibers()
	return TRUE

/obj/item/fleece/get_matter_amount_modifier()
	return 5 // One fleece is 40 threads, which is roughly 4 cloth.
