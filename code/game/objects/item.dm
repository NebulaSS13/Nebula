/obj/item
	name = "item"
	w_class = ITEM_SIZE_NORMAL
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	pass_flags = PASS_FLAG_TABLE
	abstract_type = /obj/item

	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/material_health_multiplier = 0.2
	var/hitsound
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	var/no_attack_log = 0			//If it's an item we don't want to log attack_logs with, set this to 1
	var/obj/item/master = null
	var/origin_tech                    //Used by R&D to determine what research bonuses it grants.
	var/list/attack_verb = list("hit") //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/lock_picking_level = 0 //used to determine whether something can pick a lock, and how well.
	var/force = 0
	var/attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	var/melee_accuracy_bonus = 0

	/// Flag for ZAS based contamination (chlorine etc)
	var/contaminated = FALSE

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the SLOT_HEAD, SLOT_UPPER_BODY, SLOT_LOWER_BODY, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the SLOT_HEAD, SLOT_UPPER_BODY, SLOT_LOWER_BODY, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags
	var/max_pressure_protection // Set this variable if the item protects its wearer against high pressures below an upper bound. Keep at null to disable protection.
	var/min_pressure_protection // Set this variable if the item protects its wearer against low pressures above a lower bound. Keep at null to disable protection. 0 represents protection against hard vacuum.

	var/datum/action/item_action/action = null
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.
	var/action_button_desc //A description for action button which will be displayed as tooltip.
	var/default_action_type = /datum/action/item_action // Specify the default type and behavior of the action button for this atom.

	//This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	//It should be used purely for appearance. For gameplay effects caused by items covering body parts, use body_parts_covered.
	var/flags_inv = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/item_flags = 0 //Miscellaneous flags pertaining to equippable objects.

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown_general = 0 // How much clothing is slowing you down. Negative values speeds you up. This is a genera##l slowdown, no matter equipment slot.
	var/slowdown_per_slot // How much clothing is slowing you down. This is an associative list: item slot - slowdown
	var/slowdown_accessory // How much an accessory will slow you down when attached to a worn article of clothing.
	var/canremove = 1 //Mostly for Ninja code at this point but basically will not allow the item to be removed if set to 0. /N
	var/material_armor_multiplier  // if set, item will use material's armor values multiplied by this.
	var/armor_type = /datum/extension/armor
	var/list/armor
	var/armor_degradation_speed //How fast armor will degrade, multiplier to blocked damage to get armor damage value.
	var/list/allowed = null //suit storage stuff.
	var/obj/item/uplink/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
	var/zoomdevicename = null //name used for message when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.

	var/base_parry_chance	// Will allow weapon to parry melee attacks if non-zero

	var/use_alt_layer = FALSE // Use the slot's alternative layer when rendering on a mob

	var/list/sprite_sheets // Assoc list of bodytype to icon for producing onmob overlays when this item is held or worn.

	// Material handling for material weapons (not used by default, unless material is supplied or set)
	var/decl/material/material                      // Reference to material decl. If set to a string corresponding to a material ID, will init the item with that material.
	///Will apply the flagged modifications to the object
	var/material_alteration = MAT_FLAG_ALTERATION_NONE
	var/max_force		                       // any damage above this is added to armor penetration value. If unset, autogenerated based on w_class
	var/material_force_multiplier = 0.1	       // Multiplier to material's generic damage value for this specific type of weapon
	var/thrown_material_force_multiplier = 0.1 // As above, but for throwing the weapon.
	var/anomaly_shielding					   // 0..1 value of how well it shields against xenoarch anomalies

	///Sound used when equipping the item into a valid slot
	var/equip_sound
	///Sound uses when picking the item up (into your hands)
	var/pickup_sound = 'sound/foley/paperpickup2.ogg'
	///Sound uses when dropping the item, or when its thrown.
	var/drop_sound = 'sound/foley/drop1.ogg'

	var/datum/reagents/coating // reagent container for coating things like blood/oil, used for overlays and tracks

	var/tmp/has_inventory_icon	// do not set manually
	var/tmp/use_single_icon
	var/center_of_mass = @'{"x":16,"y":16}' //can be null for no exact placement behaviour

