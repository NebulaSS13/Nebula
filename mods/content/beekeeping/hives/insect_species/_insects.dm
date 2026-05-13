/decl/insect_species
	abstract_type   = /decl/insect_species

	// Descriptive strings for individual insects and swarms.
	var/name_singular
	var/name_plural
	var/insect_desc

	// Vars for nest description and products.
	var/nest_name
	var/list/produce_reagents
	var/decl/material/produce_material
	var/produce_material_amount = 1
	var/native_frame_name = "comb"
	var/native_frame_desc = "A wax comb from an insect nest."
	var/native_frame_type = /obj/item/hive_frame/comb

	// Visual appearance and behavior of swarms.
	var/swarm_desc
	var/swarm_color = COLOR_BROWN
	var/swarm_icon  = 'mods/content/beekeeping/icons/swarm.dmi'
	var/swarm_type  = /obj/effect/insect_swarm
	var/max_swarm_growth_intensity = 50
	var/max_swarm_intensity = 100
	var/max_swarm_state = 6

	// Venom delivered by swarms whens stinging a victim.
	var/sting_reagent
	var/sting_amount
	var/per_sting_reagents = 0.1
	var/per_sting_pain     = 1

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

	if(!swarm_icon)
		. += "null swarm icon"
	else
		for(var/i = 0 to max_swarm_state)
			var/check_state = num2text(i)
			if(!check_state_in_icon(check_state, swarm_icon))
				. += "missing active icon_state '[check_state]'"
			check_state = "[check_state]_smoked"
			if(!check_state_in_icon(check_state, swarm_icon))
				. += "missing smoked icon_state '[check_state]'"

/decl/insect_species/proc/fill_hive_frame(obj/item/frame)

	if(!istype(frame) || QDELETED(frame))
		return FALSE

	var/frame_space = REAGENTS_FREE_SPACE(frame.reagents)
	if(frame_space <= 0)
		return FALSE

	if(REAGENT_MAXIMUM_VOLUME(frame.reagents) && length(produce_reagents))
		var/reagent_split = max(1, floor(min(REAGENTS_FREE_SPACE(frame.reagents), 20) / length(produce_reagents)))
		for(var/reagent in produce_reagents)
			frame.reagents.add_reagent(reagent, max(1, (reagent_split * produce_reagents[reagent])), defer_update = TRUE)
		frame.reagents.handle_update()
	if(produce_material && (frame.material != produce_material) && !(locate(/obj/item/stack/material/lump) in frame))
		for(var/atom/movable/thing in produce_material.create_object(frame, produce_material_amount, /obj/item/stack/material/lump))
			thing.forceMove(frame)
	return TRUE

/decl/insect_species/proc/try_sting(obj/effect/insect_swarm/swarm, atom/loc)
	if(!istype(swarm) || QDELETED(swarm) || !istype(loc))
		return FALSE
	// If we're agitated, always sting. Otherwise, % chance equal to a quarter of our overall swarm intensity.
	if(!swarm.is_agitated() && !prob(max(1, round(swarm.swarm_intensity/4))))
		return FALSE
	var/base_sting_chance = (sting_amount * clamp(round(swarm.swarm_intensity/10), 1, 10))
	var/sting_mult = swarm.is_agitated() ? max(base_sting_chance, 15) : base_sting_chance
	for(var/mob/living/victim in loc)
		if(!victim.simulated || victim.stat || victim.current_posture?.prone)
			continue
		var/datum/reagents/injected_reagents = victim.get_injected_reagents()
		var/obj/item/organ/external/affecting = victim.get_organ(pick(global.all_limb_tags))
		if(!affecting || BP_IS_PROSTHETIC(affecting) || BP_IS_CRYSTAL(affecting))
			continue
		if(!injected_reagents || !victim.can_inject(null, affecting.organ_tag))
			continue

		to_chat(victim, SPAN_DANGER("\A [swarm] stings you [sting_mult <= sting_amount * 2 ? "" : "multiple times"] on your [affecting.name]!"))

		var/sting_venom = (per_sting_reagents * sting_mult) - REAGENT_VOLUME(injected_reagents, sting_reagent)
		if(sting_venom > 0)
			injected_reagents.add_reagent(sting_reagent, sting_venom)

		var/sting_pain = (per_sting_pain * sting_mult) - victim.getHalLoss()
		if(sting_pain > 0)
			affecting.add_pain(sting_pain)

		. = TRUE

/decl/insect_species/proc/can_spawn_in_flora(var/obj/structure/flora)

	// Territory range.
	for(var/obj/structure/flora/plant in view(flora, 7))
		if(has_extension(plant, /datum/extension/insect_hive))
			return FALSE

	// Food source.
	for(var/obj/machinery/portable_atmospherics/hydroponics/flower in view(flora, 7))
		if(flower.seed?.produces_pollen)
			return TRUE

	for(var/obj/structure/flora/plant/flower in view(flora, 7))
		if(flower.plant?.produces_pollen)
			return TRUE


	return FALSE

/decl/insect_species/proc/process_hive(datum/extension/insect_hive/hive_metadata)

	// Sanity check.
	var/atom/movable/hive = hive_metadata.holder
	if(!istype(hive) || !swarm_type || !istype(hive_metadata))
		return

	// Make sure we always have at least one swarm.
	if(!length(hive_metadata.swarms))
		new swarm_type(hive, src, hive_metadata)

	// Reduce swarms if we have too many.
	var/swarm_intensity = hive_metadata.get_total_swarm_intensity()
	if(swarm_intensity > max_swarm_intensity && length(hive_metadata.swarms))
		var/obj/effect/insect_swarm/swarm = hive_metadata.swarms[1]
		swarm.adjust_swarm_intensity(-(swarm_intensity-max_swarm_intensity))
		return

	// Try to grow an existing swarm until we're at our max.
	if(hive_metadata.has_reserves(SWARM_GROWTH_COST) && length(hive_metadata.swarms))
		for(var/obj/effect/insect_swarm/swarm as anything in hive_metadata.swarms)
			if(swarm.can_grow() && hive_metadata.consume_reserves(SWARM_GROWTH_COST))
				swarm.adjust_swarm_intensity(min(max_swarm_growth_intensity-swarm_intensity, rand(3,5)))
				return

	// If we have sufficient filled combs, create a new swarm. Otherwise, expand a swarm.
	if(hive.loc && hive_metadata.has_reserves(SWARM_GROWTH_COST))

		var/obj/effect/insect_swarm/swarm
		for(var/obj/effect/insect_swarm/check_swarm as anything in hive_metadata.swarms)
			if(check_swarm.loc == hive.loc && check_swarm.can_grow())
				swarm = check_swarm
				break

		if(!swarm)
			var/comb_count = 0
			for(var/obj/item/hive_frame/frame in hive)
				if(REAGENT_TOTAL_VOLUME(frame.reagents) >= REAGENT_MAXIMUM_VOLUME(frame.reagents))
					comb_count++
			if(length(hive_metadata.swarms) < comb_count)
				swarm = new swarm_type(hive.loc, src, hive_metadata)

		if(!QDELETED(swarm) && istype(swarm) && hive_metadata.consume_reserves(SWARM_GROWTH_COST))
			swarm.adjust_swarm_intensity(min((max_swarm_growth_intensity-swarm_intensity), rand(3,5)))
