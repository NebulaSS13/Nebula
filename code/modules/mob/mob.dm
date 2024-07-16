/mob/Destroy() //This makes sure that mobs with clients/keys are not just deleted from the game.

	stop_automove()

	STOP_PROCESSING(SSmobs, src)
	global.dead_mob_list_ -= src
	global.living_mob_list_ -= src
	global.player_list -= src

	QDEL_NULL_LIST(pinned)
	QDEL_NULL_LIST(embedded)

	QDEL_NULL(typing_indicator)

	unset_machine()
	if(istype(hud_used))
		QDEL_NULL(hud_used)
	if(active_storage)
		active_storage.close(src)
	if(istype(ability_master))
		QDEL_NULL(ability_master)
	if(istype(skillset))
		QDEL_NULL(skillset)
	QDEL_NULL_LIST(grabbed_by)
	clear_fullscreen()
	if(istype(ai))
		QDEL_NULL(ai)
	QDEL_NULL(lighting_master)
	remove_screen_obj_references()
	if(client)
		for(var/atom/movable/AM in client.screen)
			var/obj/screen/screenobj = AM
			if(istype(screenobj) && !screenobj.is_global_screen)
				qdel(screenobj)
		client.screen = list()
	if(mind)
		mind.handle_mob_deletion(src)
	teleop = null
	ghostize()
	return ..()

/mob/proc/remove_screen_obj_references()
	QDEL_NULL_SCREEN(internals)
	QDEL_NULL_SCREEN(oxygen)
	QDEL_NULL_SCREEN(toxin)
	QDEL_NULL_SCREEN(fire)
	QDEL_NULL_SCREEN(bodytemp)
	QDEL_NULL_SCREEN(healths)
	QDEL_NULL_SCREEN(throw_icon)
	QDEL_NULL_SCREEN(maneuver_icon)
	QDEL_NULL_SCREEN(nutrition_icon)
	QDEL_NULL_SCREEN(hydration_icon)
	QDEL_NULL_SCREEN(pressure)
	QDEL_NULL_SCREEN(pain)
	QDEL_NULL_SCREEN(up_hint)
	QDEL_NULL_SCREEN(item_use_icon)
	QDEL_NULL_SCREEN(radio_use_icon)
	QDEL_NULL_SCREEN(gun_move_icon)
	QDEL_NULL_SCREEN(gun_setting_icon)
	QDEL_NULL_SCREEN(ability_master)
	QDEL_NULL_SCREEN(zone_sel)

/mob/Initialize()
	if(ispath(skillset))
		skillset = new skillset(src)
	if(!ispath(move_intent) || !(move_intent in move_intents))
		move_intent = move_intents[1]
	if(!istype(move_intent))
		move_intent = GET_DECL(move_intent)
	. = ..()
	ability_master = new(null, src)
	refresh_ai_handler()
	START_PROCESSING(SSmobs, src)

/mob/proc/refresh_ai_handler()
	var/ai_type = get_ai_type()
	if(istype(ai))
		if(ai_type == ai.type)
			return // No need to refresh.
		QDEL_NULL(ai)
	if(ai_type)
		ai = new ai_type(src)

/mob/proc/get_ai_type()
	var/ai_type = initial(ai)
	if(ispath(ai_type))
		return ai_type

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
/mob/visible_message(var/message, var/self_message, var/blind_message, var/range = world.view, var/check_ghosts = null, var/narrate = FALSE)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, range, mobs, objs, check_ghosts)

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
/mob/audible_message(var/message, var/self_message, var/deaf_message, var/hearing_distance = world.view, var/check_ghosts = null, var/narrate = FALSE, var/radio_message)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, hearing_distance, mobs, objs, check_ghosts)

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

#define ENCUMBERANCE_MOVEMENT_MOD 0.35
/mob/proc/get_movement_delay(var/travel_dir)
	. = 0
	if(isturf(loc))
		var/turf/T = loc
		. += T.get_terrain_movement_delay(travel_dir, src)
	if(HAS_STATUS(src, STAT_DROWSY))
		. += 6
	if(current_posture.prone) //Crawling, it's slower
		. += (8 + ((GET_STATUS(src, STAT_WEAK) * 3) + (GET_STATUS(src, STAT_CONFUSE) * 2)))
	var/_automove_delay = get_automove_delay()
	if(isnull(_automove_delay))
		. += move_intent.move_delay
	else
		. += _automove_delay
	. = max(. + (ENCUMBERANCE_MOVEMENT_MOD * encumbrance()), 1)

