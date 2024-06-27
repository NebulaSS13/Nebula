/obj/structure/deity/altar
	name = "altar"
	desc = "A structure made for the express purpose of religion."
	current_health = 50
	power_adjustment = 5
	deity_flags = DEITY_STRUCTURE_ALONE
	build_cost = 1000
	var/mob/living/target
	var/cycles_before_converted = 5
	var/next_cycle = 0

/obj/structure/deity/altar/Destroy()
	if(target)
		remove_target()
	if(linked_god)
		to_chat(src, SPAN_DANGER("You've lost an altar!"))
	return ..()

/obj/structure/deity/altar/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(G.force_danger())
			var/mob/living/affecting_mob = G.get_affecting_mob()
			if(istype(affecting_mob))
				affecting_mob.dropInto(loc)
				SET_STATUS_MAX(affecting_mob, STAT_WEAK, 1)
				user.visible_message(SPAN_WARNING("\The [user] throws \the [affecting_mob] onto \the [src]!"))
				qdel(G)
				return
	..()

/obj/structure/deity/altar/Process()
	if(!target || world.time < next_cycle)
		return
	if(!linked_god || target.stat)
		to_chat(linked_god, SPAN_WARNING("\The [target] has lost consciousness, breaking \the [src]'s hold on their mind!"))
		remove_target()
		return

	next_cycle = world.time + 10 SECONDS
	cycles_before_converted--
	if(!cycles_before_converted)
		src.visible_message("For one thundering moment, \the [target] cries out in pain before going limp and broken.")
		var/decl/special_role/godcultist/godcult = GET_DECL(/decl/special_role/godcultist)
		godcult.add_antagonist_mind(target.mind,1, "Servant of [linked_god]","Your loyalty may be faulty, but you know that it now has control over you...", specific_god=linked_god)
		remove_target()
		return

	switch(cycles_before_converted)
		if(4)
			text = "You can't think straight..."
		if(3)
			text = "You feel like your thought are being overriden..."
		if(2)
			text = "You can't... concentrate... must... resist!"
		if(1)
			text = "Can't... resist... anymore."
			to_chat(linked_god, SPAN_WARNING("\The [target] is getting close to conversion!"))
	to_chat(target, "<span class='cult'>[text]. <a href='byond://?src=\ref[src];resist=\ref[target]'>Resist Conversion</a></span>")


//Used for force conversion.
/obj/structure/deity/altar/proc/set_target(var/mob/living/L)
	if(target || !linked_god)
		return
	cycles_before_converted = initial(cycles_before_converted)
	START_PROCESSING(SSobj, src)
	target = L
	update_icon()
	events_repository.register(/decl/observ/destroyed, L,src, TYPE_PROC_REF(/obj/structure/deity/altar, remove_target))
	events_repository.register(/decl/observ/moved, L, src, TYPE_PROC_REF(/obj/structure/deity/altar, remove_target))
	events_repository.register(/decl/observ/death, L, src, TYPE_PROC_REF(/obj/structure/deity/altar, remove_target))

/obj/structure/deity/altar/proc/remove_target()
	STOP_PROCESSING(SSobj, src)
	events_repository.unregister(/decl/observ/destroyed, target, src)
	events_repository.unregister(/decl/observ/moved, target, src)
	events_repository.unregister(/decl/observ/death, target, src)
	target = null
	update_icon()

/obj/structure/deity/altar/OnTopic(var/user, var/list/href_list)
	if(href_list["resist"])
		var/mob/living/M = locate(href_list["resist"])
		if(!istype(M) || target != M || M.stat || M.is_on_special_ability_cooldown())
			return TOPIC_HANDLED

		M.set_special_ability_cooldown(10 SECONDS)
		M.visible_message(SPAN_WARNING("\The [M] writhes on top of \the [src]!"), SPAN_NOTICE("You struggle against the intruding thoughts, keeping them at bay!"))
		to_chat(linked_god, SPAN_WARNING("\The [M] slows its conversion through willpower!"))
		cycles_before_converted++
		if(prob(50))
			to_chat(M, SPAN_DANGER("The mental strain is too much for you! You feel your body weakening!"))
			M.take_damage(15, TOX, do_update_health = FALSE)
			M.take_damage(30, PAIN)
		return TOPIC_REFRESH

/obj/structure/deity/altar/on_update_icon()
	..()
	if(target)
		add_overlay(image('icons/effects/effects.dmi', icon_state =  "summoning"))

/obj/structure/deity/altar/nullrod_act(mob/user, obj/item/nullrod/rod)
	if(!linked_god.silenced) //Don't want them to infinity spam it.
		linked_god.silence(10)
		new /obj/effect/temporary(get_turf(src),'icons/effects/effects.dmi',"purple_electricity_constant", 10)
		visible_message(SPAN_NOTICE("\The [src] groans in protest as reality settles around \the [rod]."))
		return TRUE
	return FALSE