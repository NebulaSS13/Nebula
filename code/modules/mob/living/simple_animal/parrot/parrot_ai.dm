/// Sitting/sleeping, not moving
#define PARROT_PERCH  BITFLAG(0)
/// Moving towards or away from a target
#define PARROT_ACTIVE  BITFLAG(1)
/// Moving without a specific target in mind
#define PARROT_IDLE BITFLAG(2)
/// Flying towards a target to steal it/from it
#define PARROT_STEAL  BITFLAG(3)
/// Flying towards a target to attack it
#define PARROT_ATTACK BITFLAG(4)
/// Flying towards its perch
#define PARROT_RETURN BITFLAG(5)
/// Flying away from its attacker
#define PARROT_FLEE   BITFLAG(6)

#define SET_PARROT_PERCHED                        \
	run_interval = 5 SECONDS;                     \
	parrot_state = PARROT_PERCH;                  \
	bird.resting = TRUE;                          \
	bird.update_icon();

#define SET_PARROT_IDLE                           \
	run_interval = 2.5 SECONDS;                   \
	parrot_state = PARROT_IDLE;                   \
	bird.resting = FALSE;                         \
	bird.update_icon();

#define SET_PARROT_ACTIVE_FLEE                    \
	run_interval = 1 SECOND;                      \
	parrot_state = (PARROT_ACTIVE|PARROT_FLEE);   \
	bird.resting = FALSE;                         \
	bird.update_icon();

#define SET_PARROT_ACTIVE_RETURN                  \
	run_interval = 1 SECOND;                      \
	parrot_state = (PARROT_ACTIVE|PARROT_RETURN); \
	bird.resting = FALSE;                         \
	bird.update_icon();

#define SET_PARROT_ACTIVE_ATTACK                  \
	run_interval = 1 SECONDS;                     \
	parrot_state = (PARROT_ACTIVE|PARROT_ATTACK); \
	bird.resting = FALSE;                         \
	bird.update_icon();

#define SET_PARROT_ACTIVE_STEAL                  \
	run_interval = 1 SECONDS;                    \
	parrot_state = (PARROT_ACTIVE|PARROT_STEAL); \
	bird.resting = FALSE;                        \
	bird.update_icon();

/datum/ai/parrot
	expected_type = /mob/living/simple_animal/parrot
	run_interval = 2.5 SECONDS
	/// Our current target of interest.
	var/atom/movable/atom_of_interest
	/// A quick reference to our parrot, to avoid constantly typing and casting.
	var/mob/living/simple_animal/parrot/bird
	/// A lazylist of strings that the parrot has been previously exposed to and may repeat.
	var/list/speech_buffer
	/// A general value indicating how likely it is that the parrot will stop trying to maul someone.
	var/relax_chance = 75
	/// We lose this much from relax_chance each time we calm down.
	var/impatience = 5
	/// Bitfield indicating the current goals and mood of our bird.
	var/parrot_state = PARROT_IDLE
	/// Movement delay in ticks. used for walk() and walk_to(). Higher number = slower.
	var/parrot_speed = 5
	/// Incremented by being attacked - gives a large boost to parrot move speed.
	var/adrenaline_speed_boost = 0

/datum/ai/parrot/New()
	..()
	bird = body

/datum/ai/parrot/Destroy()
	bird = null
	atom_of_interest = null
	. = ..()

/*
 * Random Bird Events
 */
/datum/ai/parrot/proc/check_perch_state()
	var/last_state = parrot_state
	var/on_perch = bird.perched_on_atom && bird.loc == get_turf(bird.perched_on_atom)
	if(parrot_state == PARROT_PERCH && !on_perch)
		SET_PARROT_IDLE
	else if((parrot_state & PARROT_RETURN) && on_perch)
		SET_PARROT_PERCHED
	return last_state != parrot_state

/datum/ai/parrot/proc/inventory_changed()
	if(parrot_state == PARROT_PERCH)
		SET_PARROT_IDLE