/obj/item/proc/can_contaminate()
	return !(obj_flags & ITEM_FLAG_NO_CONTAMINATION)

// Foley sound callbacks
/obj/item/proc/equipped_sound_callback()
	if(ismob(loc) && equip_sound)
		playsound(src, equip_sound, 25, 0)

/obj/item/proc/pickup_sound_callback()
	if(ismob(loc) && pickup_sound)
		playsound(src, pickup_sound, 25, 0)

/obj/item/proc/dropped_sound_callback()
	if(!ismob(loc) && drop_sound)
		playsound(src, pick(drop_sound), 25, 0)

/obj/item/proc/get_origin_tech()
	return origin_tech

/obj/item/Initialize(var/ml, var/material_key)
	if(isnull(health))
		health = max_health //Make sure to propagate max_health to health var before material setup, for consistency
	if(!ispath(material_key, /decl/material))
		material_key = material
	if(material_key)
		set_material(material_key)
	. = ..()
	if(islist(armor))
		for(var/type in armor)
			if(armor[type]) // Don't set it if it gives no armor anyway, which is many items.
				set_extension(src, armor_type, armor, armor_degradation_speed)
				break
	if(randpixel && (!pixel_x && !pixel_y) && isturf(loc)) //hopefully this will prevent us from messing with mapper-set pixel_x/y
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
	reconsider_single_icon()

/obj/item/Destroy()

	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(hidden_uplink)
	QDEL_NULL(coating)

	if(ismob(loc))
		var/mob/M = loc
		LAZYREMOVE(M.pinned, src)
		LAZYREMOVE(M.embedded, src)
		for(var/obj/item/organ/external/organ in M.get_organs())
			LAZYREMOVE(organ.implants, src)
		M.drop_from_inventory(src)

	// TODO: CONVERT TO USE OBSERVATIONS
	var/obj/item/storage/storage = loc
	if(istype(storage))
		// some ui cleanup needs to be done
		storage.on_item_pre_deletion(src) // must be done before deletion // TODO: ADD PRE_DELETION OBSERVATION
		. = ..()
		storage.on_item_post_deletion(src) // must be done after deletion
	else
		return ..()

/obj/item/GetCloneArgs()
	. = ..()
	LAZYADD(., material?.type)

//#TODO: Implement this for all the sub class that need it
/obj/item/PopulateClone(obj/item/clone)
	clone = ..()
	clone.contaminated = contaminated
	clone.blood_overlay = image(blood_overlay)

	clone.health = health
	//#TODO: once item damage in, check health!

	//Coating
	clone.coating = coating?.Clone()
	if(clone.coating)
		clone.coating.set_holder(clone)
	return clone

//Run some updates
/obj/item/Clone()
	var/obj/item/clone = ..()
	if(clone)
		clone.update_icon()
		clone.update_held_icon()
	return clone

//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inhand_overlays()

/obj/item/proc/is_held_twohanded(mob/living/M)
	if(!M)
		M = loc
	if(!istype(M))
		return
	if(istype(loc, /obj/item/rig_module) || istype(loc, /obj/item/rig))
		return TRUE
	if(!(src in M.get_held_items()))
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/hand = GET_EXTERNAL_ORGAN(H, M.get_empty_hand_slot())
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE

/obj/item/examine(mob/user, distance)
	var/desc_comp = "" //For "description composite"
	desc_comp += "It is a [w_class_description()] item.<BR>"

	var/desc_damage = get_examined_damage_string()
	if(length(desc_damage))
		desc_comp += "[desc_damage]<BR>"

	var/added_header = FALSE
	if(user?.get_preference_value(/datum/client_preference/inquisitive_examine) == PREF_ON)

		var/list/available_recipes = list()
		for(var/decl/crafting_stage/initial_stage in SSfabrication.find_crafting_recipes(type))
			if(initial_stage.can_begin_with(src) && ispath(initial_stage.completion_trigger_type))
				var/atom/movable/prop = initial_stage.completion_trigger_type
				if(initial_stage.stack_consume_amount > 1)
					available_recipes[initial_stage] = "[initial_stage.stack_consume_amount] [initial(prop.name)]\s"
				else
					available_recipes[initial_stage] = "\a [initial(prop.name)]"

		if(length(available_recipes))

			if(!added_header)
				added_header = TRUE
				desc_comp += "*--------*<BR>"

			for(var/decl/crafting_stage/initial_stage in available_recipes)
				desc_comp += SPAN_NOTICE("With [available_recipes[initial_stage]], you could start making \a [initial_stage.descriptor] out of this.")
				desc_comp += "<BR>"
			desc_comp += "*--------*<BR>"

	if(distance <= 1 && has_extension(src, /datum/extension/loaded_cell))

		if(!added_header)
			added_header = TRUE
			desc_comp += "*--------*<BR>"

		var/datum/extension/loaded_cell/cell_loaded = get_extension(src, /datum/extension/loaded_cell)
		var/obj/item/cell/loaded_cell  = cell_loaded?.get_cell()
		var/obj/item/cell/current_cell = get_cell()
		// Some items use the extension but may return something else to get_cell().
		// In these cases, don't print the removal info etc.
		if(current_cell && current_cell != loaded_cell)
			desc_comp += SPAN_NOTICE("\The [src] is using an external [current_cell.name] as a power supply.")
		else
			desc_comp += jointext(cell_loaded.get_examine_text(current_cell), "<BR>")
		desc_comp += "<BR>*--------*<BR>"

	if(hasHUD(user, HUD_SCIENCE)) //Mob has a research scanner active.

		if(!added_header)
			added_header = TRUE
			desc_comp += "*--------*<BR>"

		if(origin_tech)
			desc_comp += SPAN_NOTICE("Testing potentials:")
			desc_comp += "<BR>"
			var/list/techlvls = cached_json_decode(origin_tech)
			for(var/T in techlvls)
				var/decl/research_field/field = SSfabrication.get_research_field_by_id(T)
				desc_comp += "Tech: Level [techlvls[T]] [field.name].<BR>"
		else
			desc_comp += "No tech origins detected.<BR>"

		if(LAZYLEN(matter))
			desc_comp += SPAN_NOTICE("Extractable materials:")
			desc_comp += "<BR>"
			for(var/mat in matter)
				var/decl/material/M = GET_DECL(mat)
				desc_comp += "[capitalize(M.solid_name)]<BR>"
		else
			desc_comp += SPAN_DANGER("No extractable materials detected.<BR>")
		desc_comp += "*--------*<BR>"

	return ..(user, distance, "", desc_comp)

/obj/item/check_mousedrop_adjacency(var/atom/over, var/mob/user)
	. = (loc == user && istype(over, /obj/screen/inventory)) || ..()

/obj/item/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user)
		usr.face_atom(src)
		dragged_onto(over)
		return TRUE

	// Allow dragging items onto/around tables and racks.
	if(istype(over, /obj/structure))
		var/obj/structure/struct = over
		if(struct.structure_flags & STRUCTURE_FLAG_SURFACE)
			if(user == loc && !user.try_unequip(src, get_turf(user)))
				return TRUE
			if(!isturf(loc))
				return TRUE
			var/list/click_data = params2list(params)
			do_visual_slide(src, get_turf(src), pixel_x, pixel_y, get_turf(over), text2num(click_data["icon-x"])-1, text2num(click_data["icon-y"])-1, center_of_mass && cached_json_decode(center_of_mass))
			return TRUE

	// Try to drag-equip the item.
	var/obj/screen/inventory/inv = over
	if(user.client && istype(inv) && inv.slot_id && (over in user.client.screen))
		// Remove the item from our bag if necessary.
		if(istype(loc, /obj/item/storage))
			var/obj/item/storage/bag = loc
			bag.remove_from_storage(src)
			dropInto(get_turf(bag))
		// Otherwise remove it from our inventory if necessary.
		else if(ismob(loc))
			var/mob/M = loc
			if(!M.try_unequip(src, get_turf(src)))
				return ..()
		// Equip to the slot we dragged over.
		if(isturf(loc) && mob_can_equip(user, inv.slot_id, disable_warning = TRUE))
			add_fingerprint(user)
			user.equip_to_slot_if_possible(src, inv.slot_id)
		return TRUE


	. = ..()

