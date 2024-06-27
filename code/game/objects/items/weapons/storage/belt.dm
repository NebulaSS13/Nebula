#define BELT_OVERLAY_ITEMS		1
#define BELT_OVERLAY_HOLSTER	2

/obj/item/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/clothing/belt/utility.dmi'
	icon_state = ICON_STATE_WORLD
	storage = /datum/storage/belt
	item_flags = ITEM_FLAG_IS_BELT
	slot_flags = SLOT_LOWER_BODY
	attack_verb = list("whipped", "lashed", "disciplined")
	material = /decl/material/solid/organic/leather/synth
	var/overlay_flags

/obj/item/belt/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., slot_belt_str)

/obj/item/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	use_alt_layer = !use_alt_layer
	update_icon()

/obj/item/belt/on_update_icon()
	. = ..()
	if(overlay_flags & BELT_OVERLAY_ITEMS)
		var/list/cur_overlays
		for(var/obj/item/I in contents)
			if(I.use_single_icon)
				LAZYADD(cur_overlays, I.get_on_belt_overlay())
			else
				LAZYADD(cur_overlays, overlay_image('icons/obj/clothing/obj_belt_overlays.dmi', I.icon_state))

		if(LAZYLEN(cur_overlays))
			add_overlay(cur_overlays)
	update_clothing_icon()

/obj/item/belt/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	var/image/ret = ..()
	if(ret && slot == slot_belt_str && length(contents))
		for(var/obj/item/I in contents)
			var/image/new_overlay = I.get_mob_overlay(user_mob, slot, bodypart, use_fallback_if_icon_missing, TRUE)
			if(new_overlay)
				ret.overlays += new_overlay
	return ret

/obj/item/belt/holster
	name = "holster belt"
	icon = 'icons/clothing/belt/holster.dmi'
	desc = "Can holster various things."
	storage = /datum/storage/holster
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	var/list/can_holster //List of objects which this item can store in the designated holster slot(if unset, it will default to any holsterable items)
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'

/obj/item/belt/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, storage, sound_in, sound_out, can_holster)

/obj/item/belt/holster/attackby(obj/item/W, mob/user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

/obj/item/belt/holster/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.unholster(user))
		return TRUE
	return ..()

/obj/item/belt/holster/examine(mob/user)
	. = ..()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/belt/holster/on_update_icon()
	. = ..()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(overlay_flags)
		var/list/cur_overlays
		for(var/obj/item/I in contents)
			if(I == H.holstered)
				if(overlay_flags & BELT_OVERLAY_HOLSTER)
					LAZYADD(cur_overlays, overlay_image('icons/obj/clothing/obj_belt_overlays.dmi', I.icon_state))
			else if(overlay_flags & BELT_OVERLAY_ITEMS)
				LAZYADD(cur_overlays, overlay_image('icons/obj/clothing/obj_belt_overlays.dmi', I.icon_state))

		if(LAZYLEN(cur_overlays))
			add_overlay(cur_overlays)

	update_clothing_icon()

/obj/item/belt/utility
	name = "tool belt"
	desc = "A belt of durable leather, festooned with hooks, slots, and pouches."
	icon = 'icons/clothing/belt/utility.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS
	storage = /datum/storage/belt/utility
	material = /decl/material/solid/organic/leather

/obj/item/belt/utility/full/WillContain()
	return list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/stack/cable_coil/random,
	)

/obj/item/belt/utility/atmostech/WillContain()
	return list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/t_scanner,
	)

/obj/item/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon = 'icons/clothing/belt/medical.dmi'
	storage = /datum/storage/belt/medical

/obj/item/belt/medical/emt
	name = "EMT belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon = 'icons/clothing/belt/emt_belt.dmi'

/obj/item/belt/holster/security
	name = "security holster belt"
	desc = "Can hold security gear like handcuffs and flashes. This one has a convenient holster."
	icon = 'icons/clothing/belt/security_holster.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	storage = /datum/storage/holster/security

/obj/item/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon = 'icons/clothing/belt/security.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS
	storage = /datum/storage/belt/security

/obj/item/belt/general
	name = "equipment belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies."
	icon = 'icons/clothing/belt/gearbelt.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS
	storage = /datum/storage/belt/general

/obj/item/belt/janitor
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon = 'icons/clothing/belt/janitor.dmi'
	storage = /datum/storage/belt/janitor

/obj/item/belt/holster/general
	name = "holster belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies. Comes with a holster."
	icon = 'icons/clothing/belt/command.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	storage = /datum/storage/holster/general

/obj/item/belt/holster/forensic
	name = "forensic belt"
	desc = "Can hold forensic gear like fingerprint powder and luminol."
	icon = 'icons/clothing/belt/forensic.dmi'
	overlay_flags = BELT_OVERLAY_HOLSTER
	storage = /datum/storage/holster/forensic

/obj/item/belt/holster/machete
	name = "machete belt"
	desc = "Can hold general surveying equipment used for exploration, as well as your very own machete."
	icon = 'icons/clothing/belt/machete.dmi'
	overlay_flags = BELT_OVERLAY_HOLSTER
	storage = /datum/storage/holster/machete
	can_holster = list(/obj/item/tool/machete)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon = 'icons/clothing/belt/champion.dmi'
	storage = /datum/storage/belt/champion

/obj/item/belt/holster/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon = 'icons/clothing/belt/swatbelt.dmi'
	storage = /datum/storage/holster/security/tactical

/obj/item/belt/holster/security/tactical/Initialize(ml, material_key)
	.=..()
	LAZYSET(slowdown_per_slot, slot_belt_str, 1)

/obj/item/belt/waistpack
	name = "waist pack"
	desc = "A small bag designed to be worn on the waist. May make your butt look big."
	icon = 'icons/clothing/belt/fannypack.dmi'
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK
	material = /decl/material/solid/organic/cloth
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)
	storage = /datum/storage/belt/waistpack

/obj/item/belt/waistpack/big
	name = "large waist pack"
	desc = "A bag designed to be worn on the waist. Definitely makes your butt look big."
	icon = 'icons/clothing/belt/fannypack_big.dmi'
	w_class = ITEM_SIZE_LARGE
	storage = /datum/storage/belt/waistpack/big

/obj/item/belt/waistpack/big/Initialize(ml, material_key)
	.=..()
	LAZYSET(slowdown_per_slot, slot_belt_str, 1)

/obj/item/belt/fire_belt
	name = "firefighting equipment belt"
	desc = "A belt specially designed for firefighting."
	icon = 'icons/clothing/belt/firefighter.dmi'
	overlay_flags = BELT_OVERLAY_ITEMS
	material = /decl/material/solid/fiberglass //need something that doesn't burn
	storage = /datum/storage/belt/firefighter

/obj/item/belt/fire_belt/full/WillContain()
	return list(
		/obj/item/inflatable = 2,
		/obj/item/inflatable/door,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/grenade/chem_grenade/water = 2
	)
