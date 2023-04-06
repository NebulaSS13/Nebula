// Target stakes for the firing range.
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_stake"
	density = 1
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	var/obj/item/target/pinned_target

/obj/structure/target_stake/attackby(var/obj/item/W, var/mob/user)
	if (!pinned_target && istype(W, /obj/item/target) && user.try_unequip(W, get_turf(src)))
		to_chat(user, "<span class='notice'>You slide [W] into the stake.</span>")
		set_target(W)

/obj/structure/target_stake/attack_hand(var/mob/user)
	if (!pinned_target || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	to_chat(user, SPAN_NOTICE("You take \the [pinned_target] off the stake."))
	user.put_in_hands(pinned_target)
	set_target(null)
	return TRUE

/obj/structure/target_stake/proc/set_target(var/obj/item/target/T)
	if (T)
		set_density(0)
		T.set_density(1)
		T.pixel_x = 0
		T.pixel_y = 0
		T.layer = ABOVE_OBJ_LAYER
		events_repository.register(/decl/observ/moved, T, src, /atom/movable/proc/move_to_turf)
		events_repository.register(/decl/observ/moved, src, T, /atom/movable/proc/move_to_turf)
		T.stake = src
		pinned_target = T
	else
		set_density(1)
		if(pinned_target)
			pinned_target.set_density(0)
			pinned_target.layer = OBJ_LAYER
			events_repository.unregister(/decl/observ/moved, pinned_target, src)
			events_repository.unregister(/decl/observ/moved, src, pinned_target)
			pinned_target.stake = null
		pinned_target = null

/obj/structure/target_stake/Destroy()
	. = ..()
	set_target(null)