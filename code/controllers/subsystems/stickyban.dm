SUBSYSTEM_DEF(stickyban)
	name = "Sticky Ban"
	init_order = SS_INIT_STICKY_BAN
	flags = SS_NO_FIRE

	var/list/cache = list()

/datum/controller/subsystem/stickyban/Initialize(timeofday)
	..(timeofday)

	var/list/banned_keys = world.GetConfig("ban")

	//sanitize the sticky ban list
	for (var/banned_key in banned_keys)
		var/ckey = ckey(banned_key)
		var/list/ban = stickyban2list(world.GetConfig("ban", banned_key))

		// byond stores sticky bans by key, that can end up confusing things
		// i also remove it here so that if any stickybans cause a runtime, they just stop existing
		world.SetConfig("ban", banned_key, null)

		if (!ban["ckey"])
			ban["ckey"] = ckey

		// storing these can break things and isn't needed for sticky ban tracking
		ban -= "IP"
		ban -= "computer_id"

		ban["matches_this_round"] = list()
		ban["existing_user_matches_this_round"] = list()
		cache[ckey] = ban

	for (var/banned_key in cache)
		world.SetConfig("ban", banned_key, list2stickyban(cache[banned_key]))