#undef ENCUMBERANCE_MOVEMENT_MOD

/mob/proc/encumbrance()
	for(var/obj/item/grab/G as anything in get_active_grabs())
		. = max(., G.grab_slowdown())
	. *= (0.8 ** size_strength_mod())
	. *= (0.5 + 1.5 * (SKILL_MAX - get_skill_value(SKILL_HAULING))/(SKILL_MAX - SKILL_MIN))

//Determines mob size/strength effects for slowdown purposes. Standard is 0; can be pos/neg.
/mob/proc/size_strength_mod()
	return log(2, mob_size / MOB_SIZE_MEDIUM)

/mob/proc/Life()
	SHOULD_NOT_SLEEP(TRUE)
	if(QDELETED(src))
		return PROCESS_KILL
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
	return (has_genetic_condition(GENE_COND_BLINDED) || incapacitated(INCAPACITATION_KNOCKOUT) || HAS_STATUS(src, STAT_BLIND))

/mob/proc/is_deaf()
	return (has_genetic_condition(GENE_COND_DEAFENED) || incapacitated(INCAPACITATION_KNOCKOUT) || HAS_STATUS(src, STAT_DEAF))

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
		if((incapacitation_flags & INCAPACITATION_KNOCKOUT)   && (HAS_STATUS(src, STAT_PARA) || HAS_STATUS(src, STAT_ASLEEP)))
			return TRUE
		if((incapacitation_flags & INCAPACITATION_WEAKENED)   && HAS_STATUS(src, STAT_WEAK))
			return TRUE

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if(status_flags & ENABLE_AI)
		return TRUE
	if((incapacitation_flags & INCAPACITATION_FORCELYING) && LAZYLEN(pinned))
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

/mob/proc/grab_restrained()
	for (var/obj/item/grab/G in grabbed_by)
		if(G.restrains())
			return TRUE

/mob/proc/restrained()
	if(get_equipped_item(slot_handcuffed_str))
		return TRUE
	if(grab_restrained())
		return TRUE
	if (istype(get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/straight_jacket))
		return TRUE
	return FALSE

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

/mob/proc/get_descriptive_slot_name(var/slot)
	return global.descriptive_slot_names[slot] || slot

