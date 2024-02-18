/mob/living/Initialize()

	current_health = get_max_health()
	original_fingerprint_seed = sequential_id(/mob)
	fingerprint               = md5(num2text(original_fingerprint_seed))
	original_genetic_seed     = sequential_id(/mob)
	unique_enzymes            = md5(num2text(original_genetic_seed))

	. = ..()
	if(stat == DEAD)
		add_to_dead_mob_list()
	else
		add_to_living_mob_list()

/mob/living/get_ai_type()
	var/decl/species/my_species = get_species()
	if(ispath(my_species?.ai))
		return my_species.ai
	return ..()

/mob/living/show_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	if(admin_paralyzed)
		to_chat(user, SPAN_OCCULT("OOC: They have been paralyzed by staff. Please avoid interacting with them unless cleared to do so by staff."))

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(incapacitated())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to <a href='?src=\ref[A];look_at_me=1'>[A]</a>")
	return 1

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		else
			return ((a_intent == I_HELP && swapped.a_intent == I_HELP) && swapped.can_move_mob(src, swapping, 1))

/mob/living/canface()
	if(stat)
		return 0
	return ..()

/mob/living/Bump(atom/movable/AM, yes)

	// This is boilerplate from /atom/movable/Bump() but in all honest
	// I have no clue what is going on in the logic below this and I'm
	// afraid to touch it in case it explodes and kills me.
	if(!QDELETED(throwing))
		throwing.hit_atom(AM)
		return
	// End boilerplate.

	spawn(0)
		if (!yes || now_pushing || QDELETED(src) || QDELETED(AM) || !loc || !AM.loc)
			return

		now_pushing = 1
		if (isliving(AM))
			var/mob/living/tmob = AM

			for(var/mob/living/M in range(tmob, 1))
				if(LAZYLEN(tmob.pinned) || (locate(/obj/item/grab, LAZYLEN(tmob.grabbed_by))))
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
					now_pushing = 0
					return

			if(can_swap_with(tmob)) // mutual brohugs all around!
				var/turf/oldloc = loc
				forceMove(tmob.loc)
				tmob.forceMove(oldloc)
				now_pushing = 0
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = 0
				return
			if(src.restrained())
				now_pushing = 0
				return
			if(tmob.a_intent != I_HELP)
				for(var/obj/item/shield/riot/shield in tmob.get_held_items())
					if(prob(99))
						now_pushing = 0
						return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return
			tmob.last_handled_by_mob = weakref(src)
		if(isobj(AM) && !AM.anchored)
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				to_chat(src, "<span class='warning'>It won't budge!</span>")
				now_pushing = 0
				return

		now_pushing = 0
		spawn(0)
			if (QDELETED(src) || QDELETED(AM) || !loc || !AM.loc)
				return
			..()
			var/saved_dir = AM.dir
			if (!istype(AM, /atom/movable) || AM.anchored)
				if(HAS_STATUS(src, STAT_CONFUSE) && prob(50) && !MOVING_DELIBERATELY(src))
					SET_STATUS_MAX(src, STAT_WEAK, 2)
					playsound(loc, "punch", 25, 1, -1)
					visible_message("<span class='warning'>[src] [pick("ran", "slammed")] into \the [AM]!</span>")
					src.apply_damage(5, BRUTE)
				return
			if (!now_pushing)
				now_pushing = 1

				var/t = get_dir(src, AM)
				if (istype(AM, /obj/structure/window))
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
				AM.glide_size = glide_size
				step(AM, t)
				if (isliving(AM))
					var/mob/living/tmob = AM
					if(istype(tmob.buckled, /obj/structure/bed))
						if(!tmob.buckled.anchored)
							step(tmob.buckled, t)
				if(ishuman(AM))
					var/mob/living/carbon/human/M = AM
					for(var/obj/item/grab/G in M.grabbed_by)
						step(G.assailant, get_dir(G.assailant, AM))
						G.adjust_position()
				if(saved_dir)
					AM.set_dir(saved_dir)
				now_pushing = 0

/proc/swap_density_check(var/mob/swapper, var/mob/swapee)
	var/turf/T = get_turf(swapper)
	if(T.density)
		return 1
	for(var/atom/movable/A in T)
		if(A == swapper)
			continue
		if(!A.CanPass(swapee, T, 1))
			return 1

/mob/living/proc/can_swap_with(var/mob/living/tmob)
	if(!tmob)
		return
	if(tmob.buckled || buckled || tmob.anchored)
		return 0
	//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
	if(!(tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())))
		return 0
	if(!tmob.MayMove(src) || incapacitated())
		return 0

	if(swap_density_check(src, tmob))
		return 0

	if(swap_density_check(tmob, src))
		return 0

	return can_move_mob(tmob, 1, 0)

/mob/living/verb/succumb()
	set hidden = 1
	var/current_max_health = get_max_health()
	if (current_health < (current_max_health/2)) // Health below half of maxhealth.
		adjustBrainLoss(current_max_health * 2) // Deal 2x health in BrainLoss damage, as before but variable.
		to_chat(src, SPAN_NOTICE("You have given up life and succumbed to death."))

