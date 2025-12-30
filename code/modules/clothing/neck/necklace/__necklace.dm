/obj/item/clothing/neck/necklace
	name = "necklace"
	desc = "A fine chain worn around the neck."
	icon = 'icons/clothing/accessories/jewelry/necklace.dmi'
	material = /decl/material/solid/metal/silver
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	var/obj/item/pendant/pendant

/obj/item/clothing/neck/necklace/Initialize()
	. = ..()
	if(ispath(pendant))
		set_pendant(new pendant(src, material?.type))

/obj/item/clothing/neck/necklace/Destroy()
	set_pendant(null)
	return ..()

/obj/item/clothing/neck/necklace/proc/set_pendant(obj/item/new_pendant)
	if(pendant == new_pendant)
		return FALSE
	pendant = new_pendant
	update_icon()
	return TRUE

/obj/item/clothing/neck/necklace/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(istype(pendant))
		. += "There is \a [pendant] attached."

/obj/item/clothing/neck/necklace/on_update_icon()
	. = ..()
	if(istype(pendant))
		var/list/pendant_overlays = pendant.get_pendant_overlays(icon_state)
		if(length(pendant_overlays))
			add_overlay(pendant_overlays)

/obj/item/clothing/neck/necklace/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && istype(pendant))
		var/pendant_overlays = pendant.get_pendant_overlays(overlay.icon_state)
		if(pendant_overlays)
			overlay.overlays += pendant_overlays
	return ..()

/obj/item/clothing/neck/necklace/attack_self(mob/user)
	if(pendant?.attack_self(user))
		return TRUE
	return ..()

/obj/item/clothing/neck/necklace/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/pendant))
		if(istype(pendant))
			to_chat(user, SPAN_WARNING("\The [src] doesn't have room for \the [used_item]."))
		else if(user.try_unequip(used_item, src))
			set_pendant(used_item)
			update_icon()
			to_chat(user, SPAN_NOTICE("You attach \the [pendant] to \the [src]."))
		return TRUE
	if(pendant?.attackby(used_item, user))
		return TRUE
	return ..()

/obj/item/clothing/neck/necklace/get_alt_interactions(mob/user)
	. = ..()
	if(istype(pendant))
		LAZYADD(., /decl/interaction_handler/remove_pendant)

/decl/interaction_handler/remove_pendant
	name = "Remove Pendant"
	expected_target_type = /obj/item/clothing/neck/necklace
	examine_desc = "remove $TARGET_THEIR$ pendant"

/decl/interaction_handler/remove_pendant/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/clothing/neck/necklace/necklace = target
	if(!necklace.pendant)
		return FALSE
	necklace.pendant.dropInto(user.loc)
	user.put_in_hands(necklace.pendant)
	necklace.set_pendant(null)
	return TRUE

// Loadout subtypes.
/obj/item/clothing/neck/necklace/prism
	pendant = /obj/item/pendant/prism

/obj/item/clothing/neck/necklace/frill
	pendant = /obj/item/pendant/frill

/obj/item/clothing/neck/necklace/square
	pendant = /obj/item/pendant/setting/square

/obj/item/clothing/neck/necklace/cross
	pendant = /obj/item/pendant/setting/cross

/obj/item/clothing/neck/necklace/diamond
	pendant = /obj/item/pendant/setting/diamond

/obj/item/clothing/neck/necklace/ornate
	pendant = /obj/item/pendant/setting/ornate
