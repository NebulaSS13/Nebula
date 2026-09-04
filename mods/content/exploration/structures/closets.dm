/obj/structure/closet/secure_closet/xenofauna
	name = "xenofauna technician locker"
	req_access = list(access_xenofauna)

/obj/structure/closet/secure_closet/xenofauna/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/xenofauna,
		/obj/item/clothing/suit/explorer/xenofauna,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/winterboots/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/suit/jacket/winter/parka/purple,
		/obj/item/radio/headset/headset_exp,
		/obj/item/flashlight,
		/obj/item/gps/xenofauna,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/cataloguer,
		/obj/item/backpack/satchel/grey,
		/obj/item/knife/survival,
		/obj/item/specimen_tagger
	)

/obj/structure/closet/secure_closet/guncabinet/phase
	name = "explorer weapon cabinet"
	req_access = list(access_explorer)

/obj/structure/closet/secure_closet/guncabinet/phase/WillContain()
	return list(
		/obj/item/gun/energy/gun/reloadable/phase = 2,
		/obj/item/gun/energy/gun/reloadable/phase/pistol,
		/obj/item/cell/gun = 2,
		/obj/item/clothing/permit/gun/planetside/exploration
	)

/obj/structure/closet/secure_closet/guncabinet/tranq
	name = "tranquilizer rifle cabinet"
	req_access = list(access_xenofauna)

/obj/structure/closet/secure_closet/guncabinet/tranq/WillContain()
	return list(
		/obj/item/gun/energy/gun/reloadable/phase/tranq_rifle = 2,
		/obj/item/gun/energy/gun/reloadable/phase/tranq_pistol,
		/obj/item/gun/energy/gun/reloadable/phase/pistol,
		/obj/item/cell/gun = 2,
		/obj/item/clothing/permit/gun/planetside
	)

//Explorer Lockers
/obj/structure/closet/secure_closet/explorer
	name = "explorer locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition

/obj/structure/closet/secure_closet/explorer/WillContain()
	. = list(
		/obj/item/clothing/jumpsuit/explorer,
		/obj/item/clothing/suit/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/winterboots/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/headset_exp,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/box/flares,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/flag = 3, // 30, since each is a full stack of 10
		/obj/item/cataloguer)
	if(prob(50))
		. += /obj/item/backpack/rucksack
	else
		. += /obj/item/backpack/satchel
	if(prob(75))
		. += /obj/item/knife/utility
	else
		. += /obj/item/tool/machete

//Xenofauna tech lockers
/obj/structure/closet/secure_closet/xenofauna
	name = "xenofauna technician locker"
	req_access = list(access_xenofauna)

/obj/structure/closet/secure_closet/xenofauna/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/xenofauna,
		/obj/item/clothing/suit/explorer/xenofauna,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/winterboots/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/suit/jacket/winter/parka/purple,
		/obj/item/radio/headset/headset_exp,
		/obj/item/flashlight,
		/obj/item/gps/xenofauna,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/cataloguer,
		/obj/item/backpack/satchel,
		/obj/item/knife/utility,
		/obj/item/specimen_tagger
	)
