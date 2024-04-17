
// This monstrosity deserves own file
/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "A specialized vending machine designed to contribute to your slow and uncomfortable death."
	product_slogans = "There's no better time to start smokin'.;\
		Smoke now, and win the adoration of your peers.;\
		They beat cancer centuries ago, so smoke away.;\
		If you're not smoking, you must be joking."
	product_ads = "Probably not bad for you!;\
		Don't believe the scientists!;\
		It's good for you!;\
		Don't quit, buy more!;\
		Smoke!;\
		Nicotine heaven.;\
		Best cigarettes since 2150.;\
		Award-winning cigarettes, all the best brands.;\
		Feeling temperamental? Try a Temperamento!;\
		Carcinoma Angels - go fuck yerself!;\
		Don't be so hard on yourself, kid. Smoke a Lucky Star!;\
		We understand the depressed, alcoholic cowboy in you. That's why we also smoke Jericho.;\
		Professionals. Better cigarettes for better people. Yes, better people."
	vend_delay = 21
	icon_state = "cigs"
	icon_vend = "cigs-vend"
	icon_deny = "cigs-deny"
	base_type = /obj/machinery/vending/cigarette
	products = list(
		/obj/item/cigpaper/filters = 5,
		/obj/item/cigpaper = 3,
		/obj/item/cigpaper/fancy = 2,
		/obj/item/chewables/rollable/bad = 2,
		/obj/item/chewables/rollable/generic = 2,
		/obj/item/chewables/rollable/fine = 2,
		/obj/item/box/fancy/cigarettes = 5,
		/obj/item/box/fancy/cigarettes/luckystars = 2,
		/obj/item/box/fancy/cigarettes/jerichos = 2,
		/obj/item/box/fancy/cigarettes/menthols = 2,
		/obj/item/box/fancy/cigarettes/carcinomas = 2,
		/obj/item/box/fancy/cigarettes/professionals = 2,
		/obj/item/box/fancy/cigarettes/cigarello = 2,
		/obj/item/box/fancy/cigarettes/cigarello/mint = 2,
		/obj/item/box/fancy/cigarettes/cigarello/variety = 2,
		/obj/item/box/matches = 10,
		/obj/item/flame/fuelled/lighter/random = 4,
		/obj/item/chewables/tobacco = 2,
		/obj/item/chewables/tobacco2 = 2,
		/obj/item/chewables/tobacco3 = 2,
		/obj/item/clothing/mask/smokable/ecig/simple = 10,
		/obj/item/clothing/mask/smokable/ecig/util = 5,
		/obj/item/clothing/mask/smokable/ecig/deluxe = 1,
		/obj/item/chems/ecig_cartridge/med_nicotine = 10,
		/obj/item/chems/ecig_cartridge/high_nicotine = 5,
		/obj/item/chems/ecig_cartridge/orange = 5,
		/obj/item/chems/ecig_cartridge/mint = 5,
		/obj/item/chems/ecig_cartridge/watermelon = 5,
		/obj/item/chems/ecig_cartridge/grape = 5,
		/obj/item/chems/ecig_cartridge/lemonlime = 5,
		/obj/item/chems/ecig_cartridge/coffee = 5,
		/obj/item/chems/ecig_cartridge/blanknico = 2
	)
	contraband = list(
		/obj/item/flame/fuelled/lighter/zippo = 4,
		/obj/item/clothing/mask/smokable/cigarette/rolled/sausage = 3,
		/obj/item/box/fancy/cigar = 5,
		/obj/item/box/fancy/cigarettes/killthroat = 5
	)
