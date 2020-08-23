/obj/item/robot_module/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list(
		"Service" = TRUE
	)
	sprites = list(
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/mop/advanced,
		/obj/item/holosign_creator,
		/obj/item/lightreplacer,
		/obj/item/borg/sight/hud/jani,
		/obj/item/plunger,
		/obj/item/crowbar,
		/obj/item/weldingtool
	)
	emag = /obj/item/chems/spray

/obj/item/robot_module/janitor/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/decl/material/liquid/lube, 250)
	emag.SetName("Lube spray")

/obj/item/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	if(emag)
		var/obj/item/chems/spray/S = emag
		S.reagents.add_reagent(/decl/material/liquid/lube, 20 * amount)
