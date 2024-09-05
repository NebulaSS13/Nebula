/obj/item/clothingbag
	name = "clothing bag"
	desc = "A cheap plastic bag that contains a fresh set of clothes."
	icon = 'icons/obj/items/storage/trashbag.dmi'
	icon_state = "trashbag3"
	material = /decl/material/solid/organic/plastic

	var/icon_used = "trashbag0"
	var/opened = 0

/obj/item/clothingbag/attack_self(mob/user)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open \the [src]!</span>", "<span class='notice'>You tear open \the [src]!</span>")
		opened = 1
		icon_state = icon_used
		for(var/obj/item in contents)
			item.dropInto(loc)
	else
		to_chat(user, "<span class='warning'>\The [src.name] is already ripped open and is now completely useless!</span>")
