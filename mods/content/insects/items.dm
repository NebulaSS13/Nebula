/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	material = /decl/material/solid/organic/wood

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>You start assembling \the [src]...</span>")
	if(do_after(user, 30, src))
		user.visible_message("<span class='notice'>\The [user] constructs a beehive.</span>", "<span class='notice'>You construct a beehive.</span>")
		new /obj/machinery/beehive(get_turf(user))
		qdel(src)

/obj/item/stock_parts/circuitboard/honey
	name = "circuitboard (honey extractor)"
	build_path = /obj/machinery/honey_extractor
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/stock_parts/circuitboard/seed
	name = "circuitboard (seed extractor)"
	build_path = /obj/machinery/seed_extractor
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2
	)

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/items/weapon/batterer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/wood
	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20
	material = /decl/material/solid/organic/wood

/obj/item/honey_frame/filled/Initialize()
	. = ..()
	overlays += "honeycomb"

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
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
