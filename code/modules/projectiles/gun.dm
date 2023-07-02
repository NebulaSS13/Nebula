/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/guns/pistol.dmi'
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = "{'combat':1}"
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/pickup2.ogg'

	var/waterproof = FALSE
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again. Cannot be less than [burst_delay+1]
	var/burst_delay = 1	//delay between shots, if firing in bursts
	var/fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/fire_anim = null
	var/screen_shake = 0 //shouldn't be greater than 2 unless zoomed
	var/space_recoil = 0 //knocks back in space
	var/silenced = 0
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/accuracy_power = 5  //increase of to-hit chance per 1 point of accuracy
	var/bulk = 0			//how unwieldy this weapon for its size, affects accuracy when fired without aiming
	var/last_handled		//time when hand gun's in became active, for purposes of aiming bonuses
	var/scoped_accuracy = null  //accuracy used when zoomed in a scope
	var/scope_zoom = 0
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/one_hand_penalty
	var/combustion	//whether it creates hotspot when fired

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()
	var/selector_sound = 'sound/weapons/guns/selector.ogg'

	//aiming system stuff
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/last_safety_check = -INFINITY
	var/safety_state = 1
	var/has_safety = TRUE
	var/safety_icon 	   //overlay to apply to gun based on safety state, if any

	var/autofire_enabled = FALSE
	var/atom/autofiring_at
	var/mob/autofiring_by
	var/autofiring_timer

	// Spam prevention
	var/last_fire_message_type
	var/last_fire_message_time

/obj/item/gun/Initialize()
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])
	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy
	if(scope_zoom)
		verbs += /obj/item/gun/proc/scope

/obj/item/gun/Destroy()
	// autofire timer is automatically cleaned up
	autofiring_at = null
	autofiring_by = null
	. = ..()

/obj/item/gun/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	return TRUE

/obj/item/gun/proc/set_autofire(var/atom/fire_at, var/mob/fire_by, var/autoturn = TRUE)
	. = TRUE
	if(!istype(fire_at) || !istype(fire_by))
		. = FALSE
	else if(QDELETED(fire_at) || QDELETED(fire_by) || QDELETED(src))
		. = FALSE
	else if(!autofire_enabled)
		. = FALSE
	if(.)
		autofiring_at = fire_at
		autofiring_by = fire_by
		if(!autofiring_timer)
			autofiring_timer = addtimer(CALLBACK(src, .proc/handle_autofire, autoturn), burst_delay, (TIMER_STOPPABLE | TIMER_LOOP | TIMER_UNIQUE | TIMER_OVERRIDE))
	else
		clear_autofire()

/obj/item/gun/proc/clear_autofire()
	autofiring_at = null
	autofiring_by = null
	if(autofiring_timer)
		deltimer(autofiring_timer)
		autofiring_timer = null

/obj/item/gun/proc/handle_autofire(var/autoturn)
	set waitfor = FALSE
	. = TRUE
	if(QDELETED(autofiring_at) || QDELETED(autofiring_by))
		. = FALSE
	else if(!autofiring_by.can_autofire(src, autofiring_at))
		. = FALSE
	if(!.)
		clear_autofire()
	else if(can_autofire())
		if(autoturn)
			autofiring_by.set_dir(get_dir(src, autofiring_at))
		Fire(autofiring_at, autofiring_by, null, (get_dist(autofiring_at, autofiring_by) <= 1), FALSE, FALSE)

/obj/item/gun/update_twohanding()
	if(one_hand_penalty)
		update_icon() // In case item_state is set somewhere else.
	..()

/obj/item/gun/on_update_icon()
	var/mob/living/M = loc
	. = ..()
	update_base_icon()
	if(istype(M))
		if(has_safety && M.skill_check(SKILL_WEAPONS,SKILL_BASIC))
			add_overlay(image('icons/obj/guns/gui.dmi',"safety[safety()]"))
		if(src in M.get_held_items())
			M.update_inv_hands()
	if(safety_icon)
		add_overlay(get_safety_indicator())

