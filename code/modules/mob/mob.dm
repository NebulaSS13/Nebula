/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	STOP_PROCESSING(SSmobs, src)
	global.dead_mob_list_ -= src
	global.living_mob_list_ -= src
	global.player_list -= src
	unset_machine()
	QDEL_NULL(hud_used)
	if(istype(ability_master))
		QDEL_NULL(ability_master)
	if(istype(skillset))
		QDEL_NULL(skillset)
	QDEL_NULL_LIST(grabbed_by)
	clear_fullscreen()
	QDEL_NULL(ai)
	if(client)
		remove_screen_obj_references()
		for(var/atom/movable/AM in client.screen)
			var/obj/screen/screenobj = AM
			if(!istype(screenobj) || !screenobj.globalscreen)
				qdel(screenobj)
		client.screen = list()
	if(mind && mind.current == src)
		spellremove(src)
	ghostize()
	..()
	return QDEL_HINT_HARDDEL

/mob/proc/remove_screen_obj_references()
	hands = null
	purged = null
	internals = null
	oxygen = null
	i_select = null
	m_select = null
	toxin = null
	fire = null
	bodytemp = null
	healths = null
	throw_icon = null
	nutrition_icon = null
	pressure = null
	pain = null
	item_use_icon = null
	gun_move_icon = null
	gun_setting_icon = null
	ability_master = null
	zone_sel = null

/mob/Initialize()
	. = ..()
	skillset = new skillset(src)
	if(!move_intent)
		move_intent = move_intents[1]
	if(ispath(move_intent))
		move_intent = GET_DECL(move_intent)
	var/ai_type = get_ai_type()
	if(ai_type)
		ai = new ai_type(src)
	START_PROCESSING(SSmobs, src)

/mob/proc/get_ai_type()
	if (ispath(ai))
		return ai

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	if(!client)	return

	//spaghetti code
	if(type)
		if((type & VISIBLE_MESSAGE) && is_blind())//Vision related
			if(!alt)
				return
			else
				msg = alt
				type = alt_type
		if((type & AUDIBLE_MESSAGE) && is_deaf())//Hearing related
			if(!alt)
				return
			else
				msg = alt
				type = alt_type
				if(((type & VISIBLE_MESSAGE) && is_blind()))
					return

	to_chat(src, msg)


