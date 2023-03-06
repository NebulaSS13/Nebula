/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/human
	var/datum/reagents/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()
	if(vessel)
		return
	vessel = new /datum/reagents(species.blood_volume, src)
	if(!should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	reset_blood()

//Modifies blood level
/mob/living/carbon/human/proc/adjust_blood(var/amt, var/blood_data)
	if(!vessel)
		make_blood()

	if(!should_have_organ(BP_HEART))
		return

	if(amt && species.blood_reagent)
		if(amt > 0)
			vessel.add_reagent(species.blood_reagent, amt, blood_data)
		else
			vessel.remove_any(abs(amt))

//Resets blood data
/mob/living/carbon/human/proc/reset_blood()
	if(!vessel)
		make_blood()

	if(!should_have_organ(BP_HEART))
		vessel.clear_reagents()
		vessel.maximum_volume = 0
		return

	if(vessel.total_volume < species.blood_volume)
		vessel.maximum_volume = species.blood_volume
		adjust_blood(species.blood_volume - vessel.total_volume)
	else if(vessel.total_volume > species.blood_volume)
		vessel.remove_any(vessel.total_volume - species.blood_volume)
		vessel.maximum_volume = species.blood_volume

	LAZYSET(vessel.reagent_data, species.blood_reagent, list(
		"donor" =        weakref(src),
		"species" =      species.name,
		"blood_DNA" =    dna?.unique_enzymes,
		"blood_color" = species.get_blood_color(src),
		"blood_type" =   dna?.b_type,
		"trace_chem" = null
	))

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt, var/tar = src, var/ddir)
	var/datum/reagents/bloodstream = get_injected_reagents()
	if(remove_blood(amt))
		if(bloodstream.total_volume && vessel.total_volume)
			var/chem_share = round(0.3 * amt * (bloodstream.total_volume/vessel.total_volume), 0.01)
			bloodstream.remove_any(chem_share * bloodstream.total_volume)
		blood_splatter(tar, src, (ddir && ddir>0), spray_dir = ddir)
		return amt
	return 0

#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(global.alldirs)
	amt = CEILING(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to BLOOD_SPRAY_DISTANCE)
			var/turf/old_sprayloc = sprayloc
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			var/hit_dense_obj
			var/hit_mob
			for(var/thing in sprayloc)
				var/atom/A = thing
				if(!A.simulated)
					continue

				if(isobj(A))
					if(A.density == 1)
						hit_dense_obj = TRUE
						break

				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					if(!H.lying)
						H.bloody_body(src)
						H.bloody_hands(src)
						var/blinding = FALSE
						if(ran_zone() == BP_HEAD)
							blinding = TRUE
							for(var/slot in global.standard_headgear_slots)
								var/obj/item/I = H.get_equipped_item(slot)
								if(istype(I) && (I.body_parts_covered & SLOT_EYES))
									blinding = FALSE
									break
						if(blinding)
							SET_STATUS_MAX(H, STAT_BLURRY, 10)
							SET_STATUS_MAX(H, STAT_BLIND, 5)
							to_chat(H, "<span class='danger'>You are blinded by a spray of blood!</span>")
						else
							to_chat(H, "<span class='danger'>You are hit by a spray of blood!</span>")
						hit_mob = TRUE

				if(hit_mob || !A.CanPass(src, sprayloc))
					break

			if(hit_dense_obj)
				drip(amt, old_sprayloc, spraydir)
				sprayloc = old_sprayloc
			else
				drip(amt, sprayloc, spraydir)
			bled += amt
			if(hit_mob) break
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

