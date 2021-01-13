/*
	Badges are worn on the belt or neck, and can be used to show the user's credentials.
	The user' details can be imprinted on holobadges with the relevant ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "A leather-backed badge, with gold trimmings."
	icon = 'icons/clothing/accessories/detectivebadge.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	high_visibility = 1
	accessory_icons = null
	var/badge_string = "Detective"
	var/stored_name

/obj/item/clothing/accessory/badge/get_lore_info()
	. = ..()
	. += "<br>Denotes affiliation to <l>[badge_string]</l>."

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name

/obj/item/clothing/accessory/badge/proc/set_desc(var/mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/get_examine_line()
	. = ..()
	. += "  <a href='?src=\ref[src];look_at_me=1'>\[View\]</a>"

/obj/item/clothing/accessory/badge/examine(user)
	. = ..()
	if(stored_name)
		to_chat(user,"It reads: [stored_name], [badge_string].")

/obj/item/clothing/accessory/badge/attack_self(mob/user)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		set_desc(user)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting \the [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting \the [src] into their face insistently.</span>")
		if(stored_name)
			to_chat(M, "<span class='warning'>It reads: [stored_name], [badge_string].</span>")

/obj/item/clothing/accessory/badge/PI
	name = "private investigator's badge"
	badge_string = "Private Investigator"

/*
 *Holobadges
 */
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of security."
	color = COLOR_PALE_BLUE_GRAY
	icon = 'icons/clothing/accessories/holobadge.dmi'
	badge_string = "Security"
	var/badge_access = access_security
	var/badge_number
	var/emagged //emag_act removes access requirements

/obj/item/clothing/accessory/badge/holo/cord
	icon = 'icons/clothing/accessories/holobadge_cord.dmi'
	slot_flags = SLOT_FACE | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/set_name(var/new_name)
	..()
	badge_number = random_id(type,1000,9999)
	name = "[name] ([badge_number])"

/obj/item/clothing/accessory/badge/holo/examine(user)
	. = ..()
	if(badge_number)
		to_chat(user,"The badge number is [badge_number].")

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O, var/mob/user)
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

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box containing security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo = 4,
					  /obj/item/clothing/accessory/badge/holo/cord = 2)

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. Looks crummy."
	badge_string = "Unknown"

/obj/item/clothing/accessory/badge/defenseintel
	name = "\improper DIA investigator's badge"
	desc = "A leather-backed silver badge bearing the crest of the Defense Intelligence Agency."
	icon = 'icons/clothing/accessories/diabadge.dmi'
	badge_string = "Defense Intelligence Agency"

/obj/item/clothing/accessory/badge/interstellarintel
	name = "\improper OII agent's badge"
	desc = "A synthleather holographic badge bearing the crest of the Office of Interstellar Intelligence."
	icon = 'icons/clothing/accessories/intelbadge.dmi'
	badge_string = "Office of Interstellar Intelligence"

/obj/item/clothing/accessory/badge/press
	name = "press badge"
	desc = "A leather-backed plastic badge displaying that the owner is certified press personnel."
	icon = 'icons/clothing/accessories/pressbadge.dmi'
	badge_string = "Journalist"
