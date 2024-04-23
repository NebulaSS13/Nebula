/*
 *Holobadges
 */
/obj/item/clothing/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of security."
	color = COLOR_PALE_BLUE_GRAY
	icon = 'icons/clothing/accessories/badges/holobadge.dmi'
	badge_string = "Security"
	var/badge_access = access_security
	var/badge_number
	var/emagged //emag_act removes access requirements

/obj/item/clothing/badge/holo/cord
	icon = 'icons/clothing/accessories/badges/holobadge_cord.dmi'
	slot_flags = SLOT_FACE

/obj/item/clothing/badge/holo/set_name(var/new_name)
	..()
	badge_number = random_id(type,1000,9999)
	name = "[name] ([badge_number])"

/obj/item/clothing/badge/holo/examine(user)
	. = ..()
	if(badge_number)
		to_chat(user,"The badge number is [badge_number].")

/obj/item/clothing/badge/holo/attack_self(mob/user)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/badge/holo/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/card/id) || istype(O, /obj/item/modular_computer))

		var/obj/item/card/id/id_card = O.GetIdCard()

		if(!id_card)
			return

		if((badge_access in id_card.access) || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(id_card.registered_name)
			set_desc(user)
		else
			to_chat(user, "[src] rejects your ID, and flashes 'Insufficient access!'")
		return
	..()

/obj/item/box/holobadge
	name = "holobadge box"
	desc = "A box containing security holobadges."

/obj/item/box/holobadge/WillContain()
	return list(
			/obj/item/clothing/badge/holo      = 4,
			/obj/item/clothing/badge/holo/cord = 2
		)