/obj/item/gun/proc/update_base_icon()

/obj/item/gun/proc/get_safety_indicator()
	return mutable_appearance(icon, "[get_world_inventory_state()][safety_icon][safety()]")

/obj/item/gun/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && user_mob.can_wield_item(src) && is_held_twohanded(user_mob) && check_state_in_icon("[overlay.icon_state]-wielded", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-wielded"
	. = ..()

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(!user.check_dexterity(DEXTERITY_WEAPONS))
		return 0

	var/mob/living/M = user
	if(!safety() && world.time > last_safety_check + 5 MINUTES && !user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		if(prob(30))
			toggle_safety()
			return 1
	if((MUTATION_CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			var/pew_loc = pick(BP_L_FOOT, BP_R_FOOT)
			if(process_projectile(P, user, user, pew_loc))
				var/decl/pronouns/G = user.get_pronouns()
				handle_post_fire(user, user)
				var/obj/item/affecting = GET_EXTERNAL_ORGAN(user, pew_loc)
				pew_loc = affecting ? "\the [affecting]" : "the foot"
				user.visible_message(
					SPAN_DANGER("\The [user] shoots [G.self] in [pew_loc] with \the [src]!"),
					SPAN_DANGER("You shoot yourself in [pew_loc] with \the [src]!"))
				M.try_unequip(src)
		else
			handle_click_empty(user)
		return 0
	return 1

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	Fire(A,user,params) //Otherwise, fire normally.

/obj/item/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.get_target_zone() == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent != I_HURT && user.aiming && user.aiming.active) //if aim mode, don't pistol whip
		if (user.aiming.aiming_at != A)
			PreFire(A, user)
		else
			Fire(A, user, pointblank=1)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/gun/dropped(var/mob/living/user)
	check_accidents(user)
	update_icon()
	return ..()

/obj/item/gun/proc/Fire(atom/target, atom/movable/firer, clickparams, pointblank = FALSE, reflex = FALSE, set_click_cooldown = TRUE, target_zone = BP_CHEST)
	if(!firer || !target)
		return
	if(target.z != firer.z)
		return

	if((!waterproof && submerged()))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(firer, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	var/mob/living/user = null
	if(isliving(firer))
		user = firer

	if(istype(user))
		add_fingerprint(user)

		if(!special_check(user))
			return

		if(safety())
			if(user.a_intent == I_HURT && !user.skill_fail_prob(SKILL_WEAPONS, 100, SKILL_EXPERT, 0.5)) //reflex un-safeying
				toggle_safety(user)
			else
				handle_click_empty(user)
				return

		last_safety_check = world.time

	if(set_click_cooldown)
		var/shoot_time = (burst - 1) * burst_delay
		if(istype(user))
			user.setClickCooldown(shoot_time) //no clicking on things while shooting
		next_fire_time = world.time + shoot_time

	var/held_twohanded = TRUE // Assume a non-mob shooter won't suffer from accuracy penalties.
	if(istype(user))
		held_twohanded = user.can_wield_item(src) && is_held_twohanded(user)

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(firer)
		if(!projectile)
			handle_click_empty(firer)
			break

		process_accuracy(projectile, firer, target, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, firer, target)

		if(process_projectile(projectile, firer, target, target_zone, clickparams))
			handle_post_fire(firer, target, pointblank, reflex, projectile)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	var/delay = max(fire_delay, burst_delay + 1, DEFAULT_QUICK_COOLDOWN)
	if(delay && istype(user))
		user.setClickCooldown(delay)
	next_fire_time = world.time + delay

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile(atom/movable/firer)
	return null

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target, var/mob/living/user)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return (target in check_trajectory(target, user))

#define FIREARM_MESSAGE_SPAM_TIME (1 SECOND)
/obj/item/gun/proc/check_fire_message_spam(var/check_type = "click")
	. = (last_fire_message_type != check_type) || (world.time >= last_fire_message_time + FIREARM_MESSAGE_SPAM_TIME)
	if(.)
		last_fire_message_type = check_type
		last_fire_message_time = world.time
#undef FIREARM_MESSAGE_SPAM_TIME

//called if there was no projectile to shoot
/obj/item/gun/proc/handle_click_empty(atom/movable/firer)
	if(check_fire_message_spam("click"))
		if(firer)
			firer.visible_message("*click click*", "<span class='danger'>*click*</span>")
		else
			src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(atom/movable/firer, atom/target, var/pointblank=0, var/reflex=0, var/obj/projectile)
	if(fire_anim)
		flick(fire_anim, src)

	if(!silenced && check_fire_message_spam("fire"))
		var/user_message = SPAN_WARNING("You fire \the [src][pointblank ? " point blank":""] at \the [target][reflex ? " by reflex" : ""]!")
		if (silenced)
			to_chat(firer, user_message)
		else
			firer.visible_message(
				SPAN_DANGER("\The [firer] fires \the [src][pointblank ? " point blank":""] at \the [target][reflex ? " by reflex" : ""]!"),
				user_message,
				SPAN_DANGER("You hear a [fire_sound_text]!")
			)

		if (pointblank && ismob(target) && isliving(firer))
			admin_attack_log(firer, target,
				"shot point blank with \a [type]",
				"shot point blank with \a [type]",
				"shot point blank (\a [type])"
			)

	if(combustion)
		var/turf/curloc = get_turf(src)
		if(curloc)
			curloc.hotspot_expose(700, 5)

	if(isliving(firer))
		var/mob/living/user = firer

		inaccuracy_feedback(user)

		if(screen_shake)
			shake_camera(user, max(burst_delay*burst, fire_delay), screen_shake)

		if(ishuman(user) && user.is_cloaked()) //shooting will disable a rig cloaking device
			var/mob/living/carbon/human/H = user
			var/obj/item/rig/rig = H.get_rig()
			if(rig)
				for(var/obj/item/rig_module/stealth_field/S in rig.installed_modules)
					S.deactivate()

		if(space_recoil)
			if(!user.check_space_footing())
				var/old_dir = user.dir
				user.inertia_ignore = projectile
				step(user,get_dir(target,user))
				user.set_dir(old_dir)

	update_icon()

/obj/item/gun/proc/inaccuracy_feedback(mob/living/user)
	if(one_hand_penalty)
		if(!src.is_held_twohanded(user))
			switch(one_hand_penalty)
				if(4 to 6)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, SPAN_WARNING("Your aim wavers slightly."))
				if(6 to 8)
					to_chat(user, SPAN_WARNING("You have trouble keeping \the [src] on target with just one hand."))
				if(8 to INFINITY)
					to_chat(user, SPAN_WARNING("You struggle to keep \the [src] on target with just one hand!"))
		else if(!user.can_wield_item(src))
			switch(one_hand_penalty)
				if(4 to 6)
					if(prob(50))
						to_chat(user, SPAN_WARNING("Your aim wavers slightly."))
				if(6 to 8)
					to_chat(user, SPAN_WARNING("You have trouble holding \the [src] steady."))
				if(8 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to hold \the [src] steady!</span>")

/obj/item/gun/proc/process_point_blank(obj/projectile, atom/movable/firer, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/max_mult = 1

	//determine multiplier due to the target being grabbed
	if(isliving(target))
		var/mob/living/L = target
		if(L.incapacitated())
			max_mult = 1.2
		for(var/obj/item/grab/G in L.grabbed_by)
			max_mult = max(max_mult, G.point_blank_mult())
	P.damage *= max_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, atom/movable/firer, atom/target, var/burst, var/held_twohanded)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]
	var/stood_still = last_handled

	// Living specific accuracy modifiers.
	if(isliving(firer))
		var/mob/living/user = firer
		//Not keeping gun active will throw off aim (for non-Masters)
		if(user.skill_check(SKILL_WEAPONS, SKILL_PROF))
			stood_still = min(user.l_move_time, last_handled)
		else
			stood_still = max(user.l_move_time, last_handled)

		stood_still = max(0,round((world.time - stood_still)/10) - 1)
		if(stood_still)
			acc_mod += min(max(3, accuracy), stood_still)
		else
			acc_mod -= w_class - ITEM_SIZE_NORMAL
			acc_mod -= bulk

		if(one_hand_penalty >= 4 && !held_twohanded)
			acc_mod -= one_hand_penalty/2
			disp_mod += one_hand_penalty*0.5 //dispersion per point of two-handedness

		if(burst > 1 && !user.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
			acc_mod -= 1
			disp_mod += 0.5

		//accuracy bonus from aiming
		if (aim_targets && (target in aim_targets))
			//If you aim at someone beforehead, it'll hit more often.
			//Kinda balanced by fact you need like 2 seconds to aim
			//As opposed to no-delay pew pew
			acc_mod += 2

		acc_mod += user.ranged_accuracy_mods()

	acc_mod += accuracy
	P.hitchance_mod = accuracy_power*acc_mod
	P.dispersion = disp_mod

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, atom/movable/firer, atom/target, var/target_zone, var/params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return 0 //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)

	//shooting while in shock
	var/shock_dispersion = 0
	if(istype(firer, /mob/living/carbon/human))
		var/mob/living/carbon/human/mob = firer
		if(mob.shock_stage > 120)
			shock_dispersion = rand(-4,4)
		else if(mob.shock_stage > 70)
			shock_dispersion = rand(-2,2)

	P.dispersion += shock_dispersion

	var/launched = !P.launch_from_gun(target, target_zone, firer, params)

	if(launched)
		play_fire_sound(firer, P)

	return launched

/obj/item/gun/proc/play_fire_sound(atom/movable/firer, obj/item/projectile/P)
	var/shot_sound = fire_sound
	var/shot_sound_vol = 50
	if((istype(P) && P.fire_sound))
		shot_sound = P.fire_sound
		shot_sound_vol = P.fire_sound_vol
	if(silenced)
		shot_sound_vol = 10

	playsound(firer, shot_sound, shot_sound_vol, 1)

//Suicide handling.
/obj/item/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>
/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	admin_attacker_log(user, "is attempting to suicide with \a [src]")
	M.visible_message("<span class='danger'>[user] sticks their gun in their mouth, ready to pull the trigger...</span>")
	if(!do_after(user, 40, progress=0))
		M.visible_message("<span class='notice'>[user] decided life was worth living</span>")
		mouthshoot = 0
		return

	if(safety())
		user.visible_message("*click click*", SPAN_DANGER("*click*"))
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
		mouthshoot = 0
		return

	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		var/shot_sound = in_chamber.fire_sound? in_chamber.fire_sound : fire_sound
		if(silenced)
			playsound(user, shot_sound, 10, 1)
		else
			playsound(user, shot_sound, 50, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != PAIN)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, in_chamber.damage_flags(), used_weapon = "Point blank shot in the mouth with \a [in_chamber]")
			user.death()
		else
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,PAIN,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/gun/proc/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom)

/obj/item/gun/proc/toggle_scope(mob/user, var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)

	if(zoom)
		unzoom(user)
		return

	zoom(user, zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy
		if(user.skill_check(SKILL_WEAPONS, SKILL_PROF))
			accuracy += 2
		if(screen_shake)
			screen_shake = round(screen_shake*zoom_amount+1) //screen shake is worse when looking through a scope

//make sure accuracy and screen_shake are reset regardless of how the item is unzoomed.
/obj/item/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		screen_shake = initial(screen_shake)

/obj/item/gun/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		if(firemodes.len > 1)
			var/datum/firemode/current_mode = firemodes[sel_mode]
			to_chat(user, "The fire selector is set to [current_mode.name].")
	if(has_safety)
		to_chat(user, "The safety is [safety() ? "on" : "off"].")
	last_safety_check = world.time

/obj/item/gun/proc/switch_firemodes(next_mode)
	if(!next_mode)
		next_mode = get_next_firemode()
	if(!next_mode || next_mode == sel_mode)
		return null

	sel_mode = next_mode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	playsound(loc, selector_sound, 50, 1)
	return new_mode

/obj/item/gun/proc/get_next_firemode()
	if(firemodes.len <= 1)
		return null
	. = sel_mode + 1
	if(. > firemodes.len)
		. = 1

/obj/item/gun/attack_self(mob/user)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(prob(20) && !user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		new_mode = switch_firemodes(user)
	if(new_mode)
		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")

/obj/item/gun/proc/toggle_safety(var/mob/user)
	if(!has_safety)
		to_chat(user,SPAN_NOTICE("You can't find a safety on \the [src]!"))
		return
	safety_state = !safety_state
	update_icon()
	if(user)
		to_chat(user, "<span class='notice'>You switch the safety [safety_state ? "on" : "off"] on [src].</span>")
		last_safety_check = world.time
		playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)

/obj/item/gun/verb/toggle_safety_verb()
	set src in usr
	set category = "Object"
	set name = "Toggle Gun Safety"
	if(usr == loc)
		toggle_safety(usr)

/obj/item/gun/CtrlClick(var/mob/user)
	if(loc == user)
		toggle_safety(user)
		return TRUE
	. = ..()

/obj/item/gun/proc/safety()
	return has_safety && safety_state

/obj/item/gun/equipped()
	..()
	update_icon()
	last_handled = world.time

/obj/item/gun/on_active_hand()
	last_handled = world.time

/obj/item/gun/on_disarm_attempt(mob/target, mob/attacker)
	var/list/turfs = list()
	for(var/turf/T in view())
		turfs += T
	if(turfs.len)
		var/turf/shoot_to = pick(turfs)
		target.visible_message("<span class='danger'>\The [src] goes off during the struggle!</span>")
		afterattack(shoot_to,target)
		return 1

/obj/item/gun/dropped(mob/living/user)
	. = ..()
	clear_autofire()

/obj/item/gun/proc/can_autofire()
	return (autofire_enabled && world.time >= next_fire_time)

/obj/item/gun/proc/check_accidents(mob/living/user, message = "[user] fumbles with the [src] and it goes off!",skill_path = SKILL_WEAPONS, fail_chance = 20, no_more_fail = SKILL_EXPERT, factor = 2)
	if(istype(user) && !safety() && user.skill_fail_prob(skill_path, fail_chance, no_more_fail, factor) && special_check(user))
		user.visible_message(SPAN_WARNING(message))
		var/list/targets = list(user)
		var/turf/checking = get_turf(src)
		targets += RANGE_TURFS(checking, 2)
		var/picked = pick(targets)
		afterattack(picked, user)
		return TRUE
	return FALSE

/obj/item/gun/handle_reflexive_fire(var/mob/user, var/atom/aiming_at)
	. = ..()
	if(. && isliving(user))
		var/mob/living/M = user
		if(prob(M.skill_fail_chance(SKILL_WEAPONS, 30, SKILL_ADEPT, 3)))
			to_chat(user, SPAN_WARNING("You fumble with \the [src], throwing off your aim!"))
			M.stop_aiming(src)
		else
			M.setClickCooldown(DEFAULT_QUICK_COOLDOWN) // Spam prevention, essentially.
			M.visible_message(SPAN_DANGER("\The [M] pulls the trigger reflexively!"))
			Fire(aiming_at, M, target_zone = M.get_target_zone())
			if(M.aiming)
				M.aiming.toggle_active(FALSE, TRUE)

/mob/proc/can_autofire(var/obj/item/gun/autofiring, var/atom/autofiring_at)
	if(!client || !(autofiring_at in view(client.view,src)))
		return FALSE
	if(get_active_hand() != autofiring || incapacitated())
		return FALSE
	return TRUE