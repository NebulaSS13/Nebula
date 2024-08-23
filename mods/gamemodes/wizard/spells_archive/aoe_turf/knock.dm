/decl/ability/wizard/knock
	name = "Knock"
	desc = "This spell opens nearby doors and does not require wizard garb."
	feedback = "KN"
	school = "transmutation"
	charge_max = 100
	requires_wizard_garb = FALSE
	invocation = "Aulie Oxin Fiera."
	invocation_type = SpI_WHISPER
	range = 3
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 1)
	cooldown_min = 20 //20 deciseconds reduction per rank

	ability_icon_state = "wiz_knock"
	cast_sound = 'sound/magic/knock.ogg'

/decl/ability/wizard/knock/cast(list/targets)
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn(1)
				if(istype(door,/obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = door //casting is important
					AL.locked = 0
				door.open()
	return


/decl/ability/wizard/knock/empower_spell()
	if(!..())
		return 0
	range *= 2

	return "You've doubled the range of [src]."

/decl/ability/wizard/knock/slow
	charge_max = 200
	hidden_from_codex = TRUE
