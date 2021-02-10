/obj/item/gun/hand/flare
	name = "flaregun"
	desc = "A single shot polymer flare gun, the XI-54 \"Sirius\" is a reliable way to launch flares away from yourself."
	icon = 'icons/obj/guns/flaregun.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a satisfying 'thump'"
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	w_class = ITEM_SIZE_SMALL
	obj_flags = 0
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	barrel = /obj/item/firearm_component/barrel/ballistic/shotgun
	receiver = /obj/item/firearm_component/receiver/ballistic/flaregun