/mob/living/proc/update_body(var/update_icons=1)
	if(update_icons)
		queue_icon_update()

/mob/living/proc/should_be_dead()
	return current_health <= 0

/mob/living/proc/get_total_life_damage()
	return (getOxyLoss()+getToxLoss()+getFireLoss()+getBruteLoss()+getCloneLoss()+getHalLoss())

/mob/living/proc/update_health()
	SHOULD_CALL_PARENT(TRUE)
	if(status_flags & GODMODE)
		current_health = get_max_health()
		set_stat(CONSCIOUS)
		return

	var/max_health = get_max_health()
	current_health = clamp(max_health-get_total_life_damage(), -(max_health), max_health)
	if(stat != DEAD && should_be_dead())
		death()
		if(!QDELETED(src)) // death() may delete or remove us
			set_status(STAT_BLIND, 1)
			set_status(STAT_SILENCE, 0)

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return

/mob/living/proc/increaseBodyTemp(value)
	return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/btemperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		btemperature += change
		if(actual > desired)
			btemperature = desired
	// Too hot
	if(actual > desired)
		btemperature -= change
		if(actual < desired)
			btemperature = desired
//	if(ishuman(src))
//		log_debug("[src] ~ [src.bodytemperature] ~ [temperature]")

	return btemperature

/mob/living/proc/setBruteLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getBruteLoss()
	return get_max_health() - current_health

/mob/living/proc/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/living/proc/getOxyLoss()
	return 0

/mob/living/proc/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/living/proc/setOxyLoss(var/amount)
	return

/mob/living/proc/getToxLoss()
	return 0

/mob/living/proc/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/proc/setToxLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getFireLoss()
	return

/mob/living/proc/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/proc/setFireLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getHalLoss()
	return 0

/mob/living/proc/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/proc/setHalLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/adjustBrainLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/living/proc/setBrainLoss(var/amount)
	return

/mob/living/proc/getCloneLoss()
	return 0

/mob/living/proc/setCloneLoss(var/amount)
	return

/mob/living/proc/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/living/proc/get_health_ratio() // ratio might be the wrong word
	return current_health/get_max_health()

/mob/living/proc/get_health_percent(var/sigfig = 1)
	return round(get_health_ratio()*100, sigfig)

/mob/living/proc/get_max_health()
	return mob_default_max_health

/mob/living/proc/set_max_health(var/val, var/skip_health_update = FALSE)
	mob_default_max_health = val
	if(!skip_health_update)
		update_health()

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/get_contents()
	return

//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0

/mob/living/proc/can_inject(var/mob/user, var/target_zone)
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.get_target_zone()
	if ((t in list( BP_EYES, BP_MOUTH )))
		t = BP_HEAD
	var/obj/item/organ/external/def_zone = ran_zone(t, target = src)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn, var/affect_robo = FALSE, var/update_health = TRUE)
	adjustBruteLoss(-brute, do_update_health = FALSE)
	adjustFireLoss(-burn, do_update_health = update_health)

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute = 0, var/burn = 0, var/bypass_armour = FALSE, var/override_droplimb)
	if(status_flags & GODMODE)
		return
	adjustBruteLoss(brute, do_update_health = FALSE)
	adjustFireLoss(burn)

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute, do_update_health = FALSE)
	adjustFireLoss(-burn)

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute, do_update_health = FALSE)
	adjustFireLoss(burn)

/mob/living/proc/restore_all_organs()
	return


/mob/living/carbon/revive()
	var/obj/item/cuffs = get_equipped_item(slot_handcuffed_str)
	if (cuffs)
		try_unequip(cuffs, get_turf(src))
	. = ..()

/mob/living/proc/revive()
	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0

