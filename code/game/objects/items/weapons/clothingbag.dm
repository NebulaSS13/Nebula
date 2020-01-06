/obj/item/weapon/clothingbag
	name = "clothing bag"
	desc = "A cheap plastic bag that contains a fresh set of clothes."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

	var/icon_used = "trashbag0"
	var/opened = 0

/obj/item/weapon/clothingbag/attack_self(mob/user as mob)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open \the [src.name]!</span>", "<span class='notice'>You tear open \the [src.name]!</span>")
		opened = 1
		icon_state = icon_used
		for(var/obj/item in contents)
			item.dropInto(loc)
	else
		to_chat(user, "<span class='warning'>\The [src.name] is already ripped open and is now completely useless!</span>")