/obj/item/proc/dragged_onto(var/mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/item/afterattack(var/atom/A, var/mob/user, var/proximity)
	. = ..()
	if(. || !proximity)
		return
	var/atom_heat = get_heat()
	if(atom_heat > 0)
		A.handle_external_heating(atom_heat, src, user)
		return TRUE
	return FALSE

/obj/item/attack_hand(mob/user)

	if(!user)
		return FALSE

	if(anchored)
		return ..()

	if(!user.check_dexterity(DEXTERITY_EQUIP_ITEM, silent = TRUE))

		if(user.check_dexterity(DEXTERITY_HOLD_ITEM, silent = TRUE))

			if(loc == user)
				to_chat(user, SPAN_NOTICE("You begin trying to remove \the [src]..."))
				if(do_after(user, 3 SECONDS, src) && user.try_unequip(src))
					user.drop_from_inventory(src)
				else
					to_chat(user, SPAN_WARNING("You fail to remove \the [src]!"))
				return TRUE

			if(isturf(loc))
				if(loc == get_turf(user))
					attack_self(user)
				else
					dropInto(get_turf(user))
				return TRUE

			if(istype(loc, /obj/item/storage))
				visible_message(SPAN_NOTICE("\The [user] fumbles \the [src] out of \the [loc]."))
				var/obj/item/storage/bag = loc
				bag.remove_from_storage(src)
				dropInto(get_turf(bag))
				return TRUE

		to_chat(user, SPAN_WARNING("You are not dexterous enough to pick up \the [src]."))
		return TRUE

	var/old_loc = loc
	if (istype(loc, /obj/item/storage))
		var/obj/item/storage/S = loc
		S.remove_from_storage(src)

	if(!QDELETED(throwing))
		throwing.finalize(hit=TRUE)

	if(has_extension(src, /datum/extension/loaded_cell) && user.is_holding_offhand(src))
		var/datum/extension/loaded_cell/cell_handler = get_extension(src, /datum/extension/loaded_cell)
		if(cell_handler.try_unload(user))
			return TRUE

	if (loc == user)
		if(!user.try_unequip(src))
			return TRUE
	else if(isliving(loc))
		return TRUE

	if(!QDELETED(src) && user.put_in_active_hand(src))
		on_picked_up(user)
		if (isturf(old_loc))
			var/obj/effect/temporary/item_pickup_ghost/ghost = new(old_loc, src)
			ghost.animate_towards(user)
		if(randpixel)
			pixel_x = rand(-randpixel, randpixel)
			pixel_y = rand(-randpixel/2, randpixel/2)
			pixel_z = 0
		else if(randpixel == 0)
			pixel_x = 0
			pixel_y = 0
	return TRUE

/obj/item/attack_ai(mob/living/silicon/ai/user)
	if (istype(src.loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

/obj/item/attackby(obj/item/W, mob/user)

	if(SSfabrication.try_craft_with(src, W, user))
		return TRUE

	if(SSfabrication.try_craft_with(W, src, user))
		return TRUE

	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect all items
				if(isturf(src.loc))
					S.gather_all(src.loc, user)
				return TRUE
			else if(S.can_be_inserted(src, user))
				S.handle_item_insertion(src)
				return TRUE

	if(has_extension(src, /datum/extension/loaded_cell))
		var/datum/extension/loaded_cell/cell_loaded = get_extension(src, /datum/extension/loaded_cell)
		if(cell_loaded.has_tool_unload_interaction(W))
			return cell_loaded.try_unload(user, W)
		else if(istype(W, /obj/item/cell))
			return cell_loaded.try_load(user, W)

	return FALSE

/obj/item/proc/talk_into(mob/living/M, message, message_mode, var/verb = "says", var/decl/language/speaking = null)
	return

/obj/item/proc/moved(mob/user, old_loc)
	return

// apparently called whenever an item is removed from a slot, container, or anything else.
/obj/item/proc/dropped(var/mob/user, var/play_dropsound = TRUE)

	SHOULD_CALL_PARENT(TRUE)
	if(randpixel)
		pixel_z = randpixel //an idea borrowed from some of the older pixel_y randomizations. Intended to make items appear to drop at a character
	update_twohanding()
	for(var/obj/item/thing in user?.get_held_items())
		thing.update_twohanding()
	if(play_dropsound && drop_sound && SSticker.mode)
		addtimer(CALLBACK(src, PROC_REF(dropped_sound_callback)), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))

	if(user && (z_flags & ZMM_MANGLE_PLANES))
		addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, check_emissive_equipment)), 0, TIMER_UNIQUE)

	RAISE_EVENT(/decl/observ/mob_unequipped, user, src)
	RAISE_EVENT_REPEAT(/decl/observ/item_unequipped, src, user)