/mob/living/proc/rejuvenate()

	// Wipe all of our reagent lists.
	for(var/datum/reagents/reagent_list as anything in get_metabolizing_reagent_holders(include_contact = TRUE))
		reagent_list.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	set_status(STAT_PARA, 0)
	set_status(STAT_STUN, 0)
	set_status(STAT_WEAK, 0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = get_species()?.body_temperature || initial(bodytemperature)
	sdisabilities = 0
	disabilities = 0

	// fix all status conditions including blind/deaf
	clear_status_effects()

	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	update_icon()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()
	return

/mob/living/proc/basic_revival(var/repair_brain = TRUE)

	if(repair_brain && getBrainLoss() > 50)
		repair_brain = FALSE
		setBrainLoss(50)

	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	stat = CONSCIOUS
	update_icon()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()

/mob/living/carbon/basic_revival(var/repair_brain = TRUE)
	if(repair_brain && should_have_organ(BP_BRAIN))
		repair_brain = FALSE
		var/obj/item/organ/internal/brain = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(brain)
			if(brain.damage > (brain.max_damage/2))
				brain.damage = (brain.max_damage/2)
			if(brain.status & ORGAN_DEAD)
				brain.status &= ~ORGAN_DEAD
				START_PROCESSING(SSobj, brain)
			brain.update_icon()
	..(repair_brain)

/mob/living/proc/update_damage_icon()
	return

/mob/living/handle_grabs_after_move(var/turf/old_loc, var/direction)

	..()

	if(!isturf(loc))
		for(var/G in get_active_grabs())
			qdel(G)
			return

	if(isturf(old_loc))
		for(var/atom/movable/AM as anything in ret_grab())
			if(AM != src && AM.loc != loc && !AM.anchored && old_loc.Adjacent(AM))
				AM.glide_size = glide_size // This is adjusted by grabs again from events/some of the procs below, but doing it here makes it more likely to work with recursive movement.
				AM.DoMove(get_dir(get_turf(AM), old_loc), src, TRUE)

	var/list/mygrabs = get_active_grabs()
	for(var/obj/item/grab/G as anything in mygrabs)
		if(G.assailant_reverse_facing())
			set_dir(global.reverse_dir[direction])
		G.assailant_moved()
		if(QDELETED(G) || QDELETED(G.affecting))
			mygrabs -= G

	if(length(grabbed_by))
		for(var/obj/item/grab/G as anything in grabbed_by)
			G.adjust_position()
		reset_offsets()
		reset_plane_and_layer()

	if(!length(mygrabs))
		return

	if(direction & (UP|DOWN))
		var/txt_dir = (direction & UP) ? "upwards" : "downwards"
		if(old_loc)
			old_loc.visible_message(SPAN_NOTICE("\The [src] moves [txt_dir]."))
		for(var/obj/item/grab/G as anything in mygrabs)
			var/turf/start = G.affecting.loc
			var/turf/destination = (direction == UP) ? GetAbove(G.affecting) : GetBelow(G.affecting)
			if(!start.CanZPass(G.affecting, direction))
				to_chat(src, SPAN_WARNING("\The [start] blocked your pulled object!"))
				mygrabs -= G
				qdel(G)
				continue
			for(var/atom/A in destination)
				if(!A.CanMoveOnto(G.affecting, start, 1.5, direction))
					to_chat(src, SPAN_WARNING("\The [A] blocks the [G.affecting] you were pulling."))
					mygrabs -= G
					qdel(G)
					continue
			G.affecting.forceMove(destination)
			if(QDELETED(G) || QDELETED(G.affecting))
				mygrabs -= G
			continue

	if(length(mygrabs) && !skill_check(SKILL_MEDICAL, SKILL_BASIC))
		for(var/obj/item/grab/grab as anything in mygrabs)
			var/mob/living/affecting_mob = grab.get_affecting_mob()
			if(affecting_mob)
				affecting_mob.handle_grab_damage()

/mob/living/Move(NewLoc, Dir)
	if (buckled)
		return
	var/turf/old_loc = loc
	. = ..()
	if(.)
		handle_grabs_after_move(old_loc, Dir)
		if (active_storage && !( active_storage in contents ) && get_turf(active_storage) != get_turf(src))	//check !( active_storage in contents ) first so we hopefully don't have to call get_turf() so much.
			active_storage.close(src)

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && last_resist + 2 SECONDS <= world.time)
		last_resist = world.time
		resist_grab()
		if(resting)
			lay_down()
		if(!HAS_STATUS(src, STAT_WEAK))
			process_resist()

/mob/living/proc/process_resist()

	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		escape_inventory(src.loc)
		return TRUE

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()
		return TRUE

	//Breaking out of a structure?
	if(istype(loc, /obj/structure))
		var/obj/structure/C = loc
		if(C.mob_breakout(src))
			return TRUE

	// Get rid of someone riding around on you.
	if(buckled_mob)
		unbuckle_mob()
		return TRUE

/mob/living/proc/escape_inventory(obj/item/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		to_chat(M, "<span class='warning'>\The [H] wriggles out of your grip!</span>")
		to_chat(src, "<span class='warning'>You wriggle out of \the [M]'s grip!</span>")

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/atom/A in M.contents)
			if(ismob(A) || istype(A,/obj/item/holder))
				return
		M.status_flags &= ~PASSEMOTES
	else if(istype(H.loc,/obj/item/clothing/accessory/storage/holster) || istype(H.loc,/obj/item/storage/belt/holster))
		var/datum/extension/holster/holster = get_extension(src, /datum/extension/holster)
		if(holster.holstered == H)
			holster.clear_holster()
		to_chat(src, "<span class='warning'>You extricate yourself from \the [holster].</span>")
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj))
		if(istype(H.loc, /obj/machinery/cooker))
			var/obj/machinery/cooker/C = H.loc
			C.cooking_obj = null
			C.check_cooking_obj()
		to_chat(src, "<span class='warning'>You struggle free of \the [H.loc].</span>")
		H.forceMove(get_turf(H))

	if(loc != H)
		qdel(H)

/mob/living/proc/escape_buckle()
	if(buckled)
		if(buckled.can_buckle)
			buckled.user_unbuckle_mob(src)
		else
			to_chat(usr, "<span class='warning'>You can't seem to escape from \the [buckled]!</span>")
			return

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		setClickCooldown(3)
		if(resting && !do_after(src, 2 SECONDS, src, incapacitation_flags = ~INCAPACITATION_FORCELYING))
			return
		resting = !resting
		UpdateLyingBuckledAndVerbStatus()
		update_icon()
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]."))

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(override_blindness_check || !(disabilities & BLINDED))
		..()
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SIZE_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return TRUE

