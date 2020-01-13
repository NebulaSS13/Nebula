////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	randpixel = 7
	possible_transfer_amounts = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 30

/obj/item/chems/pill/New()
	..()
	if(!icon_state)
		icon_state = "pill[rand(1, 5)]" //preset pills only use colour changing or unique icons

/obj/item/chems/pill/attack(mob/M as mob, mob/user as mob, def_zone)
		//TODO: replace with standard_feed_mob() call.

	if(M == user)
		if(!M.can_eat(src))
			return

		M.visible_message(SPAN_NOTICE("[M] swallows a pill."), SPAN_NOTICE("You swallow \the [src]."), null, 2)
		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return 1

	else if(istype(M, /mob/living/carbon/human))
		if(!M.can_force_feed(user, src))
			return

		user.visible_message(SPAN_WARNING("[user] attempts to force [M] to swallow \the [src]."))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, M))
			return
		user.visible_message(SPAN_WARNING("[user] forces [M] to swallow \the [src]."))
		var/contained = REAGENT_LIST(src)
		admin_attack_log(user, M, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")
		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return 1

	return 0

/obj/item/chems/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(ATOM_IS_OPEN_CONTAINER(target) && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty. Can't dissolve \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You dissolve \the [src] in [target].</span>")

		admin_attacker_log(user, "spiked \a [target] with a pill. Reagents: [REAGENT_LIST(src)]")
		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)
		qdel(src)
	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//We lied - it's pills all the way down
/obj/item/chems/pill/antitox
	name = "Dylovene (25u)"
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"
/obj/item/chems/pill/antitox/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 25)
	color = reagents.get_color()


/obj/item/chems/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill4"
	volume = 50
/obj/item/chems/pill/tox/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin, 50)
	color = reagents.get_color()


/obj/item/chems/pill/cyanide
	name = "strange pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pillC"
	volume = 50
/obj/item/chems/pill/cyanide/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/cyanide, 50)


/obj/item/chems/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/chems/pill/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/adminordrazine, 1)

/obj/item/chems/pill/stox
	name = "Soporific (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill3"
/obj/item/chems/pill/stox/New()
	..()
	reagents.add_reagent(/datum/reagent/soporific, 15)
	color = reagents.get_color()


/obj/item/chems/pill/kelotane
	name = "Kelotane (15u)"
	desc = "Used to treat burns."
	icon_state = "pill2"
/obj/item/chems/pill/kelotane/New()
	..()
	reagents.add_reagent(/datum/reagent/kelotane, 15)
	color = reagents.get_color()


/obj/item/chems/pill/paracetamol
	name = "Paracetamol (15u)"
	desc = "A painkiller for the ages. Chewables!"
	icon_state = "pill3"
/obj/item/chems/pill/paracetamol/New()
	..()
	reagents.add_reagent(/datum/reagent/paracetamol, 15)
	color = reagents.get_color()


/obj/item/chems/pill/tramadol
	name = "Tramadol (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"
/obj/item/chems/pill/tramadol/New()
	..()
	reagents.add_reagent(/datum/reagent/tramadol, 15)
	color = reagents.get_color()


/obj/item/chems/pill/inaprovaline
	name = "Inaprovaline (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill1"
/obj/item/chems/pill/inaprovaline/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 30)
	color = reagents.get_color()


/obj/item/chems/pill/dexalin
	name = "Dexalin (15u)"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"
/obj/item/chems/pill/dexalin/New()
	..()
	reagents.add_reagent(/datum/reagent/dexalin, 15)
	color = reagents.get_color()


/obj/item/chems/pill/dexalin_plus
	name = "Dexalin Plus (15u)"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill2"
/obj/item/chems/pill/dexalin_plus/New()
	..()
	reagents.add_reagent(/datum/reagent/dexalinp, 15)
	color = reagents.get_color()


/obj/item/chems/pill/dermaline
	name = "Dermaline (15u)"
	desc = "Used to treat burn wounds."
	icon_state = "pill2"
/obj/item/chems/pill/dermaline/New()
	..()
	reagents.add_reagent(/datum/reagent/dermaline, 15)
	color = reagents.get_color()


/obj/item/chems/pill/dylovene
	name = "Dylovene (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"
/obj/item/chems/pill/dylovene/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 15)
	color = reagents.get_color()


/obj/item/chems/pill/bicaridine
	name = "Bicaridine (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"
/obj/item/chems/pill/bicaridine/New()
	..()
	reagents.add_reagent(/datum/reagent/bicaridine, 20)
	color = reagents.get_color()


/obj/item/chems/pill/happy
	name = "happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill4"
/obj/item/chems/pill/happy/New()
	..()
	reagents.add_reagent(/datum/reagent/space_drugs, 15)
	reagents.add_reagent(/datum/reagent/sugar, 15)
	color = reagents.get_color()


/obj/item/chems/pill/zoom
	name = "zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"
