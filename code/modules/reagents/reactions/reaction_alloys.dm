/datum/chemical_reaction/alloy
	minimum_temperature = GENERIC_SMELTING_HEAT_POINT
	maximum_temperature = INFINITY
	reaction_sound = null
	mix_message = null

/datum/chemical_reaction/alloy/borosilicate
	name = "Borosilicate Glass"
	result = /decl/material/solid/glass/borosilicate
	required_reagents = list(
		/decl/material/solid/glass = 2, 
		/decl/material/solid/metal/platinum = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/steel
	name = "Steel"
	result = /decl/material/solid/metal/steel
	required_reagents = list(
		/decl/material/solid/metal/iron = 1, 
		/decl/material/solid/mineral/graphite = 1
	)
	result_amount = 2

/datum/chemical_reaction/alloy/plasteel
	name = "Plasteel"
	result = /decl/material/solid/metal/plasteel
	required_reagents = list(
		/decl/material/solid/metal/steel = 2, 
		/decl/material/solid/metal/platinum = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/ocp
	name = "Osmium Carbide Plasteel"
	result = /decl/material/solid/metal/plasteel/ocp
	required_reagents = list(
		/decl/material/solid/metal/plasteel = 2, 
		/decl/material/solid/metal/osmium = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/bronze
	name = "Bronze"
	result = /decl/material/solid/metal/bronze
	required_reagents = list(
		/decl/material/solid/metal/copper = 4, 
		/decl/material/solid/metal/tin = 1
	)
	result_amount = 5

/datum/chemical_reaction/alloy/brass
	name = "Brass"
	result = /decl/material/solid/metal/brass
	required_reagents = list(
		/decl/material/solid/metal/copper = 2, 
		/decl/material/solid/metal/zinc = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/blackbronze
	name = "Black Bronze"
	result = /decl/material/solid/metal/blackbronze
	required_reagents = list(
		/decl/material/solid/metal/copper = 2, 
		/decl/material/solid/metal/silver = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/redgold
	name = "Red Gold"
	result = /decl/material/solid/metal/redgold
	required_reagents = list(
		/decl/material/solid/metal/copper = 2, 
		/decl/material/solid/metal/gold = 1
	)
	result_amount = 3

/datum/chemical_reaction/alloy/stainlesssteel
	name = "Stainless Steel"
	result = /decl/material/solid/metal/stainlesssteel
	required_reagents = list(
		/decl/material/solid/metal/steel = 9, 
		/decl/material/solid/metal/chromium = 1
	)
	result_amount = 10