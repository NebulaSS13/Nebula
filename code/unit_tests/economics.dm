/datum/unit_test/currency_validation
	name = "ECONOMICS: Currency validation"

/datum/unit_test/currency_validation/start_test()
	var/list/failures = list()
	var/list/currencies = decls_repository.get_decls_of_subtype(/decl/currency)
	for(var/cid in currencies)

		var/decl/currency/currency = currencies[cid]
		if(currency.absolute_value < 1)
			log_bad("Absolute currency value is less than 1 for currency [cid].")
			failures |= cid
		if(!currency.name)
			log_bad("No name set for currency [cid].")
			failures |= cid
		if(!currency.name_prefix && !currency.name_suffix)
			log_bad("No name modifiers set for currency [cid].")
			failures |= cid
		if(!currency.name_singular)
			log_bad("No singular name set for currency [cid].")
			failures |= cid

		var/list/coinage_states = icon_states(currency.icon)
		for(var/datum/denomination/denomination in currency.denominations)
			if(!istext(denomination.name))
				log_bad("Non-text name found for '[denomination.type]' in [cid].")
				failures |= cid
			else if(!(denomination.state in coinage_states))
				log_bad("State '[denomination.state]' not found in icon file for '[denomination.type]' in [cid].")
				failures |= cid
			else if(denomination.mark && !(denomination.mark in coinage_states))
				log_bad("Mark state '[denomination.mark]' not found in icon file for '[denomination.type]' in [cid].")
				failures |= cid
			else if(!isnum(denomination.marked_value))
				log_bad("Non-numerical denomination marked value found for '[denomination]' in [cid].")
				failures |= cid
			else if(!denomination.overlay)
				log_bad("Null overlay found for '[denomination]' in [cid].")
				failures |= cid

	if(length(failures))
		fail("[length(failures)] currency type\s failed validation.")
	else
		pass("All currency types were validated successfully.")
	return 1
