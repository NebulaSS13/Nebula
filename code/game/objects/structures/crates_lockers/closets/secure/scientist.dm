/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(list(access_tox,access_tox_storage))
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/scientist/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/white,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/clipboard
	)

/obj/structure/closet/secure_closet/xenobio
	name = "xenobiologist's locker"
	req_access = list(access_xenobiology)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenobio/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/white,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/latex,
		/obj/item/clipboard,
		/obj/item/belt/general
	)

/obj/structure/closet/secure_closet/research_director
	name = "chief science officer's locker"
	req_access = list(access_rd)
	closet_appearance = /decl/closet_appearance/secure_closet/rd

/obj/structure/closet/secure_closet/research_director/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist = 2,
		/obj/item/clothing/head/bio_hood/scientist = 2,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/gloves/latex,
		/obj/item/radio/headset/heads/rd,
		/obj/item/clothing/mask/gas,
		/obj/item/flash,
		/obj/item/clipboard,
	)

/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_research)

/obj/structure/closet/secure_closet/animal/WillContain()
	return list(
		/obj/item/assembly/signaler,
		/obj/item/gun/launcher/syringe/rapid,
		/obj/item/box/syringegun,
		/obj/item/box/syringes,
		/obj/item/chems/glass/bottle/sedatives
	)

/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	req_access = list(access_xenobiology)

/obj/structure/closet/secure_closet/pilot/WillContain()
	return list(
		/obj/item/backpack/parachute,
		/obj/item/knife/utility,
		/obj/item/clothing/jumpsuit/pilot,
		/obj/item/clothing/suit/jacket/bomber,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/headset_sci,
		/obj/item/flashlight,
		/obj/item/food/liquidfood,
		/obj/item/chems/drinks/cans/waterbottle,
		/obj/item/box/flares,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/backpack/satchel
	)
