/datum/unit_test/default_fc_keybinds_shall_be_unprintable
	name = "INPUT: Focus Chat default keybinds shall be unprintable."

/datum/unit_test/default_fc_keybinds_shall_be_unprintable/start_test()
	var/list/failures = list()
	for (var/name in global.keybindings_by_name)
		var/datum/keybinding/binding = global.keybindings_by_name[name]
		/// If a classic keylist is provided, test that one instead.
		var/list/keys_to_check = binding.classic_keys || binding.hotkey_keys
		for(var/fc_key in keys_to_check)
			/// Strip off default modifiers.
			var/stripped_key = replacetext(fc_key, regex("(Alt|Shift|Ctrl)", "g"), "")

			if(length(stripped_key))
				continue //Pure Modifier key (Alt, Ctrl, Shift)
			if(!SSinput.unprintables_cache[stripped_key] && stripped_key != "Unbound")
				failures.Add(binding.type)

	if(failures)
		fail("Printable keys bound by default in Focus Chat keybind set.")
		log_bad("Bad Types:")
		for(var/bad_type in failures)
			log_bad("[bad_type]")
	else
		pass("All Focus Chat keys are sane.")
	return 1