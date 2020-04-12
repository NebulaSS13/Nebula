/datum/unit_test/currency_validation
	name = "ECONOMICS: Currency validation"

/datum/unit_test/currency_validation/start_test()
	var/list/failures = list()
	var/list/currencies = decls_repository.get_decls_of_type(/decl/currency)
	for(var/cid in currencies)
		var/decl/currency/currency = currencies[cid]
		var/list/coinage_states = icon_states(currency.icon)
		if(currency.absolute_value < 1)
			log_bad("Absolute currency value is less than 1 for currency [cid].")
			failures |= cid
		if(!currency.name)
			log_bad("No name set for currency [cid].")
			failures |= cid
		if(!currency.name_short)
			log_bad("No short name set for currency [cid].")
			failures |= cid
		if(!currency.name_singular)
			log_bad("No singular name set for currency [cid].")
			failures |= cid
		for(var/denomination in currency.denominations)
			if(!isnum(currency.denominations[denomination]))
				log_bad("Non-numerical denomination value found for '[denomination]' in [cid].")
				failures |= cid
		for(var/denomination in currency.denomination_is_coin)
			if(isnull(currency.denominations[denomination]))
				log_bad("Denomination in coin list not found in denomination list for '[denomination]' in [cid].")
				failures |= cid
			else if(!islist(currency.denomination_is_coin[denomination]))
				log_bad("Non-list value found for coin denomination '[denomination]' in [cid].")
				failures |= cid
			else if(length(currency.denomination_is_coin[denomination]) < 2)
				log_bad("Less than two sides found for coin denomination '[denomination]' in [cid].")
				failures |= cid
		for(var/denomination in currency.denomination_has_mark)
			if(isnull(currency.denominations[denomination]))
				log_bad("Denomination in mark list not found in denomination list for '[denomination]' in [cid].")
				failures |= cid
			else if(!(currency.denomination_has_mark[denomination] in coinage_states))
				log_bad("Mark state '[currency.denomination_has_mark[denomination]]' not found in icon file for '[denomination]' in [cid].")
				failures |= cid
		for(var/denomination in currency.denomination_has_colour)
			if(isnull(currency.denominations[denomination]))
				log_bad("Denomination in colour list not found in denomination list for '[denomination]' in [cid].")
				failures |= cid
		for(var/denomination in currency.denomination_has_state)
			if(isnull(currency.denominations[denomination]))
				log_bad("Denomination in state list not found in denomination list for '[denomination]' in [cid].")
				failures |= cid
			else if(!(currency.denomination_has_state[denomination] in coinage_states))
				log_bad("State '[currency.denomination_has_state[denomination]]' not found in icon file for '[denomination]' in [cid].")
				failures |= cid
		for(var/denomination in currency.denomination_has_name)
			if(isnull(currency.denominations[denomination]))
				log_bad("Denomination in name list not found in denomination list for '[denomination]' in [cid].")
				failures |= cid
			else if(!istext(currency.denomination_has_name[denomination]))
				log_bad("Non-text name found in name list for '[denomination]' in [cid].")
				failures |= cid
	if(length(failures))
		log_bad("[failures] currency types failed validation.")
	else
		pass("All currency types were validated successfully.")
	return 1
