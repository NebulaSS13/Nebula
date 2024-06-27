//Armor plates
/obj/item/clothing/armor_attachment/plate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_light.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_MINOR
		)
	accessory_slot = ACCESSORY_SLOT_ARMOR_C
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'

/obj/item/clothing/armor_attachment/plate/get_fibers()
	return null	//plates do not shed

/obj/item/clothing/armor_attachment/plate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_medium.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	matter = list(
		/decl/material/solid/metal/plasteel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'

/obj/item/clothing/armor_attachment/plate/tactical
	name = "tactical armor plate"
	desc = "A heavier armor plate with additional diamond micromesh. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_tactical.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	accessory_slowdown = 0.5
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":3,"engineering":2,"combat":2}'
