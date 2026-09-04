// TODO: skill check on melee/ranged hit to show bullseye/heart shot/etc
/obj/structure/target_stake
	name                = "target stake"
	desc                = "A simple stand used to prop up a target for practice."
	icon                = 'icons/obj/structures/target_stakes/target_stake.dmi'
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	density             = TRUE
	material            = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL
	structure_flags     = STRUCTURE_FLAG_THROWN_DAMAGE
	var/obj/item/training_dummy/dummy

/obj/structure/target_stake/proc/set_dummy(obj/item/training_dummy/new_dummy)
	dummy = new_dummy
	if(dummy)
		dummy.reset_offsets()
	queue_icon_update()
	queue_vis_contents_update()

/obj/structure/target_stake/Destroy()
	set_dummy(null)
	. = ..()

/obj/structure/target_stake/take_damage(damage, damage_type, damage_flags, inflicter, armor_pen, silent, do_update_health)
	if(dummy)
		. = dummy.take_damage(damage, damage_type, damage_flags, inflicter, armor_pen, silent, do_update_health)
		if(QDELETED(dummy))
			set_dummy(null)
		update_icon()
		return
	return ..()

/obj/structure/target_stake/proc/can_hold_dummy(mob/user, obj/item/training_dummy/new_dummy)
	return istype(new_dummy) && !istype(new_dummy, /obj/item/training_dummy/straw/archery)

/obj/structure/target_stake/attack_hand(mob/user)
	if(dummy)
		dummy.dropInto(loc)
		user.put_in_hands(dummy)
		set_dummy(null)
		return TRUE
	return ..()

/obj/structure/target_stake/attackby(obj/item/used_item, mob/user)
	if(dummy?.repair_target_dummy(used_item, user))
		return TRUE
	if(user.check_intent(I_FLAG_HARM) && dummy?.attackby(used_item, user))
		return TRUE
	if(istype(used_item, /obj/item/training_dummy) && can_hold_dummy(user, used_item))
		if(dummy)
			to_chat(user, SPAN_WARNING("\The [src] is already holding \the [dummy]."))
		else if(user.try_unequip(used_item, src))
			set_dummy(used_item)
			visible_message(SPAN_NOTICE("\The [user] places \the [dummy] onto \the [src]."))
		return TRUE
	return ..()

/obj/structure/target_stake/Initialize(ml, _mat, _reinf_mat)
	if(ispath(dummy))
		set_dummy(new dummy(src))
	. = ..()

/obj/structure/target_stake/get_vis_contents_to_add()
	. = ..()
	LAZYADD(., dummy)

// Subtypes below.
/obj/structure/target_stake/steel
	material   = /decl/material/solid/metal/steel

/obj/structure/target_stake/archery
	name       = "archery butt"
	desc       = "A heavy circular target used for practicing archery."
	icon       = 'icons/obj/structures/target_stakes/archery_butt.dmi'

/obj/structure/target_stake/archery/can_hold_dummy(mob/user, obj/item/training_dummy/new_dummy)
	return istype(new_dummy, /obj/item/training_dummy/straw/archery)

// Subtypes with/for dummies.
/obj/structure/target_stake/mapped
	dummy = /obj/item/training_dummy/straw

/obj/structure/target_stake/steel/mapped/Initialize()
	dummy = pick(/obj/item/training_dummy, /obj/item/training_dummy/alien, /obj/item/training_dummy/syndicate)
	return ..()

/obj/structure/target_stake/archery/mapped
	dummy = /obj/item/training_dummy/straw/archery
