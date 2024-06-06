// These are tracked/validated by currency decls.
/decl/stack_recipe/coin
	name              = "antique coin"
	result_type       = /obj/item/coin
	required_min_hardness = MAT_VALUE_FLEXIBLE
	category          = "antique coins"
	abstract_type     = /decl/stack_recipe/coin
	var/currency
	var/datum/denomination/denomination

/decl/stack_recipe/coin/Initialize()
	. = ..()
	var/decl/currency/currency_decl = GET_DECL(currency)
	if(currency_decl)
		required_material = currency_decl.material
		if(name)
			for(var/datum/denomination/currency_denomination in currency_decl.denominations)
				if(currency_denomination.name == name)
					denomination = currency_denomination
					return

/decl/stack_recipe/coin/validate()
	. = ..()
	if(!ispath(currency, /decl/currency))
		. += "invalid or null currency: [currency || "NULL"]"
	if(!istype(denomination))
		. += "invalid or null denomination: [denomination || "NULL"]"

/decl/stack_recipe/coin/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	. = ..()
	if(istype(denomination))
		for(var/obj/item/coin/coin in .)
			coin.denomination = denomination
			coin.SetName(coin.denomination.name)
