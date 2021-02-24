//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone separated our Chief Science Officer from their own head!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/suit/armor/reactive.dmi'
	blood_overlay_type = "armor"
	armor = null
	var/active = 0

/obj/item/clothing/suit/armor/reactive/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(50))
		user.visible_message("<span class='danger'>The reactive teleport system flings [user] clear of the attack!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(6, user))
			if(isspaceturf(T)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, "sparks", 50, 1)

		user.forceMove(picked)
		return PROJECTILE_FORCE_MISS
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	..()
	active = !active
	to_chat(user, SPAN_NOTICE("The reactive armor is now [active ? "" : "in"]active."))
	update_icon()

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	update_icon()
	..()

/obj/item/clothing/suit/armor/reactive/on_update_icon()
	. = ..()
	icon_state = "[get_world_inventory_state()][active ? "_on" : ""]"

/obj/item/clothing/suit/armor/reactive/experimental_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(ret && active && check_state_in_icon("[ret.icon_state]_on", icon))
		ret.icon_state = "[ret.icon_state]_on"
	return ret
	