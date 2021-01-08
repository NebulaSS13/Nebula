GLOBAL_VAR_INIT(default_gyne, create_gyne_name())

/decl/ghosttrap/kharmaani_egg
	name = "mantid nymph"
	ban_checks = list(/decl/special_role/provocateur)
	ghost_trap_message = "They are hatching from a kharmaan egg now."

/decl/ghosttrap/kharmaani_egg/forced(var/mob/user)
	request_player(new /mob/living/carbon/alien/ascent_nymph(get_turf(user)), "A mantid nymph is ready to hatch and needs a player.")

/obj/structure/insectoid_egg
	name = "alien egg"
	breakable = TRUE
	desc = "A semi-translucent alien egg."
	health = 100
	maxhealth = 100
	icon = 'mods/species/ascent/icons/species/nymph.dmi'
	icon_state = "egg"

	var/maturity_rate = 1 MINUTES		// How often to do a gestation tick.
	var/last_tick						// When we last did a gestation tick.
	var/maturity = 0					// When this reaches 100, the egg is viable and ready to hatch.
	var/min_temperature = 23 CELSIUS	// The minimum temperature for the egg to gestate.
	var/max_temperature = 30 CELSIUS	// The maximum temperature for the egg to gestate.

	var/lineage							// A string containing the gyne's name.
	var/hatching = FALSE				// If we're in the process of hatching.
	var/hatched = FALSE					// Whether or not this egg has already hatched.

	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE
	)

/obj/structure/insectoid_egg/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	lineage = GLOB.default_gyne

/obj/structure/insectoid_egg/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/structure/insectoid_egg/on_update_icon()
	. = ..()
	if(hatched || !health)
		icon_state = "egg_broken"
	else if(hatching)
		icon_state = "egg_break"
	else if(maturity == 100)
		icon_state = "egg_ready"
	else
		icon_state = "egg"

/obj/structure/insectoid_egg/examine(mob/user)
	. = ..()

	if(hatched || !health)
		to_chat(user, "\icon[src] \The [src] lays in shambles, having been hatched or broken.")
		return

	if(maturity < 5)
		to_chat(user, "\icon[src] \The [src] is freshly laid and sticky.")
	else if(maturity < 15)
		to_chat(user, "\icon[src] \The [src] is small and still to the touch.")
	else if(maturity < 30)
		to_chat(user, "\icon[src] \The [src] has swollen in size; a faint glow can be seen inside the shell.")
	else if(maturity < 50)
		to_chat(user, "\icon[src] \The [src] emanates a faint glow and moves from time to time.")
	else if(maturity < 75)
		to_chat(user, "\icon[src] \The [src] appears to be close to hatching.")
	else
		to_chat(user, "\icon[src] \The [src] is lively and appears ready to hatch at any moment.")

/obj/structure/insectoid_egg/Process()
	if(!health || hatched || hatching || (world.time <= (last_tick + maturity_rate)))
		return

	last_tick = world.time
	var/turf/T = get_turf(src)
	
	// Too high of temp will damage eggs.
	if(T.temperature > (max_temperature * 1.5))
		health = max(0, health - 5)
	
	if(T.temperature < min_temperature || T.temperature > max_temperature)
		return

	var/ready_to_hatch = maturity != 100
	maturity = min(100, maturity + 1)
	ready_to_hatch = maturity == 100 && !ready_to_hatch // Lazy flip from change.
	if(ready_to_hatch)
		var/decl/ghosttrap/G = decls_repository.get_decl(/decl/ghosttrap/kharmaani_egg)
		G.request_player(src, "A mantid nymph is ready to hatch and needs a player.")

/obj/structure/insectoid_egg/proc/hatch(var/client/C)
	if(!health || maturity != 100 || hatched || hatching)
		return

	var/mob/living/carbon/alien/ascent_nymph/new_nymph = new(src, SPECIES_MANTID_NYMPH) // Spawn in the egg.
	new_nymph.loc = src
	new_nymph.lastarea = get_area(src)
	new_nymph.key = C.ckey
	new_nymph.real_name = "[random_id(/decl/species/mantid, 10000, 99999)] [lineage]"
	hatching = TRUE
	update_icon()
	visible_message(SPAN_NOTICE("\icon[src] \The [src] trembles and cracks as it begins to hatch."))
	addtimer(CALLBACK(src, .proc/finish_hatching), 2.5 SECONDS)
	
	
/obj/structure/insectoid_egg/proc/finish_hatching()
	hatched = TRUE
	hatching = FALSE
	update_icon()
	for(var/mob/M in src)
		M.loc = get_turf(src) // Pop!
		visible_message(SPAN_NOTICE("\icon[src] \The [M] hatches out of \the [src]."))