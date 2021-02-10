
/obj/item/gun/hand/ecrossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2,'magnets':2,'esoteric':5}"
	material = /decl/material/solid/metal/steel
	slot_flags = SLOT_LOWER_BODY
	receiver = /obj/item/firearm_component/receiver/energy/crossbow
	barrel = /obj/item/firearm_component/barrel/energy/crossbow

/obj/item/gun/hand/ecrossbow/ninja
	name = "energy dart thrower"
	receiver = /obj/item/firearm_component/receiver/energy/crossbow/ninja
	barrel = /obj/item/firearm_component/barrel/energy/crossbow/ninja

/obj/item/gun/hand/ecrossbow/ninja/mounted
	receiver = /obj/item/firearm_component/receiver/energy/crossbow/ninja/mounted

/obj/item/gun/hand/ecrossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	force = 10
	material = /decl/material/solid/metal/steel
	barrel = /obj/item/firearm_component/barrel/energy/crossbow/large
