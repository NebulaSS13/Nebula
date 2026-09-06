/decl/game_mode
	/// If TRUE, ERT cannot be called during this mode.
	var/ert_disabled = FALSE

/decl/game_mode/toggle_value(key)
	if((. = ..()))
		return
	switch(key)
		if("ert")
			ert_disabled = !ert_disabled
			announce_ert_disabled()
			return TRUE

/decl/game_mode/post_setup()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(announce_ert_disabled)), rand_waittime + rand(10 SECONDS, 15 SECONDS))

/// Gets a list of default reasons for the ERT to be disabled.
/decl/game_mode/proc/possible_ert_disabled_reasons()
	// This uses a static var so that modpacks can add default reasons, e.g. "supermatter dust".
	var/static/list/reasons = list(
		"political instability",
		"quantum fluctuations",
		"hostile raiders",
		"derelict station debris",
		"REDACTED",
		"ancient alien artillery",
		"solar magnetic storms",
		"sentient time-travelling killbots",
		"gravitational anomalies",
		"wormholes to another dimension",
		"a telescience mishap",
		"radiation flares",
		"leaks into a negative reality",
		"antiparticle clouds",
		"residual exotic energy",
		"suspected criminal operatives",
		"malfunctioning von Neumann probe swarms",
		"shadowy interlopers",
		"a stranded xenoform",
		"haywire machine constructs",
		"rogue exiles",
		"artifacts of eldritch horror",
		"a brain slug infestation",
		"killer bugs that lay eggs in the husks of the living",
		"a deserted transport carrying xenofauna specimens",
		"an emissary requesting a security detail",
		"radical transevolutionaries",
		"classified security operations",
		"a gargantuan glowing goat"
		)
	return reasons

/decl/game_mode/proc/announce_ert_disabled()
	if(!ert_disabled)
		return
	command_announcement.Announce("The presence of [pick(possible_ert_disabled_reasons())] in the region is tying up all available local emergency resources; emergency response teams cannot be called at this time, and post-evacuation recovery efforts will be substantially delayed.","Emergency Transmission")

// add this as an option
/datum/controller/subsystem/ticker/get_game_mode_options()
	var/list/options = ..()
	// insert it at the start because it's important i guess
	options.Insert(1, "<b>Emergency Response Teams:</b> <a href='byond://?src=\ref[mode];toggle=ert'>[mode.ert_disabled ? "disabled" : "enabled"]</a>")
	return options