/mob/living/proc/slip(var/slipped_on, stun_duration = 8)
	return FALSE

/mob/living/carbon/human/canUnEquip(obj/item/I)
	if(!..())
		return
	if(I in get_organs())
		return
	return 1

/mob/proc/can_be_possessed_by(var/mob/observer/ghost/possessor)
	return istype(possessor) && possessor.client

/mob/living/can_be_possessed_by(var/mob/observer/ghost/possessor)
	if(!..())
		return 0
	if(!possession_candidate)
		to_chat(possessor, "<span class='warning'>That animal cannot be possessed.</span>")
		return 0
	if(jobban_isbanned(possessor, "Animal"))
		to_chat(possessor, "<span class='warning'>You are banned from animal roles.</span>")
		return 0
	if(!possessor.MayRespawn(1,ANIMAL_SPAWN_DELAY))
		return 0
	return 1

/mob/living/proc/do_possession(var/mob/observer/ghost/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		to_chat(possessor, "<span class='warning'>\The [src] already has a player.</span>")
		return 0

	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].")
	src.ckey = possessor.ckey
	qdel(possessor)

	if(round_is_spooky(6)) // Six or more active cultists.
		to_chat(src, "<span class='notice'>You reach out with tendrils of ectoplasm and invade the mind of \the [src]...</span>")
		to_chat(src, "<b>You have assumed direct control of \the [src].</b>")
		to_chat(src, "<span class='notice'>Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly.</span>")
		src.universal_speak = TRUE
		src.universal_understand = TRUE
		//src.on_defilement() // Maybe another time.
		return

	to_chat(src, "<b>You are now \the [src]!</b>")
	to_chat(src, "<span class='notice'>Remember to stay in character for a mob of this type!</span>")
	return 1

/mob/living/proc/add_aura(var/obj/aura/aura)
	LAZYDISTINCTADD(auras,aura)
	update_icon()
	return 1

/mob/living/proc/remove_aura(var/obj/aura/aura)
	LAZYREMOVE(auras,aura)
	update_icon()
	return 1

/mob/living/Destroy()
	QDEL_NULL(aiming)
	QDEL_NULL_LIST(_hallucinations)
	QDEL_NULL_LIST(aimed_at_by)
	if(stressors) // Do not QDEL_NULL, keys are managed instances.
		stressors = null
	if(auras)
		for(var/a in auras)
			remove_aura(a)
	// done in this order so that icon updates aren't triggered once all our organs are obliterated
	delete_inventory(TRUE)
	delete_organs()
	return ..()

/mob/living/proc/melee_accuracy_mods()
	. = 0
	if(incapacitated(INCAPACITATION_UNRESISTING))
		. += 100
	if(HAS_STATUS(src, STAT_BLIND))
		. += 75
	if(HAS_STATUS(src, STAT_BLURRY))
		. += 15
	if(HAS_STATUS(src, STAT_CONFUSE))
		. += 30
	if(MUTATION_CLUMSY in mutations)
		. += 40

/mob/living/proc/ranged_accuracy_mods()
	. = 0
	if(HAS_STATUS(src, STAT_JITTER))
		. -= 2
	if(HAS_STATUS(src, STAT_CONFUSE))
		. -= 2
	if(HAS_STATUS(src, STAT_BLIND))
		. -= 5
	if(HAS_STATUS(src, STAT_BLURRY))
		. -= 1
	if(MUTATION_CLUMSY in mutations)
		. -= 3

/mob/living/can_drown()
	if(get_internals())
		return FALSE
	var/obj/item/clothing/mask/mask = get_equipped_item(slot_wear_mask_str)
	if(istype(mask) && mask.filters_water())
		return FALSE
	var/obj/item/organ/internal/lungs/L = get_organ(BP_LUNGS, /obj/item/organ/internal/lungs)
	return (!L || L.can_drown())

/mob/living/handle_drowning()
	if(!can_drown() || !loc?.is_flooded(lying))
		return FALSE
	var/turf/T = get_turf(src)
	if(!lying && T.above && T.above.is_open() && !T.above.is_flooded() && can_overcome_gravity())
		return FALSE
	if(prob(5))
		var/datum/reagents/metabolism/inhaled = get_inhaled_reagents()
		var/datum/reagents/metabolism/ingested = get_ingested_reagents()
		to_chat(src, SPAN_DANGER("You choke and splutter as you inhale [T.get_fluid_name()]!"))
		var/inhale_amount = 0
		if(inhaled)
			inhale_amount = rand(2,5)
			T.reagents?.trans_to_holder(inhaled, min(T.reagents.total_volume, inhale_amount))
		if(ingested)
			var/ingest_amount = 5 - inhale_amount
			reagents?.trans_to_holder(ingested, min(T.reagents.total_volume, ingest_amount))

	T.show_bubbles()
	return TRUE // Presumably chemical smoke can't be breathed while you're underwater.