// Show a message to all mobs and objects in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/mob/visible_message(var/message, var/self_message, var/blind_message, var/range = world.view, var/checkghosts = null, var/narrate = FALSE)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, range, mobs, objs, checkghosts)

	for(var/o in objs)
		var/obj/O = o
		O.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)

	for(var/m in mobs)
		var/mob/M = m
		var/mob_message = message

		if(isghost(M))
			if(ghost_skip_message(M))
				continue
			mob_message = add_ghost_track(mob_message, M)

		if(self_message && M == src)
			M.show_message(self_message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
			continue

		if(!M.is_blind() || narrate)
			M.show_message(mob_message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
			continue

		if(blind_message)
			M.show_message(blind_message, AUDIBLE_MESSAGE)
			continue
	//Multiz, have shadow do same
	if(bound_overlay)
		bound_overlay.visible_message(message, self_message, blind_message)

// Show a message to all mobs and objects in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/mob/audible_message(var/message, var/self_message, var/deaf_message, var/hearing_distance = world.view, var/checkghosts = null, var/narrate = FALSE, var/radio_message)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, hearing_distance, mobs, objs, checkghosts)

	for(var/m in mobs)
		var/mob/M = m
		var/mob_message = message

		if(isghost(M))
			if(ghost_skip_message(M))
				continue
			mob_message = add_ghost_track(mob_message, M)

		if(self_message && M == src)
			M.show_message(self_message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		else if(is_invisible_to(M) || narrate) // Cannot view the invisible
			M.show_message(mob_message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		else
			M.show_message(mob_message, AUDIBLE_MESSAGE)

	for(var/o in objs)
		var/obj/O = o
		if(radio_message)
			O.hear_talk(src, radio_message, null, GET_DECL(/decl/language/noise))
		else
			O.show_message(message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)

/mob/proc/add_ghost_track(var/message, var/mob/observer/ghost/M)
	ASSERT(istype(M))

	var/remote = ""
	if(M.get_preference_value(/datum/client_preference/ghost_sight) == PREF_ALL_EMOTES && !(src in view(M)))
		remote = "\[R\]"

	var/track = "([ghost_follow_link(src, M)])"

	message = track + remote + " " + message
	return message

/mob/proc/ghost_skip_message(var/mob/observer/ghost/M)
	ASSERT(istype(M))
	if(M.get_preference_value(/datum/client_preference/ghost_sight) == PREF_ALL_EMOTES && !(src in view(M)))
		if(!client)
			return TRUE
	return FALSE

// Returns an amount of power drawn from the object (-1 if it's not viable).
// If drain_check is set it will not actually drain power, just return a value.
// If surge is set, it will destroy/damage the recipient and not return any power.
// Not sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge, var/amount = 0)
	return -1

/mob/proc/findname(msg)
	for(var/mob/M in SSmobs.mob_list)
		if (M.real_name == msg)
			return M
	return 0

#define ENCUMBERANCE_MOVEMENT_MOD 0.35
/mob/proc/movement_delay()
	. = 0
	if(istype(loc, /turf))
		var/turf/T = loc
		. += T.movement_delay()
	if(HAS_STATUS(src, STAT_DROWSY))
		. += 6
	if(lying) //Crawling, it's slower
		. += (8 + ((GET_STATUS(src, STAT_WEAK) * 3) + (GET_STATUS(src, STAT_CONFUSE) * 2)))
	. += move_intent.move_delay + (ENCUMBERANCE_MOVEMENT_MOD * encumbrance())
#undef ENCUMBERANCE_MOVEMENT_MOD

/mob/proc/encumbrance()
	for(var/obj/item/grab/G AS_ANYTHING in get_active_grabs())
		. = max(., G.grab_slowdown())
	. *= (0.8 ** size_strength_mod())
	. *= (0.5 + 1.5 * (SKILL_MAX - get_skill_value(SKILL_HAULING))/(SKILL_MAX - SKILL_MIN))

//Determines mob size/strength effects for slowdown purposes. Standard is 0; can be pos/neg.
/mob/proc/size_strength_mod()
	return log(2, mob_size / MOB_SIZE_MEDIUM)

/mob/proc/Life()
	SHOULD_NOT_SLEEP(TRUE)
	if(ability_master)
		ability_master.update_spells(0)

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_blind()
	return ((sdisabilities & BLINDED) || blinded || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_deaf()
	return ((sdisabilities & DEAFENED) || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)

/mob/living/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	. = ..()
	if(!.)
		if((incapacitation_flags & INCAPACITATION_STUNNED)    && HAS_STATUS(src, STAT_STUN))
			return TRUE
		if((incapacitation_flags & INCAPACITATION_FORCELYING) && HAS_STATUS(src, STAT_WEAK))
			return TRUE
		if((incapacitation_flags & INCAPACITATION_KNOCKOUT)   && (HAS_STATUS(src, STAT_PARA)|| HAS_STATUS(src, STAT_ASLEEP)))
			return TRUE
		if((incapacitation_flags & INCAPACITATION_WEAKENED)   && HAS_STATUS(src, STAT_WEAK))
			return TRUE

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if(status_flags & ENABLE_AI)
		return TRUE
	if((incapacitation_flags & INCAPACITATION_FORCELYING) && (resting || pinned.len))
		return TRUE
	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return TRUE
	if((incapacitation_flags & INCAPACITATION_KNOCKOUT) && (stat || (status_flags & FAKEDEATH)))
		return TRUE
	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return TRUE
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return TRUE
	return FALSE

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	set waitfor = 0
	while((shakecamera > world.time) && client && !QDELETED(src))
		sleep(1)
	if(!client || QDELETED(src))
		return
	client.default_pixel_x = initial(client.default_pixel_x)
	client.default_pixel_y = initial(client.default_pixel_y)
	client.pixel_x = client.default_pixel_x
	client.pixel_y = client.default_pixel_y
	A = A ? A : eyeobj
	if (istype(A, /atom/movable))
		client.perspective = EYE_PERSPECTIVE
		client.eye = A
	else if (isturf(loc))
		client.eye = client.mob
		client.perspective = MOB_PERSPECTIVE
	else
		client.perspective = EYE_PERSPECTIVE
		client.eye = loc

/mob/proc/show_inv(mob/user)
	return

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	if(!usr || !usr.client)
		return

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return 1

	face_atom(A)

	if(!isghost(src))
		if((A.loc != src || (A in get_held_items())))
			var/look_target = "at \the [A]"
			if(isobj(A.loc))
				look_target = "inside \the [A.loc]"
			if(A == src)
				var/decl/pronouns/G = get_pronouns()
				look_target = "at [G.self]"
			for(var/mob/M in viewers(4, src))
				if(M == src)
					continue
				if(M.client && M.client.get_preference_value(/datum/client_preference/examine_messages) == PREF_SHOW)
					if(M.is_blind() || is_invisible_to(M))
						continue
					to_chat(M, "<span class='subtle'><b>\The [src]</b> looks [look_target].</span>")

	var/distance = INFINITY
	if(isghost(src) || stat == DEAD)
		distance = 0
	else
		var/turf/source_turf = get_turf(src)
		var/turf/target_turf = get_turf(A)
		if(source_turf && source_turf.z == target_turf?.z)
			distance = get_dist(source_turf, target_turf)

	if(!A.examine(src, distance))
		PRINT_STACK_TRACE("Improper /examine() override: [log_info_line(A)]")

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(src.loc)))
		return FALSE
	if(istype(A, /obj/effect/decal/point))
		return FALSE

	var/tile = get_turf(A)
	if (!tile)
		return FALSE

	var/obj/P = new /obj/effect/decal/point(tile)
	P.set_invisibility(invisibility)
	P.pixel_x = A.pixel_x
	P.pixel_y = A.pixel_y
	QDEL_IN(P, 2 SECONDS)

	face_atom(A)
	return TRUE

//Gets the mob grab conga line.
/mob/proc/ret_grab(list/L)
	var/grabs = get_active_grabs()
	if(!length(grabs))
		return L
	if(!L)
		L = list(src)
	for(var/obj/item/grab/G in grabs)
		if(G.affecting && !(G.affecting in L))
			L += G.affecting
			var/mob/living/affecting_mob = G.get_affecting_mob()
			if(istype(affecting_mob))
				affecting_mob.ret_grab(L)
	return L

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr
	var/obj/item/W = get_active_hand()
	W?.attack_self(src)
	return W

/mob/living/mode()
	if(!..())
		attack_empty_hand()

/mob/proc/update_flavor_text(var/key)
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)
	if(!CanInteract(usr, global.self_topic_state))
		return
	if(msg != null)
		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, "<span class='alert'>Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a></span>")

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return "<span class='notice'>[msg]</span>"
		else
			return "<span class='notice'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a></span>"

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	getFiles(
		'html/88x31.png',
		'html/bug-minus.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/map-pencil.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/scales.png',
		'html/spell-check.png',
		'html/wrench-screwdriver.png',
		'html/changelog.css',
		'html/changelog.html'
		)
	show_browser(src, 'html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		SScharacter_setup.queue_preferences_save(prefs)
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)

/mob/DefaultTopicState()
	return global.view_topic_state

// Use to field Topic calls for which usr == src is required, which will first be funneled into here.
/mob/proc/OnSelfTopic(href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		show_browser(src, null, t1)
		return TOPIC_HANDLED
	if(href_list["flavor_change"])
		update_flavor_text(href_list["flavor_change"])
		return TOPIC_HANDLED

// If usr != src, or if usr == src but the Topic call was not resolved, this is called next.
/mob/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["flavor_more"])
		var/text = "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY><TT>[replacetext(flavor_text, "\n", "<BR>")]</TT></BODY></HTML>"
		show_browser(user, text, "window=[name];size=500x200")
		onclose(user, "[name]")
		return TOPIC_HANDLED

// You probably do not need to override this proc. Use one of the two above.
/mob/Topic(href, href_list, datum/topic_state/state)
	if(CanUseTopic(usr, global.self_topic_state, href_list) == STATUS_INTERACTIVE)
		. = OnSelfTopic(href_list)
		if(.)
			return
	else if(href_list["flavor_change"] && !is_admin(usr) && (usr != src))
		log_and_message_admins(usr, "is suspected of trying to change flavor text on [key_name_admin(src)] via Topic exploits.")
	return ..()

/mob/proc/pull_damage()
	return 0

/mob/living/carbon/human/pull_damage()
	if(!lying || getBruteLoss() + getFireLoss() < 100)
		return FALSE
	for(var/thing in organs)
		var/obj/item/organ/external/e = thing
		if(!e || e.is_stump())
			continue
		if((e.status & ORGAN_BROKEN) && !e.splinted)
			return TRUE
		if(e.status & ORGAN_BLEEDING)
			return TRUE
	return FALSE

/mob/handle_mouse_drop(atom/over, mob/user)
	if(over == user && user != src && !istype(user, /mob/living/silicon/ai))
		show_inv(user)
		return TRUE
	if(istype(over, /obj/vehicle/train))
		var/obj/vehicle/train/beep = over
		if(!beep.load(src))
			to_chat(user, SPAN_WARNING("You were unable to load \the [src] onto \the [over]."))
		return TRUE
	. = ..()

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	return istype(src, /mob/living/silicon)

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src, message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/Stat()
	..()
	. = (is_client_active(10 MINUTES))
	if(!.)
		return

	if(statpanel("Status"))
		if(GAME_STATE >= RUNLEVEL_LOBBY)
			stat("Local Time", stationtime2text())
			stat("Local Date", stationdate2text())
			stat("Round Duration", roundduration2text())
		if(client.holder || isghost(client.mob))
			stat("Location:", "([x], [y], [z]) [loc]")

	if(client.holder)
		if(statpanel("MC"))
			stat("CPU:","[world.cpu]")
			stat("Instances:","[world.contents.len]")
			stat(null)
			if(Master)
				Master.stat_entry()
			else
				stat("Master Controller:", "ERROR")
			if(Failsafe)
				Failsafe.stat_entry()
			else if (Master.initializing)
				stat("Failsafe Controller:", "Waiting for MC")
			else
				stat("Failsafe Controller:", "ERROR")
			if(Master)
				stat(null)
				for(var/datum/controller/subsystem/SS in Master.subsystems)
					SS.stat_entry()

	if(listed_turf && client)
		if(!TurfAdjacent(listed_turf))
			listed_turf = null
		else
			if(statpanel("Turf"))
				stat(listed_turf)
				for(var/atom/A in listed_turf)
					if(!A.mouse_opacity)
						continue
					if(A.invisibility > see_invisible)
						continue
					if(is_type_in_list(A, shouldnt_see))
						continue
					stat(A)


// facing verbs
/mob/proc/canface()
	return !incapacitated()

// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

//Updates lying and icons
/mob/proc/UpdateLyingBuckledAndVerbStatus()
	var/last_lying = lying
	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
	else if(buckled)
		anchored = 1
		if(istype(buckled))
			if(buckled.buckle_lying == -1)
				lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			else
				lying = buckled.buckle_lying
			if(buckled.buckle_movable)
				anchored = 0
	else
		lying = incapacitated(INCAPACITATION_KNOCKDOWN)

	if(lying)
		set_density(0)
		drop_held_items()
	else
		set_density(initial(density))
	reset_layer()

	//Temporarily moved here from the various life() procs
	//I'm fixing stuff incrementally so this will likely find a better home.
	//It just makes sense for now. ~Carn
	if( update_icon )	//forces a full overlay update
		update_icon = 0
		update_icon()
	if( lying != last_lying )
		update_transform()

/mob/proc/reset_layer()
	if(lying)
		plane = DEFAULT_PLANE
		layer = LYING_MOB_LAYER
	else
		reset_plane_and_layer()

/mob/proc/facedir(var/ndir)
	if(!canface() || moving || (buckled && (!buckled.buckle_movable && !buckled.buckle_allow_rotation)))
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	SetMoveCooldown(movement_delay())
	return 1


/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return

/mob/proc/get_species_name()
	return ""

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

/mob/proc/remove_implant(var/obj/item/implant, var/surgical_removal = FALSE)
	if(!LAZYLEN(get_visible_implants(0))) //Yanking out last object - removing verb.
		verbs -= /mob/proc/yank_out_object
	for(var/obj/item/O in pinned)
		if(O == implant)
			pinned -= O
		if(!pinned.len)
			anchored = 0
	implant.dropInto(loc)
	implant.add_blood(src)
	implant.update_icon()
	if(istype(implant,/obj/item/implant))
		var/obj/item/implant/imp = implant
		imp.removed()
	. = TRUE

/mob/living/silicon/robot/remove_implant(var/obj/item/implant, var/surgical_removal = FALSE)
	embedded -= implant
	adjustBruteLoss(5)
	adjustFireLoss(10)
	. = ..()

/mob/living/carbon/human/remove_implant(var/obj/item/implant, var/surgical_removal = FALSE, var/obj/item/organ/external/affected)
	if(!affected) //Grab the organ holding the implant.
		for(var/obj/item/organ/external/organ in organs)
			for(var/obj/item/O in organ.implants)
				if(O == implant)
					affected = organ
					break
	if(affected)
		affected.implants -= implant
		for(var/datum/wound/wound in affected.wounds)
			LAZYREMOVE(wound.embedded_objects, implant)
		if(!surgical_removal)
			shock_stage+=20
			affected.take_external_damage((implant.w_class * 3), 0, DAM_EDGE, "Embedded object extraction")
			if(!BP_IS_PROSTHETIC(affected) && prob(implant.w_class * 5) && affected.sever_artery()) //I'M SO ANEMIC I COULD JUST -DIE-.
				custom_pain("Something tears wetly in your [affected.name] as [implant] is pulled free!", 50, affecting = affected)
	. = ..()

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants(0)
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return
	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects
	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>")
	if(!do_mob(U, S, 30, incapacitation_flags = INCAPACITATION_DEFAULT & (~INCAPACITATION_FORCELYING))) //let people pinned to stuff yank it out, otherwise they're stuck... forever!!!
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body.</b></span>","<span class='warning'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body.</b></span>")
	remove_implant(selection)
	selection.forceMove(get_turf(src))
	if(U.get_empty_hand_slot())
		U.put_in_hands(selection)
	if(ishuman(U))
		var/mob/living/carbon/human/human_user = U
		human_user.bloody_hands(src)
	return 1

/mob/verb/face_direction()

	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/mob/proc/set_face_dir(var/newdir)
	if(!isnull(facing_dir) && newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		set_dir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir()
	if(facing_dir)
		if(!canface() || lying || restrained())
			facing_dir = null
		else if(buckled)
			if(buckled.obj_flags & OBJ_FLAG_ROTATABLE)
				buckled.set_dir(facing_dir)
				return ..(facing_dir)
			else
				facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/proc/set_stat(var/new_stat)
	. = stat != new_stat
	stat = new_stat

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon) //in case we don't have the HUD and we use the hotkey
		src.throw_icon.icon_state = "act_throw_off"

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

/mob/proc/toggle_antag_pool()
	set name = "Toggle Add-Antag Candidacy"
	set desc = "Toggles whether or not you will be considered a candidate by an add-antag vote."
	set category = "OOC"
	if(isghostmind(src.mind) || isnewplayer(src))
		if(SSticker.looking_for_antags)
			if(src.mind in SSticker.antag_pool)
				SSticker.antag_pool -= src.mind
				to_chat(usr, "You have left the antag pool.")
			else
				SSticker.antag_pool += src.mind
				to_chat(usr, "You have joined the antag pool. Make sure you have the needed role set to high!")
		else
			to_chat(usr, "The game is not currently looking for antags.")
	else
		to_chat(usr, "You must be observing or in the lobby to join the antag pool.")
/mob/proc/is_invisible_to(var/mob/viewer)
	return (!alpha || !mouse_opacity || viewer.see_invisible < invisibility)

/client/proc/check_has_body_select()
	return mob && mob.hud_used && istype(mob.zone_sel, /obj/screen/zone_sel)

/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1
	toggle_zone_sel(list(BP_HEAD,BP_EYES,BP_MOUTH))

/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_R_ARM,BP_R_HAND))

