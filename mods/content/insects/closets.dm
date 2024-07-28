/obj/structure/closet/crate/hydroponics/beekeeping
	name = "beekeeping crate"
	desc = "All you need to set up your own beehive."

/obj/structure/closet/crate/hydroponics/beekeeping/Initialize()
	. = ..()
	new /obj/item/beehive_assembly(src)
	new /obj/item/bee_smoker(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/bee_pack(src)
	new /obj/item/crowbar(src)
