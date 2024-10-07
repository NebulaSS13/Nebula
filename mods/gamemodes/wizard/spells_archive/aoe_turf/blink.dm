/decl/ability/wizard/blink
	name = "Blink"
	desc = "This spell randomly teleports you a short distance."
	feedback = "BL"
	school = "conjuration"
	charge_max = 20
	ignore_space_turfs = TRUE
	invocation = "none"
	invocation_type = SpI_NONE
	range = 7
	effect_inner_radius = 1

	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 4)
	cooldown_min = 5 //4 deciseconds reduction per rank
	ability_icon_state = "wiz_blink"
	cast_sound = 'sound/magic/blink.ogg'

/decl/ability/wizard/blink/cast(var/list/targets, mob/user)
	if(!targets.len)
		return

	var/turf/T = pick(targets)
	var/turf/starting = get_turf(user)
	if(T)
		if(user.buckled)
			user.buckled = null
		user.forceMove(T)

		var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
		smoke.set_up(3, 0, starting)
		smoke.start()

		smoke = new()
		smoke.set_up(3, 0, T)
		smoke.start()

	return

/decl/ability/wizard/blink/empower_spell()
	if(!..())
		return 0
	effect_inner_radius += 1

	return "You've increased the inner range of [src]."