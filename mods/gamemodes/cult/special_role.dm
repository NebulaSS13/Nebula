/proc/iscultist(var/mob/player)
	var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
	if(player.mind && (player.mind in cult.current_antagonists))
		return TRUE
	return FALSE

/decl/special_role/cultist
	name = "Cultist"
	name_plural = "Cultists"
	blacklisted_jobs = list(/datum/job/submap)
	antag_indicator = "hudcultist"
	welcome_text = "You have a tome in your possession; one that will help you start the cult. Use it well and remember - there are others."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 6
	initial_spawn_req = 4
	initial_spawn_target = 6
	antaghud_indicator = "hudcultist"
	skill_setter = /datum/antag_skill_setter/station
	faction = "cult"
	blocked_job_event_categories = list(ASSIGNMENT_ROBOT, ASSIGNMENT_COMPUTER)

	var/allow_narsie = 1
	var/powerless = 0
	var/datum/mind/sacrifice_target
	var/list/obj/effect/rune/teleport/teleport_runes = list()
	var/list/rune_strokes = list()
	var/list/sacrificed = list()
	var/cult_rating = 0
	var/list/cult_rating_bounds = list(CULT_RUNES_1, CULT_RUNES_2, CULT_RUNES_3, CULT_GHOSTS_1, CULT_GHOSTS_2, CULT_GHOSTS_3)
	var/max_cult_rating = 0
	var/conversion_blurb = "You catch a glimpse of the Realm of Nar-Sie, the Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of That Which Waits. Assist your new compatriots in their dark dealings. Their goals are yours, and yours are theirs. You serve the Dark One above all else. Bring It back."
	var/list/paper_spawn_slots = list (
		"backpack" =     slot_in_backpack_str,
		"left pocket" =  slot_l_store_str,
		"right pocket" = slot_r_store_str,
		"left hand" =    BP_L_HAND,
		"right hand" =   BP_R_HAND,
	)

/decl/special_role/cultist/create_global_objectives()

	if(!..())
		return

	global_objectives = list()
	if(prob(50))
		global_objectives |= new /datum/objective/cult/survive
	else
		global_objectives |= new /datum/objective/cult/eldergod

	var/datum/objective/cult/sacrifice/sacrifice = new()
	sacrifice.find_target()
	sacrifice_target = sacrifice.target
	global_objectives |= sacrifice

/decl/special_role/cultist/equip_role(var/mob/living/human/player)
	. = ..()
	if(.)
		var/obj/item/book/tome/T = new(get_turf(player))
		for(var/slot in paper_spawn_slots)
			player.equip_to_slot(T, slot)
			if(T.loc == player)
				return
		for(var/atom/thing in player.get_mob_contents())
			if(thing.storage)
				T.forceMove(thing)
				break

/decl/special_role/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	to_chat(player.current, "<span class='danger'>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</span>")
	player.ClearMemories(type)
	if(show_message)
		player.current.visible_message("<span class='notice'>[player.current] looks like they just reverted to their old faith!</span>")
	remove_cult_magic(player.current)
	remove_cultiness(CULTINESS_PER_CULTIST)

/decl/special_role/cultist/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
	. = ..()
	if(.)
		to_chat(player, "<span class='cult'>[conversion_blurb]</span>")
		if(player.current && !isconstruct(player.current))
			player.current.add_language(/decl/language/cultcommon)

/decl/special_role/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	. = ..()
	if(. && player.current && !isconstruct(player.current))
		player.current.remove_language(/decl/language/cultcommon)

/decl/special_role/cultist/update_antag_mob(var/datum/mind/player)
	. = ..()
	add_cultiness(CULTINESS_PER_CULTIST)
	add_cult_magic(player.current)

/decl/special_role/cultist/proc/add_cultiness(var/amount)
	cult_rating += amount
	var/old_rating = max_cult_rating
	max_cult_rating = max(max_cult_rating, cult_rating)
	if(old_rating >= CULT_MAX_CULTINESS)
		return
	var/list/to_update = list()
	for(var/i in cult_rating_bounds)
		if((old_rating < i) && (max_cult_rating >= i))
			to_update += i

	if(to_update.len)
		update_cult_magic(to_update)

/decl/special_role/cultist/proc/update_cult_magic(var/list/to_update)
	var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
	if(CULT_RUNES_1 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>The veil between this world and beyond grows thin, and your power grows.</span>")
				add_cult_magic(H.current)
	if(CULT_RUNES_2 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>You feel that the fabric of reality is tearing.</span>")
				add_cult_magic(H.current)
	if(CULT_RUNES_3 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>The world is at end. The veil is as thin as ever.</span>")
				add_cult_magic(H.current)

	if((CULT_GHOSTS_1 in to_update) || (CULT_GHOSTS_2 in to_update) || (CULT_GHOSTS_3 in to_update))
		for(var/mob/observer/ghost/D in SSmobs.mob_list)
			add_ghost_magic(D)

/decl/special_role/cultist/proc/offer_uncult(var/mob/M)
	if(!iscultist(M) || !M.mind)
		return

	to_chat(M, "<span class='cult'>Do you want to abandon the cult of Nar'Sie? <a href='byond://?src=\ref[src];confirmleave=1'>ACCEPT</a></span>")

/decl/special_role/cultist/Topic(href, href_list)
	if(href_list["confirmleave"])
		var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
		cult.remove_antagonist(usr.mind, 1)

/decl/special_role/cultist/proc/remove_cultiness(var/amount)
	cult_rating = max(0, cult_rating - amount)

/decl/special_role/cultist/proc/add_cult_magic(var/mob/M)
	M.verbs += Tier1Runes

	if(max_cult_rating >= CULT_RUNES_1)
		M.verbs += Tier2Runes

		if(max_cult_rating >= CULT_RUNES_2)
			M.verbs += Tier3Runes

			if(max_cult_rating >= CULT_RUNES_3)
				M.verbs += Tier4Runes

/decl/special_role/cultist/proc/remove_cult_magic(var/mob/M)
	M.verbs -= Tier1Runes
	M.verbs -= Tier2Runes
	M.verbs -= Tier3Runes
	M.verbs -= Tier4Runes
