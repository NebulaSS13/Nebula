/obj/item/chems/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/hypospray_borg.dmi'
	amount_per_transfer_from_this = 5
	chem_volume = 30
	possible_transfer_amounts = null
	max_health = ITEM_HEALTH_NO_DAMAGE

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

/obj/item/chems/borghypo/Initialize()
	chem_volume *= length(get_generated_reagents())
	. = ..()

/obj/item/chems/borghypo/proc/get_generated_reagents()
	var/static/list/_reagent_ids = list(
		/decl/material/liquid/regenerator,
		/decl/material/liquid/stabilizer,
		/decl/material/liquid/antibiotics
	)
	return _reagent_ids

/obj/item/chems/borghypo/surgeon/get_generated_reagents()
	var/static/list/_reagent_ids = list(
		/decl/material/liquid/brute_meds,
		/decl/material/liquid/oxy_meds,
		/decl/material/liquid/painkillers/strong
	)
	return _reagent_ids

/obj/item/chems/borghypo/crisis/get_generated_reagents()
	var/static/list/_reagent_ids = list(
		/decl/material/liquid/regenerator,
		/decl/material/liquid/stabilizer,
		/decl/material/liquid/painkillers/strong
	)
	return _reagent_ids

/obj/item/chems/borghypo/populate_reagents()
	. = ..()
	var/list/reagent_ids = get_generated_reagents()
	for(var/decl/material/reagent in decls_repository.get_decls_unassociated(reagent_ids))
		reagents.add_reagent(reagent.type, round(REAGENT_MAXIMUM_VOLUME(reagents) / length(reagent_ids)))
	START_PROCESSING(SSobj, src)

/obj/item/chems/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/chems/borghypo/Process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return
	charge_tick = 0
	if(!isrobot(loc))
		return
	var/mob/living/silicon/robot/robot = loc
	if(!robot?.cell)
		return
	var/list/reagent_ids = get_generated_reagents()
	var/max_per_reagent = round(REAGENT_MAXIMUM_VOLUME(reagents) / length(reagent_ids))
	for(var/reagent in reagent_ids)
		var/has_reagent = REAGENT_VOLUME(reagents, GET_DECL(reagent))
		if(has_reagent < max_per_reagent)
			robot.cell.use(charge_cost)
			reagents.add_reagent(reagent, round(max_per_reagent - has_reagent))

/obj/item/chems/borghypo/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	var/list/reagent_ids = get_generated_reagents()
	if(REAGENT_VOLUME(reagents, GET_DECL(reagent_ids[mode])) <= 0)
		to_chat(user, SPAN_WARNING("The injector is empty."))
		return TRUE

	var/allow = target.can_inject(user, user.get_target_zone())
	if (allow)
		if (allow == INJECTION_PORT)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, target))
				return TRUE

		to_chat(user,   SPAN_NOTICE("You inject \the [target] with the injector."))
		to_chat(target, SPAN_NOTICE("You feel a tiny prick!"))

		if(target.reagents)
			var/t = min(amount_per_transfer_from_this, REAGENT_VOLUME(reagents, GET_DECL(reagent_ids[mode])))
			target.add_to_reagents(reagent_ids[mode], t)
			reagents.remove_reagent(reagent_ids[mode], t)
			admin_inject_log(user, target, src, reagent_ids[mode], t)
			to_chat(user, SPAN_NOTICE("[t] units injected. [REAGENT_VOLUME(reagents, GET_DECL(reagent_ids[mode])) || 0] unit\s remaining."))
		return TRUE

	return ..()

/obj/item/chems/borghypo/attack_self(mob/user) //Change the mode
	var/t = ""
	var/list/reagent_ids = get_generated_reagents()
	for(var/i = 1 to length(reagent_ids))
		var/decl/material/reagent = GET_DECL(reagent_ids[i])
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>[reagent.liquid_name]</b>"
		else
			t += "<a href='byond://?src=\ref[src];reagent_index=[i]'>[reagent.liquid_name]</a>"
	t = "Available reagents: [t]."
	to_chat(user, t)

	return

/obj/item/chems/borghypo/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["reagent_index"])
		var/list/reagent_ids = get_generated_reagents()
		var/index = text2num(href_list["reagent_index"])
		if(index > 0 && index <= reagent_ids.len)
			playsound(loc, 'sound/effects/pop.ogg', 50, 0)
			mode = index
			var/decl/material/reagent = GET_DECL(reagent_ids[mode])
			to_chat(user, SPAN_NOTICE("Synthesizer is now producing '[reagent.use_name]'."))
		return TOPIC_REFRESH

/obj/item/chems/borghypo/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	var/list/reagent_ids = get_generated_reagents()
	var/decl/material/reagent = GET_DECL(reagent_ids[mode])
	. += SPAN_NOTICE("It is currently producing [reagent.use_name] and has [REAGENT_VOLUME(reagents, reagent)] out of [round(REAGENT_MAXIMUM_VOLUME(reagents) / length(reagent_ids))] units left.")

/obj/item/chems/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispenser."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 5
	recharge_time = 3
	chem_volume = 60
	possible_transfer_amounts = @"[5,10,20,30]"

/obj/item/chems/borghypo/service/get_generated_reagents()
	var/static/list/_reagent_ids = list(
		/decl/material/liquid/alcohol/beer,
		/decl/material/liquid/alcohol/coffee,
		/decl/material/liquid/alcohol/whiskey,
		/decl/material/liquid/alcohol/wine,
		/decl/material/liquid/alcohol/vodka,
		/decl/material/liquid/alcohol/gin,
		/decl/material/liquid/alcohol/rum,
		/decl/material/liquid/alcohol/tequila,
		/decl/material/liquid/alcohol/vermouth,
		/decl/material/liquid/alcohol/cognac,
		/decl/material/liquid/alcohol/ale,
		/decl/material/liquid/alcohol/mead,
		/decl/material/liquid/water,
		/decl/material/liquid/nutriment/sugar,
		/decl/material/solid/ice,
		/decl/material/liquid/drink/tea/black,
		/decl/material/liquid/drink/cola,
		/decl/material/liquid/drink/citrussoda,
		/decl/material/liquid/drink/cherrycola,
		/decl/material/liquid/drink/lemonade,
		/decl/material/liquid/drink/tonic,
		/decl/material/liquid/drink/sodawater,
		/decl/material/liquid/drink/lemon_lime,
		/decl/material/liquid/drink/juice/orange,
		/decl/material/liquid/drink/juice/lime,
		/decl/material/liquid/drink/juice/watermelon,
		/decl/material/liquid/drink/coffee,
		/decl/material/liquid/drink/hot_coco,
		/decl/material/liquid/drink/tea/green,
		/decl/material/liquid/drink/citrussoda,
		/decl/material/liquid/alcohol/beer,
		/decl/material/liquid/alcohol/coffee
	)
	return _reagent_ids

/obj/item/chems/borghypo/service/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/chems/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!ATOM_IS_OPEN_CONTAINER(target) || !target.reagents)
		return

	var/list/reagent_ids = get_generated_reagents()
	if(REAGENT_VOLUME(reagents, GET_DECL(reagent_ids[mode])) <= 0)
		to_chat(user, "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>")
		return

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	var/t = min(amount_per_transfer_from_this, REAGENT_VOLUME(reagents, GET_DECL(reagent_ids[mode])))
	target.add_to_reagents(reagent_ids[mode], t)
	reagents.remove_reagent(reagent_ids[mode], t)
	to_chat(user, "<span class='notice'>You transfer [t] units of the solution to [target].</span>")
	return
