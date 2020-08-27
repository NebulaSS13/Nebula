#define BELT_OVERLAY_ITEMS		1
#define BELT_OVERLAY_HOLSTER	2

/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/obj_belt.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	storage_slots = 7
	item_flags = ITEM_FLAG_IS_BELT
	max_w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY
	var/overlay_flags
	attack_verb = list("whipped", "lashed", "disciplined")

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	use_alt_layer = !use_alt_layer
	update_icon()

/obj/item/storage/belt/on_update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

	overlays.Cut()
	if(overlay_flags & BELT_OVERLAY_ITEMS)
		for(var/obj/item/I in contents)
			if(I.use_single_icon)
				overlays += I.get_on_belt_overlay()
			else
				overlays += image('icons/obj/clothing/obj_belt_overlays.dmi', "[I.icon_state]")

/obj/item/storage/belt/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(slot == slot_belt_str && contents.len)
		var/list/ret_overlays = list()
		for(var/obj/item/I in contents)
			if(I.use_single_icon)
				ret_overlays += I.get_mob_overlay(user_mob, slot, bodypart)
			else
				var/use_state = (I.item_state ? I.item_state : I.icon_state)
				if(ishuman(user_mob))
					var/mob/living/carbon/human/H = user_mob
					ret_overlays += H.species.get_offset_overlay_image(FALSE, 'icons/mob/onmob/onmob_belt.dmi', use_state, I.color, slot)
				else
					ret_overlays += overlay_image('icons/mob/onmob/onmob_belt.dmi', use_state, I.color, RESET_COLOR)
			ret.overlays += ret_overlays
	return ret

/obj/item/storage/belt/holster
	name = "holster belt"
	icon_state = "holsterbelt"
	item_state = "holster"
	desc = "Can holster various things."
	storage_slots = 2
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	var/list/can_holster //List of objects which this item can store in the designated holster slot(if unset, it will default to any holsterable items)
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'
	can_hold = list(
		/obj/item/baton,
		/obj/item/telebaton
		)

/obj/item/storage/belt/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, src, sound_in, sound_out, can_holster)

/obj/item/storage/belt/holster/attackby(obj/item/W, mob/user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

/obj/item/storage/belt/holster/attack_hand(mob/user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.unholster(user))
		return
	else
		. = ..(user)

/obj/item/storage/belt/holster/examine(mob/user)
	. = ..()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/storage/belt/holster/on_update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

	overlays.Cut()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(overlay_flags)
		for(var/obj/item/I in contents)
			if(I == H.holstered)
				if(overlay_flags & BELT_OVERLAY_HOLSTER)
					overlays += image('icons/obj/clothing/obj_belt_overlays.dmi', "[I.icon_state]")
			else if(overlay_flags & BELT_OVERLAY_ITEMS)
				overlays += image('icons/obj/clothing/obj_belt_overlays.dmi', "[I.icon_state]")

/obj/item/storage/belt/utility
	name = "tool belt"
	desc = "A belt of durable leather, festooned with hooks, slots, and pouches."
	icon_state = "utilitybelt"
	item_state = "utility"
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		///obj/item/combitool,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/inducer/,
		/obj/item/robotanalyzer,
		/obj/item/minihoe,
		/obj/item/hatchet,
		/obj/item/scanner/plant,
		/obj/item/taperoll,
		/obj/item/extinguisher/mini,
		/obj/item/marshalling_wand,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves
		)


/obj/item/storage/belt/utility/full/Initialize()
	. = ..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/stack/cable_coil/random(src, 30)
	update_icon()


/obj/item/storage/belt/utility/atmostech/Initialize()
	. = ..()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/t_scanner(src)
	update_icon()



/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/scanner/health,
		/obj/item/chems/dropper,
		/obj/item/chems/glass/beaker,
		/obj/item/chems/glass/bottle,
		/obj/item/chems/pill,
		/obj/item/chems/syringe,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/chems/hypospray,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/crowbar,
		/obj/item/flashlight,
		/obj/item/taperoll,
		/obj/item/extinguisher/mini,
		/obj/item/storage/med_pouch,
		/obj/item/bodybag,
		/obj/item/clothing/gloves
		)

/obj/item/storage/belt/medical/emt
	name = "EMT belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "emsbelt"
	item_state = "emsbelt"

/obj/item/storage/belt/holster/security
	name = "security holster belt"
	desc = "Can hold security gear like handcuffs and flashes. This one has a convenient holster."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 8
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/grenade,
		/obj/item/chems/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/chems/food/snacks/donut/,
		/obj/item/baton,
		/obj/item/telebaton,
		/obj/item/flame/lighter,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/energy_blade,
		/obj/item/baton,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/binoculars,
		/obj/item/clothing/gloves
		)

/obj/item/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "basicsecuritybelt"
	item_state = "basicsecurity"
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		/obj/item/crowbar,
		/obj/item/grenade,
		/obj/item/chems/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/chems/food/snacks/donut/,
		/obj/item/baton,
		/obj/item/telebaton,
		/obj/item/flame/lighter,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/energy_blade,
		/obj/item/baton,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/binoculars,
		/obj/item/clothing/gloves
		)

