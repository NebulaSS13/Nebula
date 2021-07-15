#define FEED_RESULT_INVALID -1
#define FEED_RESULT_DEAD     0
#define FEED_RESULT_VALID    1

/mob/living/slime
	name = "baby slime"
	icon = 'mods/content/xenobiology/icons/slimes/slime_baby.dmi'
	icon_state = "slime"
	pass_flags = PASS_FLAG_TABLE
	speak_emote = list("chirps")
	maxHealth = 150
	health = 150
	gender = NEUTER
	update_icon = 0
	see_in_dark = 8
	status_flags = CANPARALYSE|CANPUSH
	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0
	ai = /datum/ai/slime
	hud_type = /datum/hud/slime

	var/is_adult = FALSE
	var/mutation_chance = 30 // Chance of mutating, should be between 25 and 35
	var/powerlevel = 0 // 0-10 controls how much electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces
	var/weakref/feeding_on
	var/nutrition = 800
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

/mob/living/slime/getToxLoss()
	return toxloss

/mob/living/slime/get_digestion_product()
	return /decl/material/liquid/slimejelly

/mob/living/slime/adjustToxLoss(var/amount)
	toxloss = Clamp(toxloss + amount, 0, maxHealth)

/mob/living/slime/setToxLoss(var/amount)
	adjustToxLoss(amount-getToxLoss())

/mob/living/slime/Initialize(mapload, var/_stype = /decl/slime_colour/grey)

	. = ..(mapload)

	ingested = new /datum/reagents/metabolism(240, src, CHEM_TOUCH)
	reagents = ingested
	// See comment in /mob/living/slime/on_update_icon() regarding alpha mask filters.
	//render_target = "slime_\ref[src]"

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

/mob/living/slime/movement_delay()
	if (bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	var/tally = ..()

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 30) tally += (health_deficiency / 25)

	if (bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent(/decl/material/liquid/amphetamines)) // Stimulants slows slimes down
			tally *= 2

		if(reagents.has_reagent(/decl/material/liquid/frostoil)) // Frostoil also makes them move VEEERRYYYYY slow
			tally *= 5

	if(health <= 0) // if damaged, the slime moves twice as slow
		tally *= 2

	return tally + config.slime_delay

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
			if(istype(tmob, /mob/living/carbon/human))
				if(prob(90))
					now_pushing = 0
					return
		else
			if(istype(tmob, /mob/living/carbon/human))
				now_pushing = 0
				return

	now_pushing = 0

	..()

/mob/living/slime/Stat()
	. = ..()

	statpanel("Status")
	stat(null, "Health: [round((health / maxHealth) * 100)]%")
	stat(null, "Intent: [a_intent]")

	if (client.statpanel == "Status")
		stat(null, "Nutrition: [nutrition]/[get_max_nutrition()]")
		if(amount_grown >= 10)
			if(is_adult)
				stat(null, "You can reproduce!")
			else
				stat(null, "You can evolve!")

		stat(null,"Power Level: [powerlevel]")

/mob/living/slime/adjustFireLoss(amount)
	..(-abs(amount)) // Heals them

/mob/living/slime/bullet_act(var/obj/item/projectile/Proj)
	var/datum/ai/slime/slime_ai = ai
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

/mob/living/slime/u_equip(obj/item/W)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/living/slime/attack_ui(slot)
	return

/decl/status_condition/confused/handle_changed_amount(mob/living/victim, new_amount, last_amount)
	. = ..()
	if(new_amount != last_amount && isslime(victim))
		var/mob/living/slime/slime = victim
		if(istype(slime.ai, /datum/ai/slime))
			var/datum/ai/slime/slime_ai = slime.ai
			slime_ai.update_mood()

