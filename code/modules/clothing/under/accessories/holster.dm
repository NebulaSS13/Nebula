/obj/item/clothing/accessory/storage/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon = 'icons/clothing/accessories/holsters/holster.dmi'
	slot = ACCESSORY_SLOT_HOLSTER
	slots = 1
	max_w_class = ITEM_SIZE_NORMAL
	var/list/can_holster = null
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'

/obj/item/clothing/accessory/storage/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, hold, sound_in, sound_out, can_holster)

/obj/item/clothing/accessory/storage/holster/attackby(obj/item/W, mob/user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

/obj/item/clothing/accessory/storage/holster/attack_hand(mob/user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.unholster(user))
		return
	else
		. = ..(user)

/obj/item/clothing/accessory/storage/holster/examine(mob/user)
	. = ..(user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/clothing/accessory/storage/holster/on_attached(obj/item/clothing/under/S, mob/user)
	..()
	has_suit.verbs += /atom/proc/holster_verb

/obj/item/clothing/accessory/storage/holster/on_removed(mob/user)
	if(has_suit)
		var/remove_verb = TRUE
		if(has_extension(has_suit, /datum/extension/holster))
			remove_verb = FALSE

		for(var/obj/accessory in has_suit.accessories)
			if(accessory == src)
				continue
			if(has_extension(accessory, /datum/extension/holster))
				remove_verb = FALSE

		if(remove_verb)
			has_suit.verbs -= /atom/proc/holster_verb
	..()

/obj/item/clothing/accessory/storage/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry."

/obj/item/clothing/accessory/storage/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon = 'icons/clothing/accessories/holsters/holster_low.dmi'

/obj/item/clothing/accessory/storage/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon = 'icons/clothing/accessories/holsters/holster_hip.dmi'

/obj/item/clothing/accessory/storage/holster/thigh
	name = "thigh holster"
	desc = "A drop leg holster made of a durable synthetic fiber."
	icon = 'icons/clothing/accessories/holsters/holster_thigh.dmi'
	sound_in = 'sound/effects/holster/tactiholsterin.ogg'
	sound_out = 'sound/effects/holster/tactiholsterout.ogg'

/obj/item/clothing/accessory/storage/holster/machete
	name = "blade sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon = 'icons/clothing/accessories/holsters/holster_machete.dmi'
	can_holster = list(
		/obj/item/hatchet/machete,
		/obj/item/knife/kitchen/cleaver,
		/obj/item/sword/katana
	)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/clothing/accessory/storage/holster/knife
	name = "leather knife sheath"
	desc = "A synthetic leather knife sheath which you can strap on your leg."
	icon = 'icons/clothing/accessories/holsters/sheath_leather.dmi'
	can_holster = list(/obj/item/knife)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/clothing/accessory/storage/holster/knife/polymer
	name = "polymer knife sheath"
	desc = "A rigid polymer sheath which you can strap on your leg."
	icon = 'icons/clothing/accessories/holsters/sheath_polymer.dmi'
