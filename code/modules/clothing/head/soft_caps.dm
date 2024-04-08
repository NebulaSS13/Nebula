/obj/item/clothing/head/soft
	name = "cargo cap"
	desc = "It's a peaked cap in a tasteless yellow color."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/softcap.dmi'
	color = COLOR_YELLOW_GRAY
	var/flipped = 0
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/soft/on_update_icon()
	. = ..()
	if(flipped)
		icon_state = "[get_world_inventory_state()]_flipped"

/obj/item/clothing/head/soft/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && flipped && check_state_in_icon("[overlay.icon_state]_flipped", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_flipped"
	. = ..()

/obj/item/clothing/head/soft/dropped()
	src.flipped=0
	update_icon()
	..()

/obj/item/clothing/head/soft/attack_self(mob/user)
	src.flipped = !src.flipped
	if(src.flipped)
		to_chat(user, "You flip the hat backwards.")
	else
		to_chat(user, "You flip the hat back in normal position.")
	update_icon()
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/soft/red
	name = "red cap"
	desc = "It's a peaked hat in a tasteless red color."
	color = COLOR_NT_RED

/obj/item/clothing/head/soft/blue
	name = "blue cap"
	desc = "It's a peaked cap in a tasteless blue color."
	color = COLOR_BLUE_GRAY

/obj/item/clothing/head/soft/green
	name = "green cap"
	desc = "It's a peaked cap in a tasteless green color."
	color = COLOR_BOTTLE_GREEN

/obj/item/clothing/head/soft/yellow
	name = "yellow cap"
	desc = "It's a peaked cap in a tasteless yellow color."
	color = COLOR_YELLOW_GRAY

/obj/item/clothing/head/soft/grey
	name = "grey cap"
	desc = "It's a peaked cap in a tasteful grey color."
	color = COLOR_GRAY

/obj/item/clothing/head/soft/orange
	name = "orange cap"
	desc = "It's a peaked cap in a tasteless orange color."
	color = COLOR_SEDONA

/obj/item/clothing/head/soft/mime
	name = "white cap"
	desc = "It's a peaked cap in a tasteless white color."
	color = COLOR_WHITE

/obj/item/clothing/head/soft/purple
	name = "purple cap"
	desc = "It's a peaked cap in a tasteless purple color."
	color = COLOR_PURPLE

/obj/item/clothing/head/soft/rainbow
	name = "rainbow cap"
	desc = "It's a peaked cap in a bright rainbow of colors."
	icon = 'icons/clothing/head/softcap_rainbow.dmi'
	color = null

/obj/item/clothing/head/soft/sec
	name = "security cap"
	desc = "It's a field cap in tasteful red color."
	color = COLOR_NT_RED

/obj/item/clothing/head/soft/black
	name = "black cap"
	desc = "It's a peaked cap in a tasteful black color."
	color = COLOR_GRAY20