/mob/living/carbon/human/proc/remove_blood(var/amt)
	if(!should_have_organ(BP_HEART)) //TODO: Make drips come from the reagents instead.
		return 0
	if(!amt)
		return 0

	amt *= ((src.mob_size/MOB_SIZE_MEDIUM) ** 0.5)

	return vessel.remove_any(amt)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/chems/container, var/amount)
	container.reagents.add_reagent(species.blood_reagent, amount, get_blood_data())
	return 1

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/chems/container, var/amount)

	if(!vessel)
		make_blood()

	if(!should_have_organ(BP_HEART))
		reagents.trans_to_obj(container, amount)
		return 1

	if(vessel.total_volume < amount)
		return null
	if(vessel.has_reagent(species.blood_reagent))
		LAZYSET(vessel.reagent_data, species.blood_reagent, get_blood_data())
	vessel.trans_to_holder(container.reagents, amount)
	return 1

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(var/amount, var/datum/reagents/donor)
	if(!species.blood_volume)
		return //Don't divide by 0
	var/injected_data = REAGENT_DATA(donor, species.blood_reagent)
	var/chems = LAZYACCESS(injected_data, "trace_chem")
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/amount, var/datum/reagents/donor)
	if(!should_have_organ(BP_HEART))
		reagents.add_reagent(species.blood_reagent, amount, REAGENT_DATA(donor, species.blood_reagent))
		return
	var/injected_data = REAGENT_DATA(donor, species.blood_reagent)
	var/injected_b_type = LAZYACCESS(injected_data, "blood_type")
	if(blood_incompatible(injected_b_type))
		var/decl/blood_type/blood_decl = injected_b_type && get_blood_type_by_name(injected_b_type)
		if(istype(blood_decl))
			reagents.add_reagent(blood_decl.transfusion_fail_reagent, amount * blood_decl.transfusion_fail_percentage)
		else
			reagents.add_reagent(/decl/material/liquid/coagulated_blood, amount * 0.5)
	else
		adjust_blood(amount, injected_data)
	..()

/mob/living/carbon/human/proc/blood_incompatible(blood_type)
	return species.is_blood_incompatible(dna?.b_type, blood_type)

/mob/living/carbon/human/proc/regenerate_blood(var/amount)
	amount *= (species.blood_volume / SPECIES_BLOOD_DEFAULT)

	var/stress_modifier = get_stress_modifier()
	if(stress_modifier)
		amount *= 1-(config.stress_blood_recovery_constant * stress_modifier)

	var/blood_volume_raw = vessel.total_volume
	amount = max(0,min(amount, species.blood_volume - blood_volume_raw))
	if(amount)
		adjust_blood(amount, get_blood_data())
	return amount

/mob/living/carbon/proc/get_blood_data()
	var/data = list()
	data["donor"] = weakref(src)
	data["blood_DNA"] = dna.unique_enzymes
	data["blood_type"] = dna.b_type
	data["species"] = species.name
	data["has_oxy"] = species.blood_oxy
	var/list/temp_chem = list()
	for(var/R in reagents.reagent_volumes)
		temp_chem[R] = REAGENT_VOLUME(reagents, R)
	data["trace_chem"] = temp_chem
	data["dose_chem"] = chem_doses ? chem_doses.Copy() : list()
	data["blood_color"] = species.get_blood_color(src)
	return data

