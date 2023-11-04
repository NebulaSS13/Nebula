/decl/material/gas/alien
	name = "alien gas"
	uid = "gas_alien"
	hidden_from_codex = TRUE
	gas_symbol_html = "X"
	gas_symbol = "X"
	value = 0.6
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/gas/alien/Initialize()
	var/num = rand(100,999)
	name = "compound #[num]"
	gas_specific_heat = rand(1, 400)	
	molar_mass = rand(20,800)/1000	
	latent_heat = rand(100, 50000)
	if(prob(40))
		gas_flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		gas_flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		gas_flags |= XGM_GAS_CONTAMINANT
	if(prob(40))
		flags |= MAT_FLAG_FUSION_FUEL
	gas_symbol_html = "X<sup>[num]</sup>"
	gas_symbol = "X-[num]"
	if(prob(50))
		color = RANDOM_RGB
		gas_overlay_limit = 0.5
	. = ..()
