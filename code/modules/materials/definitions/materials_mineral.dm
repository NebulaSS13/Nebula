/decl/material/pitchblende
	name = "pitchblende"
	ore_compresses_to = MAT_PITCHBLENDE
	icon_colour = "#917d1a"
	ore_smelts_to = MAT_URANIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "pitchblende"
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = "{'materials':5}"
	ore_icon_overlay = "nugget"
	chem_products = list(
		/decl/material/radium = 10,
		MAT_URANIUM = 10
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	sale_price = 2

/decl/material/graphite
	name = "graphite"
	lore_text = "A substance composed of lattices of carbon, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	value = 0.5
	ore_compresses_to = MAT_GRAPHITE
	icon_colour = "#222222"
	ore_name = "graphite"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	chem_products = list(
		MAT_GRAPHITE = 15,
		/decl/material/toxin/plasticide = 5,
		/decl/material/acetone = 5
		)
	sale_price = 1

/decl/material/graphite/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/graphite/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T, /turf/space))
		var/volume = REAGENT_VOLUME(holder, src)
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/decl/material/quartz
	name = "quartz"
	ore_compresses_to = MAT_QUARTZ
	ore_name = "quartz"
	opacity = 0.5
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#effffe"
	chem_products = list(
		/decl/material/silicon = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2
	reflectiveness = MAT_VALUE_SHINY

/decl/material/pyrite
	name = "pyrite"
	ore_name = "pyrite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#ccc9a3"
	chem_products = list(
		/decl/material/sulfur = 15,
		MAT_IRON = 5
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_compresses_to = MAT_PYRITE
	sale_price = 2
	reflectiveness = MAT_VALUE_SHINY

/decl/material/spodumene
	name = "spodumene"
	ore_compresses_to = MAT_SPODUMENE
	ore_name = "spodumene"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e5becb"
	chem_products = list(
		/decl/material/lithium = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/decl/material/cinnabar
	name = "cinnabar"
	ore_compresses_to = MAT_CINNABAR
	ore_name = "cinnabar"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e54e4e"
	chem_products = list(
		/decl/material/mercury  = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/decl/material/phosphorite
	name = "phosphorite"
	ore_compresses_to = MAT_PHOSPHORITE
	ore_name = "phosphorite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#acad95"
	chem_products = list(
		/decl/material/phosphorus = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/decl/material/rocksalt
	name = "rock salt"
	ore_compresses_to = MAT_ROCK_SALT
	ore_name = "rock salt"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d1c0bc"
	chem_products = list(
		/decl/material/sodium = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/decl/material/potash
	name = "potash"
	ore_compresses_to = MAT_POTASH
	ore_name = "potash"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#b77464"
	chem_products = list(
		/decl/material/potassium = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/decl/material/bauxite
	name = "bauxite"
	ore_name = "bauxite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d8ad97"
	chem_products = list(
		MAT_ALUMINIUM = 15
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = MAT_ALUMINIUM
	ore_compresses_to = MAT_BAUXITE
	sale_price = 1

/decl/material/sand
	name = "sand"
	stack_type = null
	icon_colour = "#e2dbb5"
	ore_smelts_to = MAT_GLASS
	ore_compresses_to = MAT_SANDSTONE
	ore_name = "sand"
	ore_icon_overlay = "dust"
	chem_products = list(
		/decl/material/silicon = 20
		)

/decl/material/sand/clay
	name = "clay"
	icon_colour = COLOR_OFF_WHITE
	ore_name = "clay"
	ore_icon_overlay = "lump"
	ore_smelts_to = MAT_CERAMIC
	ore_compresses_to = MAT_CLAY

/decl/material/toxin/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	icon_colour = "#e37108"
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	stack_origin_tech = "{'materials':2,'phorontech':2}"
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	chem_products = list(
		MAT_PHORON = 20
		)
	construction_difficulty = MAT_VALUE_HARD_DIY
	ore_name = "phoron"
	ore_compresses_to = MAT_PHORON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "gems"
	sale_price = 5
	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	gas_specific_heat = 200	// J/(mol*K)
	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	gas_molar_mass = 0.405	// kg/mol
	gas_overlay_limit = 0.7
	gas_flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT | XGM_GAS_FUSION_FUEL
	gas_symbol_html = "Ph"
	gas_symbol = "Ph"
	reflectiveness = MAT_VALUE_SHINY
	taste_mult = 1.5
	strength = 30
	touch_met = 5
	heating_point = null
	heating_products = null
	value = 4
	fuel_value = 5

/decl/material/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fuel_value))
		M.pl_effects()

/decl/material/toxin/phoron/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_PHORON, volume, T20C)
	holder.remove_reagent(type, volume)

// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/decl/material/toxin/phoron/oxygen
	name = "oxyphoron"
	lore_text = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 15
	fuel_value = 15

/decl/material/toxin/phoron/oxygen/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_OXYGEN, ceil(volume/2), T20C)
	T.assume_gas(MAT_PHORON, ceil(volume/2), T20C)
	holder.remove_reagent(type, volume)

/decl/material/toxin/phoron/supermatter
	name = "exotic matter"
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in bluespace technology."
	icon_colour = "#ffff00"
	radioactivity = 20
	stack_origin_tech = "{'bluespace':2,'materials':6,'phorontech':4}"
	stack_type = null
	luminescence = 3
	ore_compresses_to = null
	sale_price = null

//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/decl/material/toxin/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(MAT_PHORON, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
