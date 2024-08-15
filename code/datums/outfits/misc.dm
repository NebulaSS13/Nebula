/decl/outfit/standard_space_gear
	name = "Standard space gear"
	shoes = /obj/item/clothing/shoes/color/black
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/space
	uniform = /obj/item/clothing/jumpsuit/grey
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/breath
	outfit_flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT

/decl/outfit/soviet_soldier
	name = "Soviet soldier"
	uniform = /obj/item/clothing/costume/soviet
	shoes = /obj/item/clothing/shoes/jackboots/swat/combat
	head = /obj/item/clothing/head/ushanka
	gloves = /obj/item/clothing/gloves/thick/combat
	back = /obj/item/backpack/satchel
	belt = /obj/item/gun/projectile/revolver

/decl/outfit/soviet_soldier/admiral
	name = "Soviet admiral"
	head = /obj/item/clothing/head/hgpiratecap
	l_ear = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	suit = /obj/item/clothing/suit/hgpirate

	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Admiral"

/decl/outfit/clown
	name = "Clown"
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_ear =  /obj/item/radio/headset
	uniform = /obj/item/clothing/costume/clown
	l_pocket = /obj/item/bikehorn
	outfit_flags = OUTFIT_HAS_BACKPACK | OUTFIT_RESET_EQUIPMENT | OUTFIT_HAS_VITALS_SENSOR

/decl/outfit/clown/Initialize()
	. = ..()
	backpack_overrides[/decl/backpack_outfit/backpack] = /obj/item/backpack/clown
