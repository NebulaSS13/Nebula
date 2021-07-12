//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "space helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	icon = 'icons/clothing/spacesuit/generic/helmet.dmi'
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	flags_inv = BLOCKHAIR
	permeability_coefficient = 0
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	on = 0

	var/obj/machinery/camera/camera
	var/tinted = null	//Set to non-null for toggleable tint helmets
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/metal/steel

/obj/item/clothing/head/helmet/space/Destroy()
	if(camera && !ispath(camera))
		QDEL_NULL(camera)
	. = ..()

/obj/item/clothing/head/helmet/space/Initialize()
	. = ..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_camera
	if(!isnull(tinted))
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_tint
		update_tint()

/obj/item/clothing/head/helmet/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
		else
			to_chat(usr, "<span class='notice'>Camera deactivated.</span>")

/obj/item/clothing/head/helmet/space/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && camera)
		to_chat(user, "This helmet has a built-in camera. Its [!ispath(camera) && camera.status ? "" : "in"]active.")

/obj/item/clothing/head/helmet/space/proc/update_tint()
	if(tinted)
		flash_protection = FLASH_PROTECTION_MAJOR
		flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	else
		flash_protection = FLASH_PROTECTION_NONE
		flags_inv = HIDEEARS|BLOCKHAIR
	update_icon()
	update_clothing_icon()

/obj/item/clothing/head/helmet/space/proc/toggle_tint()
	set name = "Toggle Helmet Tint"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	tinted = !tinted
	to_chat(usr, "You toggle [src]'s visor tint.")
	update_tint()

/obj/item/clothing/head/helmet/space/get_mob_overlay(var/mob/user_mob, var/slot, var/bodypart)
	var/image/ret = ..()
	if(ret && tint && check_state_in_icon("[ret.icon_state]_dark", ret.icon))
		ret.icon_state = "[ret.icon_state]_dark"
	return ret

/obj/item/clothing/head/helmet/space/on_update_icon(mob/user)
	. = ..()
	var/base_icon = get_world_inventory_state()
	if(!base_icon)
		base_icon = initial(icon_state)
	if(tint && check_state_in_icon("[base_icon]_dark", icon))
		icon_state = "[base_icon]_dark"
	else
		icon_state = base_icon

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments."
	icon = 'icons/clothing/spacesuit/generic/suit.dmi'
	w_class = ITEM_SIZE_LARGE//large item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency,/obj/item/suit_cooling_unit)
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_OVER)
	origin_tech = "{'materials':3, 'engineering':3}"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/clothing/suit/space/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)