/mob/proc/show_stripping_window(mob/user)

	if(user.incapacitated()  || !user.Adjacent(src) || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return

	user.set_machine(src)

	var/dat = list()
	dat += "<B><HR><FONT size=3>[name]</FONT></B>"
	dat += "<HR>"

	var/list/my_held_item_slots = get_held_item_slots()
	for(var/hand_slot in my_held_item_slots)
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		if(!inv_slot || inv_slot.skip_on_strip_display)
			continue
		var/obj/item/held = inv_slot.get_equipped_item()
		dat += "<b>[capitalize(inv_slot.slot_name)]:</b> <A href='byond://?src=\ref[src];item=[hand_slot]'>[held?.name || "nothing"]</A>"

	var/list/all_slots = get_all_available_equipment_slots()
	if(all_slots)
		for(var/slot in (all_slots-global.pocket_slots))
			if(slot in my_held_item_slots)
				continue
			var/obj/item/thing_in_slot = get_equipped_item(slot)
			dat += "<B>[capitalize(get_descriptive_slot_name(slot))]:</b> <a href='byond://?src=\ref[src];item=[slot]'>[thing_in_slot || "nothing"]</a>"
			if(istype(thing_in_slot, /obj/item/clothing))
				var/obj/item/clothing/C = thing_in_slot
				if(LAZYLEN(C.accessories))
					dat += "<A href='byond://?src=\ref[src];item=accessory;holder=\ref[C]'>Remove accessory</A>"

	// Do they get an option to set internals?
	if(istype(get_equipped_item(slot_wear_mask_str), /obj/item/clothing/mask) || istype(get_equipped_item(slot_head_str), /obj/item/clothing/head/helmet/space))
		for(var/slot in list(slot_back_str, slot_belt_str, slot_s_store_str))
			var/obj/item/tank/tank = get_equipped_item(slot)
			if(istype(tank))
				dat += "<BR><A href='byond://?src=\ref[src];item=internals'>Toggle internals.</A>"
				break

	// Other incidentals.
	var/obj/item/clothing/suit = get_equipped_item(slot_w_uniform_str)
	if(istype(suit))
		dat += "<BR><b>Pockets:</b> <A href='byond://?src=\ref[src];item=pockets'>Empty or Place Item</A>"
	var/obj/item/clothing/sensor/vitals/sensor = get_vitals_sensor()
	if(sensor)
		if(sensor.get_sensors_locked())
			dat += "<BR><A href='byond://?src=\ref[src];item=lock_sensors'>Unlock vitals sensors</A>"
		else if(user.get_multitool())
			dat += "<BR><A href='byond://?src=\ref[src];item=lock_sensors'>Lock vitals sensors</A>"
			dat += "<BR><A href='byond://?src=\ref[src];item=sensors'>Set vitals sensors</A>"
	if(get_equipped_item(slot_handcuffed_str))
		dat += "<BR><A href='byond://?src=\ref[src];item=[slot_handcuffed_str]'>Handcuffed</A>"

	var/list/strip_add = get_additional_stripping_options()
	if(length(strip_add))
		dat += strip_add

	dat += "<BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"

	var/datum/browser/popup = new(user, "[name]", "Inventory of \the [name]", 325, 500, src)
	popup.set_content(jointext(dat, "<br>"))
	popup.open()

/mob/proc/get_additional_stripping_options()
	return

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	if(!usr || !usr.client)
		return

	if(is_blind() && !isobserver(src))
		to_chat(src, SPAN_WARNING("Something is there but you can't see it."))
		return TRUE

	face_atom(A)

	if(!isghost(src) && get_config_value(/decl/config/toggle/visible_examine))
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

	RAISE_EVENT(/decl/observ/mob_examining, src, A)

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
	var/obj/item/holding = get_active_held_item()
	holding?.attack_self(src)
	return holding

/mob/living/mode()
	if(!..())
		attack_empty_hand()

/mob/proc/update_flavor_text(var/key)
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)
	if(!CanInteract(usr, global.self_topic_state))
		return
	if(msg != null)
		flavor_text = msg

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
/mob/proc/get_comments_record()
	return

/mob/OnTopic(mob/user, href_list, datum/topic_state/state)

	if(href_list["refresh"])
		show_stripping_window(user)
		return TOPIC_HANDLED

	if(href_list["item"])
		if(!handle_strip(href_list["item"], user, locate(href_list["holder"])))
			show_stripping_window(user)
		return TOPIC_HANDLED

	if(href_list["flavor_more"])
		var/datum/browser/popup = new(user, ckey(name), name, 500, 200)
		var/list/html = list("<h3>Appearance</h3>")
		html += replacetext(flavor_text, "\n", "<BR>")
		var/datum/character_information/comments = get_comments_record()
		if(comments)
			if(comments.ic_info)
				html += "<h3>IC Information</h3>"
				html += "[comments.ic_info]<br/>"
			if(comments.ooc_info)
				html += "<h3>OOC Information</h3>"
				html += "[comments.ooc_info]<br/>"
		popup.set_content(jointext(html, null))
		popup.open()
		return TOPIC_HANDLED

// You probably do not need to override this proc. Use one of the two above.
/mob/Topic(href, href_list, datum/topic_state/state)
	if(CanUseTopic(usr, global.self_topic_state, href_list) == STATUS_INTERACTIVE)
		. = OnSelfTopic(href_list)
		if(.)
			return
	else if(href_list["flavor_change"] && !is_admin(usr) && (usr != src))
		log_and_message_admins("is suspected of trying to change flavor text on [key_name_admin(src)] via Topic exploits.", usr)
	return ..()

/mob/proc/pull_damage()
	return 0

