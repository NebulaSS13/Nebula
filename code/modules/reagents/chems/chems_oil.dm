/decl/material/liquid/oil
	name                   = "fuel oil" // paraffin etc
	lore_text              = "Clarified fuel oil, perfect for fuelling a lantern."
	burn_product           = /decl/material/gas/carbon_monoxide
	ignition_point         = T0C+150
	accelerant_value       = FUEL_VALUE_ACCELERANT
	gas_flags              = XGM_GAS_FUEL
	melting_point          = 273
	boiling_point          = 373
	uid                    = "chem_oil_lamp"
	color                  = "#664330"
	value                  = 1.5
	fishing_bait_value     = 0
	taste_mult             = 4
	metabolism             = REM * 4
	exoplanet_rarity_gas   = MAT_RARITY_NOWHERE
	affect_blood_on_ingest = 0
	affect_blood_on_inhale = 0
	slipperiness           = 8
	coated_adjective       = "oily"

/decl/material/liquid/oil/plant
	name                   = "plant oil"
	lore_text              = "A thin yellow oil pressed from vegetables or nuts. Useful as fuel, or in cooking."
	uid                    = "chem_oil_plant"
	taste_description      = "oily blandness"
	allergen_flags         = ALLERGEN_VEGETABLE
	compost_value          = 1
	nutriment_factor       = 8

/decl/material/liquid/oil/plant/corn
	name                   = "corn oil"
	lore_text              = "An oil derived from various types of corn."
	taste_description      = "slime"
	nutriment_factor       = 20
	color                  = "#302000"
	uid                    = "chem_oil_corn"
	taste_mult             = 0.1

/decl/material/liquid/oil/fish
	name                   = "fish oil"
	lore_text              = "A pungent yellow oil pressed from fish meat and fish skin. Useful as fuel, or in cooking, or for encouraging recovery after brain injuries."
	uid                    = "chem_oil_fish"
	taste_description      = "pungent, oily fish"
	allergen_flags         = ALLERGEN_FISH
	compost_value          = 1
	nutriment_factor       = 6

// Copied from neuroannealer; yes, it's silly, but we need a way to treat brain damage on the medieval map.
// Should possibly be an ingredient rather than the be-all end-all medication.
/decl/material/liquid/oil/fish/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.add_chemical_effect(CE_BRAIN_REGEN, 0.5) // Half as effective as neuroannealer, without the side-effects.
