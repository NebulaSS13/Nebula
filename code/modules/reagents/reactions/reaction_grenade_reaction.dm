/datum/chemical_reaction/grenade_reaction
	var/lore_text
	var/mechanics_text
	result = null

/datum/chemical_reaction/grenade_reaction/explosion_potassium
	name = "Explosion"
	lore_text = "Water and potassium are infamously and violently reactive, causing a large explosion on contact."
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/grenade_reaction/flash_powder
	name = "Flash powder"
	lore_text = "This reaction causes a brief, blinding flash of light."
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
	result_amount = null
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			switch(get_dist(M, location))
				if(0 to 3)
					M.flash_eyes()
					M.Weaken(15)
				if(4 to 5)
					M.flash_eyes()
					M.Stun(5)

/datum/chemical_reaction/grenade_reaction/emp_pulse
	name = "EMP Pulse"
	lore_text = "This reaction causes an electromagnetic pulse that knocks out machinery in a sizable radius."
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/datum/chemical_reaction/grenade_reaction/phlogiston
	name = "Flash Fire"
	lore_text = "This mixture causes an immediate flash fire."
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/acid = 1 )
	result_amount = 1
	mix_message = "The solution thickens and begins to bubble."

/datum/chemical_reaction/grenade_reaction/phlogiston/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(/datum/reagent/toxin/phoron, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)

/datum/chemical_reaction/grenade_reaction/chemsmoke
	name = "Chemical Smoke"
	lore_text = "This mixture causes a large cloud of smoke, which will be laden with the other chemicals present in the mixture when it reacted."
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/phosphorus = 1)
	result_amount = 0.4
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	holder.clear_reagents()

/datum/chemical_reaction/grenade_reaction/foam
	name = "Foam"
	lore_text = "This mixture explodes in a burst of foam. Good for cleaning!"
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/water = 1)
	result_amount = 2
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")
	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/grenade_reaction/metalfoam
	name = "Metal Foam"
	lore_text = "This mixture explodes in a burst of metallic foam. Good for hull repair!"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")
	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()

/datum/chemical_reaction/grenade_reaction/ironfoam
	name = "Iron Foam"
	lore_text = "This mixture explodes in a burst of iron foam. Good for hull repair!"
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/grenade_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")
	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()
