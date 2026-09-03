//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "It's stringy and sticky."
	icon = 'mods/mobs/spiders/icons/effects.dmi'
	icon_state = "stickyweb1"
	anchored = TRUE
	density = FALSE
	max_health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50) || (severity == 3 && prob(5)))))
		qdel(src)

/obj/effect/spider/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(prob(50))
		visible_message(SPAN_WARNING("\The [user] tries to squash \the [src], but misses!"))
		disturbed()
		return TRUE
	var/showed_msg = FALSE
	if(ishuman(user))
		var/mob/living/human/H = user
		var/decl/natural_attack/attack = H.get_unarmed_attack(src)
		if(istype(attack))
			attack.show_attack(H, src, H.get_target_zone(), 1)
			showed_msg = TRUE
	if(!showed_msg)
		visible_message(SPAN_DANGER("\The [user] squashes \the [src] flat!"))
	die()
	return TRUE

/obj/effect/spider/attackby(var/obj/item/used_item, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	visible_message("<span class='warning'>\The [src] has been [used_item.pick_attack_verb()] with \the [used_item][(user ? " by [user]." : ".")]</span>")

	var/damage = used_item.expend_attack_force(user) / 4

	if(used_item.has_edge())
		damage += 5

	if(IS_WELDER(used_item))
		var/obj/item/weldingtool/welder = used_item

		if(welder.weld(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	current_health -= damage
	healthcheck()
	return TRUE

/obj/effect/spider/bullet_act(var/obj/item/projectile/Proj)
	..()
	current_health -= Proj.get_structure_damage()
	healthcheck()

/obj/effect/spider/proc/healthcheck()
	if(current_health <= 0)
		qdel(src)

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		current_health -= 5
		healthcheck()
	if(!QDELETED(src))
		return ..()

/obj/effect/spider/proc/disturbed()
	return

/obj/effect/spider/proc/die()
	visible_message("<span class='alert'>[src] dies!</span>")
	new /obj/effect/decal/cleanable/spider_remains(loc)
	qdel(src)
