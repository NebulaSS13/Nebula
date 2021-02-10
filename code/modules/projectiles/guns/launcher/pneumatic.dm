/obj/item/gun/long/pneumatic
	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon = 'icons/obj/guns/launcher/pneumatic.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':3}"
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	fire_sound_text = "a loud whoosh of moving air"
	fire_delay = 50
	fire_sound = 'sound/weapons/tablehit1.ogg'
	receiver = /obj/item/firearm_component/receiver/launcher/pneumatic

/obj/item/gun/hand/pneumatic/small
	name = "small pneumatic cannon"
	desc = "It looks smaller than your garden variety cannon"
	w_class = ITEM_SIZE_NORMAL
	receiver = /obj/item/firearm_component/receiver/launcher/pneumatic/small
