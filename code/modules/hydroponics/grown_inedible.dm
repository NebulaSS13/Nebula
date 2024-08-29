/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/trash.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = ITEM_SIZE_SMALL
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
	throw_speed = 4
	throw_range = 20
	material = /decl/material/solid/organic/plantmatter
