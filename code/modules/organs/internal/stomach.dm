/obj/item/organ/internal/stomach
	name = "stomach"
	desc = "Gross. This is hard to stomach."
	icon_state = "stomach"
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	var/stomach_capacity
	var/datum/reagents/metabolism/ingested
	var/next_cramp = 0

/obj/item/organ/internal/stomach/Destroy()
	QDEL_NULL(ingested)
	. = ..()

/obj/item/organ/internal/stomach/set_species(species_name)
	if(species?.gluttonous)
		verbs -= /obj/item/organ/internal/stomach/proc/throw_up
	. = ..()
	if(species.gluttonous)
		verbs |= /obj/item/organ/internal/stomach/proc/throw_up
	if(species && !stomach_capacity)
		stomach_capacity = species.stomach_capacity

/obj/item/organ/internal/stomach/initialize_reagents(populate)
	if(!ingested)
		ingested = new/datum/reagents/metabolism(240, (owner || src), CHEM_INGEST)
	if(!ingested.my_atom)
		ingested.my_atom = src
	. = ..()

/obj/item/organ/internal/stomach/do_uninstall(in_place, detach, ignore_children)
	. = ..()
	if(ingested) //Don't bother if we're destroying
		ingested.my_atom = src
		ingested.parent = null

/obj/item/organ/internal/stomach/do_install()
	. = ..()
	ingested.my_atom = owner
	ingested.parent = owner

/obj/item/organ/internal/stomach/proc/can_eat_atom(var/atom/movable/food)
	return !isnull(get_devour_time(food))

/obj/item/organ/internal/stomach/proc/is_full(var/atom/movable/food)
	var/total = floor(ingested.total_volume / 10)
	for(var/a in contents + food)
		if(ismob(a))
			var/mob/M = a
			total += M.mob_size
		else if(isobj(a))
			var/obj/item/I = a
			total += I.get_storage_cost()
		else
			continue
		if(total > stomach_capacity)
			return TRUE
	return FALSE

/obj/item/organ/internal/stomach/proc/get_devour_time(var/atom/movable/food)
	if(isliving(food))
		var/mob/living/L = food
		if((species.gluttonous & GLUT_TINY) && (L.mob_size <= MOB_SIZE_TINY) && !ishuman(food)) // Anything MOB_SIZE_TINY or smaller
			return DEVOUR_SLOW
		else if((species.gluttonous & GLUT_SMALLER) && owner.mob_size > L.mob_size) // Anything we're larger than
			return DEVOUR_SLOW
		else if(species.gluttonous & GLUT_ANYTHING) // Eat anything ever
			return DEVOUR_FAST
	else if(istype(food, /obj/item) && !istype(food, /obj/item/holder)) //Don't eat holders. They are special.
		var/obj/item/I = food
		var/cost = I.get_storage_cost()
		if(!(I.obj_flags & OBJ_FLAG_NO_STORAGE))
			if((species.gluttonous & GLUT_ITEM_TINY) && cost < ITEM_SIZE_LARGE)
				return DEVOUR_SLOW
			else if((species.gluttonous & GLUT_ITEM_NORMAL) && cost <= ITEM_SIZE_LARGE)
				return DEVOUR_SLOW
			else if(species.gluttonous & GLUT_ITEM_ANYTHING)
				return DEVOUR_FAST

/obj/item/organ/internal/stomach/proc/throw_up()
	set name = "Empty Stomach"
	set category = "IC"
	set src in usr
	if(usr == owner && owner && !owner.incapacitated())
		owner.vomit(deliberate = TRUE)

/obj/item/organ/internal/stomach/return_air()
	return null

#define STOMACH_VOLUME 65

/obj/item/organ/internal/stomach/Process()
	..()

	if(owner)
		var/functioning = is_usable()
		if(damage >= min_bruised_damage && prob((damage / max_damage) * 100))
			functioning = FALSE

		if(functioning)
			for(var/mob/living/M in contents)
				if(M.stat == DEAD)
					qdel(M)
					continue

				M.take_damage(3,       do_update_health = FALSE)
				M.take_damage(3, BURN, do_update_health = FALSE)
				M.take_damage(3, TOX)

				var/digestion_product = M.get_digestion_product()
				if(digestion_product)
					ingested.add_reagent(digestion_product, rand(1,3))

		else if(world.time >= next_cramp)
			next_cramp = world.time + rand(200,800)
			owner.custom_pain("Your stomach cramps agonizingly!",1)

		var/alcohol_volume = REAGENT_VOLUME(ingested, /decl/material/liquid/ethanol)

		var/alcohol_threshold_met = alcohol_volume > STOMACH_VOLUME / 2
		if(alcohol_threshold_met && owner.has_genetic_condition(GENE_COND_EPILEPSY) && prob(20))
			owner.seizure()

		// Alcohol counts as double volume for the purposes of vomit probability
		var/effective_volume = ingested.total_volume + alcohol_volume

		// Just over the limit, the probability will be low. It rises a lot such that at double ingested it's 64% chance.
		var/vomit_probability = (effective_volume / STOMACH_VOLUME) ** 6
		if(prob(vomit_probability))
			owner.vomit()

#undef STOMACH_VOLUME
