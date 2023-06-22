////////////////////////////////////////////////////////////
//Welder gun
////////////////////////////////////////////////////////////

///Welder specifically for the welder pack.
/obj/item/weldingtool/weldpack
	name         = "welding gun"
	desc         = "A welding gun with hoses connecting into a welder fuel tank pack."
	slot_flags   = SLOT_HANDS
	throw_speed  = 0
	throw_range  = 0
	drop_sound   = 'sound/effects/holster/holsterin.ogg'
	pickup_sound = 'sound/effects/holster/holsterout.ogg'
	tank         = null
	randpixel    = 0 //Prevent randpixel from screwing with backpack overlays

	var/obj/item/chems/weldpack/linked_pack

/obj/item/weldingtool/weldpack/Initialize(ml, material_key, var/obj/item/chems/weldpack/pack)
	. = ..()
	if(istype(pack))
		linked_pack = pack

/obj/item/weldingtool/weldpack/insert_tank(obj/item/chems/welder_tank/T, mob/user, no_updates, quiet)
	return FALSE

/obj/item/weldingtool/weldpack/remove_tank(mob/user)
	return FALSE

/obj/item/weldingtool/weldpack/toggle_unscrewed(mob/user)
	return FALSE

/obj/item/weldingtool/weldpack/attempt_modify(obj/item/W, mob/user)
	return FALSE

/obj/item/weldingtool/weldpack/dropped(mob/user)
	. = ..()
	if(linked_pack)
		linked_pack.reattach_gun(user)

/obj/item/weldingtool/weldpack/get_fuel()
	return linked_pack? linked_pack.get_fuel() : 0

/obj/item/weldingtool/weldpack/use_fuel(amount)
	. = TRUE
	if(get_fuel() < amount)
		. = FALSE //Try to burn as much as possible anyways
	if(linked_pack)
		linked_pack.reagents.remove_reagent(/decl/material/liquid/fuel, amount)

/**Called by the parent when the welderpack is dropped */
/obj/item/weldingtool/weldpack/proc/on_pack_dropped(var/mob/user)
	if(!linked_pack.is_welder_attached())
		linked_pack.reattach_gun(user)

/**Called by the parent when the welderpack is deleting */
/obj/item/weldingtool/weldpack/proc/on_pack_deleted()
	if(!linked_pack.is_welder_attached())
		linked_pack.reattach_gun()

/obj/item/weldingtool/weldpack/get_storage_cost()
	if(loc != linked_pack)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

////////////////////////////////////////////////////////////
//Welder Pack
////////////////////////////////////////////////////////////
/obj/item/chems/weldpack
	name              = "welding kit"
	desc              = "An unwieldy, heavy backpack with two massive fuel tanks. Comes with an attached welder gun."
	icon              = 'icons/obj/items/welderpack.dmi'
	icon_state        = ICON_STATE_WORLD
	slot_flags        = SLOT_BACK
	w_class           = ITEM_SIZE_HUGE
	volume            = 350
	var/obj/item/weldingtool/weldpack/welder = /obj/item/weldingtool/weldpack

/obj/item/chems/weldpack/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/fuel, reagents.maximum_volume)

/obj/item/chems/weldpack/Initialize(ml, material_key)
	if(ispath(welder))
		welder = new welder(src, null, src)
	. = ..()

/obj/item/chems/weldpack/Destroy()
	if(welder)
		welder.on_pack_deleted() //Force re-attach the gun, so it also gets deleted and doesn't stay in someone's hands
	QDEL_NULL(welder)
	. = ..()

