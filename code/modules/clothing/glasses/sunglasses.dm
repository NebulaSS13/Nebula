/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Glasses with treated lenses to prevent glare. They provide some rudamentary protection from dazzling attacks."
	icon = 'icons/clothing/eyes/sunglasses.dmi'
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MINOR

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 5

/obj/item/clothing/glasses/sunglasses/big
	name = "thick sunglasses"
	desc = "Glasses with treated lenses to prevent glare. The thick, wide lenses protect against a variety of flash attacks."
	icon = 'icons/clothing/eyes/sunglasses_big.dmi'
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon = 'icons/clothing/eyes/sunglasses_hud.dmi'
	hud = /obj/item/clothing/glasses/hud/security
	electric = TRUE
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/sechud/goggles
	name = "HUD goggles"
	desc = "A pair of goggles with an inbuilt heads up display. The lenses provide some flash protection."
	icon = 'icons/clothing/eyes/goggles_hud.dmi'

/obj/item/clothing/glasses/sunglasses/sechud/toggle
	name = "HUD aviators"
	desc = "Modified aviator glasses that can be switched between HUD and darkened modes."
	icon = 'icons/clothing/eyes/hud_sec_aviators.dmi'
	action_button_name = "Toggle Mode"
	toggleable = TRUE
	activation_sound = 'sound/effects/pop.ogg'
	toggle_on_message = "You switch $ITEM$ to HUD mode."
	toggle_off_message = "You toggle $ITEM$'s darkened mode on."
	var/hud_holder

/obj/item/clothing/glasses/sunglasses/sechud/toggle/Initialize()
	. = ..()
	hud_holder = hud

/obj/item/clothing/glasses/sunglasses/sechud/toggle/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	. = ..()

/obj/item/clothing/glasses/sunglasses/sechud/toggle/set_active_values()
	..()
	flash_protection = FLASH_PROTECTION_NONE
	hud = hud_holder

/obj/item/clothing/glasses/sunglasses/sechud/toggle/set_inactive_values()
	..()
	flash_protection = initial(flash_protection)
	hud = null
