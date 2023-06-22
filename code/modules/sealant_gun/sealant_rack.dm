/obj/structure/sealant_rack
	name = "sealant tank rack"
	icon = 'icons/obj/structures/sealant_props.dmi'
	icon_state = "rack"
	density = TRUE
	anchored = TRUE
	var/obj/item/gun/launcher/sealant/loaded_gun
	var/list/tanks
	var/max_tanks = 5

/obj/structure/sealant_rack/Destroy()
	QDEL_NULL_LIST(tanks)
	QDEL_NULL(loaded_gun)
	. = ..()

/obj/structure/sealant_rack/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	LAZYINITLIST(tanks)
	for(var/i = 1 to rand(1,max_tanks))
		tanks += new /obj/item/sealant_tank(src)

/obj/structure/sealant_rack/on_update_icon()
	..()
	if(loaded_gun)
		add_overlay("gun")
	if(length(tanks))
		add_overlay("tanks[length(tanks)]")

/obj/structure/sealant_rack/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	if(loaded_gun)
		loaded_gun.dropInto(loc)
		user.put_in_hands(loaded_gun)
		loaded_gun = null
		update_icon()
		return TRUE
	if(length(tanks))
		var/obj/tank = tanks[length(tanks)]
		LAZYREMOVE(tanks, tank)
		tank.dropInto(loc)
		user.put_in_hands(tank)
		update_icon()
		return TRUE
	return ..()

/obj/structure/sealant_rack/attackby(obj/item/O, mob/user)

	if(istype(O, /obj/item/gun/launcher/sealant))
		if(loaded_gun)
			to_chat(user, SPAN_WARNING("There is already a sealant gun hung up on \the [src]."))
			return TRUE
		if(user.try_unequip(O, src))
			loaded_gun = O
			update_icon()
			return TRUE

	if(istype(O, /obj/item/sealant_tank))
		if(length(tanks) >= max_tanks)
			to_chat(user, SPAN_WARNING("\The [src] is filled to capacity with sealant tanks."))
			return TRUE
		if(user.try_unequip(O, src))
			LAZYADD(tanks, O)
			update_icon()
			return TRUE

	. = ..()