/mob/living/human/pull_damage()
	if(!current_posture.prone|| get_damage(BRUTE) + get_damage(BURN) < 100)
		return FALSE
	for(var/obj/item/organ/external/e in get_external_organs())
		if((e.status & ORGAN_BROKEN) && !e.splinted)
			return TRUE
		if(e.status & ORGAN_BLEEDING)
			return TRUE
	return FALSE

/mob/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && user != src && !isAI(user))
		show_stripping_window(user)
		return TRUE
	if(!anchored && istype(over, /obj/vehicle/train))
		var/obj/vehicle/train/beep = over
		if(!beep.load(src))
			to_chat(user, SPAN_WARNING("You were unable to load \the [src] onto \the [over]."))
		return TRUE
	. = ..()

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/can_touch(var/atom/touching)
	if(!touching.Adjacent(src) || incapacitated())
		return FALSE
	if(restrained())
		to_chat(src, SPAN_WARNING("You are restrained."))
		return FALSE
	if (buckled)
		to_chat(src, SPAN_WARNING("You are buckled down."))
	return TRUE

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
			stat("CPU:", "[Master.format_color_cpu()]")
			stat("Map CPU:", "[Master.format_color_cpu_map()]")
			stat("Instances:","[world.contents.len]")
			stat("World Time:", "[world.time]")
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
					if(!A.simulated || !A.mouse_opacity)
						continue
					if(A.invisibility > see_invisible)
						continue
					if(LAZYLEN(shouldnt_see) && is_type_in_list(A, shouldnt_see))
						continue
					stat(A)


// facing verbs
/mob/proc/canface()
	return !incapacitated(INCAPACITATION_UNRESISTING)

// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

//Updates lying, transform and icons
/mob/proc/update_posture(force_update)

	var/list/available_postures = get_available_postures()
	if(length(available_postures) <= 0)
		return // No postures, no point doing any of this.

	if(length(available_postures) == 1)
		// If we only have one posture, use that.
		. = set_posture(available_postures[1], skip_buckled_update = TRUE)
	else if(istype(buckled) && buckled.buckle_lying != -1)
		// If we're buckled to something that forces a posture, use that.
		. = set_posture(buckled.buckle_lying ? /decl/posture/lying : /decl/posture/standing, skip_buckled_update = TRUE)
	else if(incapacitated(INCAPACITATION_KNOCKDOWN) || (cannot_stand() && !can_stand_overridden()))
		// If we're straight up knocked over, set that.
		if(!current_posture.prone)
			. = set_posture(/decl/posture/lying, skip_buckled_update = TRUE)
	else if(!current_posture.deliberate)
		// If we're not deliberately lying, and we can stand, stand up.
		. = set_posture(/decl/posture/standing, skip_buckled_update = TRUE)
	else
		. = FALSE

	anchored = buckled ? (!istype(buckled) || !buckled.buckle_movable) : initial(anchored)
	reset_layer()

	if(. || force_update)
		update_icon()
		update_transform()

/mob/proc/facedir(var/ndir)
	if(!canface() || moving || (buckled && (!buckled.buckle_movable && !buckled.buckle_allow_rotation)))
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	SetMoveCooldown(get_movement_delay(ndir))
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

/mob/proc/get_species_name()
	SHOULD_CALL_PARENT(TRUE)
	return "Unknown"

/mob/living/get_species_name()
	var/decl/species/my_species = get_species()
	return my_species?.name || ..()

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return !!LAZYLEN(embedded)

/mob/proc/remove_implant(obj/item/implant, surgical_removal = FALSE, obj/item/organ/external/affected)
	return FALSE

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return
	usr.setClickCooldown(20)

	if(usr.stat == UNCONSCIOUS)
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
		var/mob/living/human/human_user = U
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
		if(!canface() || current_posture.prone || restrained())
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
	if(.)
		stat = new_stat
		SStyping.set_indicator_state(client, FALSE)

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

//Throwing stuff

/mob/proc/toggle_throw_mode(force_set)
	in_throw_mode = isnull(force_set) ? !in_throw_mode : force_set
	throw_icon?.icon_state = "act_throw_[in_throw_mode ? "on" : "off"]"

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
	return mob && mob.hud_used && istype(mob.zone_sel, /obj/screen/zone_selector)

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
	toggle_zone_sel(list(BP_GROIN,BP_TAIL))

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
	var/obj/screen/zone_selector/selector = mob.zone_sel
	selector.set_selected_zone(next_in_list(mob.get_target_zone(), zones))

/mob/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/proc/handle_drowning()
	return FALSE

/mob/proc/can_drown()
	return 0

/mob/proc/get_gender()
	return gender

/mob/is_fluid_pushable(var/amt)
	if(..() && !buckled && (current_posture.prone || !Check_Shoegrip()) && (amt >= mob_size * (current_posture.prone ? 5 : 10)))
		if(!current_posture.prone)
			SET_STATUS_MAX(src, STAT_WEAK, 1)
			if(current_posture.prone && prob(10))
				to_chat(src, "<span class='danger'>You are pushed down by the flood!</span>")
		return TRUE
	return FALSE

/mob/proc/handle_embedded_and_stomach_objects()
	return

/mob/proc/get_sound_volume_multiplier()
	if(GET_STATUS(src, STAT_DEAF))
		return 0
	. = 1
	for(var/slot in global.headphone_slots)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C))
			. = min(., C.volume_multiplier)

// Mobs further up the chain should override this proc if they want to return a simple dexterity value.
/mob/proc/get_dexterity(var/silent)

	// Check if we have a slot to use for this.
	var/check_slot = get_active_held_item_slot()
	if(!check_slot)
		return DEXTERITY_NONE
	var/datum/inventory_slot/gripper/gripper = get_inventory_slot_datum(check_slot)
	if(!istype(gripper))
		if(!silent)
			to_chat(src, "Your [parse_zone(check_slot)] is missing!")
		return DEXTERITY_NONE

	// Work out if we have any brain damage impacting our dexterity.
	var/dex_malus = 0
	var/braindamage = get_damage(BRAIN)
	if(braindamage)
		var/brainloss_threshold = get_config_value(/decl/config/num/dex_malus_brainloss_threshold)
		if(braindamage > brainloss_threshold) ///brainloss shouldn't instantly cripple you, so the effects only start once past the threshold and escalate from there.
			dex_malus = clamp(CEILING((braindamage-brainloss_threshold)/10), 0, length(global.dexterity_levels))
			if(dex_malus > 0)
				dex_malus = global.dexterity_levels[dex_malus]

	// If this slot does not need an organ we just go off the dexterity of the slot itself.
	if(isnull(gripper.requires_organ_tag))
		if(dex_malus)
			if(!silent)
				to_chat(src, SPAN_WARNING("Your [lowertext(gripper.slot_name)] doesn't respond properly!"))
			return (gripper.get_dexterity(silent) & ~dex_malus)
		return gripper.get_dexterity(silent)

	// If this slot requires an organ, do the appropriate organ checks.
	check_slot = gripper.requires_organ_tag
	var/obj/item/organ/external/active_hand = GET_EXTERNAL_ORGAN(src, check_slot)
	if(!active_hand)
		if(!silent)
			to_chat(src, "Your [parse_zone(check_slot)] is missing!")
		return DEXTERITY_NONE
	if(!active_hand.is_usable())
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [active_hand.name] is unusable!"))
		return DEXTERITY_NONE

	// Return our organ dexterity.
	if(dex_malus)
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [active_hand.name] doesn't respond properly!"))
		return (active_hand.get_manual_dexterity() & ~dex_malus)
	return active_hand.get_manual_dexterity()

/mob/proc/check_dexterity(var/dex_level = DEXTERITY_FULL, var/silent = FALSE)
	. = (get_dexterity(silent) & dex_level) == dex_level
	if(!. && !silent)
		to_chat(src, FEEDBACK_YOU_LACK_DEXTERITY)

/mob/proc/lose_hair()
	return

/mob/proc/handle_reading_literacy(var/mob/user, var/text_content, var/skip_delays, var/digital = FALSE)
	if(!skip_delays)
		to_chat(src, SPAN_WARNING("You can't make heads or tails of the words."))
	. = stars(text_content, 5)

/mob/proc/handle_writing_literacy(var/mob/user, var/text_content, var/skip_delays)
	if(!skip_delays)
		to_chat(src, SPAN_WARNING("You scrawl down some meaningless lines."))
	. = stars(text_content, 5)

