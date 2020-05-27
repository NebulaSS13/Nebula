/obj/item/clothing/suit/armor/pcarrier/light/nt
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/armor/tag/corp)

/obj/item/clothing/suit/armor/pcarrier/medium/nt
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/corp)

/obj/item/clothing/suit/armor/vest/nt
	name = "corporate armored vest"
	desc = "A synthetic armor vest. This one is marked with a corporate logo."
	icon = 'mods/corporate/icons/obj/clothing/obj_suit.dmi'
	icon_state = "ntvest"
	item_icons = list(slot_wear_suit_str = 'mods/corporate/icons/mob/onmob_suit.dmi')

//Non-hardsuit ERT armor.
//Commander
/obj/item/clothing/suit/armor/vest/ert
	name = "asset protection command armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has blue highlights."
	icon = 'mods/corporate/icons/obj/clothing/obj_suit.dmi'
	icon_state = "ertarmor_cmd"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	item_icons = list(slot_wear_suit_str = 'mods/corporate/icons/mob/onmob_suit.dmi')

//Security
/obj/item/clothing/suit/armor/vest/ert/security
	name = "asset protection security armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has red highlights."
	icon_state = "ertarmor_sec"

//Engineer
/obj/item/clothing/suit/armor/vest/ert/engineer
	name = "asset protection engineering armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has orange highlights."
	icon_state = "ertarmor_eng"

//Medical
/obj/item/clothing/suit/armor/vest/ert/medical
	name = "asset protection medical armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has red and white highlights."
	icon_state = "ertarmor_med"

/obj/item/clothing/suit/armor/vest/security
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a corporate badge."
	icon = 'mods/corporate/icons/obj/clothing/obj_suit.dmi'
	icon_state = "armorsec"
	item_icons = list(slot_wear_suit_str = 'mods/corporate/icons/mob/onmob_suit.dmi')
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)