/mob/living/fluid_act(var/datum/reagents/fluids)
	..()
	if(QDELETED(src) || !fluids?.total_volume)
		return
	fluids.touch_mob(src)
	if(QDELETED(src) || !fluids.total_volume)
		return
	for(var/atom/movable/A as anything in get_equipped_items(TRUE))
		if(!A.simulated)
			continue
		A.fluid_act(fluids)
		if(QDELETED(src) || !fluids.total_volume)
			return
	var/datum/reagents/touching_reagents = get_contact_reagents()
	if(touching_reagents)
		var/saturation =  min(fluids.total_volume, round(mob_size * 1.5 * reagent_permeability()) - touching_reagents.total_volume)
		if(saturation > 0)
			fluids.trans_to_holder(touching_reagents, saturation)

/mob/living/proc/nervous_system_failure()
	return FALSE

/mob/living/proc/needs_wheelchair()
	return FALSE

/mob/living/proc/seizure()
	set waitfor = 0
	sleep(rand(5,10))
	if(!HAS_STATUS(src, STAT_PARA) && stat == CONSCIOUS)
		visible_message(SPAN_DANGER("\The [src] starts having a seizure!"))
		SET_STATUS_MAX(src, STAT_PARA, rand(8,16))
		set_status(STAT_JITTER, rand(150,200))
		adjustHalLoss(rand(50,60))

/mob/living/proc/get_digestion_product()
	return null

/mob/living/proc/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	vomit.reagents.add_reagent(/decl/material/liquid/acid/stomach, 5)

/mob/living/proc/eyecheck()
	return FLASH_PROTECTION_NONE

/mob/living/proc/get_satiated_nutrition()
	return 500

/mob/living/proc/get_max_nutrition()
	return 550

/mob/living/proc/set_nutrition(var/amt)
	nutrition = clamp(amt, 0, get_max_nutrition())

/mob/living/proc/get_nutrition(var/amt)
	return nutrition

/mob/living/proc/adjust_nutrition(var/amt)
	set_nutrition(get_nutrition() + amt)

/mob/living/proc/get_max_hydration()
	return 500

/mob/living/proc/get_hydration(var/amt)
	return hydration

/mob/living/proc/set_hydration(var/amt)
	hydration = clamp(amt, 0, get_max_hydration())

/mob/living/proc/adjust_hydration(var/amt)
	set_hydration(get_hydration() + amt)

/mob/living/proc/has_chemical_effect(var/chem, var/threshold_over, var/threshold_under)
	var/val = GET_CHEMICAL_EFFECT(src, chem)
	. = (isnull(threshold_over) || val >= threshold_over) && (isnull(threshold_under) || val <= threshold_under)

/mob/living/proc/add_chemical_effect(var/effect, var/magnitude = 1)
	magnitude += GET_CHEMICAL_EFFECT(src, effect)
	LAZYSET(chem_effects, effect, magnitude)

/mob/living/proc/add_chemical_effect_max(var/effect, var/magnitude = 1)
	magnitude = max(LAZYACCESS(chem_effects, effect), magnitude)
	LAZYSET(chem_effects, effect, magnitude)

/mob/living/proc/add_chemical_effect_min(var/effect, var/magnitude = 1)
	var/old_magnitude = LAZYACCESS(chem_effects, effect)
	if(!isnull(old_magnitude))
		magnitude = min(old_magnitude, magnitude)
	LAZYSET(chem_effects, effect, magnitude)

/mob/living/handle_reading_literacy(var/mob/user, var/text_content, var/skip_delays, var/digital = FALSE)
	if(skill_check(SKILL_LITERACY, SKILL_ADEPT))
		. = text_content
	else
		if(!skip_delays)
			to_chat(src, SPAN_NOTICE("You scan the writing..."))
			if(user != src)
				to_chat(user, SPAN_NOTICE("\The [src] scans the writing..."))
		if(skill_check(SKILL_LITERACY, SKILL_BASIC))
			if(skip_delays || do_after(src, 1 SECOND, user))
				. = stars(text_content, 85)
		else if(skip_delays || do_after(src, 3 SECONDS, user))
			. = ..()

/mob/living/handle_writing_literacy(var/mob/user, var/text_content, var/skip_delays)
	if(skill_check(SKILL_LITERACY, SKILL_ADEPT))
		. = text_content
	else
		if(!skip_delays)
			to_chat(src, SPAN_NOTICE("You write laboriously..."))
			if(user != src)
				to_chat(user, SPAN_NOTICE("\The [src] writes laboriously..."))
		if(skill_check(SKILL_LITERACY, SKILL_BASIC))
			if(skip_delays || do_after(src, 3 SECONDS, user))
				. = stars(text_content, 85)
		else if(skip_delays || do_after(src, 5 SECONDS, user))
			. = ..()

/mob/living/handle_grab_damage()
	..()
	if(!has_gravity())
		return
	if(isturf(loc) && pull_damage() && prob(getBruteLoss() / 6))
		if (!should_have_organ(BP_HEART))
			blood_splatter(loc, src, large = TRUE)
		if(prob(25))
			adjustBruteLoss(1)
			visible_message(SPAN_DANGER("\The [src]'s [isSynthetic() ? "state worsens": "wounds open more"] from being dragged!"))

