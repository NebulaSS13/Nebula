/obj/structure/flora/plant
	icon = 'icons/obj/hydroponics/hydroponics_growing.dmi'
	icon_state = "bush5-4"
	color = COLOR_GREEN
	var/growth_stage
	var/dead = FALSE
	var/sampled = FALSE
	var/datum/seed/plant
	var/harvestable

/obj/structure/flora/plant/large
	opacity = TRUE
	density = TRUE

/* Notes for future work moving logic off hydrotrays onto plants themselves:
/obj/structure/flora/plant/Process()
	// check our immediate environment
	// ask our environment for available reagents
	//    process the reagents
	// ask our environment for gas
	//    take gas/add gas from environment
	// ask our environment for light
	// update health
	// advance age
	// update icon/harvestability as appropriate
*/

/obj/structure/flora/plant/examine(mob/user, distance)
	. = ..()
	if(dead)
		to_chat(user, SPAN_OCCULT("It is dead."))
	else if(length(harvestable))
		to_chat(user, SPAN_NOTICE("You can see [length(harvestable)] harvestable fruit\s."))

/obj/structure/flora/plant/dismantle_structure(mob/user)
	if(plant)
		var/fail_chance = user ? user.skill_fail_chance(SKILL_BOTANY, 30, SKILL_ADEPT) : 30
		if(!prob(fail_chance))
			for(var/i = 1 to rand(1,3))
				new /obj/item/seeds(loc, null, plant)
	return ..()

/obj/structure/flora/plant/Initialize(ml, _mat, _reinf_mat, datum/seed/_plant)
	if(!plant && _plant)
		plant = _plant
	if(!plant)
		return INITIALIZE_HINT_QDEL
	name = plant.display_name
	desc = "A wild [name]."
	growth_stage = rand(round(plant.growth_stages * 0.65), plant.growth_stages)
	if(!dead)
		if(prob(50) && growth_stage >= plant.growth_stages)
			harvestable = rand(1, 3)
		if(plant.get_trait(TRAIT_BIOLUM))
			var/potency = plant.get_trait(TRAIT_POTENCY)
			set_light(l_range = max(1, round(potency/10)), l_power = clamp(round(potency/30), 0, 1), l_color = plant.get_trait(TRAIT_BIOLUM_COLOUR))
	update_icon()
	return ..()

/obj/structure/flora/plant/Destroy()
	plant = null
	. = ..()

/obj/structure/flora/plant/on_update_icon()
	. = ..()
	icon_state = "blank"
	color = null
	set_overlays(plant.get_appearance(dead = dead, growth_stage = growth_stage, can_harvest = length(harvestable)))

/obj/structure/flora/plant/attackby(obj/item/O, mob/user)

	if(IS_SHOVEL(O) || IS_HATCHET(O))
		user.visible_message(SPAN_NOTICE("\The [user] uproots \the [src] with \the [O]!"))
		physically_destroyed()
		return TRUE

	// Hydrotray boilerplate for taking samples.
	if(O.edge && O.w_class < ITEM_SIZE_NORMAL && user.a_intent != I_HURT)
		if(sampled)
			to_chat(user, SPAN_WARNING("There's no bits that can be used for a sampling left."))
			return TRUE
		if(dead)
			to_chat(user, SPAN_WARNING("The plant is dead."))
			return TRUE
		var/needed_skill = plant.mysterious ? SKILL_ADEPT : SKILL_BASIC
		if(prob(user.skill_fail_chance(SKILL_BOTANY, 90, needed_skill)))
			to_chat(user, SPAN_WARNING("You failed to get a usable sample."))
		else
			plant.harvest(user, harvest_sample = TRUE)
		sampled = prob(30)
		return TRUE

	. = ..()

/obj/structure/flora/plant/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()

	if(dead)
		user.visible_message(SPAN_NOTICE("\The [user] uproots the dead [name]!"))
		physically_destroyed()
		return TRUE
	if(harvestable <= 0)
		return ..()

	var/harvested = plant.harvest(user, force_amount = 1)
	if(harvested)
		if(!islist(harvested))
			harvested = list(harvested)
		harvestable -= length(harvested)
		for(var/thing in harvested)
			user.put_in_hands(thing)
		if(!harvestable)
			update_icon()
	return TRUE