/mob/living/slime/proc/adjust_friendship(var/mob/user, var/amount)
	if(user && amount != 0)
		var/datum/ai/slime/slime_ai = ai
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

	if(feeding_on)
		var/prey = feeding_on
		if(feeding_on == user)
			if(prob(60))
				visible_message(SPAN_DANGER("\The [user] fails to escape \the [src]!"))
			else
				visible_message(SPAN_DANGER("\The [user] manages to escape \the [src]!"))
				set_feeding_on()
		else
			if(prob(30))
				visible_message(SPAN_DANGER("\The [user] attempts to wrestle \the [src] off \the [feeding_on]!"))
			else
				visible_message(SPAN_DANGER("\The [user] manages to wrestle \the [src] off \the [feeding_on]!"))
				set_feeding_on()

		if(prey != feeding_on)
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
			var/datum/ai/slime/slime_ai = ai
			if(istype(slime_ai))
				slime_ai.attacked += 10
				slime_ai.adjust_friendship(user, -5)
			if(prob(10))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("\The [user] has attempted to punch \the [src]!"))
				return TRUE
			if(MUTATION_HULK in user.mutations)
				damage += 5
				if(feeding_on)
					set_feeding_on()
				if(istype(slime_ai) && slime_ai.current_target)
					slime_ai.current_target = null
				throw_at(get_edge_target_turf(src, get_dir(user, src)), 2, 10, user, FALSE)
			playsound(loc, "punch", 25, 1, -1)
			visible_message(SPAN_DANGER("\The [user] has punched \the [src]!"))
			adjustBruteLoss(damage)
			return TRUE
	. = ..()

/mob/living/slime/attackby(var/obj/item/W, var/mob/user)
	if(W.force > 0)
		var/datum/ai/slime/slime_ai = ai
		if(istype(slime_ai))
			slime_ai.attacked += 10
			slime_ai.adjust_friendship(user, -5)
		if(stat == CONSCIOUS && prob(25)) //Only run this check if we're alive or otherwise motile, otherwise surgery will be agonizing for xenobiologists.
			to_chat(user, SPAN_WARNING("\The [W] passes right through \the [src]!"))
			return TRUE
	. = ..()
	if(feeding_on && prob(W.force * 5))
		set_feeding_on()
		step_away(src, user)

/mob/living/slime/restrained()
	return 0

/mob/living/slime/toggle_throw_mode()
	return

/mob/living/slime/check_has_eyes()
	return FALSE

/mob/living/slime/check_has_mouth()
	return 0

/mob/living/slime/proc/gain_nutrition(var/amount)
	adjust_nutrition(amount)
	if(prob(amount * 2)) // Gain around one level per 50 nutrition
		powerlevel++
		if(powerlevel > 10)
			powerlevel = 10
			adjustToxLoss(-10)

/mob/living/slime/adjust_nutrition(var/amt)
	nutrition = Clamp(nutrition + amt, 0, get_max_nutrition())

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

/mob/living/slime/airflow_stun()
	return

/mob/living/slime/xenobio_scan_results()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	. += "Slime scan result for \the [src]:"
	. += "[slime_data.name] [is_adult ? "adult" : "baby"] slime"
	. += "Nutrition:\t[nutrition]/[get_max_nutrition()]"
	if(nutrition < get_starve_nutrition())
		. += "<span class='alert'>Warning:\tthe slime is starving!</span>"
	else if (nutrition < get_hunger_nutrition())
		. += "<span class='warning'>Warning:\tthe slime is hungry.</span>"
	. += "Electric charge strength:\t[powerlevel]"
	. += "Health:\t[round((health * 100) / maxHealth)]%"

	var/list/mutations = slime_data.descendants?.Copy()
	if(!mutations.len)
		. += "This slime will never mutate."
	else
		var/list/mutationChances = list()
		for(var/i in mutations)
			if(i == slime_type)
				continue
			if(mutationChances[i])
				mutationChances[i] += mutation_chance / mutations.len
			else
				mutationChances[i] = mutation_chance / mutations.len

		var/list/mutationTexts = list("[slime_data.name] ([100 - mutation_chance]%)")
		for(var/i in mutationChances)
			mutationTexts += "[i] ([mutationChances[i]]%)"

		. += "Possible colours on splitting:\t[english_list(mutationTexts)]"

	if (cores > 1)
		. += "Anomalous slime core amount detected."
	. += "Growth progress:\t[amount_grown]/10."
	. = jointext(., "<br>")

/mob/living/slime/can_change_intent()
	return TRUE

/mob/living/slime/get_telecomms_race_info()
	return list("Slime", FALSE)