/mob/living/CanUseTopicPhysical(mob/user)
	. = CanUseTopic(user, global.physical_no_access_topic_state)

/mob/living/proc/is_telekinetic()
	return FALSE

/mob/living/proc/can_do_special_ranged_attack(var/check_flag = TRUE)
	return TRUE

/mob/living/proc/get_food_satiation()
	. = get_nutrition() + (get_ingested_reagents()?.total_volume * 10)

/mob/living/proc/get_ingested_reagents()
	RETURN_TYPE(/datum/reagents)
	return reagents

/mob/living/proc/should_have_organ(organ_to_check)
	var/decl/bodytype/root_bodytype = get_bodytype()
	return root_bodytype?.has_organ[organ_to_check]

/// Returns null if the mob's bodytype doesn't have a limb tag by default.
/// Otherwise, returns the data of the limb instead.
/mob/living/proc/should_have_limb(limb_to_check)
	var/decl/bodytype/root_bodytype = get_bodytype()
	return root_bodytype?.has_limbs[limb_to_check]

/mob/living/proc/get_contact_reagents()
	RETURN_TYPE(/datum/reagents)
	return reagents

/mob/living/proc/get_injected_reagents()
	RETURN_TYPE(/datum/reagents)
	return reagents

/mob/living/proc/get_inhaled_reagents()
	RETURN_TYPE(/datum/reagents)
	return reagents

/mob/living/proc/get_adjusted_metabolism(metabolism)
	return metabolism

/mob/living/get_admin_job_string()
	return "Living"

/mob/living/handle_mouse_drop(atom/over, mob/user, params)
	if(!anchored && user == src && user != over)

		if(isturf(over))
			var/turf/T = over
			var/obj/structure/glass_tank/A = locate() in user.loc
			if(A && A.Adjacent(user) && A.Adjacent(T))
				A.do_climb_out(user, T)
				return TRUE

		if(isexosuit(over))
			var/mob/living/exosuit/exosuit = over
			if(exosuit.body)
				if(user.mob_size >= exosuit.body.min_pilot_size && user.mob_size <= exosuit.body.max_pilot_size)
					exosuit.enter(src)
				else
					to_chat(usr, SPAN_WARNING("You cannot pilot a exosuit of this size."))
				return TRUE
	. = ..()

/mob/living/is_deaf()
	. = ..() || GET_STATUS(src, STAT_DEAF)

/mob/living/attempt_hug(mob/living/target, hug_3p, hug_1p)
	. = ..()
	if(.)

		if(fire_stacks >= target.fire_stacks + 3)
			target.fire_stacks += 1
			fire_stacks -= 1
		else if(target.fire_stacks >= fire_stacks + 3)
			fire_stacks += 1
			target.fire_stacks -= 1

		if(on_fire && !target.on_fire)
			target.IgniteMob()
		else if(!on_fire && target.on_fire)
			IgniteMob()

/mob/living/proc/jump_layer_shift()
	jumping = TRUE
	reset_layer()

/mob/living/proc/jump_layer_shift_end()
	jumping = FALSE
	reset_layer()

/mob/living/proc/get_eye_overlay()
	return

/mob/living/proc/empty_stomach()
	return

/mob/living/proc/handle_actions()
	//Pretty bad, i'd use picked/dropped instead but the parent calls in these are nonexistent
	for(var/datum/action/A in actions)
		if(A.CheckRemoval(src))
			A.Remove(src)
	for(var/obj/item/I in src)
		if(I.action_button_name)
			if(!I.action)
				I.action = new I.default_action_type
			I.action.name = I.action_button_name
			I.action.desc = I.action_button_desc
			I.action.SetTarget(I)
			I.action.Grant(src)
	return

/mob/living/update_action_buttons()
	if(!hud_used) return
	if(!client) return

	if(hud_used.hud_shown != 1)	//Hud toggled to minimal
		return

	client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.update_icon()
		hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
		client.screen += hud_used.hide_actions_toggle
		return

	var/button_number = 0
	for(var/datum/action/action in actions)
		button_number++
		if(isnull(action.button))
			action.button = new /obj/screen/action_button(null, src, null, null, null, action)
		action.button.SetName(action.UpdateName())
		action.button.desc = action.UpdateDesc()
		action.button.update_icon()
		action.button.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
		client.screen |= action.button

	if(button_number > 0)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used, src)
		hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
		client.screen += hud_used.hide_actions_toggle

/mob/living/handle_fall_effect(var/turf/landing)
	..()
	if(istype(landing) && !landing.is_open())
		apply_fall_damage(landing)
		if(client)
			var/area/A = get_area(landing)
			if(A)
				A.alert_on_fall(src)

/mob/living/proc/apply_fall_damage(var/turf/landing)
	adjustBruteLoss(rand(max(1, CEILING(mob_size * 0.33)), max(1, CEILING(mob_size * 0.66))) * get_fall_height())

/mob/living/proc/get_toxin_resistance()
	var/decl/species/species = get_species()
	return isnull(species) ? 1 : species.toxins_mod

