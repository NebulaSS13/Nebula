var/global/list/image/ghost_darkness_images = list() //this is a list of images for things ghosts should still be able to see when they toggle darkness
var/global/list/image/ghost_sightless_images = list() //this is a list of images for things ghosts should still be able to see even without ghost sight

/mob/observer/ghost
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE
	anchored = TRUE	//  don't get pushed around
	universal_speak = TRUE
	mob_sort_value = 9
	is_spawnable_type = FALSE

	mob_flags = MOB_FLAG_HOLY_BAD
	movement_handlers = list(/datum/movement_handler/mob/multiz_connected, /datum/movement_handler/mob/incorporeal)

	var/static/obj/item/card/id/all_access/ghost_all_access

	var/can_reenter_corpse
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghost - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = 0
	var/medHUD = 0
	var/antagHUD = 0
	var/atom/movable/following = null
	var/admin_ghosted = 0
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/seedarkness = 1

	var/obj/item/multitool/ghost_multitool
	var/list/hud_images // A list of hud images

/mob/observer/ghost/Initialize()
	see_in_dark = 100
	verbs += /mob/proc/toggle_antag_pool

	var/turf/T
	var/mob/body = loc
	if(ismob(body))
		T = get_turf(body)               //Where is the body located?
		attack_logs_ = body.attack_logs_ //preserve our attack logs by copying them to our ghost

		set_appearance(body)
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(global.using_map.first_names_male)) + " " + capitalize(pick(global.using_map.last_names))
				else
					name = capitalize(pick(global.using_map.first_names_female)) + " " + capitalize(pick(global.using_map.last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.
	else
		spawn(10) // wait for the observer mob to receive the client's key
			if(!QDELETED(src))
				mind = new /datum/mind(key)
				mind.current = src
	if(!T)
		T = get_random_spawn_turf(SPAWN_FLAG_GHOSTS_CAN_SPAWN)

	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(global.using_map.first_names_male)) + " " + capitalize(pick(global.using_map.last_names))
	real_name = name

	ghost_multitool = new(src)

	global.ghost_mob_list += src

	. = ..()

/mob/observer/ghost/Destroy()
	global.ghost_mob_list -= src
	stop_following()
	qdel(ghost_multitool)
	ghost_multitool = null
	if(hud_images)
		for(var/image/I in hud_images)
			show_hud_icon(I.icon_state, FALSE)
		hud_images = null
	return ..()

/mob/observer/ghost/OnSelfTopic(href_list)
	if (href_list["track"])
		if(ismob(href_list["track"]))
			var/mob/target = locate(href_list["track"]) in SSmobs.mob_list
			if(target)
				ManualFollow(target)
		else
			var/atom/target = locate(href_list["track"])
			if(istype(target))
				ManualFollow(target)
		return TOPIC_HANDLED
	return ..()

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/observer/ghost/Life()

	..()
	if(!loc || !client)
		return FALSE

	handle_hud_glasses()

	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src, 14))
			if(target.mind && target.mind.assigned_special_role)
				target_list += target
		if(target_list.len)
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)

/mob/observer/ghost/proc/process_medHUD(var/mob/M)
	var/client/C = M.client
	for(var/mob/living/human/patient in oview(M, 14))
		C.images += patient.hud_list[HEALTH_HUD]
		C.images += patient.hud_list[STATUS_HUD_OOC]

