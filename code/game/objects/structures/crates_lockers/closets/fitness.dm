/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/athletic_mixed/WillContain()
	return list(
		/obj/item/clothing/pants/shorts/athletic/grey,
		/obj/item/clothing/pants/shorts/athletic/black,
		/obj/item/clothing/pants/shorts/athletic/red,
		/obj/item/clothing/pants/shorts/athletic/blue,
		/obj/item/clothing/pants/shorts/athletic/green,
		/obj/item/clothing/mask/snorkel = 2,
		/obj/item/clothing/shoes/swimmingfins = 2,
		/obj/item/towel = 2)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/WillContain()
	return list(
		/obj/item/clothing/gloves/boxing/blue,
		/obj/item/clothing/gloves/boxing/green,
		/obj/item/clothing/gloves/boxing/yellow,
		/obj/item/clothing/gloves/boxing)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/WillContain()
	return list(
		/obj/item/clothing/mask/luchador,
		/obj/item/clothing/mask/luchador/rudos,
		/obj/item/clothing/mask/luchador/tecnicos)

/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	closet_appearance = /decl/closet_appearance/wardrobe/red

/obj/structure/closet/lasertag/red/WillContain()
	return list(
		/obj/item/gun/energy/lasertag/red = 3,
		/obj/item/clothing/suit/redtag = 3)

/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	closet_appearance = /decl/closet_appearance/wardrobe

/obj/structure/closet/lasertag/blue/WillContain()
	return list(
		/obj/item/gun/energy/lasertag/blue = 3,
		/obj/item/clothing/suit/bluetag = 3)
