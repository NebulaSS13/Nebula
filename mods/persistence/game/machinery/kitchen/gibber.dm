/obj/machinery/gibber/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='danger'>You hear a loud metallic grinding sound.</span>")
		return

	use_power_oneoff(1000)
	visible_message("<span class='danger'>You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound.</span>")
	src.operating = 1
	update_icon()

	admin_attack_log(user, occupant, "Gibbed the victim", "Was gibbed", "gibbed")
	addtimer(CALLBACK(src, .proc/finish_gibbing), gib_time)

	var/list/gib_products = shuffle(occupant.harvest_meat() | occupant.harvest_skin() | occupant.harvest_bones())
	if(length(gib_products) <= 0)
		return

	var/slab_name =  occupant.name
	var/slab_nutrition = 20

	if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		slab_nutrition = C.nutrition / 15

	if(istype(occupant, /mob/living/carbon/human))
		slab_name = occupant.real_name

	// Small mobs don't give as much nutrition.
	if(issmall(src.occupant))
		slab_nutrition *= 0.5

	slab_nutrition /= gib_products.len

	var/drop_products = Floor(gib_products.len * 0.35)
	for(var/atom/movable/thing in gib_products)
		if(drop_products)
			drop_products--
			qdel(thing)
		else
			thing.forceMove(src)
			if(istype(thing, /obj/item/weapon/reagent_containers/food/snacks/meat))
				var/obj/item/weapon/reagent_containers/food/snacks/meat/slab = thing
				slab.SetName("[slab_name] [slab.name]")
				slab.reagents.add_reagent(/datum/reagent/nutriment,slab_nutrition)
