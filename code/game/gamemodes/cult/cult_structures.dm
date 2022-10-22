/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/talisman
	name = "Altar"
	desc = "A bloodstained altar dedicated to Nar-Sie."
	icon_state = "talismanaltar"


/obj/structure/cult/forge
	name = "Daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie."
	icon_state = "forge"

/obj/structure/cult/pylon
	name = "Pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon = 'icons/obj/structures/pylon.dmi'
	icon_state  = "pylon"
	light_power = 0.5
	light_range = 13
	light_color = "#3e0000"
	hitsound = 'sound/effects/Glasshit.ogg'
	material = /decl/material/solid/gemstone/crystal

/obj/structure/cult/pylon/on_update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][is_broken()? "-broken" : ""]"

/obj/structure/cult/pylon/proc/is_broken()
	return health < (max_health * 0.25) 

/obj/structure/cult/pylon/check_health(lastdamage, lastdamtype, lastdamflags)
	var/was_broken = is_broken()
	. = ..()
	if(QDELETED(src))
		return
	//Handle going in and out of broken state
	if(is_broken() && !was_broken)
		audible_message("You hear a tinkle of crystal shards.")
		visible_message(SPAN_DANGER("\The [src], and its crystal breaks apart!"))
		playsound(src, 'sound/effects/Glassbr3.ogg', 75, TRUE)
		set_density(FALSE)
		set_light(0)
		update_icon()
	
	else if(!is_broken() && was_broken)
		set_density(TRUE)
		set_light(13, 0.5)
		update_icon()

/obj/structure/cult/pylon/can_repair_with(spell/aoe_turf/conjure/pylon/tool)
	return istype(tool)

//The spell for fixing pylons calls this, and the requirement for passing a spell means it won't be triggered anywhere in the base repair handling.
/obj/structure/cult/pylon/handle_repair(mob/user, spell/aoe_turf/conjure/pylon/tool)
	if(!istype(tool))
		to_chat(user, SPAN_WARNING("You probably need some sort of magic to fix this.."))
		return
	to_chat(user, SPAN_NOTICE("You repair the pylon."))
	heal(max_health)
	return TRUE

/obj/structure/cult/pylon/get_artifact_scan_data()
	return "Tribal pylon - subject resembles statues/emblems built by cargo cult civilisations to honour energy systems from post-warp civilisations."

/obj/structure/cult/tome
	name = "Desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	icon_state = "tomealtar"

//sprites for this no longer exist	-Pete
//(they were stolen from another game anyway)
/*
/obj/structure/cult/pillar
	name = "Pillar"
	desc = "This should not exist."
	icon_state = "pillar"
	icon = 'magic_pillar.dmi'
*/

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = TRUE
	anchored = TRUE
	max_health = OBJ_HEALTH_NO_DAMAGE
	var/spawnable = null

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/faithless
	)

/obj/effect/gateway/active/cult
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)

/obj/effect/gateway/active/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/create_and_delete), rand(30,60) SECONDS)


/obj/effect/gateway/active/proc/create_and_delete()
	var/t = pick(spawnable)
	new t(src.loc)
	qdel(src)

/obj/effect/gateway/active/Crossed(var/atom/A)
	if(!istype(A, /mob/living))
		return

	var/mob/living/M = A

	if(M.stat != DEAD)
		if(M.HasMovementHandler(/datum/movement_handler/mob/transformation))
			return

		M.handle_pre_transformation()

		if(iscultist(M)) return
		if(!ishuman(M) && !isrobot(M)) return

		M.AddMovementHandler(/datum/movement_handler/mob/transformation)
		M.icon = null
		M.overlays.len = 0
		M.set_invisibility(101)

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/Robot = M
			if(Robot.mmi)
				qdel(Robot.mmi)
		else
			for(var/obj/item/W in M)
				M.drop_from_inventory(W)
				if(istype(W, /obj/item/implant))
					qdel(W)

		var/mob/living/new_mob = new /mob/living/simple_animal/corgi(A.loc)
		new_mob.a_intent = I_HURT
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key

		to_chat(new_mob, "<B>Your form morphs into that of a corgi.</B>")//Because we don't have cluwnes
