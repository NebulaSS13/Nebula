/obj/item/rig/attackby(obj/item/used_item, mob/user)

	if(!isliving(user)) return FALSE

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return TRUE

	// Pass repair items on to the chestpiece.
	if(chest && (istype(used_item,/obj/item/stack/material) || IS_WELDER(used_item)))
		return chest.attackby(used_item,user)

	// Lock or unlock the access panel.
	if(used_item.GetIdCard())
		if(subverted)
			locked = 0
			to_chat(user, "<span class='danger'>It looks like the locking system has been shorted out.</span>")
			return TRUE

		if(!length(req_access))
			locked = 0
			to_chat(user, "<span class='danger'>\The [src] doesn't seem to have a locking mechanism.</span>")
			return TRUE

		if(security_check_enabled && !src.allowed(user))
			to_chat(user, "<span class='danger'>Access denied.</span>")
			return TRUE

		locked = !locked
		to_chat(user, "You [locked ? "lock" : "unlock"] \the [src] access panel.")
		return TRUE

	else if(IS_CROWBAR(used_item))

		if(!open && locked)
			to_chat(user, "The access panel is locked shut.")
			return TRUE

		open = !open
		to_chat(user, "You [open ? "open" : "close"] the access panel.")
		return TRUE

	else if(IS_SCREWDRIVER(used_item))
		p_open = !p_open
		to_chat(user, "You [p_open ? "open" : "close"] the wire cover.")
		return TRUE

	// Hacking.
	else if(IS_WIRECUTTER(used_item) || IS_MULTITOOL(used_item))
		if(p_open)
			wires.Interact(user)
		else
			to_chat(user, "You can't reach the wiring.")
		return TRUE

	if(open)


		// Air tank.
		if(istype(used_item,/obj/item/tank)) //Todo, some kind of check for suits without integrated air supplies.

			if(air_supply)
				to_chat(user, "\The [src] already has a tank installed.")
				return TRUE

			if(!user.try_unequip(used_item))
				return TRUE
			air_supply = used_item
			used_item.forceMove(src)
			to_chat(user, "You slot [used_item] into [src] and tighten the connecting valve.")
			return TRUE

		// Check if this is a hardsuit upgrade or a modification.
		else if(istype(used_item,/obj/item/rig_module))

			if(ishuman(src.loc))
				var/mob/living/human/H = src.loc
				if(H.get_equipped_item(slot_back_str) == src)
					to_chat(user, "<span class='danger'>You can't install a hardsuit module while the suit is being worn.</span>")
					return TRUE

			if(is_type_in_list(used_item,banned_modules))
				to_chat(user, SPAN_DANGER("\The [src] cannot mount this type of module."))
				return TRUE

			var/obj/item/rig_module/mod = used_item

			if(!installed_modules) installed_modules = list()
			if(installed_modules.len)
				for(var/obj/item/rig_module/installed_mod in installed_modules)
					if(is_type_in_list(installed_mod,mod.banned_modules))
						to_chat(user, SPAN_DANGER("\The [installed_mod] is incompatible with this module."))
						return TRUE
					if(installed_mod.banned_modules.len)
						if(is_type_in_list(used_item,installed_mod.banned_modules))
							to_chat(user, SPAN_DANGER("\The [installed_mod] is incompatible with this module."))
							return TRUE
					if(!installed_mod.redundant && installed_mod.type == used_item.type)
						to_chat(user, "The hardsuit already has a module of that class installed.")
						return TRUE

			to_chat(user, "You begin installing \the [mod] into \the [src].")
			if(!do_after(user,40,src))
				return TRUE
			if(!user || !used_item)
				return TRUE
			if(!user.try_unequip(mod)) return TRUE
			to_chat(user, "You install \the [mod] into \the [src].")
			installed_modules |= mod
			mod.forceMove(src)
			mod.installed(src)
			update_icon()
			return TRUE

		else if(!cell && istype(used_item,/obj/item/cell))

			if(!user.try_unequip(used_item)) return TRUE
			to_chat(user, "You jack \the [used_item] into \the [src]'s battery mount.")
			used_item.forceMove(src)
			src.cell = used_item
			return TRUE

		else if(IS_WRENCH(used_item))

			var/list/current_mounts = list()
			if(cell) current_mounts   += "cell"
			if(air_supply) current_mounts += "tank"
			if(installed_modules && installed_modules.len) current_mounts += "system module"

			var/to_remove = input("Which would you like to modify?") as null|anything in current_mounts
			if(!to_remove)
				return TRUE

			if(ishuman(src.loc) && to_remove != "cell" && to_remove != "tank")
				var/mob/living/human/H = src.loc
				if(H.get_equipped_item(slot_back_str) == src)
					to_chat(user, "You can't remove an installed device while the hardsuit is being worn.")
					return TRUE

			switch(to_remove)

				if("cell")

					if(cell)
						to_chat(user, "You detach \the [cell] from \the [src]'s battery mount.")
						for(var/obj/item/rig_module/module in installed_modules)
							module.deactivate()
						user.put_in_hands(cell)
						cell = null
					else
						to_chat(user, "There is nothing loaded in that mount.")

				if("tank")
					if(!air_supply)
						to_chat(user, "There is no tank to remove.")
						return TRUE

					user.put_in_hands(air_supply)
					to_chat(user, "You detach and remove \the [air_supply].")
					air_supply = null

				if("system module")

					var/list/possible_removals = list()
					for(var/obj/item/rig_module/module in installed_modules)
						if(module.permanent)
							continue
						possible_removals[module.name] = module

					if(!possible_removals.len)
						to_chat(user, "There are no installed modules to remove.")
						return TRUE

					var/removal_choice = input("Which module would you like to remove?") as null|anything in possible_removals
					if(!removal_choice)
						return TRUE

					var/obj/item/rig_module/removed = possible_removals[removal_choice]
					to_chat(user, "You detach \the [removed] from \the [src].")
					removed.dropInto(loc)
					removed.removed()
					installed_modules -= removed
					update_icon()

		else if(istype(used_item,/obj/item/stack/nanopaste)) //EMP repair
			var/obj/item/stack/S = used_item
			if(malfunctioning || malfunction_delay)
				if(S.use(1))
					to_chat(user, "You pour some of \the [S] over \the [src]'s control circuitry and watch as the nanites do their work with impressive speed and precision.")
					malfunctioning = 0
					malfunction_delay = 0
				else
					to_chat(user, "\The [S] is empty!")
			else
				to_chat(user, "You don't see any use for \the [S].")
		return TRUE

	// If we've gotten this far, all we have left to do before we pass off to root procs
	// is check if any of the loaded modules want to use the item we've been given.
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.accepts_item(used_item,user)) //Item is handled in this proc
			return TRUE
	return ..()


/obj/item/rig/attack_hand(var/mob/user)
	if(electrified != 0 && shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
		return TRUE
	return ..()

/obj/item/rig/emag_act(var/remaining_charges, var/mob/user)
	if(!subverted)
		req_access?.Cut()
		locked = 0
		subverted = 1
		to_chat(user, "<span class='danger'>You short out the access protocol for the suit.</span>")
		return 1
