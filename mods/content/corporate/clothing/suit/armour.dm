/obj/item/clothing/suit/armor/pcarrier/nt_light
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate, /obj/item/clothing/accessory/armor/tag/corp)

/obj/item/clothing/suit/armor/pcarrier/nt_medium
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/corp)

/obj/item/clothing/suit/armor/vest/nt
	name = "corporate armored vest"
	desc = "A synthetic armor vest. This one is marked with a corporate logo."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/nt.dmi'

//Non-hardsuit ERT armor.
//Commander
/obj/item/clothing/suit/armor/vest/ert
	name = "asset protection command armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has blue highlights."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/ert_cmd.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)

//Security
/obj/item/clothing/suit/armor/vest/ert/security
	name = "asset protection security armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has red highlights."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/ert_sec.dmi'

//Engineer
/obj/item/clothing/suit/armor/vest/ert/engineer
	name = "asset protection engineering armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has orange highlights."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/ert_eng.dmi'

//Medical
/obj/item/clothing/suit/armor/vest/ert/medical
	name = "asset protection medical armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has red and white highlights."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/ert_med.dmi'

/obj/item/clothing/suit/armor/vest/security
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a corporate badge."
	icon = 'mods/content/corporate/icons/clothing/suit/armor/sec.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)

