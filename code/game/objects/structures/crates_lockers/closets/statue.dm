/obj/structure/closet/statue //what
	name = "statue"
	desc = "An incredibly lifelike marble carving."
	icon = 'icons/obj/structures/statue.dmi'
	icon_state = "human_male"
	density = TRUE
	anchored = TRUE
	setup = 0
	current_health = 0 //destroying the statue kills the mob within
	var/intialTox = 0 	//these are here to keep the mob from taking damage from things that logically wouldn't affect a rock
	var/intialFire = 0	//it's a little sloppy I know but it was this or the GODMODE flag. Lesser of two evils.
	var/intialBrute = 0
	var/intialOxy = 0
	var/timer = 240 //eventually the person will be freed

/obj/structure/closet/statue/Initialize(mapload, var/mob/living/L)
	if(L && (ishuman(L) || L.isMonkey() || iscorgi(L)))
		if(L.buckled)
			L.buckled = 0
			L.anchored = FALSE
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.forceMove(src)
		L.add_genetic_condition(GENE_COND_MUTED)
		current_health = L.current_health + 100 //stoning damaged mobs will result in easier to shatter statues
		intialTox = L.get_damage(TOX)
		intialFire = L.get_damage(BURN)
		intialBrute = L.get_damage(BRUTE)
		intialOxy = L.get_damage(OXY)
		if(ishuman(L))
			name = "statue of [L.name]"
			if(L.gender == "female")
				icon_state = "human_female"
		else if(L.isMonkey())
			name = "statue of a monkey"
			icon_state = "monkey"
		else if(iscorgi(L))
			name = "statue of a corgi"
			icon_state = "corgi"
			desc = "If it takes forever, I will wait for you..."

	if(current_health == 0) //meaning if the statue didn't find a valid target
		return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSobj, src)
	. = ..(mapload)

/obj/structure/closet/statue/Process()
	timer--
	for(var/mob/living/M in src) //Go-go gadget stasis field
		M.set_damage(TOX, intialTox)
		M.take_damage(intialFire - M.get_damage(BURN), BURN, do_update_health = FALSE)
		M.take_damage(intialBrute - M.get_damage(BRUTE))
		M.set_damage(OXY, intialOxy)
	if (timer <= 0)
		dump_contents()
		STOP_PROCESSING(SSobj, src)
		qdel(src)

/obj/structure/closet/statue/dump_contents(atom/forced_loc = loc, mob/user)
	for(var/obj/O in src)
		O.dropInto(forced_loc)

	for(var/mob/living/M in src)
		M.dropInto(forced_loc)
		M.remove_genetic_condition(GENE_COND_MUTED)
		M.take_overall_damage((M.current_health - current_health - 100),0) //any new damage the statue incurred is transfered to the mob
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/statue/open(mob/user)
	return

/obj/structure/closet/statue/close(mob/user)
	return

/obj/structure/closet/statue/toggle()
	return

/obj/structure/closet/statue/proc/check_health()
	if(current_health <= 0)
		for(var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/bullet_act(var/obj/item/projectile/Proj)
	current_health -= Proj.get_structure_damage()
	check_health()

	return

/obj/structure/closet/statue/explosion_act(severity)
	for(var/mob/M in src)
		M.explosion_act(severity)
	..()
	if(!QDELETED(src))
		current_health -= 60 / severity
		check_health()

/obj/structure/closet/statue/attackby(obj/item/I, mob/user)
	current_health -= I.get_attack_force(user)
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] strikes [src] with [I].</span>")
	check_health()

/obj/structure/closet/statue/receive_mouse_drop(atom/dropping, mob/user, params)
	return TRUE

/obj/structure/closet/statue/relaymove()
	return

/obj/structure/closet/statue/attack_hand()
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/obj/structure/closet/statue/verb_toggleopen()
	return

/obj/structure/closet/statue/on_update_icon()
	return

/obj/structure/closet/statue/proc/shatter(mob/user)
	if (user)
		user.dust()
	dump_contents()
	visible_message("<span class='warning'>[src] shatters!.</span>")
	qdel(src)