/proc/blood_splatter(var/target, var/source, var/large, var/spray_dir)

	var/obj/effect/decal/cleanable/blood/splatter
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	if(T)
		var/list/existing = filter_list(T.contents, decal_type)
		if(length(existing) > 3)
			splatter = pick(existing)
	if(!splatter)
		splatter = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = splatter
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	var/blood_data
	var/blood_type
	if(ishuman(source))
		var/mob/living/carbon/human/donor = source
		blood_data = REAGENT_DATA(donor.vessel, donor.species.blood_reagent)
		blood_type = donor.b_type
	else if(isatom(source))
		var/atom/donor = source
		blood_data = REAGENT_DATA(donor.reagents, /decl/material/liquid/blood)
	if(!islist(blood_data))
		return splatter

	if(spray_dir)
		splatter.icon_state = "squirt"
		splatter.set_dir(spray_dir)
	// Update blood information.
	if(LAZYACCESS(blood_data, "blood_DNA"))
		LAZYSET(splatter.blood_data, blood_data["blood_DNA"], blood_data)
		splatter.blood_DNA = list()
		if(LAZYACCESS(blood_data, "blood_type"))
			splatter.blood_DNA[blood_data["blood_DNA"]] = blood_data["blood_type"]
		else
			splatter.blood_DNA[blood_data["blood_DNA"]] = "O+"
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(splatter, /datum/extension/forensic_evidence)
		forensics.add_data(/datum/forensics/blood_dna, blood_data["blood_DNA"])

	if(!blood_type && LAZYACCESS(blood_data, "blood_type"))
		blood_type = LAZYACCESS(blood_data, "blood_type")

	// Update appearance.
	if(blood_type)
		var/decl/blood_type/blood_type_decl = get_blood_type_by_name(blood_type)
		splatter.name =      blood_type_decl.splatter_name
		splatter.desc =      blood_type_decl.splatter_desc
		splatter.basecolor = blood_type_decl.splatter_colour

	if(LAZYACCESS(blood_data, "blood_color"))
		splatter.basecolor = blood_data["blood_color"]

	splatter.update_icon()
	splatter.fluorescent  = 0
	splatter.set_invisibility(0)
	return splatter

//Percentage of maximum blood volume.
/mob/living/carbon/human/proc/get_blood_volume()
	return species.blood_volume? round((vessel.total_volume/species.blood_volume)*100) : 0

//Percentage of maximum blood volume, affected by the condition of circulation organs
/mob/living/carbon/human/proc/get_blood_circulation()
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	var/blood_volume = get_blood_volume()
	if(!heart)
		return 0.25 * blood_volume

	var/recent_pump = LAZYACCESS(heart.external_pump, 1) > world.time - (20 SECONDS)
	var/pulse_mod = 1
	if((status_flags & FAKEDEATH) || BP_IS_PROSTHETIC(heart))
		pulse_mod = 1
	else
		switch(heart.pulse)
			if(PULSE_NONE)
				if(recent_pump)
					pulse_mod = LAZYACCESS(heart.external_pump, 2)
				else
					pulse_mod *= 0.25
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_2FAST, PULSE_THREADY)
				pulse_mod *= 1.25
	blood_volume *= pulse_mod

	if(lying)
		blood_volume *= 1.25

	var/min_efficiency = recent_pump ? 0.5 : 0.3
	blood_volume *= max(min_efficiency, (1-(heart.damage / heart.max_damage)))

	if(!heart.open && has_chemical_effect(CE_BLOCKAGE, 1))
		blood_volume *= max(0, 1-GET_CHEMICAL_EFFECT(src, CE_BLOCKAGE))

	return min(blood_volume, 100)

//Whether the species needs blood to carry oxygen. Used in get_blood_oxygenation and may be expanded based on blood rather than species in the future.
/mob/living/carbon/human/proc/blood_carries_oxygen()
	return species.blood_oxy

//Percentage of maximum blood volume, affected by the condition of circulation organs, affected by the oxygen loss. What ultimately matters for brain
/mob/living/carbon/human/proc/get_blood_oxygenation()
	var/blood_volume = get_blood_circulation()
	if(blood_carries_oxygen())
		if(is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
			return min(blood_volume, BLOOD_VOLUME_SURVIVE)

		if(!need_breathe())
			return blood_volume
	else
		blood_volume = 100

	var/blood_volume_mod = max(0, 1 - getOxyLossPercent()/(species.total_health/2))
	var/oxygenated_mult = 0
	switch(GET_CHEMICAL_EFFECT(src, CE_OXYGENATED))
		if(1)
			oxygenated_mult = 0.5
		if(2)
			oxygenated_mult = 0.7
		if(3)
			oxygenated_mult = 0.9
	blood_volume_mod = blood_volume_mod + oxygenated_mult - (blood_volume_mod * oxygenated_mult)
	blood_volume = blood_volume * blood_volume_mod
	return min(blood_volume, 100)
