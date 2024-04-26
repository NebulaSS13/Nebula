
/obj/item/clothing/suit/armor/pcarrier/merc
	starting_accessories = list(
		/obj/item/clothing/armor_attachment/plate/merc,
		/obj/item/clothing/gloves/armguards/merc,
		/obj/item/clothing/shoes/legguards/merc,
		/obj/item/clothing/webbing/pouches/large
	)

/obj/item/clothing/armor_attachment/plate/merc
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

/obj/item/clothing/gloves/armguards/merc
	name = "heavy arm guards"
	desc = "A pair of red-trimmed black arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armguards_merc.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	color = null
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'

/obj/item/clothing/shoes/legguards/merc
	name = "heavy leg guards"
	desc = "A pair of heavily armored leg pads in red-trimmed black. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/legguards_merc.dmi'
	color = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'