/obj/item/storage/belt/general
	name = "equipment belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies."
	icon_state = "gearbelt"
	item_state = "gear"
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		/obj/item/flash,
		/obj/item/telebaton,
		/obj/item/taperecorder,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/modular_computer/tablet,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/radio,
		/obj/item/tape,
		/obj/item/pen,
		/obj/item/stamp,
		/obj/item/stack/package_wrap,
		/obj/item/binoculars,
		/obj/item/marshalling_wand,
		/obj/item/camera,
		/obj/item/hand_labeler,
		/obj/item/destTagger,
		/obj/item/clothing/glasses,
		/obj/item/clothing/head/soft,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/crowbar
		)

/obj/item/storage/belt/janitor
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	can_hold = list(
		/obj/item/grenade/chem_grenade,
		/obj/item/lightreplacer,
		/obj/item/flashlight,
		/obj/item/chems/spray/cleaner,
		/obj/item/soap,
		/obj/item/holosign_creator,
		/obj/item/clothing/gloves,
		/obj/item/assembly/mousetrap,
		/obj/item/crowbar,
		/obj/item/plunger
		)

/obj/item/storage/belt/holster/general
	name = "holster belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies. Comes with a holster."
	icon_state = "commandbelt"
	item_state = "command"
	storage_slots = 7
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/flash,
		/obj/item/telebaton,
		/obj/item/taperecorder,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/modular_computer/tablet,
		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/radio,
		/obj/item/tape,
		/obj/item/pen,
		/obj/item/stamp,
		/obj/item/stack/package_wrap,
		/obj/item/binoculars,
		/obj/item/marshalling_wand,
		/obj/item/camera,
		/obj/item/destTagger,
		/obj/item/clothing/glasses,
		/obj/item/clothing/head/soft,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/crowbar
		)

/obj/item/storage/belt/holster/forensic
	name = "forensic belt"
	desc = "Can hold forensic gear like fingerprint powder and luminol."
	icon_state = "forensicbelt"
	item_state = "forensic"
	storage_slots = 8
	overlay_flags = BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/chems/spray/luminol,
		/obj/item/uv_light,
		/obj/item/chems/syringe,
		/obj/item/forensics/sample/swab,
		/obj/item/forensics/sample/print,
		/obj/item/forensics/sample/fibers,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/forensic,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/forensics/sample_kit,
		/obj/item/camera,
		/obj/item/taperecorder,
		/obj/item/tape
		)

/obj/item/storage/belt/holster/machete
	name = "machete belt"
	desc = "Can hold general surveying equipment used for exploration, as well as your very own machete."
	icon_state = "machetebelt"
	item_state = "machetebelt"
	storage_slots = 8
	overlay_flags = BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/binoculars,
		/obj/item/camera,
		/obj/item/stack/flag,
		/obj/item/geiger,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/gps,
		/obj/item/scanner/mining,
		/obj/item/scanner/xenobio,
		/obj/item/scanner/plant,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/spaceflare,
		/obj/item/radio/beacon,
		/obj/item/pinpointer/radio,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/scanner/gas
		)
	can_holster = list(/obj/item/hatchet/machete)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	can_hold = list(
		/obj/item/soulstone
		)

/obj/item/storage/belt/soulstone/full/Initialize()
	. = ..()
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)


/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = null
	max_storage_space = ITEM_SIZE_SMALL
	can_hold = list(
		/obj/item/clothing/mask/luchador
		)

/obj/item/storage/belt/holster/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 10

/obj/item/storage/belt/holster/security/tactical/Initialize()
	.=..()
	LAZYSET(slowdown_per_slot, slot_belt_str, 1)

/obj/item/storage/belt/waistpack
	name = "waist pack"
	desc = "A small bag designed to be worn on the waist. May make your butt look big."
	icon_state = "fannypack_white"
	item_state = "fannypack_white"
	storage_slots = null
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = ITEM_SIZE_SMALL * 4
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK

/obj/item/storage/belt/waistpack/big
	name = "large waist pack"
	desc = "A bag designed to be worn on the waist. Definitely makes your butt look big."
	icon_state = "fannypack_big_white"
	item_state = "fannypack_big_white"
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = ITEM_SIZE_NORMAL * 4

/obj/item/storage/belt/waistpack/big/Initialize()
	.=..()
	LAZYSET(slowdown_per_slot, slot_belt_str, 1)

/obj/item/storage/belt/fire_belt
	name = "firefighting equipment belt"
	desc = "A belt specially designed for firefighting."
	icon_state = "firebelt"
	item_state = "gear"
	storage_slots = 5
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		/obj/item/grenade/chem_grenade/water,
		/obj/item/extinguisher/mini,
		/obj/item/inflatable/door
		)


/obj/item/storage/belt/fire_belt/full
	startswith = list(
		/obj/item/inflatable/door,
		/obj/item/extinguisher/mini,
		/obj/item/grenade/chem_grenade/water = 2
	)