/decl/hierarchy/supply_pack/supply
	name = "Supplies - Comissary"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/supply/toner
	name = "Refills - Toner cartridges"
	contains = list(/obj/item/chems/toner_cartridge = 3)
	containername = "toner cartridges"

/decl/hierarchy/supply_pack/supply/cardboard_sheets
	name = "Material - cardboard sheets (50)"
	contains = list(/obj/item/stack/material/cardstock/mapped/cardboard/fifty)
	containername = "cardboard sheets crate"

/decl/hierarchy/supply_pack/supply/stickies
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	containername = "\improper Sticky notes crate"

/decl/hierarchy/supply_pack/supply/wpaper
	name = "Cargo - Wrapping paper"
	contains = list(/obj/item/stack/package_wrap/twenty_five = 3)
	containername = "wrapping paper"

/decl/hierarchy/supply_pack/supply/tapes
	name = "Supplies - Blank Tapes (14)"
	contains = list (/obj/item/box/tapes)
	containername = "blank tapes crate"

/decl/hierarchy/supply_pack/supply/taperolls
	name = "Supplies - Barricade Tapes (mixed)"
	contains = list (/obj/item/box/taperolls)
	containername = "barricade tape crate"

/decl/hierarchy/supply_pack/supply/bogrolls
	name = "Custodial - Toilet paper (12)"
	contains = list (/obj/item/box/bogrolls = 2)
	containername = "toilet paper crate"

/decl/hierarchy/supply_pack/supply/scanner_module
	name = "Electronics - Paper scanner modules"
	contains = list(/obj/item/stock_parts/computer/scanner/paper = 4)
	containername = "paper scanner module crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Electronics - Spare PDAs"
	contains = list(/obj/item/modular_computer/pda = 3)
	containername = "spare PDA crate"

/decl/hierarchy/supply_pack/supply/eftpos
	contains = list(/obj/item/eftpos)
	name = "Electronics - EFTPOS scanner"
	containername = "\improper EFTPOS crate"

/decl/hierarchy/supply_pack/supply/water
	name = "Refills - Bottled water"
	contains = list (/obj/item/box/water = 2)
	containername = "bottled water crate"

/decl/hierarchy/supply_pack/supply/sodas
	num_contained = 2
	contains = list(/obj/item/box/cola,
					/obj/item/box/cola/spacewind,
					/obj/item/box/cola/drgibb,
					/obj/item/box/cola/starkist,
					/obj/item/box/cola/spaceup,
					/obj/item/box/cola/lemonlime,
					/obj/item/box/cola/icedtea,
					/obj/item/box/cola/grapejuice,
					/obj/item/box/cola/sodawater)
	name = "Refills - Soda cans"
	containername = "soda can crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/snacks
	num_contained = 2
	contains = list(/obj/item/box/snack,
					/obj/item/box/snack/noraisin,
					/obj/item/box/snack/cheesehonks,
					/obj/item/box/snack/tastybread,
					/obj/item/box/snack/candy,
					/obj/item/box/snack/chips)
	name = "Refills - Snack foods"
	containername = "snack foods crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/canned
	num_contained = 2
	contains = list(/obj/item/box/canned,
					/obj/item/box/canned/beef,
					/obj/item/box/canned/beans,
					/obj/item/box/canned/tomato,
)
	name = "Emergency - Canned foods"
	containername = "canneds crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/decl/hierarchy/supply_pack/supply/watertank
	name = "Liquid - Water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 12
	containertype = /obj/structure/largecrate
	containername = "water tank crate"

//replacement vendors
//Vending Machines
//I have decided against adding the adherent vendor because it is a modified machine as well as the security vendors, which should probably be under a bit more scrutiny than "whoever is deck tech at the time"

/decl/hierarchy/supply_pack/supply/snackvendor
	name = "Vendor - Getmoore Chocolate Co"
	contains = list(/obj/machinery/vending/snack)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/snixvendor
	name = "Vendor - Snix Zakuson TCC"
	contains = list(/obj/machinery/vending/snix)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/solvendor
	name = "Vendor - Mars Mart SCC"
	contains = list(/obj/machinery/vending/sol)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/sodavendor
	name = "Vendor - Softdrinks Robust Industries LLC"
	contains = list(/obj/machinery/vending/cola)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/lavatoryvendor
	name = "Vendor - Lavatory Essentials - Waffle Co"
	contains = list(/obj/machinery/vending/lavatory)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/boozevendor
	name = "Vendor - Booze-o-mat - GrekkaTarg Boozeries"
	contains = list(/obj/machinery/vending/boozeomat)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/gamevendor
	name = "Vendor - Games - Honk Co"
	contains = list(/obj/machinery/vending/games)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/fitnessvendor
	name = "Vendor - Fitness - SwolMAX Bros"
	contains = list(/obj/machinery/vending/fitness)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/cigarettevendor
	name = "Vendor - Cigarettes - Gideon Asbestos Mining Conglomerate"
	contains = list(/obj/machinery/vending/cigarette)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"
	cost = 150

/decl/hierarchy/supply_pack/supply/roboticsvendor
	name = "Vendor - Robotics - Dandytronics LLT"
	contains = list(/obj/machinery/vending/robotics)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/engineeringvendor
	name = "Vendor - Engineering - Dandytronics LLT"
	contains = list(/obj/machinery/vending/engineering)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/toolvendor
	name = "Vendor - Tools - YouTool Co"
	contains = list(/obj/machinery/vending/tool)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/coffeevendor
	name = "Vendor - Coffee - Hot Drinks LCD"
	contains = list(/obj/machinery/vending/coffee)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/dinnerwarevendor
	name = "Vendor - Dinnerwares - Plastic Tat Inc"
	contains = list(/obj/machinery/vending/dinnerware)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/bodavendor
	name = "Vendor - BODA - Zakuson TCC"
	contains = list(/obj/machinery/vending/sovietsoda)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/weebvendor
	name = "Vendor - Nippon-tan - ArigatoRobotics LCD"
	contains = list(/obj/machinery/vending/weeb)
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"