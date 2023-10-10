/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	closet_appearance = /decl/closet_appearance/wardrobe

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/red

/obj/structure/closet/wardrobe/red/WillContain()
	return list(
		/obj/item/clothing/under/security  = 3,
		/obj/item/clothing/under/security2 = 3,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/head/soft/sec   = 3,
	)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/pink


/obj/structure/closet/wardrobe/pink/WillContain()
	return list(
		/obj/item/clothing/under/color/pink  = 3,
		/obj/item/clothing/shoes/color/brown = 3,
	)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/black/WillContain()
	return list(
		/obj/item/clothing/under/color/black = 3,
		/obj/item/clothing/shoes/color/black = 3,
		/obj/item/clothing/head/that         = 3,
		/obj/item/clothing/head/soft/black   = 3,
	)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/chaplain_black/WillContain()
	return list(
		/obj/item/storage/candle_box = 2,
		/obj/item/clothing/under/chaplain,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/clothing/head/chaplain_hood,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/storage/backpack/cultpack,
		/obj/item/deck/tarot,
	)

/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/green/WillContain()
	return list(
		/obj/item/clothing/under/color/green = 3,
		/obj/item/clothing/shoes/color/black = 3,
	)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/xenos/WillContain()
	return list(
		/obj/item/clothing/suit/robe    = 3,
		/obj/item/clothing/shoes/sandal = 3,
	)

/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	closet_appearance = /decl/closet_appearance/wardrobe/orange

/obj/structure/closet/wardrobe/orange/WillContain()
	return list(
		/obj/item/clothing/under/color/orange = 3,
		/obj/item/clothing/shoes/color/orange = 3,
		/obj/item/radio/headset = 3,
	)

/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/yellow/WillContain()
	return list(
		/obj/item/clothing/under/color/yellow = 3,
		/obj/item/clothing/shoes/color/orange = 3,
	)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/atmospherics_yellow/WillContain()
	return list(
		/obj/item/clothing/under/atmospheric_technician = 3,
		/obj/item/clothing/shoes/workboots = 3,
		/obj/item/clothing/head/hardhat/red = 3,
	)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/engineering_yellow/WillContain()
	return list(
		/obj/item/clothing/under/engineer  = 3,
		/obj/item/clothing/shoes/workboots = 3,
		/obj/item/clothing/head/hardhat    = 3,
	)

/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/white/WillContain()
	return list(
		/obj/item/clothing/under/color/white = 3,
		/obj/item/clothing/shoes/color/white = 3,
	)

/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/pjs/WillContain()
	return list(
		/obj/item/clothing/under/pj = 2,
		/obj/item/clothing/under/pj/blue = 2,
		/obj/item/clothing/shoes/color/white = 2,
		/obj/item/clothing/shoes/slippers = 2,
	)

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/science_white/WillContain()
	return list(
		/obj/item/clothing/under/color/white = 3,
		/obj/item/clothing/suit/storage/toggle/labcoat = 3,
		/obj/item/clothing/shoes/color/white = 3,
	)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/robotics_black/WillContain()
	return list(
		/obj/item/clothing/under/roboticist = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/shoes/color/black = 2,
		/obj/item/clothing/gloves/thick = 2,
	)

/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/chemistry_white/WillContain()
	return list(
		/obj/item/clothing/under/chemist = 2,
		/obj/item/clothing/shoes/color/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 2,
	)

/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/genetics_white/WillContain()
	return list(
		/obj/item/clothing/under/geneticist  = 2,
		/obj/item/clothing/shoes/color/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics = 2,
	)

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/virology_white/WillContain()
	return list(
		/obj/item/clothing/under/virologist = 2,
		/obj/item/clothing/shoes/color/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 2,
		/obj/item/clothing/mask/surgical = 2,
	)

/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/medic_white/WillContain()
	return list(
		/obj/item/clothing/under/medical = 2,
		/obj/item/clothing/shoes/color/white = 3,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/clothing/under/medical/scrubs/blue,
		/obj/item/clothing/under/medical/scrubs/green,
		/obj/item/clothing/under/medical/scrubs/purple,
		/obj/item/clothing/under/medical/scrubs/black,
		/obj/item/clothing/under/medical/scrubs/navyblue,
		/obj/item/clothing/head/surgery/navyblue,
		/obj/item/clothing/head/surgery/purple,
		/obj/item/clothing/head/surgery/blue,
		/obj/item/clothing/head/surgery/green,
		/obj/item/clothing/head/surgery/black,
	)

/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/grey

/obj/structure/closet/wardrobe/grey/WillContain()
	return list(
		/obj/item/clothing/under/color/grey  = 3,
		/obj/item/clothing/shoes/color/black = 3,
		/obj/item/clothing/head/soft/grey    = 3,
	)

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/mixed/WillContain()
	return list(
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/dress/plaid_blue,
		/obj/item/clothing/under/dress/plaid_red,
		/obj/item/clothing/under/dress/plaid_purple,
		/obj/item/clothing/shoes/color/blue,
		/obj/item/clothing/shoes/color/yellow,
		/obj/item/clothing/shoes/color/green,
		/obj/item/clothing/shoes/color/orange,
		/obj/item/clothing/shoes/color/purple,
		/obj/item/clothing/shoes/color/red,
		/obj/item/clothing/shoes/craftable,
		/obj/item/clothing/accessory/toggleable/hawaii/random,
	)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	closet_appearance = /decl/closet_appearance/tactical

/obj/structure/closet/wardrobe/tactical/WillContain()
	return list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/suit/armor/pcarrier/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/storage/belt/holster/security/tactical,
		/obj/item/clothing/shoes/jackboots/tactical,
		/obj/item/clothing/gloves/tactical,
	)

/obj/structure/closet/wardrobe/suit
	name = "formal clothing locker"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/suit/WillContain()
	return list(
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/female,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/scratch,
		/obj/item/clothing/under/internalaffairs/plain,
		/obj/item/clothing/suit/storage/toggle/suit/black,
		/obj/item/clothing/under/assistantformal,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/bluesuit,
		/obj/item/clothing/suit/storage/toggle/suit/blue,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/suit/storage/toggle/suit/purple,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/clothing/shoes/dress,
	)

/obj/structure/closet/wardrobe/lawyer_black
	name = "internal affairs wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/lawyer_black/WillContain()
	return list(
		/obj/item/clothing/under/internalaffairs = 2,
		/obj/item/clothing/suit/storage/toggle/suit/black = 2,
		/obj/item/clothing/shoes/color/brown = 2,
		/obj/item/clothing/glasses/sunglasses/big = 2,
		/obj/item/storage/briefcase = 2,
	)
