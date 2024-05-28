/obj/item/bladed/folding
	name                      = "folding knife"
	desc                      = "A small folding knife."
	icon                      = 'icons/obj/items/bladed/folding.dmi'
	material_force_multiplier = 0.2
	w_class                   = ITEM_SIZE_SMALL
	sharp                     = FALSE
	pommel_material           = null
	guard_material            = null
	slot_flags                = null
	material                  = /decl/material/solid/metal/bronze
	hilt_material             = /decl/material/solid/organic/wood

	var/open                  = FALSE
	var/closed_item_size      = ITEM_SIZE_SMALL
	var/open_item_size        = ITEM_SIZE_NORMAL
	var/open_attack_verbs     = list("slashed", "stabbed")
	var/closed_attack_verbs   = list("prodded", "tapped")

/obj/item/bladed/folding/Initialize()
	. = ..()
	update_force()

/obj/item/bladed/folding/attack_self(mob/user)
	open = !open
	update_force()
	update_icon()
	if(open)
		user.visible_message(SPAN_NOTICE("\The [user] opens \the [src]."))
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]."))
	add_fingerprint(user)
	return TRUE

/obj/item/bladed/folding/update_base_icon_state()
	. = ..()
	if(!open)
		icon_state = "[icon_state]-closed"

/obj/item/bladed/folding/update_force()
	edge  = open
	sharp = open
	if(open)
		w_class     = open_item_size
		attack_verb = open_attack_verbs
	else
		w_class     = closed_item_size
		attack_verb = closed_attack_verbs
	..()

// Only show the inhand sprite when open.
/obj/item/bladed/folding/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	. = open ? ..() : new /image

// TODO: Select hilt, guard, etc. as striking material based on dynamic intents
/obj/item/bladed/folding/get_striking_material(mob/user, atom/target)
	. = open ? ..() : hilt_material

/obj/item/bladed/folding/get_tool_speed(archetype)
	return open ? ..() : 0

/obj/item/bladed/folding/get_tool_quality(archetype)
	if(open && archetype == TOOL_HATCHET)
		// If this were an `/obj/item/tool` subtype, we could get away with just doing this based on
		// `open_item_size` in `get_initial_tool_qualities()`.
		switch(w_class)
			if(0 to ITEM_SIZE_SMALL)
				return TOOL_QUALITY_NONE
			if(ITEM_SIZE_SMALL to ITEM_SIZE_NORMAL) // Since ITEM_SIZE_SMALL was already covered, this is just ITEM_SIZE_NORMAL.
				return TOOL_QUALITY_WORST
			if(ITEM_SIZE_NORMAL to ITEM_SIZE_LARGE)
				return TOOL_QUALITY_BAD
			else
				return TOOL_QUALITY_MEDIOCRE
	return open ? ..() : 0
