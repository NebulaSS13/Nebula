/decl/config/num/movement_slime
	uid = "slime_delay"
	desc = "Movement delay for slimes."

#define FEED_RESULT_INVALID -1
#define FEED_RESULT_DEAD     0
#define FEED_RESULT_VALID    1

/mob/living/slime
	name = "baby slime"
	icon = 'mods/content/xenobiology/icons/slimes/slime_baby.dmi'
	icon_state = ICON_STATE_WORLD
	pass_flags = PASS_FLAG_TABLE
	speak_emote = list("chirps")
	max_health = 150
	gender = NEUTER
	see_in_dark = 8
	status_flags = CANPARALYSE|CANPUSH
	butchery_data = null
	ai = /datum/mob_controller/slime
	hud_used = /datum/hud/slime
	nutrition = 800

	var/is_adult = FALSE
	var/mutation_chance = 30 // Chance of mutating, should be between 25 and 35
	var/powerlevel = 0 // 0-10 controls how much electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces
	var/weakref/feeding_on
	var/toxloss = 0
	var/hurt_temperature = T0C-50 // slime keeps taking damage when its bodytemperature is below this
	var/die_temperature = 50 // slime dies instantly when its bodytemperature is below this
	var/number
	var/slime_type = /decl/slime_colour/grey
	var/cores = 1 // the number of /obj/item/slime_extract's the slime has left inside
	var/core_removal_stage = 0 //For removing cores.
	var/datum/reagents/metabolism/ingested

/mob/living/slime/Destroy()
	set_feeding_on()
	for(var/atom/movable/AM in contents)
		AM.dropInto(loc)
	. = ..()

/mob/living/slime/get_available_postures()
	var/static/list/available_postures = list(
		/decl/posture/standing
	)
	return available_postures

/mob/living/slime/getToxLoss()
	return toxloss

/mob/living/slime/get_digestion_product()
	return /decl/material/liquid/slimejelly

/mob/living/slime/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	toxloss = clamp(toxloss + amount, 0, get_max_health())
	if(do_update_health)
		update_health()

/mob/living/slime/setToxLoss(var/amount)
	take_damage(amount-get_damage(TOX), TOX)

/mob/living/slime/Initialize(mapload, var/_stype = /decl/slime_colour/grey)

	. = ..(mapload)

	ingested = new /datum/reagents/metabolism(240, src, CHEM_TOUCH)
	reagents = ingested
	render_target = "slime_\ref[src]"

	verbs += /mob/living/proc/ventcrawl
	slime_type = _stype

	if(!ispath(slime_type, /decl/slime_colour))
		PRINT_STACK_TRACE("Slime initialized with non-decl slime type: [slime_type || "NULL"]")
		return INITIALIZE_HINT_QDEL

	number = random_id(/mob/living/slime, 1, 1000)
	mutation_chance = rand(25, 35)
	update_name()
	update_icon()

/mob/living/slime/proc/update_name()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	SetName("[slime_data.name] [is_adult ? "adult" : "baby"] slime ([number])")