/obj/item/chems/weldpack/attackby(obj/item/W, mob/user)
	if(W.isflamesource() && get_fuel() && W.get_heat() >= 700 && prob(50))
		playsound(src, 'sound/items/Welder2.ogg', 90, TRUE)
		try_detonate_reagents()
		log_and_message_admins("triggered a fueltank explosion.", user)
		return TRUE

	if(IS_WELDER(W))
		var/obj/item/weldingtool/T = W
		if(T.welding)
			user.visible_message(SPAN_DANGER("\The [user] singes \his [src] with \his [W]!"), SPAN_DANGER("You singed your [src] with your [W]!"))

		if(W == welder)
			return reattach_gun(user)
		if(!T.tank)
			to_chat(user, "\The [T] has no tank attached!")
		reagents.trans_to_obj(T.tank, T.tank.reagents.maximum_volume)
		to_chat(user, SPAN_NOTICE("You refuel \the [W]."))
		playsound(src, 'sound/effects/refill.ogg', 50, TRUE, -6)
		return TRUE

	else if(istype(W, /obj/item/chems/welder_tank))
		var/obj/item/chems/welder_tank/tank = W
		reagents.trans_to_obj(tank, tank.reagents.maximum_volume)
		to_chat(user, SPAN_NOTICE("You refuel \the [W]."))
		playsound(src, 'sound/effects/refill.ogg', 50, TRUE, -6)
		return TRUE

	return ..()

/obj/item/chems/weldpack/afterattack(obj/O, mob/user, proximity)
	if (!ATOM_IS_OPEN_CONTAINER(src) || !proximity)
		return
	if(standard_dispenser_refill(user, O))
		return TRUE
	if(standard_pour_into(user, O))
		return TRUE
	return ..()

/obj/item/chems/weldpack/attack_hand(mob/user)
	if(!is_welder_attached() || !user.check_dexterity(DEXTERITY_GRIP))
		return ..()
	if(user.is_holding_offhand(src))
		detach_gun(user)
		return TRUE
	var/curslot = user.get_equipped_slot_for_item(src)
	if(curslot == slot_back_str || curslot == slot_s_store_str)
		detach_gun(user)
		return TRUE
	return ..()

/obj/item/chems/weldpack/check_mousedrop_adjacency(atom/over, mob/user)
	return (loc == user && istype(over, /obj/screen)) || ..()

/obj/item/chems/weldpack/handle_mouse_drop(atom/over, mob/user)
	if(loc == user && !user.incapacitated())
		if(istype(over, /obj/screen/inventory))
			var/obj/screen/inventory/I = over
			if(user.try_unequip(src))
				user.equip_to_slot_if_possible(src, I.slot_id)
				return TRUE
	return ..()

/obj/item/chems/weldpack/on_update_icon()
	. = ..()
	if(is_welder_attached())
		var/mutable_appearance/welder_image = new(welder)
		welder_image.appearance_flags |= RESET_COLOR
		welder_image.plane = FLOAT_PLANE //Use parent plane
		welder_image.pixel_y = 0
		welder_image.pixel_x = 15
		add_overlay(welder_image)

/obj/item/chems/weldpack/examine(mob/user)
	. = ..()
	to_chat(user, "[html_icon(src)] [reagents.total_volume] unit\s of fuel left!")

/obj/item/chems/weldpack/dropped(mob/user)
	. = ..()
	if(welder)
		welder.on_pack_dropped(user)

/obj/item/chems/weldpack/proc/get_fuel()
	return REAGENT_VOLUME(reagents, /decl/material/liquid/fuel)

/obj/item/chems/weldpack/proc/is_welder_attached()
	return welder && (welder.loc == src)

/**Re-attach the welder gun to the pack.*/
/obj/item/chems/weldpack/proc/reattach_gun(var/mob/user)
	if(is_welder_attached())
		return
	if(user)
		to_chat(user, SPAN_NOTICE("You re-attach \the [welder] to \the [src]."))
	if(welder.isOn())
		welder.turn_off(user)

	if(user && (user == welder.loc))
		if(!user.try_unequip(welder, src))
			return
	else
		welder.forceMove(src)
	update_icon()
	update_held_icon()
	return TRUE

/obj/item/chems/weldpack/proc/detach_gun(var/mob/user)
	if(!is_welder_attached())
		return
	if(!user)
		return
	to_chat(user, SPAN_NOTICE("You detach \the [welder] from \the [src]."))
	user.put_in_active_hand(welder)
	update_icon()
	update_held_icon()
	return TRUE

//Empty variant
/obj/item/chems/weldpack/empty/populate_reagents()
	return
