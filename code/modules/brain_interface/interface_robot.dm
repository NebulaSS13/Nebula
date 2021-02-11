/obj/item/brain_interface/robot
	name = "computer intelligence core"
	desc = "The pinnacle of artifical intelligence, in a fist-sized cube."
	icon = 'icons/obj/items/brain_interface_robotic.dmi'
	origin_tech = "{'engineering':4,'materials':3,'programming':4}"
	var/searching = FALSE

/obj/item/brain_interface/robot/Initialize(ml, material_key)
	. = ..()
	if(holding_brain?.brainmob)
		holding_brain.brainmob.SetName("[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[random_id(type,1000,9999)]")
		holding_brain.brainmob.real_name = holding_brain.brainmob.name

/obj/item/brain_interface/robot/update_icon()
	if(searching)
		icon_state = get_world_inventory_state()
	else
		. = ..()

/obj/item/brain_interface/robot/on_update_icon()
	if(searching)
		icon_state = get_world_inventory_state()
	else
		. = ..()