/mob/living/slime/get_movement_delay(var/travel_dir)
	if (bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	var/tally = ..()

	var/health_deficiency = (get_max_health() - current_health)
	if(health_deficiency >= 30) tally += (health_deficiency / 25)

	if (bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent(/decl/material/liquid/amphetamines)) // Stimulants slows slimes down
			tally *= 2

		if(reagents.has_reagent(/decl/material/liquid/frostoil)) // Frostoil also makes them move VEEERRYYYYY slow
			tally *= 5

	if(current_health <= 0) // if damaged, the slime moves twice as slow
		tally *= 2

	return tally + get_config_value(/decl/config/num/movement_slime)

/mob/living/slime/Bump(atom/movable/AM, yes)
	if ((!(yes) || now_pushing))
		return
	now_pushing = 1

	if(isobj(AM) && !client && powerlevel > 0)
		var/probab = 10
		switch(powerlevel)
			if(1 to 2)	probab = 20
			if(3 to 4)	probab = 30
			if(5 to 6)	probab = 40
			if(7 to 8)	probab = 60
			if(9)		probab = 70
			if(10)		probab = 95
		if(prob(probab))
			if(istype(AM, /obj/structure/window) || istype(AM, /obj/structure/grille))
				if(nutrition <= get_hunger_nutrition())
					if (is_adult || prob(5))
						UnarmedAttack(AM)

	if(ismob(AM))
		var/mob/tmob = AM

		if(is_adult)
			if(ishuman(tmob))
				if(prob(90))
					now_pushing = 0
					return
		else
			if(ishuman(tmob))
				now_pushing = 0
				return

	now_pushing = 0

	..()

/mob/living/slime/Stat()
	. = ..()

	statpanel("Status")
	stat(null, "Health: [get_health_percent()]%")
	stat(null, "Intent: [a_intent]")

	if (client.statpanel == "Status")
		stat(null, "Nutrition: [nutrition]/[get_max_nutrition()]")
		if(amount_grown >= 10)
			if(is_adult)
				stat(null, "You can reproduce!")
			else
				stat(null, "You can evolve!")

		stat(null,"Power Level: [powerlevel]")

/mob/living/slime/adjustFireLoss(amount, do_update_health = TRUE)
	..(-abs(amount), do_update_health) // Heals them

/mob/living/slime/bullet_act(var/obj/item/projectile/Proj)
	var/datum/mob_controller/slime/slime_ai = ai
	if(istype(slime_ai))
		slime_ai.attacked += 10
		slime_ai.adjust_friendship(Proj.firer, -5)
	..(Proj)
	return 0

/mob/living/slime/emp_act(severity)
	powerlevel = 0 // oh no, the power!
	..()

/mob/living/slime/explosion_act(severity)
	..()
	if(severity == 1)
		qdel(src)

/mob/living/slime/attack_ui(slot)
	return

/decl/status_condition/confused/handle_changed_amount(mob/living/victim, new_amount, last_amount)
	. = ..()
	if(new_amount != last_amount && isslime(victim))
		var/mob/living/slime/slime = victim
		if(istype(slime.ai, /datum/mob_controller/slime))
			var/datum/mob_controller/slime/slime_ai = slime.ai
			slime_ai.update_mood()

/mob/living/slime/proc/adjust_friendship(var/mob/user, var/amount)
	if(user && amount != 0)
		var/datum/mob_controller/slime/slime_ai = ai
		if(istype(slime_ai))
			return slime_ai.adjust_friendship(user, amount)

/mob/living/slime/attack_hand(mob/user)

	if(stat == DEAD)
		visible_message(SPAN_NOTICE("\The [user] pokes \the [src]."))
		return TRUE

	if(user.a_intent == I_HELP)
		if(length(contents))
			var/atom/movable/AM = pick(contents)
			AM.dropInto(loc)
			visible_message(SPAN_NOTICE("\The [user] extracts \the [AM] from \the [src]."))
			update_icon()
		else
			visible_message(SPAN_NOTICE("\The [user] pets \the [src]."))
			adjust_friendship(user, rand(2,3))
		return TRUE

	var/prey = feeding_on?.resolve()
	if(prey)
		if(prey == user)
			if(prob(60))
				visible_message(SPAN_DANGER("\The [user] fails to escape \the [src]!"))
			else
				visible_message(SPAN_DANGER("\The [user] manages to escape \the [src]!"))
				set_feeding_on()
		else
			if(prob(30))
				visible_message(SPAN_DANGER("\The [user] attempts to wrestle \the [src] off \the [prey]!"))
			else
				visible_message(SPAN_DANGER("\The [user] manages to wrestle \the [src] off \the [prey]!"))
				set_feeding_on()

		if(prey != feeding_on?.resolve())
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			SET_STATUS_MAX(src, STAT_CONFUSE, 2)
			step_away(src, user)
		else
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return TRUE

	switch(user.a_intent)
		if(I_HELP)
			visible_message(SPAN_NOTICE("\The [user] hugs \the [src] to make it feel better!"))
			return TRUE
		if(I_DISARM)
			if(prob(40))
				visible_message(SPAN_DANGER("\The [user] shoves \the [src] and it wobbles around, disoriented!"))
				SET_STATUS_MAX(src, STAT_CONFUSE, 2)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			else
				visible_message(SPAN_DANGER("\The [user] shoves \the [src]!"))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			return TRUE
		if(I_HURT)
			var/damage = rand(1, 9)
			var/datum/mob_controller/slime/slime_ai = ai
			if(istype(slime_ai))
				slime_ai.attacked += 10
				slime_ai.adjust_friendship(user, -5)
			if(prob(10))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("\The [user] has attempted to punch \the [src]!"))
				return TRUE
			playsound(loc, "punch", 25, 1, -1)
			visible_message(SPAN_DANGER("\The [user] has punched \the [src]!"))
			take_damage(damage)
			return TRUE

	return ..()

