/decl/material/liquid
	name = null
	melting_point = T0C
	boiling_point = T100C
	opacity = 0.5
	molar_mass = 0.018 //water
	latent_heat = 2258
	abstract_type = /decl/material/liquid
	accelerant_value = FUEL_VALUE_SUPPRESSANT // Abstract way of dousing fires with fluid; realistically it should deprive them of oxidizer but heigh ho

/decl/material/liquid/Initialize()
	if(!gas_name)
		gas_name = "vaporized [name]"
	if(!solid_name)
		solid_name = "frozen [name]"
	. = ..()