/obj/item/chems/pill/zoom/New()
	..()
	reagents.add_reagent(/datum/reagent/impedrezene, 10)
	reagents.add_reagent(/datum/reagent/synaptizine, 5)
	reagents.add_reagent(/datum/reagent/hyperzine, 5)
	color = reagents.get_color()

/obj/item/chems/pill/three_eye
	name = "strange pill"
	desc = "The surface of this unlabelled pill crawls against your skin."
	icon_state = "pill2"

/obj/item/chems/pill/three_eye/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/three_eye, 10)
	color = reagents.get_color()

/obj/item/chems/pill/spaceacillin
	name = "Spaceacillin (10u)"
	desc = "Contains antiviral agents."
	icon_state = "pill3"
/obj/item/chems/pill/spaceacillin/New()
	..()
	reagents.add_reagent(/datum/reagent/spaceacillin, 10)
	color = reagents.get_color()


/obj/item/chems/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill4"
/obj/item/chems/pill/diet/New()
	..()
	reagents.add_reagent(/datum/reagent/lipozine, 2)
	color = reagents.get_color()


/obj/item/chems/pill/noexcutite
	name = "Noexcutite (15u)"
	desc = "Feeling jittery? This should calm you down."
	icon_state = "pill4"
obj/item/chems/pill/noexcutite/New()
	..()
	reagents.add_reagent(/datum/reagent/noexcutite, 15)
	color = reagents.get_color()


/obj/item/chems/pill/antidexafen
	name = "Antidexafen (15u)"
	desc = "Common cold mediciation. Safe for babies!"
	icon_state = "pill4"
/obj/item/chems/pill/antidexafen/New()
	..()
	reagents.add_reagent(/datum/reagent/antidexafen, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/lemon, 5)
	reagents.add_reagent(/datum/reagent/menthol, REM*0.2)
	color = reagents.get_color()

//Psychiatry pills.
/obj/item/chems/pill/methylphenidate
	name = "Methylphenidate (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"
/obj/item/chems/pill/methylphenidate/New()
	..()
	reagents.add_reagent(/datum/reagent/methylphenidate, 15)
	color = reagents.get_color()


/obj/item/chems/pill/citalopram
	name = "Citalopram (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"
/obj/item/chems/pill/citalopram/New()
	..()
	reagents.add_reagent(/datum/reagent/citalopram, 15)
	color = reagents.get_color()


/obj/item/chems/pill/paroxetine
	name = "Paroxetine (10u)"
	desc = "Before you swallow a bullet: try swallowing this!"
	icon_state = "pill4"
/obj/item/chems/pill/paroxetine/New()
	..()
	reagents.add_reagent(/datum/reagent/paroxetine, 10)
	color = reagents.get_color()


/obj/item/chems/pill/hyronalin
	name = "Hyronalin (7u)"
	desc = "Used to treat radiation poisoning."
	icon_state = "pill1"
/obj/item/chems/pill/hyronalin/New()
	..()
	reagents.add_reagent(/datum/reagent/hyronalin, 7)
	color = reagents.get_color()

/obj/item/chems/pill/antirad
	name = "AntiRad"
	desc = "Used to treat radiation poisoning."
	icon_state = "yellow"
/obj/item/chems/pill/antirad/New()
	..()
	reagents.add_reagent(/datum/reagent/hyronalin, 5)
	reagents.add_reagent(/datum/reagent/dylovene, 10)


/obj/item/chems/pill/sugariron
	name = "Sugar-Iron (10u)"
	desc = "Used to help the body naturally replenish blood."
	icon_state = "pill1"
/obj/item/chems/pill/sugariron/New()
	..()
	reagents.add_reagent(/datum/reagent/iron, 5)
	reagents.add_reagent(/datum/reagent/sugar, 5)
	color = reagents.get_color()

/obj/item/chems/pill/detergent
	name = "detergent pod"
	desc = "Put in water to get space cleaner. Do not eat. Really."
	icon_state = "pod21"
	var/smell_clean_time = 10 MINUTES

/obj/item/chems/pill/detergent/New()
	..()
	reagents.add_reagent(/datum/reagent/ammonia, 30)

/obj/item/chems/pill/pod
	name = "master flavorpod item"
	desc = "A cellulose pod containing some kind of flavoring."
	icon_state = "pill4"

/obj/item/chems/pill/pod/cream
	name = "creamer pod"

/obj/item/chems/pill/pod/cream/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/milk, 5)
	color = reagents.get_color()

/obj/item/chems/pill/pod/cream_soy
	name = "non-dairy creamer pod"

/obj/item/chems/pill/pod/cream_soy/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/milk/soymilk, 5)
	color = reagents.get_color()

/obj/item/chems/pill/pod/orange
	name = "orange flavorpod"

/obj/item/chems/pill/pod/orange/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 5)
	color = reagents.get_color()

/obj/item/chems/pill/pod/mint
	name = "mint flavorpod"

/obj/item/chems/pill/pod/mint/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/mint, 1) //mint is used as a catalyst in all reactions as of writing
	color = reagents.get_color()