/datum/ai/parrot/proc/perform_avian_threat_assessment(var/mob/living/target)
	return istype(target) && !target.incapacitated() && target.health <= target.maxHealth * 0.5

/datum/ai/parrot/proc/attacked_by(var/mob/attacker)
	if(!bird || bird.stat)
		return
	atom_of_interest = attacker
	if(adrenaline_speed_boost <= 0)
		adrenaline_speed_boost = 3
	if(isliving(attacker))
		if(relax_chance <= 0 || perform_avian_threat_assessment(attacker))
			SET_PARROT_ACTIVE_ATTACK
		else
			if(parrot_state & PARROT_ATTACK)
				cease_hostilities()
			SET_PARROT_ACTIVE_FLEE
	else
		SET_PARROT_ACTIVE_FLEE
	for(var/thing in bird.get_held_items())
		bird.try_unequip(thing, get_turf(bird))

/datum/ai/parrot/proc/add_radio_code(message)
	if(prob(50) && length(bird.ears.channels))
		var/datum/radio_channel/channel = pick(bird.ears.channels)
		message = ":[channel.key] [message]"
	return message

// Parrots will add overheard strings to a speech buffer. Periodically they
// will pick one and swap out a speech string for it. We cut the buffer after
// this to avoid remembering things they heard hours ago.
/datum/ai/parrot/proc/handle_speech()
	if(prob(10) && LAZYLEN(speech_buffer))
		if(length(bird.speak))
			bird.speak -= pick(bird.speak)
		bird.speak |= pick(speech_buffer)
		LAZYCLEARLIST(speech_buffer)

// Helper proc for clearing hosility and resetting targets.
/datum/ai/parrot/proc/cease_hostilities()
	SET_PARROT_IDLE
	bird.visible_message(SPAN_NOTICE("\The [bird] seems to calm down."))
	if(relax_chance >= impatience)
		relax_chance -= impatience
	else
		relax_chance = 0

// Helper proc for searching for nearby atoms to grab or perch on.
/datum/ai/parrot/proc/find_atom_of_interest()
	for(var/thing in shuffle(view(world.view, bird.loc)))
		if(isitem(thing) && !length(bird.get_held_items()) && bird.perched_on_atom?.loc != get_turf(thing) && bird.can_pick_up_item(thing))
			return thing
		if(isobj(thing) && bird.atom_is_perchable(thing))
			return thing

// Helper proc for validating we can see/access our atom of interest.
/datum/ai/parrot/proc/validate_atom_of_interest()
	if(!atom_of_interest || !bird?.loc)
		return FALSE
	if(get_dist(atom_of_interest, bird) > world.view || !(atom_of_interest in view(world.view, bird.loc)))
		atom_of_interest = null
		return FALSE
	return TRUE

/*
 * Main parrot logic entrypoint.
 */
