/decl/material/liquid/bee_venom
	name = "bee venom"
	uid = "liquid_venom_bee"
	lore_text = "An irritant used by bees to drive off predators."
	taste_description = "noxious bitterness"
	color = "#d7d891"
	heating_products = list(
		/decl/material/liquid/denatured_toxin = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "becomes clear."
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/bee_venom/affect_blood(mob/living/M, removed, datum/reagents/holder)
	. = ..()
	if(istype(M))
		M.adjustHalLoss(max(1, ceil(removed * 10)))
