
//This one's from bay12
/obj/machinery/vending/bombresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	base_type = /obj/machinery/vending/bombresearch
	products = list(
		/obj/item/clothing/suit/bio_suit = 6,
		/obj/item/clothing/head/bio_hood = 6,
		/obj/item/transfer_valve = 6,
		/obj/item/assembly/timer = 6,
		/obj/item/assembly/signaler = 6,
		/obj/item/assembly/prox_sensor = 6,
		/obj/item/assembly/igniter = 6
	)

/obj/machinery/vending/assist
	products = list(	
		/obj/item/assembly/prox_sensor = 5,
		/obj/item/assembly/igniter = 3,
		/obj/item/assembly/signaler = 4,
		/obj/item/wirecutters = 1
	)
	contraband = list(/obj/item/flashlight = 5,/obj/item/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/assist/antag
	name = "AntagCorpVend"
	contraband = list()
	products = list(	
		/obj/item/assembly/prox_sensor = 5, 
		/obj/item/assembly/signaler = 4,
		/obj/item/assembly/infra = 4, 
		/obj/item/assembly/prox_sensor = 4,
		/obj/item/handcuffs = 8, 
		/obj/item/flash = 4, 
		/obj/item/clothing/glasses/sunglasses = 4
	)
