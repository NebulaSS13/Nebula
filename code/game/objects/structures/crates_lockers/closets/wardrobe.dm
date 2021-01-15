/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	closet_appearance = /decl/closet_appearance/wardrobe

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/red

/obj/structure/closet/wardrobe/red/Initialize()
	. = ..()
	new /obj/item/clothing/under/security(src)
	new /obj/item/clothing/under/security(src)
	new /obj/item/clothing/under/security(src)
	new /obj/item/clothing/under/security2(src)
	new /obj/item/clothing/under/security2(src)
	new /obj/item/clothing/under/security2(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/pink


/obj/structure/closet/wardrobe/pink/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/shoes/color/brown(src)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/black/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/chaplain_black/Initialize()
	. = ..()
	new /obj/item/clothing/under/chaplain(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/clothing/under/wedding/bride_white(src)
	new /obj/item/storage/backpack/cultpack (src)
	new /obj/item/storage/candle_box(src)
	new /obj/item/storage/candle_box(src)
	new /obj/item/deck/tarot(src)

/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/green/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/xenos/Initialize()
	. = ..()
	new /obj/item/clothing/suit/robe(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)

/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	closet_appearance = /decl/closet_appearance/wardrobe/orange

/obj/structure/closet/wardrobe/orange/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/radio/headset(src)
	new /obj/item/radio/headset(src)
	new /obj/item/radio/headset(src)

/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/yellow/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/clothing/shoes/color/orange(src)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/atmospherics_yellow/Initialize()
	. = ..()
	new /obj/item/clothing/under/atmospheric_technician(src)
	new /obj/item/clothing/under/atmospheric_technician(src)
	new /obj/item/clothing/under/atmospheric_technician(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/engineering_yellow/Initialize()
	. = ..()
	new /obj/item/clothing/under/engineer(src)
	new /obj/item/clothing/under/engineer(src)
	new /obj/item/clothing/under/engineer(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)

/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/white/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)

/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/pjs/Initialize()
	. = ..()
	new /obj/item/clothing/under/pj(src)
	new /obj/item/clothing/under/pj(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/science_white/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/robotics_black/Initialize()
	. = ..()
	new /obj/item/clothing/under/roboticist(src)
	new /obj/item/clothing/under/roboticist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/gloves/thick(src)

/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/chemistry_white/Initialize()
	. = ..()
	new /obj/item/clothing/under/chemist(src)
	new /obj/item/clothing/under/chemist(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)

/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/genetics_white/Initialize()
	. = ..()
	new /obj/item/clothing/under/geneticist(src)
	new /obj/item/clothing/under/geneticist(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/virology_white/Initialize()
	. = ..()
	new /obj/item/clothing/under/virologist(src)
	new /obj/item/clothing/under/virologist(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)

/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/medic_white/Initialize()
	. = ..()
	new /obj/item/clothing/under/medical(src)
	new /obj/item/clothing/under/medical(src)
	new /obj/item/clothing/under/medical/scrubs/blue(src)
	new /obj/item/clothing/under/medical/scrubs/green(src)
	new /obj/item/clothing/under/medical/scrubs/purple(src)
	new /obj/item/clothing/under/medical/scrubs/black(src)
	new /obj/item/clothing/under/medical/scrubs/navyblue(src)
	new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/black(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)

/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/grey

/obj/structure/closet/wardrobe/grey/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/shoes/color/black(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/mixed/Initialize()
	. = ..()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/dress/plaid_blue(src)
	new /obj/item/clothing/under/dress/plaid_red(src)
	new /obj/item/clothing/under/dress/plaid_purple(src)
	new /obj/item/clothing/shoes/color/blue(src)
	new /obj/item/clothing/shoes/color/yellow(src)
	new /obj/item/clothing/shoes/color/green(src)
	new /obj/item/clothing/shoes/color/orange(src)
	new /obj/item/clothing/shoes/color/purple(src)
	new /obj/item/clothing/shoes/color/red(src)
	new /obj/item/clothing/shoes/craftable(src)
	new /obj/item/clothing/accessory/toggleable/hawaii/random(src)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	closet_appearance = /decl/closet_appearance/tactical

/obj/structure/closet/wardrobe/tactical/Initialize()
	. = ..()
	new /obj/item/clothing/under/tactical(src)
	new /obj/item/clothing/suit/armor/pcarrier/tactical(src)
	new /obj/item/clothing/head/helmet/tactical(src)
	new /obj/item/clothing/mask/balaclava/tactical(src)
	new /obj/item/clothing/glasses/tacgoggles(src)
	new /obj/item/storage/belt/holster/security/tactical(src)
	new /obj/item/clothing/shoes/jackboots/tactical(src)
	new /obj/item/clothing/gloves/tactical(src)

/obj/structure/closet/wardrobe/suit
	name = "formal clothing locker"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/suit/Initialize()
	. = ..()
	new /obj/item/clothing/under/suit_jacket/charcoal(src)
	new /obj/item/clothing/under/suit_jacket/navy(src)
	new /obj/item/clothing/under/suit_jacket/burgundy(src)
	new /obj/item/clothing/under/suit_jacket/checkered(src)
	new /obj/item/clothing/under/suit_jacket/tan(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/suit_jacket(src)
	new /obj/item/clothing/under/suit_jacket/female(src)
	new /obj/item/clothing/under/suit_jacket/really_black(src)
	new /obj/item/clothing/under/suit_jacket/red(src)
	new /obj/item/clothing/under/scratch(src)
	new /obj/item/clothing/under/internalaffairs/plain(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/under/assistantformal(src)
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/suit/storage/toggle/suit/blue(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/storage/toggle/suit/purple(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/shoes/dress(src)

/obj/structure/closet/wardrobe/lawyer_black
	name = "internal affairs wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/lawyer_black/Initialize()
	. = ..()
	new /obj/item/clothing/under/internalaffairs(src)
	new /obj/item/clothing/under/internalaffairs(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/shoes/color/brown(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/storage/briefcase(src)
	new /obj/item/storage/briefcase(src)