/mob/observer/ghost/proc/assess_targets(list/target_list, mob/observer/ghost/U)
	var/client/C = U.client
	for(var/mob/living/human/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	for(var/mob/living/silicon/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	return 1

/mob/proc/ghostize(var/_can_reenter_corpse = CORPSE_CAN_REENTER)
	// Are we the body of an aghosted admin? If so, don't make a ghost.
	if(isghost(teleop))
		var/mob/observer/ghost/G = teleop
		if(G.admin_ghosted)
			return
	if(key)
		hide_fullscreens()
		var/mob/observer/ghost/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = _can_reenter_corpse
		ghost.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time
		ghost.key = key
		if(ghost.client && !ghost.client.holder && !get_config_value(/decl/config/toggle/antag_hud_allowed))		// For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs -= /mob/observer/ghost/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
		return ghost

/mob/observer/ghostize() // Do not create ghosts of ghosts.

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		announce_ghost_joinleave(ghostize())
	else
		var/respawn_delay = get_config_value(/decl/config/num/respawn_delay)
		var/response
		if(src.client && src.client.holder)
			response = alert(src, "You have the ability to Admin-Ghost. The regular Ghost verb will announce your presence to dead chat. Both variants will allow you to return to your body using 'aghost'.\n\nWhat do you wish to do?", "Are you sure you want to ghost?", "Ghost", "Admin Ghost", "Stay in body")
			if(response == "Admin Ghost")
				if(!src.client)
					return
				src.client.admin_ghost()
		else if(respawn_delay)
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another [respawn_delay] minute\s! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		else
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to return to this body! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return
		set_posture(/decl/posture/lying)
		log_and_message_admins("has ghosted.")
		var/mob/observer/ghost/ghost = ghostize(CORPSE_CANNOT_REENTER)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		ghost.timeofdeath = world.time // Because the living mob won't have a time of death and we want the respawn timer to work properly.
		announce_ghost_joinleave(ghost)

/mob/observer/ghost/is_active()
	return FALSE

/mob/observer/ghost/Stat()
	. = ..()
	if(statpanel("Status") && SSevac.evacuation_controller)
		var/eta_status = SSevac.evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

/mob/observer/ghost/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"

	if(!client)
		return FALSE

	if(QDELETED(mind?.current))
		to_chat(src, SPAN_WARNING("You have no body."))
		return FALSE

	if(!(can_reenter_corpse & CORPSE_CAN_REENTER))
		to_chat(src, SPAN_WARNING("You are not permitted to reenter your body."))
		return FALSE

	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any adminghosted clients
		to_chat(src, SPAN_WARNING("Another consciousness is in your body... it is resisting you."))
		return FALSE

	stop_following()
	mind.current.key = key
	mind.current.teleop = null
	mind.current.reload_fullscreen()
	if(!admin_ghosted)
		announce_ghost_joinleave(mind, 0, "They now occupy their body again.")
	return TRUE

/mob/observer/ghost/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"
	if(!client)
		return
	if(medHUD)
		medHUD = 0
		to_chat(src, "<span class='notice'>Medical HUD Disabled</span>")
	else
		medHUD = 1
		to_chat(src, "<span class='notice'>Medical HUD Enabled</span>")

/mob/observer/ghost/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(!client)
		return
	if(!get_config_value(/decl/config/toggle/antag_hud_allowed) && !client.holder)
		to_chat(src, SPAN_WARNING("Admins have disabled this for this round"))
		return
	var/mob/observer/ghost/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, SPAN_WARNING("You have been banned from using this feature."))
		return
	if(get_config_value(/decl/config/toggle/antag_hud_restricted) && !M.has_enabled_antagHUD && !client.holder)
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?","Yes","No")
		if(response == "No")
			return
		M.can_reenter_corpse = CORPSE_CANNOT_REENTER
	if(!M.has_enabled_antagHUD && !client.holder)
		M.has_enabled_antagHUD = 1
	if(M.antagHUD)
		M.antagHUD = 0
		to_chat(src, SPAN_NOTICE("AntagHUD Disabled"))
	else
		M.antagHUD = 1
		to_chat(src, SPAN_NOTICE("AntagHUD Enabled"))

/mob/observer/ghost/verb/dead_tele(A in area_repository.get_areas_by_z_level())
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"

	var/area/thearea = area_repository.get_areas_by_z_level()[A]
	if(!thearea)
		to_chat(src, "No area available.")
		return

	var/list/area_turfs = get_area_turfs(thearea, shall_check_if_holy() ? list(/proc/is_not_holy_turf) : list())
	if(!area_turfs.len)
		to_chat(src, "<span class='warning'>This area has been entirely made into sacred grounds, you cannot enter it while you are in this plane of existence!</span>")
		return

	ghost_to_turf(pick(area_turfs))

/mob/observer/ghost/verb/dead_tele_coord(tx as num, ty as num, tz as num)
	set category = "Ghost"
	set name = "Teleport to Coordinate"
	set desc= "Teleport to a coordinate"

	var/turf/T = locate(tx, ty, tz)
	if(T)
		ghost_to_turf(T)
	else
		to_chat(src, "<span class='warning'>Invalid coordinates.</span>")
/mob/observer/ghost/verb/follow(var/datum/follow_holder/fh in get_follow_targets())
	set category = "Ghost"
	set name = "Follow"
	set desc = "Follow and haunt a mob."

	if(!fh.show_entry()) return
	ManualFollow(fh.followed_instance)

/mob/observer/ghost/proc/ghost_to_turf(var/turf/target_turf)
	if(check_is_holy_turf(target_turf))
		to_chat(src, "<span class='warning'>The target location is holy grounds!</span>")
		return
	stop_following()
	forceMove(target_turf)

// This is the ghost's follow verb with an argument
/mob/observer/ghost/proc/ManualFollow(var/atom/movable/target)
	if(!target || target == following || target == src)
		return

	stop_following()
	following = target
	verbs |= /mob/observer/ghost/proc/scan_target
	events_repository.register(/decl/observ/moved, following, src, TYPE_PROC_REF(/atom/movable, move_to_turf))
	events_repository.register(/decl/observ/dir_set, following, src, TYPE_PROC_REF(/atom, recursive_dir_set))
	events_repository.register(/decl/observ/destroyed, following, src, TYPE_PROC_REF(/mob/observer/ghost, stop_following))

	to_chat(src, "<span class='notice'>Now following \the [following].</span>")
	move_to_turf(following, loc, following.loc)

/mob/observer/ghost/proc/stop_following()
	if(following)
		to_chat(src, "<span class='notice'>No longer following \the [following]</span>")
		events_repository.unregister(/decl/observ/moved, following, src)
		events_repository.unregister(/decl/observ/dir_set, following, src)
		events_repository.unregister(/decl/observ/destroyed, following, src)
		following = null
		verbs -= /mob/observer/ghost/proc/scan_target

/mob/observer/ghost/move_to_turf(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(check_is_holy_turf(T))
		to_chat(src, "<span class='warning'>You cannot follow something standing on holy grounds!</span>")
		return
	..()

/mob/observer/ghost/StoreMemory()
	set hidden = 1
	to_chat(src, "<span class='warning'>You are dead! You have no mind to store memory!</span>")

/mob/observer/ghost/AddMemory()
	set hidden = 1
	to_chat(src, "<span class='warning'>You are dead! You have no mind to store memory!</span>")

/mob/observer/ghost/PostIncorporealMovement()
	stop_following()

/mob/observer/ghost/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	var/turf/t = get_turf(src)
	if(t)
		print_atmos_analysis(src, atmosanalyzer_scan(t))

/mob/observer/ghost/verb/check_radiation()
	set name = "Check Radiation"
	set category = "Ghost"

	var/turf/t = get_turf(src)
	if(t)
		var/rads = SSradiation.get_rads_at_turf(t)
		to_chat(src, "<span class='notice'>Radiation level: [rads ? rads : "0"] Roentgen.</span>")

/mob/observer/ghost/proc/scan_target()
	set name = "Scan Target"
	set category = "Ghost"
	set desc = "Analyse whatever you are following."

	if(ishuman(following))
		to_chat(src, medical_scan_results(following, 1, SKILL_MAX))

	else to_chat(src, SPAN_WARNING("\The [following] is not a scannable target."))

/mob/observer/ghost/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(get_config_value(/decl/config/enum/server_whitelist) == CONFIG_SERVER_JOIN_WHITELIST && !check_server_whitelist(src))
		to_chat(src, SPAN_WARNING("Non-whitelisted players cannot join rounds except as observers."))
		return

	if(get_config_value(/decl/config/toggle/disable_player_mice))
		to_chat(src, SPAN_WARNING("Spawning as a mouse is currently disabled."))
		return

	if(!MayRespawn(1, ANIMAL_SPAWN_DELAY))
		return

	var/turf/T = get_turf(src)
	if(!T || isAdminLevel(T.z))
		to_chat(src, SPAN_WARNING("You may not spawn as a mouse on this Z-level."))
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?","Squeek!","Nope!")
	if(response != "Squeek!")
		return

	//find a viable mouse candidate
	var/mob/living/simple_animal/passive/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in SSmachines.machinery)
		if(!v.welded && v.z == T.z)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_animal/passive/mouse(vent_found.loc)
	else
		to_chat(src, SPAN_WARNING("Unable to find any unwelded vents to spawn mice at."))

	if(host)
		if(get_config_value(/decl/config/toggle/uneducated_mice))
			host.universal_understand = FALSE
		announce_ghost_joinleave(src, 0, "They are now a mouse.")
		host.ckey = src.ckey
		host.status_flags |= NO_ANTAG
		to_chat(host, SPAN_INFO("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

/mob/observer/ghost/verb/view_manfiest()
	set name = "Show Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += html_crew_manifest()

	show_browser(src, dat, "window=manifest;size=370x420;can_close=1")

//This is called when a ghost is drag clicked to something.
/mob/observer/ghost/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	SHOULD_CALL_PARENT(FALSE)
	var/atom/over = over_object
	if(!usr || !over)
		return
	if(isghost(usr) && usr.client && isliving(over))
		var/mob/living/M = over
		// If they an admin, see if control can be resolved.
		if(usr.client.holder && usr.client.holder.cmd_ghost_drag(src,M))
			return
		// Otherwise, see if we can possess the target.
		if(usr == src && try_possession(M))
			return
	if(istype(over, /obj/machinery/drone_fabricator) && try_drone_spawn(src, over))
		return
	return ..()

/mob/observer/ghost/proc/try_possession(var/mob/living/M)
	if(!get_config_value(/decl/config/toggle/ghosts_can_possess_animals))
		to_chat(src, SPAN_WARNING("Ghosts are not permitted to possess animals."))
		return FALSE
	if(!M.can_be_possessed_by(src))
		return FALSE
	return M.do_possession(src)

/mob/observer/ghost/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return FALSE
	for(var/mob/M in viewers(7, get_turf(A)))
		if(M.see_invisible >= invisibility)
			to_chat(M, "<span class='deadsay'><b>[src]</b> points to [A]</span>")
	return TRUE

/mob/observer/ghost/proc/show_hud_icon(var/icon_state, var/make_visible)
	if(!hud_images)
		hud_images = list()
	var/image/hud_image = hud_images[icon_state]
	if(!hud_image)
		hud_image = image('icons/mob/mob.dmi', loc = src, icon_state = icon_state)
		hud_images[icon_state] = hud_image

	if(make_visible)
		add_client_image(hud_image)
	else
		remove_client_image(hud_image)

/mob/observer/ghost/verb/toggle_anonsay()
	set category = "Ghost"
	set name = "Toggle Anonymous Chat"
	set desc = "Toggles showing your key in dead chat."

	if(client.get_preference_value(/datum/client_preference/anon_say) == PREF_NO)
		to_chat(src, "<span class='info'>Your key won't be shown when you speak in dead chat.</span>")
		client.set_preference(/datum/client_preference/anon_say, PREF_YES)
	else
		to_chat(src, "<span class='info'>Your key will be publicly visible again.</span>")
		client.set_preference(/datum/client_preference/anon_say, PREF_NO)

/mob/observer/ghost/canface()
	return 1

/mob/proc/can_admin_interact()
	return 0

/mob/observer/ghost/can_admin_interact()
	return check_rights(R_ADMIN, 0, src)

/mob/observer/ghost/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	updateghostsight()
	to_chat(src, "You [(ghostvision?"now":"no longer")] have ghost vision.")

/mob/observer/ghost/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	seedarkness = !(seedarkness)
	updateghostsight()
	to_chat(src, "You [(seedarkness?"now":"no longer")] see darkness.")

/mob/observer/ghost/proc/updateghostsight()
	if (!seedarkness)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else
		set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)
	SSghost_images.queue_image_update(src)

/mob/observer/ghost/proc/updateghostimages()
	if (!client)
		return
	client.images -= ghost_sightless_images
	client.images -= ghost_darkness_images
	if(!seedarkness)
		client.images |= ghost_sightless_images
		if(ghostvision)
			client.images |= ghost_darkness_images
	else if(seedarkness && !ghostvision)
		client.images |= ghost_sightless_images
	client.images -= ghost_image //remove ourself

/mob/observer/ghost/MayRespawn(var/feedback = 0, var/respawn_time = 0)

	if(!client)
		return FALSE

	if(mind?.current && !QDELETED(mind.current) && mind.current.stat != DEAD && (can_reenter_corpse & CORPSE_CAN_REENTER) && !(can_reenter_corpse & CORPSE_CAN_RESPAWN))
		if(feedback)
			to_chat(src, SPAN_WARNING("Your non-dead body prevents you from respawning."))
		return FALSE

	if(get_config_value(/decl/config/toggle/antag_hud_restricted) && has_enabled_antagHUD == 1)
		if(feedback)
			to_chat(src, SPAN_WARNING("antagHUD restrictions prevent you from respawning."))
		return FALSE

	var/timedifference = world.time - timeofdeath
	if(!client.holder && respawn_time && timeofdeath && timedifference < respawn_time MINUTES)
		var/timedifference_text = time2text(respawn_time MINUTES - timedifference,"mm:ss")
		to_chat(src, SPAN_WARNING("You must have been dead for [respawn_time] minute\s to respawn. You have [timedifference_text] left."))
		return FALSE

	return TRUE

/proc/isghostmind(var/datum/mind/player)
	return player && !isnewplayer(player.current) && (!player.current || isghost(player.current) || (isliving(player.current) && player.current.stat == DEAD) || !player.current.client)

/mob/proc/check_is_holy_turf(var/turf/T)
	return 0

/mob/observer/ghost/check_is_holy_turf(var/turf/T)
	if(shall_check_if_holy() && is_holy_turf(T))
		return TRUE

/mob/observer/ghost/proc/shall_check_if_holy()
	if(invisibility >= INVISIBILITY_OBSERVER)
		return FALSE
	if(check_rights(R_ADMIN|R_FUN, 0, src))
		return FALSE
	return TRUE

/mob/observer/ghost/proc/set_appearance(var/mob/target)
	var/pre_alpha = alpha
	var/pre_plane = plane
	var/pre_layer = layer
	var/pre_invis = invisibility

	appearance = target
	appearance_flags |= initial(appearance_flags)

	// Keep mob offsets when you move over tables and such!
	default_pixel_x = target.default_pixel_x
	default_pixel_w = target.default_pixel_w
	default_pixel_y = target.default_pixel_y
	default_pixel_z = target.default_pixel_z

	// Apply ghostly alpha and layering.
	alpha = pre_alpha
	plane = pre_plane
	layer = pre_layer

	set_invisibility(pre_invis)
	transform = null	//make goast stand up

/mob/observer/ghost/verb/respawn()
	set name = "Respawn"
	set category = "OOC"

	if (!get_config_value(/decl/config/toggle/on/abandon_allowed))
		to_chat(usr, SPAN_WARNING("Respawn is disabled."))
		return
	if (!SSticker.mode)
		to_chat(usr, SPAN_WARNING("<b>You may not attempt to respawn yet.</b>"))
		return
	if (SSticker.mode.deny_respawn)
		to_chat(usr, SPAN_WARNING("Respawn is disabled for this roundtype."))
		return
	else if(!MayRespawn(1, get_config_value(/decl/config/num/respawn_delay)))
		return

	to_chat(usr, SPAN_NOTICE("You can respawn now, enjoy your new life!"))
	to_chat(usr, SPAN_NOTICE("<b>Make sure to play a different character, and please roleplay correctly!</b>"))
	announce_ghost_joinleave(client, 0)

	var/mob/new_player/M = new /mob/new_player()
	M.key = key
	log_and_message_admins("has respawned.", M)

/mob/observer/ghost/GetIdCards(list/exceptions)
	. = ..()
	if(is_admin(src))
		if (!ghost_all_access)
			ghost_all_access = new
		if(!is_type_in_list(ghost_all_access, exceptions))
			LAZYDISTINCTADD(., ghost_all_access)
