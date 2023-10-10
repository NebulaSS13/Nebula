/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon = 'icons/obj/structures/inflatable.dmi'
	icon_state = "folded_wall"
	material = /decl/material/solid/plastic
	w_class = ITEM_SIZE_NORMAL
	var/deploy_path = /obj/structure/inflatable/wall
	var/inflatable_health

/obj/item/inflatable/attack_self(mob/user)
	if(!deploy_path)
		return
	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("\The [src] cannot be inflated here."))
		return
	user.visible_message("[user] starts inflating \the [src].", "You start inflating \the [src].")
	if(!do_after(user, 1 SECOND, src))
		return
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	user.visible_message(SPAN_NOTICE("[user] inflates \the [src]."), SPAN_NOTICE("You inflate \the [src]."))
	var/obj/structure/inflatable/R = new deploy_path(user.loc)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	if(inflatable_health)
		R.health = inflatable_health
	qdel(src)

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	item_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable
	name = "inflatable structure"
	desc = "An inflated membrane. Do not puncture."
	density = 1
	anchored = 1
	opacity = 0
	icon = 'icons/obj/structures/inflatable.dmi'
	icon_state = "wall"
	maxhealth = 20
	hitsound = 'sound/effects/Glasshit.ogg'
	atmos_canpass = CANPASS_DENSITY
	material = /decl/material/solid/plastic

	var/undeploy_path = null
	var/taped

	var/max_pressure_diff = RIG_MAX_PRESSURE
	var/max_temp = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable

/obj/structure/inflatable/Initialize()
	. = ..()
	update_nearby_tiles(need_rebuild=1)
	START_PROCESSING(SSobj,src)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	STOP_PROCESSING(SSobj,src)
	return ..()

/obj/structure/inflatable/examine(mob/user, distance)
	. = ..()
	if(taped)
		to_chat(user, SPAN_NOTICE("It's been duct taped in few places."))

/obj/structure/inflatable/Process()
	check_environment()

/obj/structure/inflatable/proc/check_environment()
	var/min_pressure = INFINITY
	var/max_pressure = 0
	var/max_local_temp = 0

	for(var/check_dir in global.cardinal)
		var/turf/T = get_step(get_turf(src), check_dir)
		var/datum/gas_mixture/env = T.return_air()
		var/pressure = env.return_pressure()
		min_pressure = min(min_pressure, pressure)
		max_pressure = max(max_pressure, pressure)
		max_local_temp = max(max_local_temp, env.temperature)

	if(prob(50) && (max_pressure - min_pressure > max_pressure_diff || max_local_temp > max_temp))
		take_damage(1)

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 0

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	if(QDELETED(src))
		return PROJECTILE_CONTINUE

/obj/structure/inflatable/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1)
			physically_destroyed()
		else if(severity == 2 || (severity == 3 && prob(50)))
			deflate(TRUE)

/obj/structure/inflatable/can_repair_with(obj/item/tool)
	. = istype(tool, /obj/item/stack/tape_roll/duct_tape) && (health < maxhealth)

/obj/structure/inflatable/handle_repair(mob/user, obj/item/tool)
	var/obj/item/stack/tape_roll/duct_tape/T = tool
	if(taped)
		to_chat(user, SPAN_WARNING("You cannot tape up \the [src] any further."))
		return
	if(T.can_use(2))
		to_chat(user, SPAN_WARNING("You need 2 [T.plural_name] to repair \the [src]."))
		return
	T.use(2)
	playsound(src, 'sound/effects/tape.ogg', 50, TRUE)
	last_damage_message = null
	to_chat(user, SPAN_NOTICE("You tape up some of the damage to \the [src]."))
	health = clamp(health + 3, 0, maxhealth)
	taped = TRUE

/obj/structure/inflatable/attackby(obj/item/W, mob/user)

	if((W.damtype == BRUTE || W.damtype == BURN) && (W.can_puncture() || W.force > 10))
		visible_message(SPAN_DANGER("\The [user] pierces \the [src] with \the [W]!"))
		deflate(TRUE)
		return TRUE

	if(!istype(W, /obj/item/inflatable_dispenser))
		return ..()

	return FALSE

/obj/structure/inflatable/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	. = deflate(1)

/obj/structure/inflatable/CtrlClick()
	return hand_deflate()

/obj/structure/inflatable/proc/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/torn/R = new(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		if(!undeploy_path)
			return
		visible_message("\The [src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/R = new undeploy_path(src.loc)
			src.transfer_fingerprints_to(R)
			R.inflatable_health = health
			qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return FALSE

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()
	return TRUE

/obj/structure/inflatable/CanFluidPass(var/coming_from)
	return !density

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = 1
	anchored = 1
	opacity = 0

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door
	atmos_canpass = CANPASS_PROC

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

/obj/structure/inflatable/door/attack_ai(mob/living/silicon/ai/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user)
	if(user.a_intent == I_HURT || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return state
	if(istype(mover, /obj/effect/ir_beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.get_equipped_item(slot_handcuffed_str))
					SwitchState()
			else
				SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	flick("door_opening",src)
	sleep(10)
	set_density(0)
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/proc/Close()
	isSwitchingStates = 1
	flick("door_closing",src)
	sleep(10)
	set_density(1)
	set_opacity(0)
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/on_update_icon()
	..()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/structures/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, "<span class='notice'>The inflatable wall is too torn to be inflated!</span>")
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/structures/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, "<span class='notice'>The inflatable door is too torn to be inflated!</span>")
	add_fingerprint(user)

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon = 'icons/obj/items/storage/inflatables.dmi'
	icon_state = "inf_box"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	can_hold = list(/obj/item/inflatable)

/obj/item/storage/briefcase/inflatable/WillContain()
	return list(
			/obj/item/inflatable/door = 2,
			/obj/item/inflatable      = 3
		)
