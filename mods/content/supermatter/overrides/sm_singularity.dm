#define STAGE_SUPER	11

/// A singularity that has the mass of a supermatter crystal.
/decl/singularity_stage/stage_super
	name = "super gravitational singularity"
	desc = "A gravitational singularity with the properties of supermatter. <b>It has the power to destroy worlds.</b>"
	min_energy = 50000
	max_energy = INFINITY
	stage_size = STAGE_SUPER
	footprint = 6
	icon = 'icons/effects/352x352.dmi'
	icon_state = "singularity_s11"//uh, whoever drew that, you know that black holes are supposed to look dark right? What's this, the clown's singulo?
	pixel_x = -160
	pixel_y = -160
	grav_pull = 16
	consume_range = 5
	dissipates_over_time = 0 //It cant go smaller due to e loss
	event_chance = 25 //Events will fire off more often.
	forced_event = /decl/singularity_event/supermatter_wave
	wander = TRUE
	explosion_vulnerable = FALSE
	em_heavy_range = 12
	em_light_range = 16
	mesmerize_text = "helpless"
	the_goggles_do_nothing = TRUE
	ignore_obstacles = TRUE

/decl/singularity_stage/stage_super/grow_to(obj/effect/singularity/source)
	source.visible_message(SPAN_SINISTER("<font size='3'>You witness the creation of a destructive force that cannot possibly be stopped by human hands.</font>"))

// why is this not shrink_from or something?
/decl/singularity_stage/stage_five/shrink_to(obj/effect/singularity/source)
	source.visible_message(SPAN_WARNING("\The [source] miraculously reduces in size and loses its supermatter properties."))

// Singularity event
/decl/singularity_event/supermatter_wave/handle_event(obj/effect/singularity/source)
	for(var/mob/living/M in view(10, source.loc))
		to_chat(M, SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat."))
		if(prob(67))
			to_chat(M, SPAN_NOTICE("Miraculously, it fails to kill you."))
		else
			to_chat(M, SPAN_DANGER("You don't even have a moment to react as you are reduced to ashes by the intense radiation."))
			M.dust()
	SSradiation.radiate(source, rand(source.energy))

#undef STAGE_SUPER