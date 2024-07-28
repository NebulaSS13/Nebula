/decl/insect_species
	abstract_type   = /decl/insect_species

	// Descriptive strings for individual insects and swarms.
	var/name_singular
	var/name_plural
	var/insect_desc

	// Vars for nest description and products.
	var/nest_name
	var/constructed_nest_name
	var/list/produce_reagents
	var/decl/material/produce_material
	var/produce_material_amount = 1
	var/native_frame_name = "comb"
	var/native_frame_desc = "A wax comb from an insect nest."
	var/native_frame_type = /obj/item/hive_frame/comb

	// Visual appearance and behavior of swarms.
	var/swarm_desc
	var/swarm_color = COLOR_BROWN
	var/swarm_icon  = 'mods/content/insects/icons/swarm.dmi'
	var/swarm_type  = /obj/effect/insect_swarm
	var/max_swarm_intensity = 100

	// Venom delivered by swarms whens stinging a victim.
	var/sting_reagent
	var/sting_amount

/decl/insect_species/Initialize()
	if(produce_material)
		produce_material = GET_DECL(produce_material)
	return ..()

/decl/insect_species/validate()
	. = ..()

	if(!name_singular)
		. += "no singular name set"
	if(!name_plural)
		. += "no plural name set"
	if(!nest_name)
		. += "no nest name set"
	if(!constructed_nest_name)
		. += "no constructed nest name set"
	if(!insect_desc)
		. += "no insect desc set"

	if(swarm_type)
		if(!ispath(swarm_type, /obj/effect/insect_swarm))
			. += "invalid swarm path (must be /obj/effect/insect_swarm or subtype): '[swarm_type]'"
		if(!swarm_desc)
			. += "no swarm description set"

	if(produce_reagents)
		if(!length(produce_reagents) || !islist(produce_reagents))
			. += "empty or non-list produce_reagents"
		else
			var/total = 0
			for(var/reagent in produce_reagents)
				if(!ispath(reagent, /decl/material))
					. += "non-material produce_reagents entry '[reagent]'"
					continue
				var/amt = produce_reagents[reagent]
				if(!isnum(amt) || amt <= 0)
					. += "non-numerical or 0 produce_reagents value: '[reagent]', '[amt]'"
				total += amt
			if(total != 1)
				. += "produce_reagents weighting does not sum to 1: '[total]'"

	if(produce_material)
		if(!isnum(produce_material_amount) || produce_material_amount <= 0)
			. += "non-numeric or zero produce amount: '[produce_material_amount]'"
		if(!istype(produce_material, /decl/material))
			. += "non-material product material type: '[produce_material]'"

/decl/insect_species/proc/fill_hive_frame(obj/item/frame)

	if(!istype(frame) || QDELETED(frame))
		return

	if(frame.reagents?.maximum_volume && length(produce_reagents))
		var/reagent_split = max(1, floor(min(REAGENTS_FREE_SPACE(frame.reagents), 20) / length(produce_reagents)))
		for(var/reagent in produce_reagents)
			frame.reagents.add_reagent(reagent, max(1, (reagent_split * produce_reagents[reagent])), defer_update = TRUE)
		frame.reagents.update_total()

	if(produce_material && (frame.material != produce_material) && !(locate(/obj/item/stack/material/lump) in frame))
		produce_material.create_object(frame, produce_material_amount, /obj/item/stack/material/lump)

/decl/insect_species/proc/try_sting(obj/effect/insect_swarm/swarm, atom/loc)
	if(!istype(swarm) || QDELETED(swarm) || !istype(loc))
		return FALSE
	// If we're agitated, always sting. Otherwise, % chance equal to a quarter of our overall swarm intensity.
	if(!swarm.is_agitated() && !prob(max(1, round(swarm.swarm_intensity/4))))
		return FALSE
	var/sting_mult = sting_amount * clamp(round(swarm.swarm_intensity/10), 1, 10)
	for(var/mob/living/victim in loc)
		if(!victim.simulated || victim.stat || victim.current_posture?.prone)
			continue
		var/datum/reagents/injected_reagents = victim.get_injected_reagents()
		var/obj/item/organ/external/affecting = victim.get_organ(pick(global.all_limb_tags))
		if(!affecting || BP_IS_PROSTHETIC(affecting) || BP_IS_CRYSTAL(affecting))
			continue
		if(injected_reagents && victim.can_inject(victim, affecting.organ_tag))
			injected_reagents.add_reagent(sting_reagent, sting_mult)
			affecting.add_pain(sting_mult)
			if(sting_mult <= sting_amount * 2)
				to_chat(victim, SPAN_DANGER("You are stung on your [affecting.name] by \a [swarm]!"))
			else
				to_chat(victim, SPAN_DANGER("You are stung multiple times on your [affecting.name] by \a [swarm]!"))
			. = TRUE

