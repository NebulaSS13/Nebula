// These are tracked/validated by currency decls.
/decl/stack_recipe/coin
	name = "antique coin"
	result_type = /obj/item/coin
	required_hardness = MAT_VALUE_FLEXIBLE
	category = "antique coins"
	abstract_type = /decl/stack_recipe/coin
	var/currency
	var/denomination_name
	var/datum/denomination/denomination

/decl/stack_recipe/coin/Initialize()
	. = ..()
	var/decl/currency/currency_decl = GET_DECL(currency)
	if(currency_decl && denomination_name)
		for(var/datum/denomination/currency_denomination in currency_decl.denominations)
			if(currency_denomination.name == denomination_name)
				denomination = currency_denomination
				break

/decl/stack_recipe/coin/validate()
	. = ..()
	if(!ispath(currency, /decl/currency))
		. += "invalid or null currency: [currency || "NULL"]"
	if(!istext(denomination_name))
		. += "invalid or null denomination name: [denomination_name || "NULL"]"
	if(!istype(denomination))
		. += "invalid or null denomination: [denomination || "NULL"]"

/decl/stack_recipe/coin/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat)
	var/obj/item/coin/coin = ..()
	if(istype(coin) && istype(denomination))
		coin.denomination = denomination
		coin.SetName(coin.denomination.name)
	return coin