// called just after an item is picked up, after it has been equipped to the mob.
/obj/item/proc/on_picked_up(mob/user)
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(var/mob/user, var/slot)
	SHOULD_CALL_PARENT(TRUE)

	add_fingerprint(user)

	hud_layerise()
	addtimer(CALLBACK(src, PROC_REF(reconsider_client_screen_presence), user.client, slot), 0)

	//Update two-handing status
	var/mob/M = loc
	if(istype(M))
		for(var/obj/item/held in M.get_held_items())
			held.update_twohanding()

	if(user)
		if(SSticker.mode)
			if(pickup_sound && (slot in user.get_held_item_slots()))
				addtimer(CALLBACK(src, PROC_REF(pickup_sound_callback)), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))
			else if(equip_sound)
				addtimer(CALLBACK(src, PROC_REF(equipped_sound_callback)), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))
		if(z_flags & ZMM_MANGLE_PLANES)
			addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, check_emissive_equipment)), 0, TIMER_UNIQUE)

	RAISE_EVENT(/decl/observ/mob_equipped, user, src, slot)
	RAISE_EVENT_REPEAT(/decl/observ/item_equipped, src, user, slot)

// As above but for items being equipped to an active module on a robot.
/obj/item/proc/equipped_robot(var/mob/user)
	return

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Set ignore_equipped to 1 if you wish to ignore covering checks etc. when this item is already equipped.
/obj/item/proc/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	if(!slot || !user)
		return FALSE

	// Some slots don't have an associated handler as they are shorthand for various setup functions.
	if(slot in global.abstract_inventory_slots)
		switch(slot)
			// Putting stuff into backpacks.
			if(slot_in_backpack_str)
				var/obj/item/storage/backpack/backpack = user.get_equipped_item(slot_back_str)
				return istype(backpack) && backpack.can_be_inserted(src, user, TRUE)
			// Equipping accessories.
			if(slot_tie_str)
				// Find something to equip the accessory to.
				for(var/check_slot in list(slot_w_uniform_str, slot_wear_suit_str))
					var/obj/item/clothing/check_gear = user.get_equipped_item(check_slot)
					if(istype(check_gear) && check_gear.can_attach_accessory(src))
						return TRUE
				if(!disable_warning)
					to_chat(user, SPAN_WARNING("You need to be wearing something you can attach \the [src] to."))
				return FALSE

	var/datum/inventory_slot/inv_slot = user.get_inventory_slot_datum(slot)
	if(!inv_slot)
		return FALSE

	if(!force)
		if(!ignore_equipped && !inv_slot.is_accessible(user, src, disable_warning))
			return FALSE

	if(!inv_slot.can_equip_to_slot(user, src, disable_warning, ignore_equipped))
		return FALSE

	return TRUE

/obj/item/proc/mob_can_unequip(mob/user, slot, disable_warning = FALSE)
	if(!slot || !user || !canremove)
		return FALSE
	var/datum/inventory_slot/inv_slot = user.get_inventory_slot_datum(slot)
	return inv_slot?.is_accessible(user, src, disable_warning)

/obj/item/proc/can_be_dropped_by_client(mob/M)
	return M.canUnEquip(src)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!CanPhysicallyInteract(usr) || !ishuman(usr) || !isturf(loc) || !simulated)
		return
	if(usr.incapacitated() || usr.restrained())
		to_chat(usr, SPAN_WARNING("You cannot pick up \the [src] at the moment."))
		return
	if(anchored)
		to_chat(usr, SPAN_WARNING("\The [src] won't budge."))
		return
	if(!usr.get_empty_hand_slot())
		to_chat(usr, SPAN_WARNING("Your hands are full."))
		return
	usr.UnarmedAttack(src)


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	attack_self(usr)

