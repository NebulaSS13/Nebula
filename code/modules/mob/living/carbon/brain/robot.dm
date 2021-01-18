/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/modules/module_mainboard.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'engineering':4,'materials':3,'programming':4}"

/obj/item/mmi/digital/robot/PickName()
	src.brainmob.SetName("[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[random_id(type,1000,9999)]")
	src.brainmob.real_name = src.brainmob.name

/obj/item/mmi/digital/robot/on_update_icon()
	icon_state = initial(icon_state)
