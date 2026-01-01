/decl/material/liquid
	name = null
	melting_point = T0C
	boiling_point = T100C
	opacity = 0.5
	molar_mass = 0.018 //water
	latent_heat = 2258
	abstract_type = /decl/material/liquid
	accelerant_value = FUEL_VALUE_SUPPRESSANT // Abstract way of dousing fires with fluid; realistically it should deprive them of oxidizer but heigh ho
	// Assume if we're dealing with stacks, then it's solid (like ice)
	sound_manipulate = 'sound/foley/rockscrape.ogg'
	sound_dropped    = 'sound/foley/rockscrape.ogg'

/decl/material/liquid/Initialize()
	if(!gas_name)
		gas_name = "vaporized [name]"
	if(!solid_name)
		solid_name = "frozen [name]"
	. = ..()