//RETURN VALUES
//handle_shield should return a positive value to indicate that the attack is blocked and should be prevented.
//If a negative value is returned, it should be treated as a special return value for bullet_act() and handled appropriately.
//For non-projectile attacks this usually means the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/parry_chance = get_parry_chance(user)
	if(attacker)
		parry_chance = max(0, parry_chance - 10 * attacker.get_skill_difference(SKILL_COMBAT, user))
	if(parry_chance)
		if(default_parry_check(user, attacker, damage_source) && prob(parry_chance))
			user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))
			playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
			on_parry(damage_source)
			return 1
	return 0

/obj/item/proc/on_parry(damage_source)
	return

/obj/item/proc/get_parry_chance(mob/user)
	. = base_parry_chance
	if(user)
		if(base_parry_chance || user.skill_check(SKILL_COMBAT, SKILL_ADEPT))
			. += 10 * (user.get_skill_value(SKILL_COMBAT) - SKILL_BASIC)

/obj/item/proc/on_disarm_attempt(mob/target, mob/living/attacker)
	if(force < 1)
		return 0
	if(!istype(attacker))
		return 0
	var/decl/pronouns/G = attacker.get_pronouns()
	attacker.apply_damage(force, damtype, attacker.get_active_held_item_slot(), used_weapon = src)
	attacker.visible_message(SPAN_DANGER("\The [attacker] hurts [G.his] hand on \the [src]!"))
	playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	playsound(target, hitsound, 50, 1, -1)
	return 1

/obj/item/clean_blood()
	. = ..()
	clean()

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = FLUORESCENT_GLOWS
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M, amount = 2, list/blood_data)
	if (!..())
		return FALSE

	if(istype(src, /obj/item/energy_blade))
		return

	if(!istype(M))
		return TRUE

	if(!blood_data)
		blood_data = REAGENT_DATA(M.vessel, /decl/material/liquid/blood)

	var/sample_dna = LAZYACCESS(blood_data, "blood_DNA")
	if(sample_dna)
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
		forensics.add_data(/datum/forensics/blood_dna, sample_dna)
	add_coating(/decl/material/liquid/blood, amount, blood_data)

	var/unique_enzymes = M.get_unique_enzymes()
	var/blood_type = M.get_blood_type()
	if(unique_enzymes && blood_type && !LAZYACCESS(blood_DNA, unique_enzymes))
		LAZYSET(blood_DNA, unique_enzymes, blood_type)

	return TRUE

var/global/list/_blood_overlay_cache = list()
var/global/list/_item_blood_mask = icon('icons/effects/blood.dmi', "itemblood")
/obj/item/proc/generate_blood_overlay(force = FALSE)
	if(blood_overlay && !force)
		return
	var/cache_key = "[icon]-[icon_state]"
	if(global._blood_overlay_cache[cache_key])
		blood_overlay = global._blood_overlay_cache[cache_key]
		return
	var/icon/I = new /icon(icon, icon_state)
	I.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1)         // Sets the icon RGB channel to pure white.
	I.Blend(global._item_blood_mask, ICON_MULTIPLY) // Masks the blood overlay against the generated mask.
	blood_overlay = image(I)
	blood_overlay.appearance_flags |= NO_CLIENT_COLOR|RESET_COLOR
	global._blood_overlay_cache[cache_key] = blood_overlay

