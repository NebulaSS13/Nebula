/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."
	icon = 'icons/mob/simple_animal/bear_brown.dmi'
	health = 75
	maxHealth = 75
	density = TRUE
	natural_weapon = /obj/item/natural_weapon/claws
	can_escape = TRUE
	max_gas = list(
		/decl/material/gas/chlorine = 2,
		/decl/material/gas/carbon_dioxide = 5
	)
	known_commands = list("stay", "stop", "attack", "follow", "dance", "boogie", "boogy")
	base_animal_type = /mob/living/simple_animal/hostile/bear // used for language, ignore type

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/listen()
	if(stance != COMMANDED_MISC) //cant listen if its booty shakin'
		..()

//WE DANCE!
/mob/living/simple_animal/hostile/commanded/bear/misc_command(var/mob/speaker,var/text)
	stay_command()
	stance = COMMANDED_MISC //nothing can stop this ride
	spawn(0)
		src.visible_message("\The [src] starts to dance!.")
		var/decl/pronouns/G = get_pronouns()
		for(var/i in 1 to 10)
			if(stance != COMMANDED_MISC || incapacitated()) //something has stopped this ride.
				return
			var/message = pick(\
							"moves [G.his] head back and forth!",\
							"bobs [G.his] booty!",\
							"shakes [G.his] paws in the air!",\
							"wiggles [G.his] ears!",\
							"taps [G.his] foot!",\
							"shrugs [G.his] shoulders!",\
							"dances like you've never seen!")
			if(dir != WEST)
				set_dir(WEST)
			else
				set_dir(EAST)
			src.visible_message("\The [src] [message]")
			sleep(30)
		stance = COMMANDED_STOP
		set_dir(SOUTH)
		src.visible_message("\The [src] bows, finished with [G.his] dance.")