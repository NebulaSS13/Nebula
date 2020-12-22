/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization Manager"
	extended_desc = "Control console used to activate the NT1019 authorization chip."
	size = 4
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	program_icon_state = "security"
	program_menu_icon = "locked"
	requires_network = 1
	available_on_network = 1
	required_access = list(access_armory)
	nanomodule_path = /datum/nano_module/program/forceauthorization/
	category = PROG_SEC

/datum/nano_module/program/forceauthorization/
	name = "Use of Force Authorization Manager"

/datum/nano_module/program/forceauthorization/proc/is_gun_connected(obj/item/gun/G)
	var/datum/computer_network/our_net = get_network()
	var/mob/living/silicon/S = G.loc
	var/datum/computer_network/gun_net = istype(S) ? S.get_computer_network() : G.get_network()
	return our_net == gun_net

/datum/nano_module/program/forceauthorization/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["is_silicon_usr"] = issilicon(user)

	data["guns"] = list()
	for(var/obj/item/gun/G in GLOB.registered_weapons)
		if(G.standby)
			continue

		if(!is_gun_connected(G))
			continue

		var/list/modes = list()
		for(var/i = 1 to G.firemodes.len)
			if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
				continue
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

		var/turf/T = get_turf(G)
		data["guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z)))
	var/list/guns = data["guns"]
	if(!guns.len)
		data["message"] = "No weapons registered"

	if(!data["is_silicon_usr"]) // don't send data even though they won't be able to see it
		data["cyborg_guns"] = list()
		for(var/obj/item/gun/energy/gun/secure/mounted/G in GLOB.registered_cyborg_weapons)
			if(!is_gun_connected(G))
				continue
			var/list/modes = list() // we don't get location, unlike inside of the last loop, because borg locations are reported elsewhere.
			for(var/i = 1 to G.firemodes.len)
				if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
					continue
				var/datum/firemode/firemode = G.firemodes[i]
				modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

			data["cyborg_guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "forceauthorization.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/forceauthorization/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/gun/G = locate(href_list["gun"]) in GLOB.registered_weapons
		if(!is_gun_connected(G))
			return
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && G && G.authorize(mode, do_authorize, usr.name)

	if(href_list["cyborg_gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/gun/energy/gun/secure/mounted/M = locate(href_list["cyborg_gun"]) in GLOB.registered_cyborg_weapons
		if(!is_gun_connected(M))
			return
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && M && M.authorize(mode, do_authorize, usr.name)

	return 0