/mob/living/slime/attackby(var/obj/item/W, var/mob/user)
	var/force = W.get_attack_force(user)
	if(force > 0)
		var/datum/mob_controller/slime/slime_ai = ai
		if(istype(slime_ai))
			slime_ai.attacked += 10
			slime_ai.adjust_friendship(user, -5)
		if(stat == CONSCIOUS && prob(25)) //Only run this check if we're alive or otherwise motile, otherwise surgery will be agonizing for xenobiologists.
			to_chat(user, SPAN_WARNING("\The [W] passes right through \the [src]!"))
			return TRUE
	. = ..()
	if(feeding_on && prob(force * 5))
		set_feeding_on()
		step_away(src, user)

/mob/living/slime/restrained()
	return 0

/mob/living/slime/toggle_throw_mode()
	return

/mob/living/slime/check_has_eyes()
	return FALSE

/mob/living/slime/check_has_mouth()
	return FALSE

/mob/living/slime/set_nutrition(amt)
	..()

/mob/living/slime/get_hydration()
	return get_nutrition()

/mob/living/slime/proc/gain_nutrition(var/amount)
	adjust_nutrition(amount)
	if(prob(amount * 2)) // Gain around one level per 50 nutrition
		powerlevel++
		if(powerlevel > 10)
			powerlevel = 10
			heal_damage(TOX, 10)

/mob/living/slime/proc/get_hunger_state()
	. = 0
	if (nutrition < get_starve_nutrition())
		. += 2
	else if((nutrition < get_grow_nutrition() && prob(25)) || nutrition < get_hunger_nutrition())
		. += 1

/mob/living/slime/can_be_buckled(var/mob/user)
	to_chat(user, SPAN_WARNING("\The [src] is too squishy to buckle in."))
	return FALSE

/mob/living/slime/mind_initialize()
	..()
	mind.assigned_role = "slime"

/mob/living/slime/can_ventcrawl()
	if(feeding_on)
		to_chat(src, SPAN_WARNING("You cannot ventcrawl while feeding."))
		return FALSE
	. = ..()

/mob/living/slime/handle_airflow(differential, list/connecting_turfs, repelled)
	return FALSE

/mob/living/slime/handle_airflow_stun(differential)
	return FALSE

/mob/living/slime/xenobio_scan_results()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	. = list()
	. += "Slime scan result for \the [src]:"
	. += "[slime_data.name] [is_adult ? "adult" : "baby"] slime"
	. += "Nutrition:\t[nutrition]/[get_max_nutrition()]"
	if(nutrition < get_starve_nutrition())
		. += "<span class='alert'>Warning:\tthe slime is starving!</span>"
	else if (nutrition < get_hunger_nutrition())
		. += "<span class='warning'>Warning:\tthe slime is hungry.</span>"
	. += "Electric charge strength:\t[powerlevel]"
	. += "Health:\t[get_health_percent()]%"

	var/list/slime_mutations = slime_data.descendants?.Copy()
	if(!length(slime_mutations))
		. += "This slime will never mutate."
	else
		var/list/mutationChances = list()
		for(var/i in slime_mutations)
			if(i == slime_type)
				continue
			if(mutationChances[i])
				mutationChances[i] += mutation_chance / length(slime_mutations)
			else
				mutationChances[i] = mutation_chance / length(slime_mutations)

		var/list/mutationTexts = list("[slime_data.name] ([100 - mutation_chance]%)")
		for(var/i in mutationChances)
			mutationTexts += "[GET_DECL(i)] ([mutationChances[i]]%)"

		. += "Possible colours on splitting:\t[english_list(mutationTexts)]"

	if (cores > 1)
		. += "Anomalous slime core amount detected."
	. += "Growth progress:\t[amount_grown]/10."
	. = jointext(., "<br>")

/mob/living/slime/can_change_intent()
	return TRUE
