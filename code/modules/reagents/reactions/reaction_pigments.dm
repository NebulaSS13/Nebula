/decl/chemical_reaction/compound/pigment
	abstract_type = /decl/chemical_reaction/compound/pigment
	result_amount = 2

// Black and grey should use oil, not ethanol, but would overlap with soapmaking.
/decl/chemical_reaction/compound/pigment/grey
	name = "grey pigment"
	required_reagents = list(
		/decl/material/liquid/alcohol/ethanol = 1,
		/decl/material/solid/carbon/ashes     = 1
	)
	result = /decl/material/liquid/pigment/grey

/decl/chemical_reaction/compound/pigment/black
	name = "black pigment"
	required_reagents = list(
		/decl/material/liquid/alcohol/ethanol = 1,
		/decl/material/solid/carbon           = 1
	)
	result = /decl/material/liquid/pigment/black/ink

/decl/chemical_reaction/compound/pigment/black_ink
	name = "black ink"
	required_reagents = list(
		/decl/material/liquid/pigment/black = 1,
		/decl/material/liquid/oil/plant     = 1
	)
	result = /decl/material/liquid/pigment/black/ink

/decl/chemical_reaction/compound/pigment/blue
	name = "blue pigment"
	required_reagents = list(
		/decl/material/solid/metal/copper = 2,
		/decl/material/solid/quartz = 2,
		/decl/material/solid/carbon/ashes = 1
	)
	minimum_temperature = 800 CELSIUS
	result_amount = 5
	result = /decl/material/liquid/pigment/blue

// This is silly but we don't have orpiment, lead chromate, etc.
/decl/chemical_reaction/compound/pigment/orange
	name = "orange pigment"
	required_reagents = list(
		/decl/material/solid/metal/chromium = 1,
		/decl/material/solid/metal/lead = 1
	)
	minimum_temperature = 800 CELSIUS
	result = /decl/material/liquid/pigment/orange
