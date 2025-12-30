/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'mods/content/beekeeping/icons/apiary_bees_etc.dmi'
	icon_state = "apiary"
	material = /decl/material/solid/organic/wood/oak

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>You start assembling \the [src]...</span>")
	if(do_after(user, 30, src))
		user.visible_message("<span class='notice'>\The [user] constructs a beehive.</span>", "<span class='notice'>You construct a beehive.</span>")
		new /obj/machinery/beehive(get_turf(user))
		qdel(src)

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'mods/content/beekeeping/icons/smoker.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'mods/content/beekeeping/icons/beekeeping.dmi'
	icon_state = "beepack"
	material = /decl/material/solid/organic/plastic
	var/full = 1

/obj/item/bee_pack/Initialize()
	. = ..()
	overlays += "beepack-full"

/obj/item/bee_pack/proc/empty()
	full = 0
	name = "empty bee pack"
	desc = "A stasis pack for moving bees. It's empty."
	overlays.Cut()
	overlays += "beepack-empty"

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	SetName(initial(name))
	desc = initial(desc)
	overlays.Cut()
	overlays += "beepack-full"