/mob/living/proc/get_metabolizing_reagent_holders(var/include_contact = FALSE)
	for(var/datum/reagents/adding in list(reagents, get_ingested_reagents(), get_inhaled_reagents()))
		LAZYDISTINCTADD(., adding)
	if(include_contact)
		for(var/datum/reagents/adding in list(get_injected_reagents(), get_contact_reagents()))
			LAZYDISTINCTADD(., adding)

/mob/living/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/admin_kill)

/decl/interaction_handler/admin_kill
	name = "Admin Kill"
	expected_user_type = /mob/observer
	expected_target_type = /mob/living
	interaction_flags = 0

/decl/interaction_handler/admin_kill/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		if(!check_rights(R_INVESTIGATE, 0, user))
			return FALSE
		var/mob/living/M = target
		if(M.stat == DEAD)
			return FALSE

/decl/interaction_handler/admin_kill/invoked(atom/target, mob/user, obj/item/prop)
	var/mob/living/M = target
	var/key_name = key_name(M)
	if(alert(user, "Do you wish to kill [key_name]?", "Kill \the [M]?", "No", "Yes") != "Yes")
		return FALSE
	if(!is_possible(target, user, prop))
		to_chat(user, SPAN_NOTICE("You were unable to kill [key_name]."))
		return FALSE
	M.death()
	log_and_message_admins("\The [user] admin-killed [key_name].")

/mob/living/get_speech_bubble_state_modifier()
	return isSynthetic() ? "synth" : ..()

/mob/living/proc/is_on_special_ability_cooldown()
	return world.time < next_special_ability

/mob/living/proc/set_special_ability_cooldown(var/amt)
	next_special_ability = max(next_special_ability, world.time+amt)

/mob/living/proc/get_seconds_until_next_special_ability_string()
	return ticks2readable(next_special_ability - world.time)

/mob/living/proc/handle_some_updates()
	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
	return life_tick <= 5 || !timeofdeath || (timeofdeath >= 5 && (world.time-timeofdeath) <= 10 MINUTES)

/mob/living/proc/check_dna()
	dna?.check_integrity(src)

/mob/living/get_unique_enzymes()
	return unique_enzymes

/mob/living/get_blood_type()
	return blood_type

/mob/living/proc/get_mob_footstep(var/footstep_type)
	var/decl/species/my_species = get_species()
	return my_species?.get_footstep(src, footstep_type)

/mob/living/GetIdCards(list/exceptions)
	. = ..()
	// Grab our equipped ID.
	// TODO: consider just iterating the entire equipment list here?
	// Mask/neck slot lanyards or IDs as uniform accessories someday?
	// TODO: May need handling for a held or equipped item returning
	// multiple ID cards, currently will take the last one added.
	var/obj/item/id = get_equipped_item(slot_wear_id_str)
	if(istype(id))
		id = id.GetIdCard()
		if(istype(id) && !is_type_in_list(id, exceptions))
			LAZYDISTINCTADD(., id)
	// Go over everything we're holding.
	for(var/obj/item/thing in get_held_items())
		thing = thing.GetIdCard()
		if(istype(thing) && !is_type_in_list(thing, exceptions))
			LAZYDISTINCTADD(., thing)

/mob/living/proc/update_surgery(update_icons)
	SHOULD_CALL_PARENT(TRUE)
	var/image/total = null
	for(var/obj/item/organ/external/E in get_external_organs())
		if(BP_IS_PROSTHETIC(E))
			continue
		var/how_open = round(E.how_open())
		if(how_open <= 0)
			continue
		var/surgery_icon = E.species.get_surgery_overlay_icon(src)
		if(!surgery_icon)
			continue
		if(!total)
			total = new
			total.appearance_flags = RESET_COLOR
		var/base_state = "[E.icon_state][how_open]"
		var/overlay_state = "[base_state]-flesh"
		var/list/overlays_to_add
		if(check_state_in_icon(overlay_state, surgery_icon))
			var/image/flesh = image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER)
			flesh.color = E.species.get_species_flesh_color(src)
			LAZYADD(overlays_to_add, flesh)
		overlay_state = "[base_state]-blood"
		if(check_state_in_icon(overlay_state, surgery_icon))
			var/image/blood = image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER)
			blood.color = E.species.get_species_blood_color(src)
			LAZYADD(overlays_to_add, blood)
		overlay_state = "[base_state]-bones"
		if(check_state_in_icon(overlay_state, surgery_icon))
			LAZYADD(overlays_to_add, image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER))
		total.overlays |= overlays_to_add
	set_current_mob_overlay(HO_SURGERY_LAYER, total, update_icons)

/mob/living/get_overhead_text_x_offset()
	var/decl/bodytype/bodytype = get_bodytype()
	return ..() + bodytype?.antaghud_offset_x

