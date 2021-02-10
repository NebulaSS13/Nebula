/obj/item/gun/hand/money
	name = "money cannon"
	desc = "A blocky, plastic novelty launcher that claims to be able to shoot money at considerable velocities."
	icon = 'icons/obj/guns/launcher/money.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':1,'materials':1}"
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	fire_sound_text = "a whoosh and a crisp, papery rustle"
	fire_delay = 1
	fire_sound = 'sound/weapons/gunshot/money_launcher.ogg'
	receiver = /obj/item/firearm_component/receiver/launcher/money

/obj/item/gun/hand/money/hacked
	receiver = /obj/item/firearm_component/receiver/launcher/money/hacked
