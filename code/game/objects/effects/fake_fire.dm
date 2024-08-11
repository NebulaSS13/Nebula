/obj/effect/fake_fire
	blend_mode = BLEND_ADD
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = FIRE_LAYER
	var/lifetime = 10 SECONDS //0 for infinite
	//See Fire.dm (the real one), but in a nutshell:
	var/firelevel = 1 //Larger the number, worse burns.
	var/last_temperature = T100C //People with heat protection above this temp will be immune.
	var/pressure = ONE_ATMOSPHERE //Larger the number, worse burns.

/obj/effect/fake_fire/Initialize()
	. = ..()
	if(!loc)
		return INITIALIZE_HINT_QDEL
	var/new_light_range
	var/new_light_power
	if(firelevel > 6)
		icon_state = "3"
		new_light_range = 7
		new_light_power = 3
	else if(firelevel > 2.5)
		icon_state = "2"
		new_light_range = 5
		new_light_power = 2
	else
		icon_state = "1"
		new_light_range = 3
		new_light_power = 1
	color = fire_color()
	set_light(new_light_range, new_light_power, color)
	START_PROCESSING(SSobj,src)
	if(lifetime)
		QDEL_IN(src,lifetime)

/obj/effect/fake_fire/proc/can_affect_atom(atom/target)
	if(target == src)
		return FALSE
	return target.simulated

/obj/effect/fake_fire/proc/can_affect_mob(mob/living/victim)
	return can_affect_atom(victim)

/obj/effect/fake_fire/Process()
	if(!loc)
		qdel(src)
		return PROCESS_KILL
	for(var/mob/living/victim in loc)
		if(!can_affect_mob(victim))
			continue
		victim.FireBurn(firelevel, last_temperature, pressure)
	loc.fire_act(firelevel, last_temperature, pressure)
	for(var/atom/burned in loc)
		if(!can_affect_atom(burned))
			continue
		burned.fire_act(firelevel, last_temperature, pressure)

/obj/effect/fake_fire/proc/fire_color()
	var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), last_temperature)
	return heat2color(temperature)

/obj/effect/fake_fire/Destroy()
	STOP_PROCESSING(SSobj,src)
	return ..()

// A subtype of fake_fire used for spells that shouldn't affect the caster.
/obj/effect/fake_fire/variable/owned
	var/mob/living/owner

/obj/effect/fake_fire/variable/owned/can_affect_atom(atom/target)
	if(target == owner)
		return FALSE
	return ..()

/obj/effect/fake_fire/variable/owned/Destroy()
	owner = null
	return ..()