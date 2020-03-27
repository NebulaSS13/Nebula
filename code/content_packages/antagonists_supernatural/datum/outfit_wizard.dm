/decl/hierarchy/outfit/wizard
	uniform = /obj/item/clothing/under/color/lightpurple
	shoes = /obj/item/clothing/shoes/sandal
	l_ear = /obj/item/radio/headset
	r_pocket = /obj/item/teleportation_scroll
	l_hand = /obj/item/staff
	r_hand = /obj/item/spellbook
	back = /obj/item/storage/backpack
	backpack_contents = list(/obj/item/storage/box = 1)
	hierarchy_type = /decl/hierarchy/outfit/wizard
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/wizard/blue
	name = "Wizard - Blue"
	head = /obj/item/clothing/head/wizard
	suit = /obj/item/clothing/suit/wizrobe

/decl/hierarchy/outfit/wizard/red
	name = "Wizard - Red"
	head = /obj/item/clothing/head/wizard/red
	suit = /obj/item/clothing/suit/wizrobe/red

/decl/hierarchy/outfit/wizard/marisa
	name = "Wizard - Marisa"
	head = /obj/item/clothing/head/wizard/marisa
	suit = /obj/item/clothing/suit/wizrobe/marisa
	shoes = /obj/item/clothing/shoes/sandal/marisa

/obj/effect/landmark/costume/marisawizard/fake/make_costumes()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)

/obj/effect/landmark/costume/fakewizard/make_costumes()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)