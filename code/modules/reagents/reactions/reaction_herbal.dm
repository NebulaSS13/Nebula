/decl/chemical_reaction/drug/herbal
	abstract_type       = /decl/chemical_reaction/drug/herbal
	result_amount       = 2
	minimum_temperature = 100 CELSIUS

/decl/chemical_reaction/drug/herbal/on_reaction(datum/reagents/holder, created_volume, reaction_flags, list/reaction_data)
	. = ..()
	// Add plant matter to represent the herbs that the medicine has been leached out of.
	holder?.add_reagent(/decl/material/solid/organic/plantmatter, created_volume)

/decl/chemical_reaction/drug/herbal/yarrow_tea
	name = "yarrow tea"
	required_reagents = list(
		/decl/material/liquid/water             = 1,
		/decl/material/liquid/brute_meds/yarrow = 3
	)
	result = /decl/material/liquid/brute_meds/yarrow/tea

/decl/chemical_reaction/drug/herbal/aloe_tea
	name = "aloe tea"
	required_reagents = list(
		/decl/material/liquid/water          = 1,
		/decl/material/liquid/burn_meds/aloe = 3
	)
	result = /decl/material/liquid/burn_meds/aloe/tea

/decl/chemical_reaction/drug/herbal/ginseng_tea
	name = "ginseng tea"
	required_reagents = list(
		/decl/material/liquid/water              = 1,
		/decl/material/liquid/antitoxins/ginseng = 3
	)
	result = /decl/material/liquid/antitoxins/ginseng/tea

/decl/chemical_reaction/drug/herbal/valerian_tea
	name = "valerian tea"
	required_reagents = list(
		/decl/material/liquid/water              = 1,
		/decl/material/liquid/sedatives/valerian = 3
	)
	result = /decl/material/liquid/sedatives/valerian/tea

// Tinctures are stronger but have side-effects from the alcohol.
/decl/chemical_reaction/drug/herbal/yarrow_tincture
	name = "tincture of yarrow"
	required_reagents = list(
		/decl/material/liquid/ethanol           = 1,
		/decl/material/liquid/brute_meds/yarrow = 3
	)
	result = /decl/material/liquid/brute_meds/yarrow/tincture

/decl/chemical_reaction/drug/herbal/aloe_tincture
	name = "tincture of aloe"
	required_reagents = list(
		/decl/material/liquid/ethanol        = 1,
		/decl/material/liquid/burn_meds/aloe = 3
	)
	result = /decl/material/liquid/burn_meds/aloe/tincture

/decl/chemical_reaction/drug/herbal/ginseng_tincture
	name = "tincture of ginseng"
	required_reagents = list(
		/decl/material/liquid/ethanol            = 1,
		/decl/material/liquid/antitoxins/ginseng = 3
	)
	result = /decl/material/liquid/antitoxins/ginseng/tincture

/decl/chemical_reaction/drug/herbal/valerian_tincture
	name = "tincture of valerian"
	required_reagents = list(
		/decl/material/liquid/ethanol            = 1,
		/decl/material/liquid/sedatives/valerian = 3
	)
	result = /decl/material/liquid/sedatives/valerian/tincture
