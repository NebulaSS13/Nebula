
/obj/item/clothing/suit/armor/pcarrier/merc
	starting_accessories = list(
		/obj/item/clothing/armor_plate/merc,
		/obj/item/clothing/gloves/armguards/merc,
		/obj/item/clothing/shoes/legguards/merc,
		/obj/item/clothing/webbing/pouches/large
	)

/obj/item/clothing/armor_plate/merc
	name = "heavy armor plate"
	desc = "A diamond-reinforced titanium armor plate, providing state of of the art protection. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_merc.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	material = /decl/material/solid/metal/titanium
	matter = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":5,"engineering":2,"combat":3}'
