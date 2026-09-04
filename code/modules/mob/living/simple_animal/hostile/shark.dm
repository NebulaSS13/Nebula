/mob/living/simple_animal/hostile/carp/shark // generally stronger version of a carp that doesn't die from a mean look. Fance new sprites included, credits to F-Tang Steve
	name = "cosmoshark"
	desc = "Enormous creature that resembles a shark with magenta glowing lines along its body and set of long deep-purple teeth."
	icon = 'maps/away/errant_pisces/icons/cosmoshark.dmi'
	butchery_data = /decl/butchery_data/animal/fish/space_carp/shark
	max_health = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	faction = "shark"
	ai = /datum/mob_controller/aggressive/carp/shark

/datum/mob_controller/aggressive/carp/shark
	break_stuff_probability = 35
	turns_per_wander = 10

/mob/living/simple_animal/hostile/carp/shark/carp_randomify()
	return

/mob/living/simple_animal/hostile/carp/shark/death(gibbed)
	. = ..()
	if(. && !gibbed)
		var/datum/gas_mixture/environment = loc.return_air()
		if (environment)
			var/datum/gas_mixture/sharkmaw_chlorine = new
			sharkmaw_chlorine.adjust_gas(/decl/material/gas/chlorine, 10)
			environment.merge(sharkmaw_chlorine)
			visible_message(SPAN_WARNING("\The [src]'s body releases some gas from the gills with a quiet fizz!"))

/mob/living/simple_animal/hostile/carp/shark/apply_attack_effects(mob/living/target)
	. =..()
	var/mob/living/L = target
	if(istype(L))
		if(prob(25))//if one is unlucky enough, they get tackled few tiles away
			L.visible_message("<span class='danger'>\The [src] tackles [L]!</span>")
			var/tackle_length = rand(3,5)
			for (var/i = 1 to tackle_length)
				var/turf/T = get_step(L.loc, dir)//on a first step of tackling standing mob would block movement so let's check if there's something behind it. Works for consequent moves too
				if (T.density || LinkBlocked(L.loc, T) || TurfBlockedNonWindow(T) || DirBlocked(T, global.flip_dir[dir]))
					break
				sleep(2)
				forceMove(T)//maybe there's better manner then just forceMove() them
				L.forceMove(T)
			visible_message("<span class='danger'>\The [src] releases [L].</span>")

/decl/butchery_data/animal/fish/space_carp/shark
	meat_type = /obj/item/food/butchery/meat/fish/shark
	must_use_hook = TRUE

/obj/item/food/butchery/meat/fish/shark
	desc = "A fillet of cosmoshark meat."
	meat_name = "cosmoshark"
	color = "#cecece"
	center_of_mass = @'{"x":17,"y":13}'
	bitesize = 8

/obj/item/food/butchery/meat/fish/shark/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/psychoactives, 1)
	add_to_reagents(/decl/material/gas/chlorine,         1)
