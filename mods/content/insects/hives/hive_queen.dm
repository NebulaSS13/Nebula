
/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'mods/content/insects/icons/bee_pack.dmi'
	material = /decl/material/solid/organic/plastic
	var/contains_insects = /decl/insect_species/honeybees

/obj/item/bee_pack/Initialize()
	. = ..()
	update_icon()

/obj/item/bee_pack/on_update_icon()
	. = ..()
	if(contains_insects)
		add_overlay("[icon_state]-full")
	else
		add_overlay("[icon_state]-empty")

/obj/item/bee_pack/proc/empty()
	SetName("empty [initial(name)]")
	desc = "A stasis pack for moving bees. It's empty."
	contains_insects = null
	update_icon()
