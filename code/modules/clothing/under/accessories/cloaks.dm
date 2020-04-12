obj/item/clothing/accessory/cloak // A colorable cloak
	name = "blank cloak"
	desc = "A simple, bland cloak."
	icon_state = "cloak_colorable"

	item_icons = list(
		slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories.dmi', \
		slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories.dmi', \
		slot_tie_str = 'icons/mob/onmob/onmob_accessories.dmi')

	w_class = ITEM_SIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER
	slot_flags = SLOT_OCLOTHING

	allowed = list(/obj/item/tank/emergency/oxygen)
	high_visibility = TRUE
	made_of_cloth = TRUE

	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9

	var/fire_resist = T0C + 100

/obj/item/clothing/accessory/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the captain."
	icon_state = "cloak_cap"

/obj/item/clothing/accessory/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cloak_ce"

/obj/item/clothing/accessory/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cloak_cmo"

/obj/item/clothing/accessory/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "cloak_hop"

/obj/item/clothing/accessory/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "cloak_rd"

/obj/item/clothing/accessory/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "cloak_qm"

/obj/item/clothing/accessory/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon_state = "cloak_hos"


/obj/item/clothing/accessory/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cloak_cargo"

/obj/item/clothing/accessory/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "cloak_mining"

/obj/item/clothing/accessory/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "cloak_sec"

/obj/item/clothing/accessory/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "cloak_service"

/obj/item/clothing/accessory/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "cloak_engi"

/obj/item/clothing/accessory/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "cloak_atmos"

/obj/item/clothing/accessory/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "cloak_sci"

/obj/item/clothing/accessory/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "cloak_med"