/datum/ai/parrot/do_process(time_elapsed)
	if(!bird || bird.incapacitated() || !isturf(bird.loc))
		return

	bird.a_intent = I_HELP // Reset early; we set it again as needed.

	/*
	 * WANDER STATE
	 */
	if(parrot_state & PARROT_IDLE)

		// Stop any pre-existing automated movement.
		atom_of_interest = null
		walk(bird, 0)

		// Wander around aimlessly most of the time.
		if(prob(90))
			bird.SelfMove(pick(global.cardinal))
			return

		// Find something to pick up or perch on.
		if(!length(bird.get_held_items()) || !bird.perched_on_atom)
			atom_of_interest = find_atom_of_interest()
			if(atom_of_interest)
				if(istype(atom_of_interest, /obj/item))
					SET_PARROT_ACTIVE_STEAL
				else
					SET_PARROT_ACTIVE_RETURN
				bird.visible_emote("turns and flies towards [atom_of_interest]")
		return
	// End wander state.

	/*
	 * PERCHED STATE
	 */
	if(parrot_state == PARROT_PERCH)
		// check some kind of process limiter to replace parrot sleep
		handle_speech()

		//Search for item to steal
		atom_of_interest = find_atom_of_interest()
		if(atom_of_interest)
			bird.visible_emote("looks in \the [atom_of_interest]'s direction and takes flight.")
			SET_PARROT_ACTIVE_STEAL
		return
	// End perch state.

	/*
	 * ACTIVE STATES
	 */
	if(parrot_state & PARROT_ACTIVE)
		walk(bird, 0)

		// None of these states make sense with no initial atom of interest.
		if(!validate_atom_of_interest())
			SET_PARROT_IDLE
			return

		/*
		 * FLEEING STATE
		 */
		if(parrot_state & PARROT_FLEE)
			walk_away(bird, atom_of_interest, world.view, parrot_speed-adrenaline_speed_boost)
			if(adrenaline_speed_boost > 0)
				adrenaline_speed_boost--
			return

		/*
		 * HOSTILE STATE
		 */
		if(parrot_state & PARROT_ATTACK)

			if(prob(relax_chance))
				cease_hostilities()
			// No point trying to attack non-living-mobs.
			if(!isliving(atom_of_interest))
				atom_of_interest = null
				SET_PARROT_IDLE
				return

			if(bird.Adjacent(atom_of_interest))

				var/mob/living/victim = atom_of_interest

				// They're up and kicking, time to claw their eyes.
				if(!victim.incapacitated())
					bird.a_intent = I_HURT
					victim.attackby(bird.get_natural_weapon(), bird)
				// They're prone on the ground, try to steal their shit.
				else
					if(!length(bird.get_held_items()))
						bird.a_intent = I_GRAB
						bird.UnarmedAttack(victim)

					// We already had, or stole, something, let's flee back to our perch (or return to wandering).
					if(length(bird.get_held_items()) && bird.perched_on_atom)
						atom_of_interest = bird.perched_on_atom
						SET_PARROT_ACTIVE_RETURN
						run_interval = 1 SECOND
					else
						atom_of_interest = null
						SET_PARROT_IDLE
					return
			else // Need to get closer.
				walk_to(bird, atom_of_interest, 1, parrot_speed)
			return

		/*
		 * THEFT/PERCHING STATE
		 */
		// We are next to the atom we want to interact with, so take a grab at it.
		if(bird.Adjacent(atom_of_interest))
			bird.a_intent = I_GRAB
			bird.UnarmedAttack(atom_of_interest)

			// We are sitting on our perch, either due to coincidence
			// or due to returning. We perch and drop whatever we stole.
			if(bird.perched_on_atom == bird.loc)
				SET_PARROT_PERCHED
				for(var/thing in bird.get_held_items())
					bird.try_unequip(thing, get_turf(bird))

			// We were stealing an item, so now we will return to our perch.
			else if(parrot_state & PARROT_STEAL)
				atom_of_interest = bird.perched_on_atom
				if(atom_of_interest) // We have a perch!
					SET_PARROT_ACTIVE_RETURN
				else // We don't have a perch/
					SET_PARROT_IDLE

			// We're in a moderate confused state, so go back to wandering.
			else
				SET_PARROT_IDLE

		else // We need to get closer to our target atom.
			walk_to(bird, atom_of_interest, 1, parrot_speed)
		return

	/*
	 * SANITY in case of incoherent parrot_state
	 */
	walk(bird, 0)
	atom_of_interest = null
	bird.perched_on_atom = null
	for(var/thing in bird.get_held_items())
		bird.try_unequip(thing, get_turf(bird))

	SET_PARROT_IDLE

#undef PARROT_PERCH
#undef PARROT_ACTIVE
#undef PARROT_IDLE
#undef PARROT_STEAL
#undef PARROT_ATTACK
#undef PARROT_RETURN
#undef PARROT_FLEE

#undef SET_PARROT_IDLE
#undef SET_PARROT_ACTIVE_RETURN
#undef SET_PARROT_ACTIVE_ATTACK
#undef SET_PARROT_ACTIVE_STEAL
#undef SET_PARROT_ACTIVE_FLEE
#undef SET_PARROT_PERCHED