// mobs do not have mouths by default, unless provided by an organ
/mob/proc/check_has_mouth()
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(!H || !istype(H) || !H.can_intake_reagents)
		return FALSE
	return TRUE

/mob/proc/check_has_eyes()
	return TRUE

/mob/proc/handle_pre_transformation()
	dump_contents()

/mob/get_mass()
	return mob_size

/mob/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	gib()

/mob/get_contained_external_atoms()
	. = ..()
	LAZYREMOVE(., get_organs())

/mob/explosion_act(var/severity)
	. = ..()
	if(!QDELETED(src))
		if(severity == 1)
			physically_destroyed()
		else if(!is_blind())
			flash_eyes()

/mob/proc/can_enter_cryopod(var/mob/user)
	if(stat == DEAD)
		if(user == src)
			to_chat(src, SPAN_WARNING("You cannot use that, as you are dead."))
		else
			to_chat(user, SPAN_WARNING("\The [src] cannot use that, as they are dead."))
		return FALSE
	return TRUE

/mob/proc/get_species()
	RETURN_TYPE(/decl/species)
	return

/mob/proc/get_bodytype()
	RETURN_TYPE(/decl/bodytype)

/mob/proc/has_body_flag(flag, default = FALSE)
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(istype(root_bodytype))
		return root_bodytype.body_flags & flag
	return default

/// Update the mouse pointer of the attached client in this mob.
/mob/proc/update_mouse_pointer()
	if(!client)
		return

	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)

	if(examine_cursor_icon && client.keys_held["Shift"])
		client.mouse_pointer_icon = examine_cursor_icon

/mob/keybind_face_direction(direction)
	facedir(direction)

/mob/proc/check_emissive_equipment()
	var/old_zflags = z_flags
	z_flags &= ~ZMM_MANGLE_PLANES
	for(var/atom/movable/AM in get_equipped_items(TRUE))
		if(AM.z_flags & ZMM_MANGLE_PLANES)
			z_flags |= ZMM_MANGLE_PLANES
			break
	if(old_zflags != z_flags)
		UPDATE_OO_IF_PRESENT

/mob/get_mob()
	return src

/mob/proc/set_glide_size(var/delay)
	glide_size = ADJUSTED_GLIDE_SIZE(delay)

/mob/proc/IsMultiZAdjacent(var/atom/neighbor)

	var/turf/T = get_turf(src)
	var/turf/N = get_turf(neighbor)

	// Not on valid turfs.
	if(QDELETED(src) || QDELETED(neighbor) || !istype(T) || !istype(N))
		return FALSE

	// On the same z-level, we don't need to care about multiz.
	if(N.z == T.z)
		return Adjacent(neighbor)

	// More than one z-level away from each other.
	if(abs(N.x - T.x) > 1 || abs(N.y - T.y) > 1 || abs(N.z - T.z) > 1)
		return FALSE

	// Not in a connected z-volume.
	if(!(N.z in SSmapping.get_connected_levels(T.z)))
		return FALSE

	// Are they below us?
	if(N.z < T.z && HasBelow(T.z))
		var/turf/B = GetBelow(T)
		return T.is_open() && neighbor.Adjacent(B)

	// Are they above us?
	if(HasAbove(T.z))
		var/turf/A = GetAbove(T)
		return A.is_open() && neighbor.Adjacent(A)

	return FALSE

/mob/proc/handle_flashed(var/obj/item/flash/flash, var/flash_strength)
	return FALSE

/mob/proc/do_flash_animation()
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

// Mob procs relating to the typing indicator subsystem.
/mob/Logout()
	if (typing_indicator)
		vis_contents -= typing_indicator
	is_typing = FALSE
	..()