/obj/item/proc/showoff(mob/user)
	for(var/mob/M in view(user))
		if(!user.is_invisible_to(M))
			M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", 1)

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal vision. Still, increase viewsize a tiny bit so that sniping isn't as restricted to NSEW
/obj/item/proc/zoom(mob/user, var/tileoffset = 14,var/viewsize = 9) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view
	if(!user.client)
		return
	if(zoom)
		return

	var/devicename = zoomdevicename || name

	var/mob/living/carbon/human/H = user
	if(user.incapacitated(INCAPACITATION_DISABLED))
		to_chat(user, SPAN_WARNING("You are unable to focus through the [devicename]."))
		return
	else if(!zoom && istype(H) && H.equipment_tint_total >= TINT_MODERATE)
		to_chat(user, SPAN_WARNING("Your visor gets in the way of looking through the [devicename]."))
		return
	else if(!zoom && user.get_active_hand() != src)
		to_chat(user, SPAN_WARNING("You are too distracted to look through the [devicename], perhaps if it was in your active hand this might work better."))
		return

	if(user.hud_used.hud_shown)
		user.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
	user.client.view = viewsize
	zoom = 1

	var/viewoffset = WORLD_ICON_SIZE * tileoffset
	switch(user.dir)
		if (NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = viewoffset
		if (SOUTH)
			user.client.pixel_x = 0
			user.client.pixel_y = -viewoffset
		if (EAST)
			user.client.pixel_x = viewoffset
			user.client.pixel_y = 0
		if (WEST)
			user.client.pixel_x = -viewoffset
			user.client.pixel_y = 0

	user.visible_message("\The [user] peers through [zoomdevicename ? "the [zoomdevicename] of [src]" : "[src]"].")

	events_repository.register(/decl/observ/destroyed, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.register(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.register(/decl/observ/dir_set, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.register(/decl/observ/item_unequipped, src, src, TYPE_PROC_REF(/obj/item, zoom_drop))
	if(isliving(user))
		events_repository.register(/decl/observ/stat_set, user, src, TYPE_PROC_REF(/obj/item, unzoom))

/obj/item/proc/zoom_drop(var/obj/item/I, var/mob/user)
	unzoom(user)

/obj/item/proc/unzoom(var/mob/user)
	if(!zoom)
		return
	zoom = 0

	events_repository.unregister(/decl/observ/destroyed, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.unregister(/decl/observ/moved, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.unregister(/decl/observ/dir_set, user, src, TYPE_PROC_REF(/obj/item, unzoom))
	events_repository.unregister(/decl/observ/item_unequipped, src, src, TYPE_PROC_REF(/obj/item, zoom_drop))
	if(isliving(user))
		events_repository.unregister(/decl/observ/stat_set, user, src, TYPE_PROC_REF(/obj/item, unzoom))

	if(!user.client)
		return

	user.client.view = world.view
	if(!user.hud_used.hud_shown)
		user.toggle_zoom_hud()
	user.client.pixel_x = 0
	user.client.pixel_y = 0
	user.client.OnResize()
	user.visible_message("[zoomdevicename ? "\The [user] looks up from [src]" : "\The [user] lowers [src]"].")

/obj/item/proc/pwr_drain()
	return 0 // Process Kill

/obj/item/proc/get_examine_line()
	if(coating)
		. = SPAN_WARNING("[html_icon(src)] [gender==PLURAL?"some":"a"] <font color='[coating.get_color()]'>stained</font> [name]")
	else
		. = "[html_icon(src)] \a [src]"
	var/ID = GetIdCard()
	if(ID)
		. += "  <a href='?src=\ref[ID];look_at_id=1'>\[Look at ID\]</a>"

/obj/item/proc/on_active_hand()

/obj/item/proc/has_embedded()
	return

/obj/item/proc/get_pressure_weakness(pressure,zone)
	. = 1
	if(pressure > ONE_ATMOSPHERE)
		if(max_pressure_protection != null)
			if(max_pressure_protection < pressure)
				return min(1, round((pressure - max_pressure_protection) / max_pressure_protection, 0.01))
			else
				return 0
	if(pressure < ONE_ATMOSPHERE)
		if(min_pressure_protection != null)
			if(min_pressure_protection > pressure)
				return min(1, round((min_pressure_protection - pressure) / min_pressure_protection, 0.01))
			else
				return 0

/obj/item/do_simple_ranged_interaction(var/mob/user)
	if(user)
		attack_self(user)
	return TRUE

/obj/item/proc/inherit_custom_item_data(var/datum/custom_item/citem)
	. = src
	if(citem.item_name)
		SetName(citem.item_name)
	if(citem.item_desc)
		desc = citem.item_desc
	if(citem.item_icon)
		icon = citem.item_icon
	if(citem.item_state)
		set_icon_state(citem.item_state)

/obj/item/proc/is_special_cutting_tool(var/high_power)
	return FALSE

/obj/item/proc/w_class_description()
	switch(w_class)
		if(ITEM_SIZE_TINY)
			return "tiny"
		if(ITEM_SIZE_SMALL)
			return "small"
		if(ITEM_SIZE_NORMAL)
			return "normal-sized"
		if(ITEM_SIZE_LARGE)
			return "large"
		if(ITEM_SIZE_HUGE)
			return "bulky"
		if(ITEM_SIZE_HUGE + 1 to INFINITY)
			return "huge"

/obj/item/proc/get_autopsy_descriptors()
	var/list/descriptors = list()
	descriptors += w_class_description()
	if(sharp)
		descriptors += "sharp"
	if(edge)
		descriptors += "edged"
	if(force >= 10 && !sharp && !edge)
		descriptors += "heavy"
	if(material)
		descriptors += "made of [material.solid_name]"
	return descriptors

/obj/item/proc/attack_message_name()
	return "\a [src]"

/obj/item/proc/add_coating(reagent_type, amount, data)
	if(!coating)
		coating = new/datum/reagents(10, src)
	coating.add_reagent(reagent_type, amount, data)

	if(!blood_overlay)
		generate_blood_overlay()
	blood_overlay.color = coating.get_color()

	update_icon()

/obj/item/proc/remove_coating(amount)
	if(!coating)
		return
	coating.remove_any(amount)
	if(coating.total_volume <= MINIMUM_CHEMICAL_VOLUME)
		clean(0)

/obj/item/proc/clean(clean_forensics=TRUE)
	QDEL_NULL(coating)
	blood_overlay = null
	if(clean_forensics)
		var/datum/extension/forensic_evidence/forensics = get_extension(src, /datum/extension/forensic_evidence)
		if(forensics)
			forensics.remove_data(/datum/forensics/trace_dna)
			forensics.remove_data(/datum/forensics/blood_dna)
			forensics.remove_data(/datum/forensics/gunshot_residue)
	update_icon()
	update_clothing_icon()

// Used to call appropriate slot updates in update_clothing_icon()
/obj/item/proc/get_associated_equipment_slots()
	SHOULD_CALL_PARENT(TRUE)
	if(item_flags & ITEM_FLAG_IS_BELT)
		LAZYADD(., slot_belt_str)

// Updates the icons of the mob wearing the clothing item, if any.
/obj/item/proc/update_clothing_icon()
	var/mob/wearer = loc
	if(!istype(wearer))
		return FALSE
	var/equip_slots = get_associated_equipment_slots()
	if(!islist(equip_slots))
		return FALSE
	for(var/slot in equip_slots)
		wearer.update_equipment_overlay(slot, FALSE)
	wearer.update_icon()
	return TRUE

/obj/item/proc/reconsider_client_screen_presence(var/client/client, var/slot)
	if(!client)
		return
	if(client.mob?.item_should_have_screen_presence(src, slot))
		client.screen |= src
	else
		client.screen -= src

/obj/item/proc/gives_weather_protection()
	return FALSE

/obj/item/proc/get_assembly_detail_color()
	return

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/item/singularity_pull(S, current_size)
	set waitfor = FALSE
	if(!simulated || anchored)
		return
	sleep(0) //this is needed or multiple items will be thrown sequentially and not simultaneously
	if(current_size >= STAGE_FOUR)
		//throw_at(S, 14, 3)
		step_towards(src,S)
		sleep(1)
		step_towards(src,S)
	else if(current_size > STAGE_ONE)
		step_towards(src,S)
	else ..()

/obj/item/check_mousedrop_adjacency(var/atom/over, var/mob/user)
	. = (loc == user && istype(over, /obj/screen)) || ..()

// Supplied during loadout gear tweaking.
/obj/item/proc/set_custom_name(var/new_name)
	SetName(new_name)

// Supplied during loadout gear tweaking.
/obj/item/proc/set_custom_desc(var/new_desc)
	desc = new_desc

/obj/item/proc/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	SHOULD_CALL_PARENT(FALSE)
	if(loaded_cell_type && accepted_cell_type)
		set_extension(src, (power_supply_extension_type || /datum/extension/loaded_cell), accepted_cell_type, loaded_cell_type, charge_value)

/obj/item/proc/handle_loadout_equip_replacement(obj/item/old_item)
	return
