/obj/item/pill_bottle/dice	//7d6
	name = "bag of dice"
	desc = "It's a small bag with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	material = /decl/material/solid/organic/cloth

/obj/item/pill_bottle/dice/WillContain()
	return list(/obj/item/dice = 7)

/obj/item/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"

/obj/item/pill_bottle/dice_nerd/WillContain()
	return list(
		/obj/item/dice/d4,
		/obj/item/dice,
		/obj/item/dice/d8,
		/obj/item/dice/d10,
		/obj/item/dice/d12,
		/obj/item/dice/d20,
		/obj/item/dice/d100,
	)

//misc tobacco nonsense
/obj/item/cigpaper
	name = "\improper Gen. Eric cigarette paper"
	desc = "A ubiquitous brand of cigarette paper, allegedly endorsed by 24th century war hero General Eric Osmundsun for rolling your own cigarettes. Osmundsun died in a freak kayak accident. As it ate him alive during his last campaign. It was pretty freaky."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpaperbook"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	storage = /datum/storage/cigpapers
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/plastic

/obj/item/cigpaper/WillContain()
	return list(/obj/item/paper/cig = 10)

/obj/item/cigpaper/fancy
	name = "\improper Trident cigarette paper"
	desc = "A fancy brand of Trident cigarette paper, for rolling your own cigarettes. Like a person who appreciates the finer things in life."
	icon_state = "fancycigpaperbook"

/obj/item/cigpaper/fancy/WillContain()
	return list(/obj/item/paper/cig/fancy = 10)

/obj/item/cigpaper/filters
	name = "box of cigarette filters"
	desc = "A box of generic cigarette filters for those who rolls their own but prefers others to inhale the fumes. Not endorsed by Late General Osmundsun."
	icon_state = "filterbin"

/obj/item/cigpaper/filters/WillContain()
	return list(/obj/item/paper/cig/filter = 10)

/obj/item/chewables
	name = "box of chewing wads master"
	desc = "A generic brands of Waffle Co Wads, unflavored chews. Why do these exist?"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "placeholder"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	storage = /datum/storage/chewables
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/tin

/obj/item/chewables/WillContain()
	return list(/obj/item/clothing/mask/chewable/tobacco = 6)

//loose leaf
/obj/item/chewables/rollable
	name = "bag of tobacco"
	storage = /datum/storage/chewables/rollable

/obj/item/chewables/rollable/bad
	name = "bag of Men at Arms tobacco"
	desc = "A bag of coarse gritty tobacco marketed towards leather-necks."
	icon_state = "rollcoarse"

/obj/item/chewables/rollable/bad/WillContain()
	return list(/obj/item/food/grown/dried_tobacco/bad = 8)

/obj/item/chewables/rollable/generic
	name = "bag of BluSpace tobacco"
	desc = "Decent quality tobacco for mid-income earners and long haul space sailors."
	icon_state = "rollgeneric"

/obj/item/chewables/rollable/generic/WillContain()
	return list(/obj/item/food/grown/dried_tobacco = 8)

/obj/item/chewables/rollable/fine
	name = "bag of Golden Sol tobacco"
	desc = "A exclusive brand of overpriced tobacco, allegedly grown at a lagrange point station in Sol system."
	icon_state = "rollfine"

/obj/item/chewables/rollable/fine/WillContain()
	return list(/obj/item/food/grown/dried_tobacco/fine = 8)

//chewing tobacco
/obj/item/chewables/tobacco
	name = "tin of Lenny's brand chewing tobacco"
	desc = "A generic brand of chewing tobacco, for when you can't even be assed to light up."
	icon_state = "chew_levi"
	item_state = "Dpacket"

/obj/item/chewables/tobacco/WillContain()
	return list(/obj/item/clothing/mask/chewable/tobacco/lenni = 6)

/obj/item/chewables/tobacco2
	name = "tin of Red Lady chewing tobacco"
	desc = "A finer grade of chewing tobacco."
	icon_state = "chew_redman"
	item_state = "redlady"

/obj/item/chewables/tobacco2/WillContain()
	return list(/obj/item/clothing/mask/chewable/tobacco/redlady = 6)

/obj/item/chewables/tobacco3
	name = "box of Nico-Tine gum"
	desc = "A Sol-approved brand of nicotine gum. Cut out the middleman for your addiction fix."
	icon_state = "chew_nico"

/obj/item/chewables/tobacco3/WillContain()
	return list(/obj/item/clothing/mask/chewable/tobacco/nico = 6)

//non-tobacco
/obj/item/chewables/candy
	material = /decl/material/solid/organic/plastic

/obj/item/chewables/candy/cookies
	name = "pack of Getmore Cookies"
	desc = "A pack of delicious cookies, and possibly the only product in Getmores Chocolate Corp lineup that has any trace of chocolate in it."
	icon_state = "cookiebag"
	storage = /datum/storage/chewables/cookies

/obj/item/chewables/candy/cookies/WillContain()
	return list(/obj/item/food/cookie = 6)

/obj/item/chewables/candy/gum
	name = "pack of Rainbo-Gums"
	desc = "A mixed pack of delicious fruit flavored bubble-gums!"
	icon_state = "gumpack"
	storage = /datum/storage/chewables/gum

/obj/item/chewables/candy/gum/WillContain()
	return list(/obj/item/clothing/mask/chewable/candy/gum = 8)

/obj/item/chewables/candy/medicallollis
	name = "pack of medicinal lollipops"
	desc = "A mixed pack of medicinal flavored lollipops. These have no business being on store shelves."
	icon_state = "lollipack"
	storage = /datum/storage/chewables/lollipops

/obj/item/chewables/candy/medicallollis/WillContain()
	return list(/obj/item/clothing/mask/chewable/candy/lolli/meds = 20)

/obj/item/medical_lolli_jar
	name = "lollipops jar"
	desc = "A mixed pack of flavored medicinal lollipops. Perfect for small boo-boos."
	icon = 'icons/obj/items/storage/lollijar.dmi'
	icon_state = "lollijar"
	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'
	material = /decl/material/solid/glass
	storage = /datum/storage/chewables/lollipops

/obj/item/medical_lolli_jar/WillContain()
	return list(/obj/item/clothing/mask/chewable/candy/lolli/weak_meds = 15)

/obj/item/medical_lolli_jar/on_update_icon()
	. = ..()
	if(length(contents))
		icon_state = "lollijar"
	else
		icon_state = "lollijar_empty"
