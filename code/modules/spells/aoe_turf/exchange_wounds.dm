/spell/aoe_turf/exchange_wounds
	name = "Exchange Wounds"
	desc = "Allows you to sacrifice your own well-being for that of those around you."
	feedback = "EW"
	school = "transmutation"
	invocation = "Esh Yek Vai!"
	invocation_type = SpI_SHOUT
	charge_max = 400
	spell_flags = 0

	var/amt_healed = 0
	var/heal_max = 100
	range = 4
	inner_radius = 0
	number_of_channels = 0
	time_between_channels = 20

	hud_state = "wiz_exchange"

/spell/aoe_turf/exchange_wounds/perform()
	amt_healed = 0
	..()

/spell/aoe_turf/exchange_wounds/cast(var/list/targets, var/mob/living/user)
	new /obj/effect/temporary(get_turf(user),10,'icons/effects/effects.dmi',"purple_electricity_constant")
	for(var/t in targets)
		for(var/mob/living/L in t)
			if(L.faction != user.faction)
				continue
			new /obj/effect/temporary(get_turf(L),10,'icons/effects/effects.dmi',"green_sparkles")
			if(L.get_damage(BRUTE) > 5)
				L.heal_damage(BRUTE, 5)
				user.take_damage(2)
				amt_healed += 5
			if(L.get_damage(BURN) > 5)
				L.heal_damage(BURN, 5)
				user.take_damage(2, BURN)
				amt_healed += 5

/spell/aoe_turf/exchange_wounds/check_valid_targets()
	if(amt_healed > heal_max)
		return FALSE
	return ..()