/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_L_ARM,BP_L_HAND))

/client/verb/body_chest()
	set name = "body-chest"
	set hidden = 1
	toggle_zone_sel(list(BP_CHEST))

/client/verb/body_groin()
	set name = "body-groin"
	set hidden = 1
	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_R_LEG,BP_R_FOOT))

/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_L_LEG,BP_L_FOOT))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/obj/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(next_in_list(mob.zone_sel.selecting,zones))

/mob/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/proc/handle_drowning()
	return FALSE

/mob/proc/can_drown()
	return 0

/mob/proc/get_sex()
	return gender

/mob/is_fluid_pushable(var/amt)
	if(..() && !buckled && (lying || !Check_Shoegrip()) && (amt >= mob_size * (lying ? 5 : 10)))
		if(!lying)
			SET_STATUS_MAX(src, STAT_WEAK, 1)
			if(lying && prob(10))
				to_chat(src, "<span class='danger'>You are pushed down by the flood!</span>")
		return TRUE
	return FALSE

/mob/proc/get_footstep(var/footstep_type)
	return

/mob/proc/handle_embedded_and_stomach_objects()
	return

/mob/proc/get_sound_volume_multiplier()
	if(GET_STATUS(src, STAT_DEAF))
		return 0
	return 1

/mob/proc/has_dexterity(var/dex_level)
	. = TRUE

