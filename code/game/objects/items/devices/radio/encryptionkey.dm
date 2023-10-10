/obj/item/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	icon = 'icons/obj/items/device/radio/key.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	var/translate_binary
	var/list/can_decrypt

/obj/item/encryptionkey/attack_self(mob/user)
	if(alert(user, "Do you wish to factory reset this encryption key? This will remove ALL channel access and cannot be undone.", "Factory Reset", "No", "Yes") == "Yes" && !user.incapacitated() && user.get_held_slot_for_item(src))
		can_decrypt = null
		to_chat(user, "You depress the factory reset switch and flush \the [src].")
		return TRUE
	. = ..()

/obj/item/encryptionkey/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/id = W
		var/list/access = id.GetAccess()
		if(!length(access))
			to_chat(user, SPAN_WARNING("\The [W] has no access keys to copy."))
			return TRUE
		LAZYINITLIST(can_decrypt)
		can_decrypt |= access
		UNSETEMPTY(can_decrypt)
		to_chat(user, SPAN_NOTICE("You pass \the [W] across \the [src], copying the access keys into the encryption cache."))
		return TRUE
	. = ..()

/obj/item/encryptionkey/binary
	icon_state = "cypherkey"
	translate_binary = TRUE
	origin_tech = "{'esoteric':3}"
