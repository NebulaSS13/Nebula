/datum/preferences
	/// Custom Keybindings
	var/list/key_bindings = list()
	var/hotkeys = TRUE

/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!client)
		return

	// When loading from savefile key_binding can be null
	// This happens when player had savefile created before new kb system, but hotkeys was not saved
	if(!length(key_bindings))
		key_bindings = deepCopyList(global.default_keybinds) // give them default keybinds too

	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	var/list/notadded = list()
	var/list/all_keybindings = decls_repository.get_decls_of_subtype(/decl/keybinding)
	for(var/keybind_type in all_keybindings)
		var/decl/keybinding/kb = all_keybindings[keybind_type]
		if(kb.is_abstract() || length(user_binds[kb.uid]))
			continue // key is unbound and or bound to something
		var/addedbind = FALSE
		if(hotkeys)
			for(var/hotkeytobind in kb.hotkey_keys)
				if(!length(key_bindings[hotkeytobind]) || hotkeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[hotkeytobind], kb.uid)
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(!length(key_bindings[classickeytobind]) || classickeytobind == "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					LAZYADD(key_bindings[classickeytobind], kb.uid)
					addedbind = TRUE
		if(!addedbind)
			notadded += kb

	if(length(notadded))
		addtimer(CALLBACK(src, .proc/announce_keybind_conflict, notadded), 5 SECONDS)

/datum/preferences/proc/announce_keybind_conflict(list/notadded)
	to_chat(client, SPAN_DANGER("KEYBINDING CONFLICT!<br>There are new keybindings that have defaults bound to keys you have already set. They will be unbound. You can rebind them in Setup Character or Game Preferences, <a href='?src=\ref[src];preference=tab;tab=3'>or you can click here to go straight to the keybindings page</a>."))
	for(var/item in notadded)
		var/decl/keybinding/conflicted = item
		var/decl/keybinding/category = GET_DECL(conflicted.abstract_type)
		to_chat(client, SPAN_DANGER("[category.name]: [conflicted.name] ([conflicted.type]) needs rebinding."))
		LAZYADD(key_bindings["None"], conflicted.uid) // set it to unbound to prevent this from opening up again in the future

/datum/category_item/player_setup_item/controls/keybindings
	name = "Keybindings"
	sort_order = 1

/datum/category_item/player_setup_item/controls/keybindings/load_preferences(datum/pref_record_reader/R)
	pref.key_bindings = R.read("key_bindings")

/datum/category_item/player_setup_item/controls/keybindings/sanitize_preferences()
	pref.key_bindings = sanitize_keybindings(pref.key_bindings)
	pref.check_keybindings()

/datum/category_item/player_setup_item/controls/keybindings/save_preferences(datum/pref_record_writer/W)
	W.write("key_bindings", pref.key_bindings)

/datum/category_item/player_setup_item/controls/keybindings/content(mob/user)
	. = list()
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for (var/key in pref.key_bindings)
		for(var/kb_name in pref.key_bindings[key])
			user_binds[kb_name] += list(key)

	// Group keybinds by category
	var/list/kb_categories = list()
	var/list/all_keybinds = decls_repository.get_decls_of_subtype(/decl/keybinding)
	for(var/keybind_type in all_keybinds)
		var/decl/keybinding/kb = all_keybinds[keybind_type]
		if(!kb.is_abstract())
			if(!(kb.abstract_type in kb_categories))
				kb_categories[kb.abstract_type] = list()
			kb_categories[kb.abstract_type] += kb

	. += "<center>"
	. += "<div class='statusDisplay'>"
	for(var/category_type in kb_categories)
		var/decl/keybinding/category = GET_DECL(category_type)
		. += "<h3>[category.name]</h3>"
		. += "<table width='100%'>"
		for (var/i in kb_categories[category_type])
			var/decl/keybinding/kb = i
			if(!length(user_binds[kb.uid]) || (user_binds[kb.uid][1] == "None" && length(user_binds[kb.uid]) == 1))
				. += "<tr><td width='40%'>[kb.name]</td><td width='15%'><a class='fluid' href ='?src=\ref[src];preference=keybindings_capture;keybinding=[kb.uid];old_key=["None"]'>None</a></td>"
				var/list/default_keys = pref.hotkeys ? kb.hotkey_keys : kb.classic_keys
				var/class
				if(user_binds[kb.uid] ~= default_keys)
					class = "class='linkOff fluid'"
				else
					class = "class='fluid' href ='?src=\ref[src];preference=keybinding_reset;keybinding=[kb.uid];old_keys=[jointext(user_binds[kb.uid], ",")]"

				. += {"<td width='15%'></td><td width='15%'></td><td width='15%'><a [class]'>Reset</a></td>"}
				. += "</tr>"
			else
				var/bound_key = user_binds[kb.uid][1]
				var/normal_name = _kbMap_reverse[bound_key] ? _kbMap_reverse[bound_key] : bound_key
				. += "<tr><td width='40%'>[kb.name]</td><td width='15%'><a class='fluid' href ='?src=\ref[src];preference=keybindings_capture;keybinding=[kb.uid];old_key=[bound_key]'>[normal_name]</a></td>"
				for(var/bound_key_index in 2 to length(user_binds[kb.uid]))
					bound_key = user_binds[kb.uid][bound_key_index]
					normal_name = _kbMap_reverse[bound_key] ? _kbMap_reverse[bound_key] : bound_key
					. += "<td width='15%'><a class='fluid' href ='?src=\ref[src];preference=keybindings_capture;keybinding=[kb.uid];old_key=[bound_key]'>[normal_name]</a></td>"
				if(length(user_binds[kb.uid]) < MAX_KEYS_PER_KEYBIND)
					. += "<td width='15%'><a class='fluid' href ='?src=\ref[src];preference=keybindings_capture;keybinding=[kb.uid]'>None</a></td>"
				for(var/j in 1 to MAX_KEYS_PER_KEYBIND - (length(user_binds[kb.uid]) + 1))
					. += "<td width='15%'></td>"
				var/list/default_keys = pref.hotkeys ? kb.hotkey_keys : kb.classic_keys
				. += {"<td width='15%'><a [user_binds[kb.uid] ~= default_keys ? "class='linkOff fluid'" : "class='fluid' href ='?src=\ref[src];preference=keybinding_reset;keybinding=[kb.uid];old_keys=[jointext(user_binds[kb.uid], ",")]"]'>Reset</a></td>"}
				. += "</tr>"
		. += "</table>"

	. += "</div>"
	. += "<br><br>"
	. += "<a href ='?src=\ref[src];preference=keybindings_reset'>Reset to default</a>"
	. += "</center>"

	return jointext(., null)

/datum/category_item/player_setup_item/controls/keybindings/proc/capture_keybinding(mob/user, decl/keybinding/kb, old_key)
	var/HTML = {"
	<div class='Section fill'id='focus' style="outline: 0; text-align:center;" tabindex=0>
		Keybinding: [kb.name]<br>[kb.description]
		<br><br>
		<b>Press any key to change<br>Press ESC to clear</b>
	</div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var sanitizedKey = e.key;
		if (47 < e.keyCode && e.keyCode < 58) {
			sanitizedKey = String.fromCharCode(e.keyCode);
		}
		else if (64 < e.keyCode && e.keyCode < 91) {
			sanitizedKey = String.fromCharCode(e.keyCode);
		}
		var url = 'byond://?src=\ref[src];preference=keybindings_set;keybinding=[kb.uid];old_key=[old_key];clear_key='+escPressed+';key='+sanitizedKey+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/category_item/player_setup_item/controls/keybindings/OnTopic(href, list/href_list, mob/user)
	switch(href_list["preference"])
		if("keybindings_capture")
			var/decl/keybinding/kb = decls_repository.get_decl_by_id(href_list["keybinding"])
			var/old_key = href_list["old_key"]
			capture_keybinding(user, kb, old_key)
			return TOPIC_REFRESH

		if("keybindings_set")
			var/kb_name = href_list["keybinding"]
			if(!kb_name)
				show_browser(user, null, "window=capturekeypress")
				return TOPIC_REFRESH

			var/clear_key = text2num(href_list["clear_key"])
			var/old_key = href_list["old_key"]
			if(clear_key)
				if(pref.key_bindings[old_key])
					pref.key_bindings[old_key] -= kb_name
					if(!(kb_name in pref.key_bindings["None"]))
						LAZYADD(pref.key_bindings["None"], kb_name)
					if(!length(pref.key_bindings[old_key]))
						pref.key_bindings -= old_key
				show_browser(user, null, "window=capturekeypress")
				user.client.set_macros()
				return TOPIC_REFRESH

			var/new_key = uppertext(href_list["key"])
			var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
			var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
			var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
			var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""

			if(!new_key) // Just in case (; - not work although keyCode 186 and nothing should break)
				show_browser(user, null, "window=capturekeypress")
				return TOPIC_REFRESH

			if(global._kbMap[new_key])
				new_key = global._kbMap[new_key]

			var/full_key
			switch(new_key)
				if("Alt")
					full_key = "[new_key][CtrlMod][ShiftMod]"
				if("Ctrl")
					full_key = "[AltMod][new_key][ShiftMod]"
				if("Shift")
					full_key = "[AltMod][CtrlMod][new_key]"
				else
					full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
			if(kb_name in pref.key_bindings[full_key]) //We pressed the same key combination that was already bound here, so let's remove to re-add and re-sort.
				pref.key_bindings[full_key] -= kb_name
			if(pref.key_bindings[old_key])
				pref.key_bindings[old_key] -= kb_name
				if(!length(pref.key_bindings[old_key]))
					pref.key_bindings -= old_key
			pref.key_bindings[full_key] += list(kb_name)
			pref.key_bindings[full_key] = sortTim(pref.key_bindings[full_key], /proc/cmp_text_asc)

			show_browser(user, null, "window=capturekeypress")
			user.client.set_macros()
			return TOPIC_REFRESH

		if("keybindings_reset")
			pref.key_bindings = deepCopyList(global.default_keybinds)
			user.client.set_macros()
			return TOPIC_REFRESH

		if("keybinding_reset")
			var/kb_name = href_list["keybinding"]
			var/list/old_keys = splittext(href_list["old_keys"], ",")

			for(var/old_key in old_keys)
				if(!pref.key_bindings[old_key])
					continue
				pref.key_bindings[old_key] -= kb_name
				if(!length(pref.key_bindings[old_key]))
					pref.key_bindings -= old_key

			var/decl/keybinding/kb = decls_repository.get_decl_by_id(kb_name)
			for(var/key in kb.hotkey_keys)
				pref.key_bindings[key] += list(kb_name)
				pref.key_bindings[key] = sortTim(pref.key_bindings[key], /proc/cmp_text_asc)
			user.client.set_macros()
			return TOPIC_REFRESH

	return ..()

/proc/sanitize_keybindings(value)
	decls_repository.get_decls_of_subtype(/decl/keybinding)
	var/list/base_bindings = sanitize_islist(value,list())
	for(var/key in base_bindings)
		if(!decls_repository.get_decl_by_id(key))
			base_bindings -= key
	return base_bindings
