/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	icon_deny = "MagiVend-deny"
	icon_vend = "MagiVend-vend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Down with Central!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(
		/obj/item/clothing/head/wizard = 1,
		/obj/item/clothing/suit/wizrobe = 1,
		/obj/item/clothing/head/wizard/red = 1,
		/obj/item/clothing/suit/wizrobe/red = 1,
		/obj/item/clothing/shoes/sandal = 1,
		/obj/item/staff = 2)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	icon_vend = "dinnerware-vend"
	icon_deny = "dinnerware-deny"
	markup = 0
	base_type = /obj/machinery/vending/dinnerware
	products = list(
		/obj/item/chems/glass/beaker/bowl =2,
		/obj/item/storage/tray/metal/aluminium = 8,
		/obj/item/knife/kitchen = 3,
		/obj/item/kitchen/rollingpin = 2,
		/obj/item/chems/drinks/pitcher = 2,
		/obj/item/chems/drinks/glass2/coffeecup = 8,
		/obj/item/chems/drinks/glass2/coffeecup/teacup = 8,
		/obj/item/chems/drinks/glass2/carafe = 2,
		/obj/item/chems/drinks/glass2/square = 8,
		/obj/item/clothing/suit/chef/classic = 2,
		/obj/item/storage/lunchbox = 3,
		/obj/item/storage/lunchbox/heart = 3,
		/obj/item/storage/lunchbox/cat = 3,
		/obj/item/storage/lunchbox/mars = 3,
		/obj/item/storage/lunchbox/cti = 3,
		/obj/item/storage/lunchbox/syndicate = 3,
		/obj/item/knife/kitchen/cleaver = 1
	)
	contraband = list(/obj/item/knife/kitchen/cleaver/bronze = 1,/obj/item/storage/tray/metal/silver = 1)

/obj/machinery/vending/fashionvend
	name = "Smashing Fashions"
	desc = "For all your cheap knockoff needs."
	product_slogans = "Look smashing for your darling!;Be rich! Dress rich!"
	icon_state = "theater"
	vend_delay = 15
	base_type = /obj/machinery/vending/fashionvend
	vend_reply = "Absolutely smashing!"
	product_ads = "Impress the love of your life!;Don't look poor, look rich!;100% authentic designers!;All sales are final!;Lowest prices guaranteed!"
	products = list(
		/obj/item/mirror = 8,
		/obj/item/haircomb = 8,
		/obj/item/clothing/glasses/eyepatch/monocle = 5,
		/obj/item/clothing/glasses/sunglasses = 5,
		/obj/item/lipstick = 3,
		/obj/random/lipstick = 3,
		/obj/item/storage/wallet/poly = 2
	)
	contraband = list(
		/obj/item/clothing/glasses/eyepatch = 2,
		/obj/item/clothing/accessory/horrible = 2,
		/obj/item/clothing/mask/smokable/pipe = 3
	)

// eliza's attempt at a new vending machine
/obj/machinery/vending/games
	name = "Good Clean Fun"
	desc = "Vends things that the CO and SEA are probably not going to appreciate you fiddling with instead of your job..."
	vend_delay = 15
	product_slogans = "Escape to a fantasy world!;Fuel your gambling addiction!;Ruin your friendships!"
	product_ads = "Elves and dwarves!;Totally not satanic!;Fun times forever!"
	icon_state = "games"
	icon_deny = "games-deny"
	icon_vend = "games-vend"
	base_type = /obj/machinery/vending/games
	products = list(
		/obj/item/toy/blink = 5,
		/obj/item/toy/eightball = 8,
		/obj/item/deck/cards = 5,
		/obj/item/deck/tarot = 5,
		/obj/item/deck/cag/white = 5,
		/obj/item/deck/cag/black = 5,
		/obj/item/pack/cardemon = 6,
		/obj/item/pack/spaceball = 6,
		/obj/item/storage/pill_bottle/dice_nerd = 5,
		/obj/item/storage/pill_bottle/dice = 5,
		/obj/item/storage/box/checkers = 2,
		/obj/item/storage/box/checkers/chess/red = 2,
		/obj/item/storage/box/checkers/chess = 2,
		/obj/item/board = 2
	)
	contraband = list(
		/obj/item/chems/spray/waterflower = 2,
		/obj/item/storage/box/snappops = 3,
		/obj/item/spirit_board = 1,
		/obj/item/gun/projectile/revolver/capgun = 1,
		/obj/item/ammo_magazine/caps = 4
	)

//Cajoes/Kyos/BloodyMan's Lavatory Articles Dispensiary

/obj/machinery/vending/lavatory
	name = "Lavatory Essentials"
	desc = "Vends things that make you less reviled in the work-place!"
	vend_delay = 15
	product_slogans = "Take a shower you hippie.;Get a haircut, hippie!;Reeking of scale taint? Take a shower!"

	icon_state = "lavatory"
	icon_deny = "lavatory-deny"
	icon_vend = "lavatory-vend"
	base_type = /obj/machinery/vending/lavatory
	products = list(
		/obj/item/soap = 12,
		/obj/item/mirror = 8,
		/obj/item/haircomb/random = 8,
		/obj/item/haircomb/brush = 4,
		/obj/item/towel/random = 6,
		/obj/item/chems/spray/cleaner/deodorant = 5
	)
	contraband = list(
		/obj/item/inflatable_duck = 1
	)
