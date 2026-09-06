// A replacement for having the supermatter tick on SSmachinery, since it's no longer a machine.
PROCESSING_SUBSYSTEM_DEF(supermatter)
	name = "Supermatter"
	priority = SS_PRIORITY_MACHINERY
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS