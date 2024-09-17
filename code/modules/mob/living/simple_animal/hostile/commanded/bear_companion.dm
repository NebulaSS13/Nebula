/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."
	icon = 'icons/mob/simple_animal/bear_brown.dmi'
	max_health = 75
	density = TRUE
	natural_weapon = /obj/item/natural_weapon/claws
	max_gas = list(
		/decl/material/gas/chlorine = 2,
		/decl/material/gas/carbon_dioxide = 5
	)
	base_animal_type = /mob/living/simple_animal/hostile/bear // used for language, ignore type
	ai = /datum/mob_controller/aggressive/commanded/bear

/datum/mob_controller/aggressive/commanded/bear
	known_commands = list("stay", "stop", "attack", "follow", "dance", "boogie", "boogy")
	can_escape_buckles = TRUE

/datum/mob_controller/aggressive/commanded/bear/listen()
	if(get_stance() != STANCE_COMMANDED_MISC) //cant listen if its booty shakin'
		..()

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(.)
		custom_emote(AUDIBLE_MESSAGE, "roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		custom_emote(AUDIBLE_MESSAGE, "roars in rage!")

//WE DANCE!
/datum/mob_controller/aggressive/commanded/bear/misc_command(var/mob/speaker,var/text)
	stay_command()
	set_stance(STANCE_COMMANDED_MISC) //nothing can stop this ride
	spawn(0)
		body.visible_message("\The [body] starts to dance!.")
		var/decl/pronouns/pronouns = body.get_pronouns()
		for(var/i in 1 to 10)
			if(get_stance() != STANCE_COMMANDED_MISC || body.incapacitated()) //something has stopped this ride.
				return
			var/message = pick(\
							"moves [pronouns.his] head back and forth!",\
							"bobs [pronouns.his] booty!",\
							"shakes [pronouns.his] paws in the air!",\
							"wiggles [pronouns.his] ears!",\
							"taps [pronouns.his] foot!",\
							"shrugs [pronouns.his] shoulders!",\
							"dances like you've never seen!")
			if(body.dir != WEST)
				body.set_dir(WEST)
			else
				body.set_dir(EAST)
			body.visible_message("\The [body] [message]")
			sleep(30)
		set_stance(STANCE_COMMANDED_STOP)
		body.set_dir(SOUTH)
		body.visible_message("\The [body] bows, finished with [pronouns.his] dance.")
