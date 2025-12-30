var/list/nukanames = list("Joni", "Lauralee", "Kayden", "Amy", "Alyx", "Vriani", "Yuri", "Bruce", "Mariya", "Jackson", "Sam", "Mak", "Lucy", "Lamb", "Luke", "Dakota", "Vyn", "Augustina", "Tina", "Dae", "Amiya", "Aaron", "Argon", "Hannan", "Piper", "Sofia", "Lukas", "Sarah", "Brooklynn", "Valerie", "Travis", "Aphelion", "Robin", "Tycho", "Nephila", "Seris", "Vel", "Kimberley", "Cosmo", "Mavis", "Myrle", "Amastacia", "Kelly", "Temperance")

/obj/machinery/vending/nukacola
	name = "Nuka Cola Vendor"
	desc = "Bottled and sold by the Nuka Cola Corporation!"
	product_slogans = "Take a Nuka Break!;Nuka Cola has what you crave!"
	product_ads = "Drink Nuka Cola!;Support the war effort, buy a Nuka Cola!;Share a Nuka with [pick(nukanames)]!"
	icon = 'mods/content/fallout/machinery/icons/nukacola.dmi'
	vend_delay = 26
	base_type = /obj/machinery/vending/hydronutrients
	products = list(
		/obj/item/chems/glass/bottle/eznutrient = 6,
		/obj/item/chems/glass/bottle/left4zed = 4,
		/obj/item/chems/glass/bottle/robustharvest = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/chems/syringe = 5,
		/obj/item/plants = 5,
		/obj/item/chems/glass/bottle/ammonia = 10
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	markup = 0