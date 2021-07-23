/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)

/obj/structure/closet/secure_closet/freezer/kitchen/WillContain()
	return list(
		/obj/item/chems/condiment/salt = 1,
		/obj/item/chems/condiment/flour = 7,
		/obj/item/chems/condiment/sugar = 2
	)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/freezer/meat/WillContain()
	return list(
		/obj/item/chems/food/meat/beef = 8,
		/obj/item/chems/food/fish = 4
	)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/freezer/fridge/WillContain()
	return list(
		/obj/item/chems/drinks/milk = 6,
		/obj/item/chems/drinks/soymilk = 4,
		/obj/item/storage/fancy/egg_box = 4
	)

/obj/structure/closet/secure_closet/freezer/money
	name = "secure locker"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/Initialize()
	. = ..()
	//let's make hold a substantial amount.
	var/created_size = 0
	for(var/i = 1 to 200) //sanity loop limit
		var/obj/item/cash_type = pick(3; /obj/item/cash/c1000, 4; /obj/item/cash/c500, 5; /obj/item/cash/c200)
		var/bundle_size = initial(cash_type.w_class) / 2
		if(created_size + bundle_size <= storage_capacity)
			created_size += bundle_size
			new cash_type(src)
		else
			break
