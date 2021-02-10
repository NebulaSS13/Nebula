
/obj/item/gun/cannon/esniper
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance."
	icon = 'icons/obj/guns/laser_sniper.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':6,'materials':5,'powerstorage':4}"
	slot_flags = SLOT_BACK
	fire_delay = 35
	force = 10
	w_class = ITEM_SIZE_HUGE
	accuracy = -2 //shooting at the hip
	scoped_accuracy = 9
	scope_zoom = 2
	receiver = /obj/item/firearm_component/receiver/energy/sniper
	barrel = /obj/item/firearm_component/barrel/energy/sniper
