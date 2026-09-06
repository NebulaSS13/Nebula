/obj/item/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon = 'icons/obj/guns/launcher/rocket.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	throw_speed = 2
	throw_range = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = 0
	origin_tech = @'{"combat":8,"materials":5}'
	fire_sound = 'sound/effects/bang.ogg'
	combustion = 1

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()

/obj/item/gun/launcher/rocket/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		. += SPAN_NOTICE("[rockets.len]/[max_rockets] rocket\s.")

/obj/item/gun/launcher/rocket/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			if(!user.try_unequip(used_item, src))
				return TRUE
			rockets += used_item
			to_chat(user, "<span class='notice'>You put the rocket in [src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")
			return TRUE
		else
			to_chat(user, "<span class='warning'>\The [src] cannot hold more rockets.</span>")
			return TRUE
	return ..()

/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/rocket = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= rocket
		return M
	return null

/obj/item/gun/launcher/rocket/handle_post_fire(atom/movable/firer, atom/target)
	log_and_message_admins("fired a rocket from a rocket launcher ([src.name]) at [target].", firer)
	..()
