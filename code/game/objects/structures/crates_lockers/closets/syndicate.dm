/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	closet_appearance = /decl/closet_appearance/tactical/alt

/obj/structure/closet/syndicate/personal
	desc = "It's a storage unit for operative gear."

/obj/structure/closet/syndicate/personal/Initialize()
	. = ..()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/clothing/shirt/syndicate(src)
	new /obj/item/clothing/pants/casual/camo(src)
	new /obj/item/clothing/head/helmet/space/void/merc(src)
	new /obj/item/clothing/suit/space/void/merc(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/cell/high(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/multitool(src)
	new /obj/item/shield/energy(src)
	new /obj/item/clothing/shoes/magboots(src)


/obj/structure/closet/syndicate/suit
	desc = "It's a storage unit for voidsuits."

/obj/structure/closet/syndicate/suit/Initialize()
	. = ..()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/suit/space/void/merc(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/clothing/head/helmet/space/void/merc(src)


/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

/obj/structure/closet/syndicate/nuclear/Initialize()
	. = ..()

	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/box/handcuffs(src)
	new /obj/item/box/flashbangs(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/modular_computer/pda/mercenary(src)
	var/obj/item/radio/uplink/U = new(src)
	U.tc_amount = 40
	return

/obj/structure/closet/syndicate/resources
	desc = "An old, dusty locker."

/obj/structure/closet/syndicate/resources/Initialize()
	. = ..()
	var/common_min = 30 //Minimum amount of minerals in the stack for common minerals
	var/common_max = 50 //Maximum amount of HONK in the stack for HONK common minerals
	var/rare_min = 5  //Minimum HONK of HONK in the stack HONK HONK rare minerals
	var/rare_max = 20 //Maximum HONK HONK HONK in the HONK for HONK rare HONK



	var/pickednum = rand(1, 50)

	//Sad trombone
	if(pickednum == 1)
		var/obj/item/paper/P = new /obj/item/paper(src)
		P.SetName("IOU")
		P.info = "Sorry man, we needed the money so we sold your stash. It's ok, we'll double our money for sure this time!"

	//Metal (common ore)
	if(pickednum >= 2)
		SSmaterials.create_object(/decl/material/solid/metal/steel, src, rand(common_min, common_max))

	//Glass (common ore)
	if(pickednum >= 5)
		SSmaterials.create_object(/decl/material/solid/glass, src, rand(common_min, common_max))

	//Plasteel (common metal)
	if(pickednum >= 10)
		SSmaterials.create_object(/decl/material/solid/metal/plasteel, src, rand(common_min, common_max))

	//Silver (rare ore)
	if(pickednum >= 15)
		SSmaterials.create_object(/decl/material/solid/metal/silver, src, rand(rare_min, rare_max))

	//Gold (rare ore)
	if(pickednum >= 30)
		SSmaterials.create_object(/decl/material/solid/metal/gold, src, rand(rare_min, rare_max))

	//Uranium (rare ore)
	if(pickednum >= 40)
		SSmaterials.create_object(/decl/material/solid/metal/uranium, src, rand(rare_min, rare_max))

	//Diamond (rare HONK)
	if(pickednum >= 45)
		SSmaterials.create_object(/decl/material/solid/gemstone/diamond, src, rand(rare_min, rare_max))

	//Jetpack (You hit the jackpot!)
	if(pickednum == 50)
		new /obj/item/tank/jetpack/carbondioxide(src)

/obj/structure/closet/syndicate/resources/everything
	desc = "It's an emergency storage closet for repairs."

/obj/structure/closet/syndicate/resources/everything/Initialize()
	. = ..()

	var/list/resources = list(
		/obj/item/stack/material/sheet/mapped/steel/fifty,
		/obj/item/stack/material/pane/mapped/glass/fifty,
		/obj/item/stack/material/ingot/mapped/gold/fifty,
		/obj/item/stack/material/ingot/mapped/silver/fifty,
		/obj/item/stack/material/puck/mapped/uranium/fifty,
		/obj/item/stack/material/gemstone/mapped/diamond/fifty,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/fifty,
		/obj/item/stack/material/rods/fifty
	)

	for(var/i = 0, i < 2, i++)
		for(var/res in resources)
			new res(src)