/mob/living/get_overhead_text_y_offset()
	var/decl/bodytype/bodytype = get_bodytype()
	return ..() + bodytype?.antaghud_offset_y

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/proc/get_authentification_rank(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	return istype(id) ? (id.position || if_no_job) : if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/proc/get_assignment(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.assignment ? id.assignment : if_no_job
	return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when players do something with computers
/mob/living/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/card/id/id = GetIdCard()
	if(istype(id))
		return id.registered_name
	return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/proc/get_visible_name()
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if((face_name == "Unknown") && id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
//Also used in AI tracking people by face, so added in checks for head coverings like masks and helmets
/mob/living/proc/get_face_name()
	if(identity_is_visible())
		return real_name
	var/obj/item/clothing/mask = get_equipped_item(slot_wear_mask_str)
	var/obj/item/clothing/head = get_equipped_item(slot_head_str)
	if(istype(head) && head.visible_name)
		return head.visible_name
	else if(istype(mask) && mask.visible_name)
		return mask.visible_name
	else if(get_rig()?.visible_name)
		return get_rig()?.visible_name
	return "Unknown"

/mob/living/proc/identity_is_visible()
	if(!real_name)
		return FALSE
	var/obj/item/clothing/mask/mask = get_equipped_item(slot_wear_mask_str)
	var/obj/item/head = get_equipped_item(slot_head_str)
	if((mask?.flags_inv & HIDEFACE) || (head?.flags_inv & HIDEFACE))
		return FALSE
	if(should_have_limb(BP_HEAD))
		var/obj/item/organ/external/skull = GET_EXTERNAL_ORGAN(src, BP_HEAD)
		if(!skull || (skull.status & ORGAN_DISFIGURED))	//Face is unrecognizeable
			return FALSE
	return TRUE

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/proc/get_id_name(if_no_id = "Unknown")
	return GetIdCard(exceptions = list(/obj/item/holder))?.registered_name || if_no_id

/mob/living/get_default_temperature_threshold(threshold)
	if(isSynthetic())
		switch(threshold)
			if(COLD_LEVEL_1)
				return SYNTH_COLD_LEVEL_1
			if(COLD_LEVEL_2)
				return SYNTH_COLD_LEVEL_2
			if(COLD_LEVEL_3)
				return SYNTH_COLD_LEVEL_3
			if(HEAT_LEVEL_1)
				return SYNTH_HEAT_LEVEL_1
			if(HEAT_LEVEL_2)
				return SYNTH_HEAT_LEVEL_2
			if(HEAT_LEVEL_3)
				return SYNTH_HEAT_LEVEL_3
			else
				CRASH("synthetic get_default_temperature_threshold() called with invalid threshold value.")
	return ..()

/mob/living/clean(clean_forensics = TRUE)

	SHOULD_CALL_PARENT(FALSE)

	for(var/obj/item/thing in get_held_items())
		thing.clean()

	var/obj/item/back = get_equipped_item(slot_back_str)
	if(back)
		back.clean()

	//flush away reagents on the skin
	var/datum/reagents/touching_reagents = get_contact_reagents()
	if(touching_reagents)
		var/remove_amount = touching_reagents.maximum_volume * reagent_permeability() //take off your suit first
		touching_reagents.remove_any(remove_amount)

	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	if(mask)
		mask.clean()

	var/washgloves  = TRUE
	var/washshoes   = TRUE
	var/washmask    = TRUE
	var/washears    = TRUE
	var/washglasses = TRUE

	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	if(suit)
		washgloves = !(suit.flags_inv & HIDEGLOVES)
		washshoes = !(suit.flags_inv & HIDESHOES)

	var/obj/item/head = get_equipped_item(slot_head_str)
	if(head)
		washmask = !(head.flags_inv & HIDEMASK)
		washglasses = !(head.flags_inv & HIDEEYES)
		washears = !(head.flags_inv & HIDEEARS)

	if(mask)
		if (washears)
			washears = !(mask.flags_inv & HIDEEARS)
		if (washglasses)
			washglasses = !(mask.flags_inv & HIDEEYES)

	if(head)
		head.clean()

	if(suit)
		suit.clean()
	else
		var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
		if(uniform)
			uniform.clean()

	if(washgloves)
		var/obj/item/gloves = get_equipped_item(slot_gloves_str)
		if(gloves)
			gloves.clean()
		else
			germ_level = 0

	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(shoes && washshoes)
		shoes.clean()

	if(mask && washmask)
		mask.clean()

	if(washglasses)
		var/obj/item/glasses = get_equipped_item(slot_glasses_str)
		if(glasses)
			glasses.clean()

	if(washears)
		var/obj/item/ear = get_equipped_item(slot_l_ear_str)
		if(ear)
			ear.clean()
		ear = get_equipped_item(slot_r_ear_str)
		if(ear)
			ear.clean()

	var/obj/item/belt = get_equipped_item(slot_belt_str)
	if(belt)
		belt.clean()

	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves)
		gloves.clean()
		gloves.germ_level = 0
		for(var/organ_tag in get_held_item_slots())
			var/obj/item/organ/external/organ = get_organ(organ_tag)
			if(organ)
				organ.clean()
	else
		germ_level = 0
	update_equipment_overlay(slot_gloves_str, FALSE)

	if(!get_equipped_item(slot_shoes_str))
		var/static/list/clean_slots = list(BP_L_FOOT, BP_R_FOOT)
		for(var/organ_tag in clean_slots)
			var/obj/item/organ/external/organ = get_organ(organ_tag)
			if(organ)
				organ.clean()
	update_equipment_overlay(slot_shoes_str)

	return TRUE
