/obj/item/clothing/head/helmet/space/void/Initialize()
	. = ..()
	if("exclude" in bodytype_restricted)
		LAZYDISTINCTADD(bodytype_restricted, BODYTYPE_VOX)
	else if(length(bodytype_restricted))
		LAZYREMOVE(bodytype_restricted, BODYTYPE_VOX)
	else
		bodytype_restricted = list("exclude", BODYTYPE_VOX)

/obj/item/clothing/head/helmet/space/vox
	name = "alien helmet"
	icon = 'mods/species/vox/icons/clothing/pressure_helmet.dmi'
	desc = "A huge, armoured, pressurized helmet. Looks like an ancient human diving suit."
	light_overlay = "invis_light"
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SMALL, 
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.6
	item_flags = 0
	flags_inv = 0
	bodytype_restricted = list(BODYTYPE_VOX)

/obj/item/clothing/head/helmet/space/vox/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
	
/obj/item/clothing/head/helmet/space/vox/carapace
	name = "alien visor"
	icon = 'mods/species/vox/icons/clothing/carapace_helmet.dmi'
	desc = "A glowing visor. The light slowly pulses, and seems to follow you."
	color = "#486e6e"
	var/lights_color = "#00ffff"

/obj/item/clothing/head/helmet/space/vox/carapace/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart)
	if(overlay && lights_color && check_state_in_icon("[overlay.icon_state]-lights", overlay.icon))
		var/image/I = emissive_overlay(overlay.icon, "[overlay.icon_state]-lights")
		I.color = lights_color
		I.appearance_flags |= RESET_COLOR
		overlay.overlays += I
	. = ..()

/obj/item/clothing/head/helmet/space/vox/carapace/on_update_icon()
	cut_overlays()
	if(lights_color && check_state_in_icon("[icon_state]-lights", icon))
		var/image/I = emissive_overlay(icon, "[icon_state]-lights")
		I.color = lights_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/clothing/head/helmet/space/vox/stealth
	name = "alien stealth helmet"
	icon = 'mods/species/vox/icons/clothing/stealth_helmet.dmi'
	desc = "A smoothly contoured, matte-black alien helmet."

/obj/item/clothing/head/helmet/space/vox/medic
	name = "alien goggled helmet"
	icon = 'mods/species/vox/icons/clothing/medic_helmet.dmi'
	desc = "An alien helmet with enormous goggled lenses."