/mob/proc/get_speech_bubble_state_modifier()
	return

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = TRUE
	SStyping.set_indicator_state(client, TRUE)
	var/message = input("","say (text)") as text|null
	SStyping.set_indicator_state(client, FALSE)
	if (message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = TRUE
	SStyping.set_indicator_state(client, TRUE)
	var/message = input("","me (text)") as text|null
	SStyping.set_indicator_state(client, FALSE)
	if (message)
		me_verb(message)

/mob/verb/whisper_wrapper()
	set name = ".Whisper"
	set hidden = TRUE
	if(get_config_value(/decl/config/toggle/show_typing_indicator_for_whispers))
		SStyping.set_indicator_state(client, TRUE)
	var/message = input("","me (text)") as text|null
	if(get_config_value(/decl/config/toggle/show_typing_indicator_for_whispers))
		SStyping.set_indicator_state(client, FALSE)
	if (message)
		whisper(message)

// Darksight procs.
/mob/proc/refresh_lighting_master()
	if(!lighting_master)
		lighting_master = new(null, src)
	if(client)
		client.screen |= lighting_master

/mob/proc/set_internals(obj/item/tank/source, source_string)
	return

/mob/proc/get_internals()
	return

/mob/proc/toggle_internals(var/mob/living/user)
	return

/mob/proc/get_target_zone()
	return zone_sel?.selecting || BP_CHEST

/mob/proc/get_default_temperature_threshold(threshold)
	switch(threshold)
		if(COLD_LEVEL_1)
			return 243
		if(COLD_LEVEL_2)
			return 200
		if(COLD_LEVEL_3)
			return 120
		if(HEAT_LEVEL_1)
			return 360
		if(HEAT_LEVEL_2)
			return 400
		if(HEAT_LEVEL_3)
			return 1000
		else
			CRASH("base get_default_temperature_threshold() called with invalid threshold value.")

/mob/proc/get_mob_temperature_threshold(threshold, bodypart)

	// If we have organs, return the requested organ.
	if(bodypart)
		var/obj/item/organ/external/organ = get_organ(bodypart)
		if(organ?.bodytype)
			return organ.bodytype.get_body_temperature_threshold(threshold)

	// If we have a bodytype, use that.
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(root_bodytype)
		return root_bodytype.get_body_temperature_threshold(threshold)

	return get_default_temperature_threshold(threshold)

/mob/proc/get_unique_enzymes()
	return

/mob/proc/set_unique_enzymes(value)
	return

/mob/proc/get_blood_type()
	return

// Gets the ID card of a mob, but will not check types in the exceptions list
/mob/GetIdCard(exceptions = null)
	RETURN_TYPE(/obj/item/card/id)
	return LAZYACCESS(GetIdCards(exceptions), 1)

/mob/get_overhead_text_x_offset()
	return offset_overhead_text_x

/mob/get_overhead_text_y_offset()
	return offset_overhead_text_y

/mob/can_be_injected_by(var/atom/injector)
	return FALSE // Handled elsewhere in syringe logic.

/mob/proc/getBrainLoss()
	return 0

/mob/proc/get_bodytype_category()
	return get_bodytype()?.bodytype_category

/mob/proc/get_overlay_state_modifier()
	return current_posture?.overlay_modifier

/mob/proc/nervous_system_failure()
	return FALSE

/mob/proc/mob_throw_item(atom/target)
	return

/mob/proc/swap_hand()
	SHOULD_CALL_PARENT(TRUE)

/mob/proc/set_skin_tone(value)
	return

/mob/proc/get_skin_tone(value)
	return

/mob/proc/force_update_limbs()
	return

/mob/proc/update_eyes(update_icons = TRUE)
	var/obj/item/organ/internal/eyes/eyes = get_organ((get_bodytype()?.vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	if(eyes)
		eyes.update_colour()
		if(update_icons)
			queue_icon_update()

/mob/proc/has_genetic_information()
	if(isSynthetic())
		return FALSE
	var/decl/bodytype/bodytype = get_bodytype()
	if(bodytype?.body_flags & BODY_FLAG_NO_DNA)
		return FALSE
	return TRUE

/mob/living/proc/get_butchery_product_name()
	var/decl/butchery_data/butchery_decl = GET_DECL(butchery_data)
	. = butchery_decl?.meat_name || name

/mob/reset_movement_delay()
	var/datum/movement_handler/mob/delay/delay = locate() in movement_handlers
	if(istype(delay))
		delay.next_move = world.time

/mob/proc/do_attack_windup_checking(atom/target)
	return TRUE