/mob/proc/check_dexterity(var/dex_level, var/silent)
	. = has_dexterity(dex_level)
	if(!. && !silent)
		to_chat(src, FEEDBACK_YOU_LACK_DEXTERITY)

/mob/proc/lose_hair()
	return

/mob/proc/handle_reading_literacy(var/mob/user, var/text_content, var/skip_delays)
	if(!skip_delays)
		to_chat(src, SPAN_WARNING("You can't make heads or tails of the words."))
	. = stars(text_content, 5)

/mob/proc/handle_writing_literacy(var/mob/user, var/text_content, var/skip_delays)
	if(!skip_delays)
		to_chat(src, SPAN_WARNING("You scrawl down some meaningless lines."))
	. = stars(text_content, 5)

// mobs do not have mouths by default
/mob/proc/check_has_mouth()
	return FALSE

/mob/proc/check_has_eyes()
	return TRUE

/mob/proc/handle_pre_transformation()
	for(var/obj/item/W in contents)
		if(istype(W, /obj/item/implant))
			qdel(W)
		else
			drop_from_inventory(W)

/mob/get_mass()
	return mob_size

/mob/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	gib()

/mob/explosion_act()
	. = ..()
	if(!blinded)
		flash_eyes()

/mob/proc/get_telecomms_race_info()
	return list("Unknown", FALSE)

/mob/proc/can_enter_cryopod(var/mob/user)
	if(stat == DEAD)
		if(user == src)
			to_chat(src, SPAN_WARNING("You cannot use that, as you are dead."))
		else
			to_chat(user, SPAN_WARNING("\The [src] cannot use that, as they are dead."))
		return FALSE
	return TRUE

/mob/proc/get_species()
	return

/mob/proc/get_bodytype()
	return
