/obj/item/firearm_component/receiver/ballistic/pump
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 4
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'
	loaded = /obj/item/ammo_casing/shotgun/beanbag
	var/next_pump = 0

/obj/item/firearm_component/receiver/ballistic/pump/holder_attack_self(mob/user)
	if(world.time < next_pump)
		return FALSE
	next_pump = (world.time + 1 SECOND)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(chambered)
		chambered.dropInto(get_turf(user)) 
		if(LAZYLEN(chambered.fall_sounds))
			playsound(loc, pick(chambered.fall_sounds), 50, 1)
		chambered = null
	if(length(loaded))
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC
	update_icon()

/obj/item/firearm_component/receiver/ballistic/pump/get_next_projectile()
	return chambered?.BB

/obj/item/firearm_component/receiver/ballistic/pump/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && !length(loaded))
		ret.icon_state = "[ret.icon_state]-empty"
	return ret
