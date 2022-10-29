/decl/special_role/proc/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement, var/preserve_appearance)

	if(!target)
		return

	update_antag_mob(target, preserve_appearance)
	if(!target.current)
		remove_antagonist(target)
		return 0
	if(flags & ANTAG_CHOOSE_NAME)
		INVOKE_ASYNC(src, .proc/set_antag_name, target.current)
	if(move)
		place_mob(target.current)
	update_leader()
	create_objectives(target)
	update_icons_added(target)
	greet(target)
	if(!gag_announcement)
		announce_antagonist_spawn()

/decl/special_role/proc/create_default(var/mob/source)
	var/mob/living/M
	if(mob_path)
		M = new mob_path(get_turf(source))
	else
		M = new /mob/living/carbon/human(get_turf(source))
	M.ckey = source.ckey
	add_antagonist(M.mind, 1, 0, 1) // Equip them and move them to spawn.
	return M

/decl/special_role/proc/create_nuke(var/atom/paper_spawn_loc, var/datum/mind/code_owner)

	// Decide on a code.
	var/obj/abstract/landmark/nuke_spawn = locate(nuke_spawn_loc ? nuke_spawn_loc : "landmark*Nuclear-Bomb")

	var/code
	if(nuke_spawn)
		var/obj/machinery/nuclearbomb/nuke = new(get_turf(nuke_spawn))
		code = "[rand(10000, 99999)]"
		nuke.r_code = code

	if(code)
		if(!paper_spawn_loc)
			if(leader && leader.current)
				paper_spawn_loc = get_turf(leader.current)
			else
				paper_spawn_loc = get_turf(locate("landmark*Nuclear-Code"))

		if(paper_spawn_loc)
			// Create and pass on the bomb code paper.
			var/obj/item/paper/P = new(paper_spawn_loc)
			P.info = "The nuclear authorization code is: <b>[code]</b>"
			P.SetName("nuclear bomb code")
			if(leader && leader.current)
				if(get_turf(P) == get_turf(leader.current) && leader.current.get_empty_hand_slot())
					leader.current.put_in_hands(P)

		if(!code_owner && leader)
			code_owner = leader
		if(code_owner)
			code_owner.StoreMemory("<B>Nuclear Bomb Code</B>: [code]", /decl/memory_options/system)
			to_chat(code_owner.current, "The nuclear authorization code is: <B>[code]</B>.")
	else
		message_admins("<span class='danger'>Could not spawn nuclear bomb. Contact a developer.</span>")
		return

	spawned_nuke = code
	return code

/decl/special_role/proc/greet(var/datum/mind/player)

	// Basic intro text.
	to_chat(player.current, "<span class='danger'><font size=3>You are a [name]!</font></span>")
	if(leader_welcome_text && player == leader)
		to_chat(player.current, "<span class='antagdesc'>[get_leader_welcome_text(player.current)]</span>")
	else
		to_chat(player.current, "<span class='antagdesc'>[get_welcome_text(player.current)]</span>")
	if (config.objectives_disabled == CONFIG_OBJECTIVE_NONE || !player.objectives.len)
		to_chat(player.current, get_antag_text(player.current))

	if((flags & ANTAG_HAS_NUKE) && !spawned_nuke)
		create_nuke()

	src.show_objectives_at_creation(player)
	return 1

/decl/special_role/proc/set_antag_name(var/mob/living/player)
	// Choose a name, if any.
	var/newname = sanitize(input(player, "You are a [name]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		player.real_name = newname
		player.SetName(player.real_name)
		if(player.dna)
			player.dna.real_name = newname
	if(player.mind) player.mind.name = player.name
	// Update any ID cards.
	update_access(player)
