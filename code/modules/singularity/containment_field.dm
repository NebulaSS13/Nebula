//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/containment_field
	name = "containment field"
	desc = "An energy field."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "Contain_F"
	anchored = TRUE
	density = FALSE
	light_range = 4
	movable_flags = MOVABLE_FLAG_PROXMOVE
	var/obj/machinery/field_generator/FG1 = null
	var/obj/machinery/field_generator/FG2 = null
	var/next_shock_time = 0 SECONDS //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.

/obj/effect/containment_field/Destroy()
	if(FG1 && !FG1.clean_up)
		FG1.cleanup()
	if(FG2 && !FG2.clean_up)
		FG2.cleanup()
	. = ..()

/obj/effect/containment_field/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	shock(user)
	return TRUE

/obj/effect/containment_field/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/obj/effect/containment_field/HasProximity(atom/movable/AM)
	. = ..()
	if(. && isliving(AM) && prob(50))
		shock(AM)

/obj/effect/containment_field/proc/shock(mob/living/user)
	if(next_shock_time > world.time)
		return FALSE
	if(!FG1 || !FG2)
		qdel(src)
		return FALSE
	if(isliving(user))
		next_shock_time = world.time + 2 SECONDS
		var/shock_damage = min(rand(30,40),rand(30,40))
		user.electrocute_act(shock_damage, src)
		var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
		user.throw_at(target, 200, 4)
		return TRUE
	return FALSE

/obj/effect/containment_field/proc/set_master(var/master1,var/master2)
	if(!master1 || !master2)
		return 0
	FG1 = master1
	FG2 = master2
	return 1
