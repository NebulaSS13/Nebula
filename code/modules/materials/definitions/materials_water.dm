// Water!
#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/material/water
	name = "water"
	lore_text = "A ubiquitous chemical substance composed of hydrogen and oxygen."
	icon_colour = COLOR_OCEAN
	scannable = 1
	metabolism = REM * 10
	taste_description = "water"
	value = 0.01
	chem_products = list(MAT_WATER = 20)
	gas_tile_overlay = "generic"
	gas_overlay_limit = 0.5
	gas_specific_heat = 30
	gas_molar_mass = 0.020
	melting_point = T0C
	boiling_point = T100C
	gas_symbol_html = "H<sub>2</sub>O"
	gas_symbol = "H2O"
	glass_name = "water"
	glass_desc = "The father of all refreshments."

/decl/material/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed, holder)

/decl/material/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjust_hydration(removed * 10)
	if(is_holy(holder) && ishuman(M)) // Any location
		if(iscultist(M))
			if(prob(10))
				GLOB.cult.offer_uncult(M)
			if(prob(2))
				var/obj/effect/spider/spiderling/S = new(get_turf(M))
				M.visible_message("<span class='warning'>\The [M] coughs up \the [S]!</span>")
		else if(M.mind && GLOB.godcult.is_antagonist(M.mind))
			if(REAGENT_VOLUME(holder, type) > 5)
				M.adjustHalLoss(5)
				M.adjustBruteLoss(1)
				if(prob(10)) //Only annoy them a /bit/
					to_chat(M,"<span class='danger'>You feel your insides curdle and burn!</span> \[<a href='?src=\ref[src];deconvert=\ref[M]'>Give Into Purity</a>\]")
	if(istype(M, /mob/living/carbon/slime) || alien == IS_SLIME)
		M.adjustToxLoss(2 * removed)

/decl/material/water/proc/is_holy(var/datum/reagents/holder)
	var/list/rdata = REAGENT_DATA(holder, type)
	. = rdata && rdata["blessed"]

/decl/material/water/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)

	if(!istype(T))
		return

	if(is_holy(holder) && REAGENT_VOLUME(holder, type) >= 5)
		T.holy = TRUE

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	var/volume = REAGENT_VOLUME(holder, type)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		var/turf/simulated/S = T
		S.wet_floor(8, TRUE)

/decl/material/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/chems/food/snacks/monkeycube))
		var/obj/item/chems/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/decl/material/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		var/needed = M.fire_stacks * 10
		if(amount > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			holder.remove_reagent(type, needed)

		else
			M.adjust_fire_stacks(-(amount / 10))
			holder.remove_reagent(type, amount)

/decl/material/water/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(10 * removed)	// Babies have 150 health, adults have 200; So, 15 units and 20
	var/mob/living/carbon/slime/S = M
	if(!S.client && istype(S))
		if(S.Target) // Like cats
			S.Target = null
		if(S.Victim)
			S.Feedstop()
	if(M.chem_doses[type] == removed)
		M.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")
		M.confused = max(M.confused, 2)

/decl/material/water/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/mob/living/carbon/C = locate(href_list["deconvert"])
		if(C.mind)
			GLOB.godcult.remove_antagonist(C.mind,1)

#undef WATER_LATENT_HEAT
