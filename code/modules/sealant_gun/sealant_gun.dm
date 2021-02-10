/obj/item/gun/cannon/sealant
	name = "sealant gun"
	desc = "A heavy, unwieldly device used to spray metal foam sealant onto hull breaches or damaged flooring."
	icon =         'icons/obj/guns/sealant_gun.dmi'
	icon_state =    ICON_STATE_WORLD
	can_autofire =  TRUE
	waterproof =    TRUE
	w_class =       ITEM_SIZE_NO_CONTAINER
	slot_flags =    SLOT_BACK
	fire_sound =    'sound/effects/refill.ogg'
	fire_delay =    1
	receiver = /obj/item/firearm_component/receiver/launcher/sealantgun
	var/foam_charges_per_shot = 1
	var/obj/item/sealant_tank/loaded_tank

/obj/item/gun/cannon/sealant/on_update_icon()
	update_world_inventory_state()
	cut_overlays()
	if(loaded_tank)
		add_overlay("[icon_state]-tank")

/obj/item/gun/cannon/sealant/apply_overlays(mob/user_mob, bodytype, image/overlay, slot)
	. = ..()
	if(loaded_tank)
		overlay.overlays += image(icon, "[overlay.icon_state]-tank")

/obj/item/gun/cannon/sealant/mapped
	loaded_tank = /obj/item/sealant_tank/mapped

/obj/item/gun/cannon/sealant/consume_next_projectile(mob/user)
	if(loaded_tank?.foam_charges >= foam_charges_per_shot)
		loaded_tank.foam_charges -= foam_charges_per_shot
		. = new /obj/item/clothing/sealant(src)

/obj/item/gun/cannon/sealant/Initialize()
	. = ..()
	if(ispath(loaded_tank))
		loaded_tank = new loaded_tank(src)	
	update_icon()

/obj/item/gun/cannon/sealant/Destroy()
	QDEL_NULL(loaded_tank)
	. = ..()

/obj/item/gun/cannon/sealant/examine(mob/user, distance)
	. = ..()
	if(loc == user)
		if(loaded_tank)
			to_chat(user, SPAN_NOTICE("The loaded tank has about [loaded_tank.foam_charges] liter\s of sealant left."))
		else
			to_chat(user, SPAN_WARNING("\The [src] has no sealant loaded."))

/obj/item/gun/cannon/sealant/proc/unload_tank(var/mob/user)
	if(!loaded_tank)
		to_chat(user, SPAN_WARNING("\The [src] has no tank loaded."))
		return

	loaded_tank.dropInto(get_turf(src))
	user.put_in_hands(loaded_tank)
	to_chat(user, SPAN_NOTICE("You pop \the [loaded_tank] out of \the [src]."))
	loaded_tank = null
	update_icon()
