/obj/item/chems/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/decl/reagent/regenerator, /decl/reagent/adrenaline, /decl/reagent/antibiotics)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/chems/borghypo/surgeon
	reagent_ids = list(/decl/reagent/brute_meds, /decl/reagent/oxy_meds, /decl/reagent/painkillers)

/obj/item/chems/borghypo/crisis
	reagent_ids = list(/decl/reagent/regenerator, /decl/reagent/adrenaline, /decl/reagent/painkillers)

/obj/item/chems/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/decl/reagent/R = T
		reagent_names += initial(R.name)

/obj/item/chems/borghypo/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/chems/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/chems/borghypo/Process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/chems/borghypo/attack(var/mob/living/M, var/mob/user, var/target_zone)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='warning'>The injector is empty.</span>")
		return

	var/allow = M.can_inject(user, target_zone)
	if (allow)
		if (allow == INJECTION_PORT)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M))
				return
		to_chat(user, "<span class='notice'>You inject [M] with the injector.</span>")
		to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			admin_inject_log(user, M, src, reagent_ids[mode], t)
			to_chat(user, "<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>")
	return

/obj/item/chems/borghypo/attack_self(mob/user) //Change the mode
	var/t = ""
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>[reagent_names[i]]</b>"
		else
			t += "<a href='?src=\ref[src];reagent_index=[i]'>[reagent_names[i]]</a>"
	t = "Available reagents: [t]."
	to_chat(user, t)

	return

/obj/item/chems/borghypo/OnTopic(var/href, var/list/href_list)
	if(href_list["reagent_index"])
		var/index = text2num(href_list["reagent_index"])
		if(index > 0 && index <= reagent_ids.len)
			playsound(loc, 'sound/effects/pop.ogg', 50, 0)
			mode = index
			var/decl/reagent/R = reagent_ids[mode]
			to_chat(usr, "<span class='notice'>Synthesizer is now producing '[initial(R.name)]'.</span>")
		return TOPIC_REFRESH

/obj/item/chems/borghypo/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	var/decl/reagent/R = reagent_ids[mode]
	to_chat(user, "<span class='notice'>It is currently producing [initial(R.name)] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>")

/obj/item/chems/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 5
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = @"[5,10,20,30]"
	reagent_ids = list(
		/decl/reagent/ethanol/beer,
		/decl/reagent/ethanol/coffee/kahlua,
		/decl/reagent/ethanol/whiskey,
		/decl/reagent/ethanol/wine,
		/decl/reagent/ethanol/vodka,
		/decl/reagent/ethanol/gin,
		/decl/reagent/ethanol/rum,
		/decl/reagent/ethanol/tequilla,
		/decl/reagent/ethanol/vermouth,
		/decl/reagent/ethanol/cognac,
		/decl/reagent/ethanol/ale,
		/decl/reagent/ethanol/mead,
		/decl/reagent/water,
		/decl/reagent/nutriment/sugar,
		/decl/reagent/drink/ice,
		/decl/reagent/drink/tea/black,
		/decl/reagent/drink/cola,
		/decl/reagent/drink/citrussoda,
		/decl/reagent/drink/cherrycola,
		/decl/reagent/drink/lemonade,
		/decl/reagent/drink/tonic,
		/decl/reagent/drink/sodawater,
		/decl/reagent/drink/lemon_lime,
		/decl/reagent/drink/juice/orange,
		/decl/reagent/drink/juice/lime,
		/decl/reagent/drink/juice/watermelon,
		/decl/reagent/drink/coffee,
		/decl/reagent/drink/hot_coco,
		/decl/reagent/drink/tea/green,
		/decl/reagent/drink/citrussoda,
		/decl/reagent/ethanol/beer,
		/decl/reagent/ethanol/coffee/kahlua
		)

/obj/item/chems/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/chems/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!ATOM_IS_OPEN_CONTAINER(target) || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>")
		return

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	to_chat(user, "<span class='notice'>You transfer [t] units of the solution to [target].</span>")
	return
