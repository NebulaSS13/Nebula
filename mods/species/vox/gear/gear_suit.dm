/obj/item/clothing/suit/space/void/setup_equip_flags()
	. = ..()
	if(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE)
		bodytype_equip_flags |= BODY_EQUIP_FLAG_VOX

/obj/item/clothing/suit/space/vox
	name = "alien pressure suit"
	icon = 'mods/species/vox/icons/clothing/pressure_suit.dmi'
	desc = "A huge, armoured, pressurized suit, designed for distinctly nonhuman proportions."
	w_class = ITEM_SIZE_NORMAL
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/baton,
		/obj/item/energy_blade/sword,
		/obj/item/handcuffs,
		/obj/item/tank
	)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.6
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX
	flags_inv = (HIDEJUMPSUIT|HIDETAIL)

/obj/item/clothing/suit/space/vox/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/suit/space/vox/carapace
	name = "alien carapace armour"
	color = "#486e6e"
	icon = 'mods/species/vox/icons/clothing/carapace_suit.dmi'
	desc = "An armoured, segmented carapace with glowing purple lights. It looks pretty run-down."
	var/lights_color = "#00ffff"

/obj/item/clothing/suit/space/vox/carapace/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && lights_color && check_state_in_icon("[overlay.icon_state]-lights", overlay.icon))
		var/image/I = emissive_overlay(overlay.icon, "[overlay.icon_state]-lights")
		I.color = lights_color
		I.appearance_flags |= RESET_COLOR
		overlay.overlays += I
	. = ..()

/obj/item/clothing/suit/space/vox/carapace/on_update_icon()
	. = ..()
	if(lights_color && check_state_in_icon("[icon_state]-lights", icon))
		var/image/I = emissive_overlay(icon, "[icon_state]-lights")
		I.color = lights_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/clothing/suit/space/vox/stealth
	name = "alien stealth suit"
	icon = 'mods/species/vox/icons/clothing/stealth_suit.dmi'
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."

/obj/item/clothing/suit/space/vox/medic
	name = "alien armour"
	icon = 'mods/species/vox/icons/clothing/medic_suit.dmi'
	desc = "An almost organic-looking nonhuman pressure suit."

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	icon = 'mods/species/vox/icons/clothing/scrap_suit.dmi'
	allowed = list(/obj/item/gun, /obj/item/tank)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED) //Higher melee armor versus lower everything else.
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_TAIL
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX
	siemens_coefficient = 1 //It's literally metal
