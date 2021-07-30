/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	closet_appearance = /decl/closet_appearance/cabinet/secure

/obj/structure/closet/secure_closet/bar/WillContain()
	return list(/obj/item/chems/drinks/bottle/small/beer = 10)

/obj/structure/closet/secure_closet/bar/empty/WillContain()
	return
