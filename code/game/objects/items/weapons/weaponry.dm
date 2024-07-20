/obj/item/nullrod
	name = "null sceptre"
	desc = "A sceptre of pure black obsidian capped at both ends with silver ferrules. Some religious groups claim it disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/items/weapon/nullrod.dmi'
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_LOWER_BODY
	item_flags = ITEM_FLAG_IS_WEAPON
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/glass
	max_health = ITEM_HEALTH_NO_DAMAGE
	_base_attack_force = 10

/obj/item/nullrod/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(target)

	if (!user.check_dexterity(DEXTERITY_WEAPONS))
		return TRUE

	if (user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		to_chat(user, SPAN_DANGER("The rod slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		SET_STATUS_MAX(user, STAT_PARA, 20)
		return TRUE

	if (holy_act(target, user))
		return TRUE

	return ..()

/obj/item/nullrod/proc/holy_act(mob/living/target, mob/living/user)
	if(target.mind && LAZYLEN(target.mind.learned_spells))
		target.silence_spells(30 SECONDS)
		to_chat(target, SPAN_DANGER("You've been silenced!"))
		return TRUE
	return FALSE

/obj/item/nullrod/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return
	return A.nullrod_act(user, src)

/atom/proc/nullrod_act(mob/user, obj/item/nullrod/rod)
	return FALSE


/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	max_health = 100
	_base_attack_force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."
	net_type = /obj/effect/energy_net/safari

/obj/item/energy_net/dropped()
	..()
	spawn(10)
		if(src) qdel(src)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()
	try_capture_mob(hit_atom)

// This will validate the hit_atom, then spawn an energy_net effect and qdel itself
/obj/item/energy_net/proc/try_capture_mob(mob/living/M)

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return FALSE

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net_effect = new net_type(T)
		net_effect.capture_mob(M)
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_NORMAL
	anchored = TRUE
	can_buckle = 0 //no manual buckling or unbuckling

	max_health = 25
	var/countdown = 15
	var/temporary = 1
	var/mob/living/captured = null
	var/min_free_time = 50
	var/max_free_time = 85

/obj/effect/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."

	anchored = FALSE
	max_health = 5
	temporary = 0
	min_free_time = 5
	max_free_time = 10

/obj/effect/energy_net/teleport
	countdown = 60

/obj/effect/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/energy_net/Destroy()
	if(captured)
		unbuckle_mob()
	STOP_PROCESSING(SSobj, src)
	captured = null
	return ..()

/obj/effect/energy_net/Process()
	if(!captured)
		qdel(src)
		return PROCESS_KILL
	if(temporary)
		countdown--
	if(captured.buckled != src)
		current_health = 0
	if(get_turf(src) != get_turf(captured))  //just in case they somehow teleport around or
		countdown = 0
	if(countdown <= 0)
		current_health = 0
	healthcheck()

/obj/effect/energy_net/Move()
	..()

	if(buckled_mob)
		buckled_mob.forceMove(src.loc)
	else
		countdown = 0


/obj/effect/energy_net/proc/capture_mob(mob/living/M)
	captured = M
	if(M.buckled)
		M.buckled.unbuckle_mob()
	buckle_mob(M)
	return 1

/obj/effect/energy_net/post_buckle_mob(mob/living/M)
	..()
	if(buckled_mob)
		layer = ABOVE_HUMAN_LAYER
		visible_message("\The [M] was caught in [src]!")
	else
		to_chat(M,"<span class='warning'>You are free of the net!</span>")
		reset_plane_and_layer()

/obj/effect/energy_net/proc/healthcheck()
	if(current_health <=0)
		set_density(0)
		if(countdown <= 0)
			visible_message("<span class='warning'>\The [src] fades away!</span>")
		else
			visible_message("<span class='danger'>\The [src] is torn apart!</span>")
		qdel(src)

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	current_health -= Proj.get_structure_damage()
	healthcheck()
	return 0

/obj/effect/energy_net/explosion_act()
	..()
	if(!QDELETED(src))
		current_health = 0
		healthcheck()

/obj/effect/energy_net/attack_hand(var/mob/user)
	if(user.a_intent != I_HURT)
		return ..()
	var/decl/species/my_species = user.get_species()
	if(my_species)
		if(my_species.can_shred(user))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			current_health -= rand(10, 20)
		else
			current_health -= rand(1,3)
	else
		current_health -= rand(5,8)
	to_chat(user, SPAN_DANGER("You claw at the energy net."))
	healthcheck()
	return TRUE

/obj/effect/energy_net/attackby(obj/item/W, mob/user)
	current_health -= W.get_attack_force(user)
	healthcheck()
	..()

/obj/effect/energy_net/user_unbuckle_mob(mob/user)
	return escape_net(user)


/obj/effect/energy_net/proc/escape_net(mob/user)
	set waitfor = FALSE
	visible_message(
		"<span class='warning'>\The [user] attempts to free themselves from \the [src]!</span>",
		"<span class='warning'>You attempt to free yourself from \the [src]!</span>"
		)
	if(do_after(user, rand(min_free_time, max_free_time), src, incapacitation_flags = INCAPACITATION_DISABLED))
		current_health = 0
		healthcheck()
		return 1
	return 0