/decl/insect_species/proc/process_hive(datum/extension/insect_hive/hive_metadata)

	// Sanity check.
	var/atom/movable/hive = hive_metadata.holder
	if(!istype(hive) || !swarm_type || !istype(hive_metadata))
		return

	// Reduce swarms if we have too many.
	var/swarm_intensity = hive_metadata.get_total_swarm_intensity()
	if(swarm_intensity > max_swarm_intensity)
		var/obj/effect/insect_swarm/swarm = hive_metadata.swarms[1]
		swarm.adjust_swarm_intensity(-(swarm_intensity-max_swarm_intensity))
		return

	// Try to grow an existing swarm until we're at our max.
	if(hive_metadata.has_reserves(15) && length(hive_metadata.swarms))
		for(var/obj/effect/insect_swarm/swarm as anything in hive_metadata.swarms)
			if(swarm.can_grow() && hive_metadata.consume_reserves(15))
				swarm.adjust_swarm_intensity(rand(3,5))
				return

	// Create a new swarm.
	if(swarm_intensity < max_swarm_intensity && hive.loc && hive_metadata.has_reserves(15))

		var/obj/effect/insect_swarm/swarm
		for(var/obj/effect/insect_swarm/check_swarm as anything in hive_metadata.swarms)
			if(check_swarm.loc == hive.loc && check_swarm.swarm_intensity < 100)
				swarm = check_swarm
				break

		if(!swarm)
			swarm = new swarm_type(hive.loc, src, hive_metadata)

		if(!QDELETED(swarm) && istype(swarm) && hive_metadata.consume_reserves(15))
			LAZYDISTINCTADD(hive_metadata.swarms, swarm)
			swarm.adjust_swarm_intensity(min((max_swarm_intensity-swarm_intensity), rand(3,5)))

// Specific subtypes follow.
/decl/insect_species/honeybees
	name_singular         = "honeybee"
	name_plural           = "honeybees"
	nest_name             = "beehive"
	native_frame_name     = "honeycomb"
	native_frame_desc     = "A lattice of hexagonal wax cells usually filled with honey."
	native_frame_type     = /obj/item/hive_frame/comb/honeypot_ant
	constructed_nest_name = "apiary"
	swarm_desc            = "A swarm of buzzing honeybees."
	insect_desc           = "A single buzzing honeybee."
	swarm_color           = COLOR_GOLD
	swarm_type            = /obj/effect/insect_swarm/pollinator
	sting_reagent         = /decl/material/liquid/bee_venom
	sting_amount          = 1
	produce_reagents      = list(/decl/material/liquid/nutriment/honey = 1)
	produce_material      = /decl/material/solid/organic/wax

/decl/insect_species/ants
	name_singular         = "ant"
	name_plural           = "ants"
	nest_name             = "anthill"
	native_frame_name     = "honeypot ant"
	native_frame_desc     = "A wiggling, bulbous honeypot ant."
	constructed_nest_name = "ant farm"
	swarm_desc            = "A column of marching ants."
	insect_desc           = "A single ant."
	swarm_color           = COLOR_GRAY20
	swarm_type            = /obj/effect/insect_swarm/forager
	sting_reagent         = /decl/material/liquid/bee_venom
	sting_amount          = 1
	produce_reagents      = list(/decl/material/liquid/nutriment/honey = 1)
	produce_material      = /decl/material/solid/organic/wax
