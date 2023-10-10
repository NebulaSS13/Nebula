////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/pill
	name = "pill"
	base_name = "pill"
	desc = "A pill."
	icon = 'icons/obj/items/chem/pill.dmi'
	icon_state = null
	item_state = "pill"
	randpixel = 7
	possible_transfer_amounts = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 30
	material = /decl/material/solid/plantmatter
	var/static/list/colorizable_icon_states = list("pill1", "pill2", "pill3", "pill4", "pill5") // if using an icon state from here, color will be derived from reagents

/obj/item/chems/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = pick(colorizable_icon_states) //preset pills only use colour changing or unique icons
	update_icon()

/obj/item/chems/pill/on_update_icon()
	. = ..()
	if(icon_state in colorizable_icon_states)
		color = reagents.get_color()
		alpha = 255 // above probably reset our alpha
	else
		color = null

/obj/item/chems/pill/attack_self(mob/user)
	attack(user, user)

/obj/item/chems/pill/dragged_onto(var/mob/user)
	attack(user, user)

/obj/item/chems/pill/attack(mob/M, mob/user, def_zone)
	//TODO: replace with standard_feed_mob() call.
	if(M == user)
		if(!M.can_eat(src))
			return
		M.visible_message(SPAN_NOTICE("[M] swallows a pill."), SPAN_NOTICE("You swallow \the [src]."), null, 2)
		if(reagents?.total_volume)
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
		user.visible_message(SPAN_NOTICE("\The [user] puts something in \the [target]."), range = 2)
		qdel(src)
	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//We lied - it's pills all the way down
/obj/item/chems/pill/antitox
	name = "antitoxins (25u)"
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"

/obj/item/chems/pill/antitox/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, 25)

/obj/item/chems/pill/bromide
	name = "bromide pill"
	desc = "Highly toxic."
	icon_state = "pill4"
	volume = 50

/obj/item/chems/pill/bromide/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/bromide, reagents.maximum_volume)

/obj/item/chems/pill/cyanide
	name = "strange pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pillC"
	volume = 50

/obj/item/chems/pill/cyanide/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/cyanide, reagents.maximum_volume)

/obj/item/chems/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/chems/pill/adminordrazine/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/adminordrazine, 1)

/obj/item/chems/pill/stox
	name = "sedatives (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill3"

/obj/item/chems/pill/stox/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/sedatives, 15)

/obj/item/chems/pill/burn_meds
	name = "synthskin (15u)"
	desc = "Used to treat burns."
	icon_state = "pill2"

/obj/item/chems/pill/burn_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/burn_meds, 15)

/obj/item/chems/pill/painkillers
	name = "painkillers (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"

/obj/item/chems/pill/painkillers/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/painkillers, 15)

/obj/item/chems/pill/strong_painkillers
	name = "strong painkillers (15u)"
	desc = "A powerful painkiller. Do not mix with alcohol consumption."
	icon_state = "pill3"

/obj/item/chems/pill/strong_painkillers/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/painkillers/strong, 15)

/obj/item/chems/pill/stabilizer
	name = "stabilizer (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill1"

/obj/item/chems/pill/stabilizer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stabilizer, 30)

/obj/item/chems/pill/oxygen
	name = "oxygen (15u)"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"

/obj/item/chems/pill/oxygen/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/oxy_meds, 15)

/obj/item/chems/pill/antitoxins
	name = "antitoxins (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"

/obj/item/chems/pill/antitoxins/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, 15)

/obj/item/chems/pill/brute_meds
	name = "styptic (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"

/obj/item/chems/pill/brute_meds/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/brute_meds, 20)

/obj/item/chems/pill/happy
	name = "happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill4"

/obj/item/chems/pill/happy/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/psychoactives,   15)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 15)

/obj/item/chems/pill/zoom
	name = "zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"

/obj/item/chems/pill/zoom/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/narcotics,       5)
	reagents.add_reagent(/decl/material/liquid/antidepressants, 5)
	reagents.add_reagent(/decl/material/liquid/stimulants,      5)
	reagents.add_reagent(/decl/material/liquid/amphetamines,    5)

/obj/item/chems/pill/gleam
	name = "strange pill"
	desc = "The surface of this unlabelled pill crawls against your skin."
	icon_state = "pill2"

/obj/item/chems/pill/gleam/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/glowsap/gleam, 10)

/obj/item/chems/pill/antibiotics
	name = "antibiotics (10u)"
	desc = "Contains antibiotic agents."
	icon_state = "pill3"

/obj/item/chems/pill/antibiotics/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antibiotics, 10)

//Psychiatry pills.
/obj/item/chems/pill/stimulants
	name = "stimulants (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"

/obj/item/chems/pill/stimulants/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stimulants, 15)

/obj/item/chems/pill/antidepressants
	name = "antidepressants (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"

/obj/item/chems/pill/antidepressants/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antidepressants, 15)

/obj/item/chems/pill/antirads
	name = "antirads (7u)"
	desc = "Used to treat radiation poisoning."
	icon_state = "pill1"

/obj/item/chems/pill/antirads/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antirads, 7)

/obj/item/chems/pill/antirad
	name = "AntiRad"
	desc = "Used to treat radiation poisoning."
	icon_state = "yellow"

/obj/item/chems/pill/antirad/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antirads,   5)
	reagents.add_reagent(/decl/material/liquid/antitoxins, 10)

/obj/item/chems/pill/sugariron
	name = "Sugar-Iron (10u)"
	desc = "Used to help the body naturally replenish blood."
	icon_state = "pill1"

/obj/item/chems/pill/sugariron/populate_reagents()
	reagents.add_reagent(/decl/material/solid/metal/iron,       5)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 5)

/obj/item/chems/pill/detergent
	name = "detergent pod"
	desc = "Put in water to get space cleaner. Do not eat. Really."
	icon_state = "pod21"
	var/smell_clean_time = 10 MINUTES

// Don't overwrite the custom name.
/obj/item/chems/pill/detergent/update_container_name()
	return

/obj/item/chems/pill/detergent/populate_reagents()
	reagents.add_reagent(/decl/material/gas/ammonia, 30)

/obj/item/chems/pill/pod
	name = "master flavorpod item"
	desc = "A cellulose pod containing some kind of flavoring."
	icon_state = "pill4"

// Don't overwrite the custom names.
/obj/item/chems/pill/pod/update_container_name()
	return

/obj/item/chems/pill/pod/cream
	name = "creamer pod"

/obj/item/chems/pill/pod/cream/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/milk, 5)

/obj/item/chems/pill/pod/cream_soy
	name = "non-dairy creamer pod"

/obj/item/chems/pill/pod/cream_soy/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/milk/soymilk, 5)

/obj/item/chems/pill/pod/orange
	name = "orange flavorpod"

/obj/item/chems/pill/pod/orange/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/juice/orange, 5)

/obj/item/chems/pill/pod/mint
	name = "mint flavorpod"

/obj/item/chems/pill/pod/mint/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/syrup/mint, 1)
