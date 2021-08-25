
//FOR ACTORS GUILD - mainly props that cannot be spawned otherwise
/obj/machinery/vending/props
	name = "prop dispenser"
	desc = "All the props an actor could need. Probably."
	icon_state = "theater"
	icon_vend = "theater-vend"
	icon_deny = "theater-deny"
	products = list(
		/obj/structure/flora/pottedplant = 2,
		/obj/item/flashlight/lamp = 2,
		/obj/item/flashlight/lamp/green = 2,
		/obj/item/chems/drinks/jar = 1,
		/obj/item/nullrod = 1,
		/obj/item/sword/cult_toy = 4,
		/obj/item/sword/katana/toy = 2
	)

/obj/machinery/vending/props/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-overlay")

//FOR ACTORS GUILD - Containers
/obj/machinery/vending/containers
	name = "container dispenser"
	desc = "A container that dispenses containers."
	icon_state = "robotics"
	base_type = /obj/machinery/vending/containers
	products = list(
		/obj/structure/closet/crate/freezer = 2,
		/obj/structure/closet = 3,
		/obj/structure/closet/crate = 3
	)
