// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown weapons
	name = "grown_weapon"
	material = /decl/material/solid/organic/plantmatter
	var/plantname
	var/potency = 1

/obj/item/grown/Initialize(mapload,planttype)
	. = ..(mapload)
	if(planttype)
		plantname = planttype
	initialize_reagents()

/obj/item/grown/initialize_reagents(populate)
	create_reagents(50)
	if(!plantname)
		return
	. = ..()

/obj/item/grown/populate_reagents()
	//Handle some post-spawn var stuff.
	var/datum/seed/S = SSplants.seeds[plantname]
	if(!S || !S.chems)
		return

	potency = S.get_trait(TRAIT_POTENCY)

	for(var/rid in S.chems)
		var/list/reagent_data = S.chems[rid]
		var/rtotal = reagent_data[1]
		if(reagent_data.len > 1 && potency > 0)
			rtotal += round(potency/reagent_data[2])
		reagents.add_reagent(rid,max(1,rtotal))

/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/trash.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	material = /decl/material/solid/organic/plantmatter

/obj/item/corncob/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/circular_saw) || IS_HATCHET(W) || istype(W, /obj/item/knife))
		to_chat(user, "<span class='notice'>You use [W] to fashion a pipe out of the corn cob!</span>")
		new /obj/item/clothing/mask/smokable/pipe/cobpipe (user.loc)
		qdel(src)
		return

/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items/banana.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	material = /decl/material/solid/organic/plantmatter
