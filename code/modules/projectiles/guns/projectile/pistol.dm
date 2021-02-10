
/obj/item/gun/hand/pistol
	name = "pistol"
	icon = 'icons/obj/guns/pistol.dmi'
	barrel = /obj/item/firearm_component/barrel/ballistic/pistol
	receiver = /obj/item/firearm_component/receiver/ballistic/pistol
	accuracy_power = 7

/obj/item/gun/hand/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	item_state = null
	w_class = ITEM_SIZE_SMALL
	barrel = /obj/item/firearm_component/barrel/ballistic/holdout
	receiver = /obj/item/firearm_component/receiver/ballistic/pistol/holdout
	silenced = 0
	fire_delay = 4
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol_silencer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
