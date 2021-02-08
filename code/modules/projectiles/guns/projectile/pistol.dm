
/obj/item/gun/projectile/pistol
	name = "pistol"
	icon = 'icons/obj/guns/pistol.dmi'
	barrel = /obj/item/firearm_component/barrel/ballistic/pistol
	receiver = /obj/item/firearm_component/receiver/ballistic/pistol
	accuracy_power = 7
	safety_icon = "safety"
	ammo_indicator = TRUE

/obj/item/gun/projectile/pistol/update_base_icon()
	var/base_state = get_world_inventory_state()
	if(!length(ammo_magazine?.stored_ammo) && check_state_in_icon("[base_state]-e", icon))
		icon_state = "[base_state]-e"
	else
		icon_state = base_state

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	barrel = /obj/item/firearm_component/barrel/ballistic/holdout
	receiver = /obj/item/firearm_component/receiver/ballistic/holdout
	silenced = 0
	fire_delay = 4
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"

/obj/item/gun/projectile/pistol/holdout/update_base_icon()
	..()
	if(silenced)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()]-silencer")

/obj/item/gun/projectile/pistol/holdout/get_on_belt_overlay()
	if(silenced && check_state_in_icon("on_belt_silenced", icon))
		return overlay_image(icon, "on_belt_silenced", color)
	return ..()

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol_silencer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
