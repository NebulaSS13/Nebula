/obj/item/clothing/suit/armor/pcarrier/light/nt
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/armor/tag/nt)

/obj/item/clothing/suit/armor/pcarrier/medium/nt
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/nt)

/obj/item/clothing/suit/armor/vest/nt
	name = "corporate armored vest"
	desc = "A synthetic armor vest. This one is marked with a corporate logo."
	icon_state = "ntvest"

//Non-hardsuit ERT armor.
//Commander
/obj/item/clothing/suit/armor/vest/ert
	name = "asset protection command armor"
	desc = "A set of armor worn by many corporate and private asset protection forces. Has blue highlights."
	icon_state = "ertarmor_cmd"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
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

/obj/item/clothing/suit/armor/vest/old/security
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a corporate badge."
	icon_state = "armorsec"
