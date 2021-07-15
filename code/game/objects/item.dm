/obj/item
	name = "item"
	w_class = ITEM_SIZE_NORMAL
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	pass_flags = PASS_FLAG_TABLE

	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/r_speed = 1.0
	var/health = null
	var/max_health
	var/material_health_multiplier = 0.2
	var/burn_point = null
	var/burning = null
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
	var/applies_material_colour = FALSE        // Whether or not the material recolours this icon.
	var/applies_material_name = FALSE          // If true, item becomes 'material item' ie. 'steel hatchet'.
	var/max_force		                       // any damage above this is added to armor penetration value. If unset, autogenerated based on w_class
	var/material_force_multiplier = 0.1	       // Multiplier to material's generic damage value for this specific type of weapon
	var/thrown_material_force_multiplier = 0.1 // As above, but for throwing the weapon.
	var/unbreakable = FALSE                    // Whether or not this weapon degrades.
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

// Foley sound callbacks
/obj/item/proc/equipped_sound_callback()
	if(ismob(loc) && equip_sound)
		playsound(src, equip_sound, 25, 0)

/obj/item/proc/pickup_sound_callback()
	if(ismob(loc) && pickup_sound)
		playsound(src, pickup_sound, 25, 0)

/obj/item/proc/dropped_sound_callback()
	if(!ismob(loc) && drop_sound)
		playsound(src, drop_sound, 25, 0)

/obj/item/proc/get_origin_tech()
	return origin_tech

/obj/item/create_matter()
	..()
	LAZYINITLIST(matter)
	if(istype(material))
		matter[material.type] = max(matter[material.type], round(MATTER_AMOUNT_PRIMARY * get_matter_amount_modifier()))
	UNSETEMPTY(matter)

/obj/item/Initialize(var/ml, var/material_key)
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
	if(ismob(loc))
		var/mob/m = loc
		m.drop_from_inventory(src)
	var/obj/item/storage/storage = loc
	if(istype(storage))
		// some ui cleanup needs to be done
		storage.on_item_pre_deletion(src) // must be done before deletion
		. = ..()
		storage.on_item_post_deletion(src) // must be done after deletion
	else
		return ..()

//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_hands()

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
		var/obj/item/organ/external/hand = H.organs_by_name[M.get_empty_hand_slot()]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE

/obj/item/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50) || (severity == 3 && prob(5)))))
		qdel(src)

/obj/item/examine(mob/user, distance)
	var/desc_comp = "" //For "description composite"
	desc_comp += "It is a [w_class_description()] item."

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
			desc_comp += "<BR>*--------* <BR>"
			for(var/decl/crafting_stage/initial_stage in available_recipes)
				desc_comp += SPAN_NOTICE("With [available_recipes[initial_stage]], you could start making \a [initial_stage.descriptor] out of this.")
				desc_comp += "<BR>"
			desc_comp += "*--------*"

	if(hasHUD(user, HUD_SCIENCE)) //Mob has a research scanner active.
		desc_comp += "<BR>*--------* <BR>"

		if(origin_tech)
			desc_comp += SPAN_NOTICE("Testing potentials:<BR>")
			var/list/techlvls = cached_json_decode(origin_tech)
			for(var/T in techlvls)
				var/decl/research_field/field = SSfabrication.get_research_field_by_id(T)
				desc_comp += "Tech: Level [techlvls[T]] [field.name] <BR>"
		else
			desc_comp += "No tech origins detected.<BR>"

		if(LAZYLEN(matter))
			desc_comp += SPAN_NOTICE("Extractable materials:<BR>")
			for(var/mat in matter)
				var/decl/material/M = GET_DECL(mat)
				desc_comp += "[capitalize(M.solid_name)]<BR>"
		else
			desc_comp += SPAN_DANGER("No extractable materials detected.<BR>")
		desc_comp += "*--------*"

	return ..(user, distance, "", desc_comp)

// This is going to need a solid go-over to properly integrate all the movement procs into each
// other and make sure everything is updating nicely. Snowflaking it for now. ~Jan 2020
/obj/item/handle_mouse_drop(atom/over, mob/user)

	if(over == user)
		usr.face_atom(src)
		dragged_onto(over)
		return TRUE

	var/obj/screen/inventory/inv = over
	if(user.client && istype(inv) && inv.slot_id && (over in user.client.screen))
		if(istype(loc, /obj/item/storage))
			var/obj/item/storage/bag = loc
			bag.remove_from_storage(src)
			dropInto(get_turf(bag))
		else if(istype(loc, /mob))
			var/mob/M = loc
			if(!M.unEquip(src, get_turf(src)))
				return ..()
		user.equip_to_slot_if_possible(src, inv.slot_id)
		return TRUE

	. = ..()

/obj/item/proc/dragged_onto(var/mob/user)
	attack_hand(user)

/obj/item/attack_hand(mob/user)

	if(!user)
		return

	if(anchored)
		return ..()

	if(!user.check_dexterity(DEXTERITY_GRIP, silent = TRUE))

		if(user.check_dexterity(DEXTERITY_KEYBOARDS, silent = TRUE))

			if(loc == user)
				to_chat(user, SPAN_NOTICE("You begin trying to remove \the [src]..."))
				if(do_after(user, 3 SECONDS, src) && user.unEquip(src))
					user.drop_from_inventory(src)
				else
					to_chat(user, SPAN_WARNING("You fail to remove \the [src]!"))
				return

			if(isturf(loc))
				if(loc == get_turf(user))
					attack_self(user)
				else
					dropInto(get_turf(user))
				return

			if(istype(loc, /obj/item/storage))
				visible_message(SPAN_NOTICE("\The [user] fumbles \the [src] out of \the [loc]."))
				var/obj/item/storage/bag = loc
				bag.remove_from_storage(src)
				dropInto(get_turf(bag))
				return

		to_chat(user, SPAN_WARNING("You are not dexterous enough to pick up \the [src]."))
		return

	var/old_loc = loc
	pickup(user)
	if (istype(loc, /obj/item/storage))
		var/obj/item/storage/S = loc
		S.remove_from_storage(src)

	if(!QDELETED(throwing))
		throwing.finalize(hit=TRUE)

	if (loc == user)
		if(!user.unEquip(src))
			return
	else
		if(isliving(loc))
			return

	if(QDELETED(src))
		return // Unequipping changes our state, so must check here.

	if(user.put_in_active_hand(src))
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
			else if(S.can_be_inserted(src, user))
				S.handle_item_insertion(src)

/obj/item/proc/talk_into(mob/M, text)
	return

/obj/item/proc/moved(mob/user, old_loc)
	return

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
	if(throwforce && w_class)
		return Clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return Clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0

/obj/item/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
		var/volume = get_volume_by_throwforce_and_or_w_class()
		if (throwforce > 0)
			if(hitsound)
				playsound(hit_atom, hitsound, volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)

// apparently called whenever an item is removed from a slot, container, or anything else.
/obj/item/proc/dropped(mob/user)
	if(randpixel)
		pixel_z = randpixel //an idea borrowed from some of the older pixel_y randomizations. Intended to make items appear to drop at a character
	update_twohanding()
	for(var/obj/item/thing in user?.get_held_items())
		thing.update_twohanding()
	if(drop_sound && SSticker.mode)
		addtimer(CALLBACK(src, .proc/dropped_sound_callback), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
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
	hud_layerise()
	if(user.client)
		user.client.screen |= src
	//Update two-handing status
	var/mob/M = loc
	if(istype(M))
		for(var/obj/item/held in M.get_held_items())
			held.update_twohanding()

	if(SSticker.mode && (equip_sound || pickup_sound))
		if((slot_flags & global.slot_flags_enumeration[slot]) && equip_sound)
			addtimer(CALLBACK(src, .proc/equipped_sound_callback), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))
		else if(isliving(user) && pickup_sound)
			var/mob/living/L = user
			if(slot in L.held_item_slots)
				addtimer(CALLBACK(src, .proc/pickup_sound_callback), 0, (TIMER_OVERRIDE | TIMER_UNIQUE))

//Defines which slots correspond to which slot flags
var/global/list/slot_flags_enumeration = list(
	"[slot_wear_mask_str]" = SLOT_FACE,
	"[slot_back_str]" = SLOT_BACK,
	"[slot_wear_suit_str]" = SLOT_OVER_BODY,
	"[slot_gloves_str]" = SLOT_HANDS,
	"[slot_shoes_str]" = SLOT_FEET,
	"[slot_belt_str]" = SLOT_LOWER_BODY,
	"[slot_glasses_str]" = SLOT_EYES,
	"[slot_head_str]" = SLOT_HEAD,
	"[slot_l_ear_str]" = SLOT_EARS,
	"[slot_r_ear_str]" = SLOT_EARS,
	"[slot_w_uniform_str]" = SLOT_UPPER_BODY,
	"[slot_wear_id_str]" = SLOT_ID,
	"[slot_tie_str]" = SLOT_TIE,
	)

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Should probably move the bulk of this into mob code some time, as most of it is related to the definition of slots and not item-specific
//set force to ignore blocking overwear and occupied slots
/obj/item/proc/mob_can_equip(M, slot, disable_warning = 0, force = 0)

	if(!slot || !M || !ishuman(M))
		return FALSE

	var/can_hold = FALSE
	if(isliving(M) && !isnum(slot))
		var/mob/living/L = M
		can_hold = !!LAZYACCESS(L.held_item_slots, slot)

	//First check if the item can be equipped to the desired slot.
	var/list/mob_equip = list()
	var/mob/living/carbon/human/H = M
	if(!can_hold)
		if(H.species.hud && H.species.hud.equip_slots)
			mob_equip = H.species.hud.equip_slots
		if(H.species && !(slot in mob_equip))
			return FALSE
		var/associated_slot = global.slot_flags_enumeration[slot]
		if(!isnull(associated_slot) && !(associated_slot & slot_flags))
			return 0

	if(!force)
		//Next check that the slot is free
		if(H.get_equipped_item(slot))
			return FALSE
		//Next check if the slot is accessible.
		var/mob/_user = disable_warning? null : H
		if(!H.slot_is_accessible(slot, src, _user))
			return FALSE

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(slot_l_ear_str, slot_r_ear_str)
			if((w_class > ITEM_SIZE_TINY) && !(slot_flags & SLOT_EARS))
				return FALSE
		if(slot_belt_str)
			if(slot == slot_belt_str && (item_flags & ITEM_FLAG_IS_BELT))
				return TRUE
			else if(!H.w_uniform && (slot_w_uniform_str in H.species.hud?.equip_slots))
				if(!disable_warning)
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
				return FALSE
		if(slot_l_store_str, slot_r_store_str)
			if(!H.w_uniform && (slot_w_uniform_str in H.species.hud?.equip_slots))
				if(!disable_warning)
					to_chat(H, SPAN_WARNING("You need a jumpsuit before you can attach this [name]."))
				return FALSE
			if( w_class > ITEM_SIZE_SMALL && !(slot_flags & SLOT_POCKET) )
				return FALSE
			if(get_storage_cost() >= ITEM_SIZE_NO_CONTAINER)
				return FALSE
		if(slot_s_store_str)
			if(!H.wear_suit && (slot_wear_suit_str in H.species.hud?.equip_slots))
				if(!disable_warning)
					to_chat(H, SPAN_WARNING("You need a suit before you can attach this [name]."))
				return FALSE
			if(H.wear_suit && !H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(usr, SPAN_WARNING("You somehow have a suit with no defined allowed items for suit storage, stop that."))
				return FALSE
			if( !(istype(src, /obj/item/modular_computer/pda) || istype(src, /obj/item/pen) || is_type_in_list(src, H.wear_suit.allowed)) )
				return FALSE
		if(slot_handcuffed_str)
			if(!istype(src, /obj/item/handcuffs))
				return FALSE
		if(slot_in_backpack_str) //used entirely for equipping spawned mobs or at round start
			var/allow = FALSE
			if(H.back && istype(H.back, /obj/item/storage/backpack))
				var/obj/item/storage/backpack/B = H.back
				if(B.can_be_inserted(src,M,1))
					allow = TRUE
			if(!allow)
				return FALSE
		if(slot_tie_str)
			if((!H.w_uniform && (slot_w_uniform_str in H.species.hud?.equip_slots)) && (!H.wear_suit && (slot_wear_suit_str in H.species.hud?.equip_slots)))
				if(!disable_warning)
					to_chat(H, SPAN_WARNING("You need something you can attach \the [src] to."))
				return FALSE
			if(H.w_uniform && (slot_w_uniform_str in H.species.hud?.equip_slots))
				var/obj/item/clothing/under/uniform = H.w_uniform
				if(uniform && !uniform.can_attach_accessory(src))
					if (!disable_warning)
						to_chat(H, SPAN_WARNING("You cannot equip \the [src] to \the [uniform]."))
					return FALSE
				return TRUE
			if(H.wear_suit && (slot_wear_suit_str in H.species.hud?.equip_slots))
				var/obj/item/clothing/suit/suit = H.wear_suit
				if(suit && !suit.can_attach_accessory(src))
					if (!disable_warning)
						to_chat(H, SPAN_WARNING("You cannot equip \the [src] to \the [suit]."))
					return FALSE
	return TRUE

/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!canremove)
		return 0
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1

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

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)

	var/mob/living/carbon/human/H = M
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & SLOT_EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
				return

	if(!M.check_has_eyes())
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on [M]!"))
		return

	admin_attack_log(user, M, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	src.add_fingerprint(user)

	if(istype(H))

		var/obj/item/organ/internal/eyes/eyes = H.get_internal_organ(BP_EYES)

		if(H != user)

			M.visible_message(
				SPAN_DANGER("\The [M] has been stabbed in the eye with \the [src] by \the [user]!"),
				self_message = SPAN_DANGER("You stab \the [M] in the eye with \the [src]!"))
		else
			user.visible_message(
				SPAN_DANGER("\The [user] has stabbed themself with \the [src]!"),
				self_message = SPAN_DANGER("You stab yourself in the eyes with \the [src]!"))

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(!BP_IS_PROSTHETIC(eyes)) //robot eyes bleeding might be a bit silly
					to_chat(M, SPAN_DANGER("Your eyes start to bleed profusely!"))
			if(prob(50))
				if(M.stat != 2)
					to_chat(M, SPAN_WARNING("You drop what you're holding and clutch at your eyes!"))
					M.drop_held_items()
				SET_STATUS_MAX(M, STAT_BLURRY, 10)
				SET_STATUS_MAX(M, STAT_PARA, 1)
				SET_STATUS_MAX(M, STAT_WEAK, 4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, SPAN_WARNING("You go blind!"))

		var/obj/item/organ/external/affecting = H.get_organ(eyes.parent_organ)
		affecting.take_external_damage(7)
	else
		M.take_organ_damage(7)
	SET_STATUS_MAX(M, STAT_BLURRY, rand(3,4))
	return

/obj/item/clean_blood()
	. = ..()
	clean()

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M, amount = 2, blood_data)
	if (!..())
		return 0

	if(istype(src, /obj/item/energy_blade))
		return

	if(!blood_data && istype(M))
		blood_data = M.vessel.reagent_data[/decl/material/liquid/blood]		
	var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
	forensics.add_data(/datum/forensics/blood_dna, blood_data["blood_DNA"])
	add_coating(/decl/material/liquid/blood, amount, blood_data)
	return 1 //we applied blood to the item

var/global/list/blood_overlay_cache = list()

/obj/item/proc/generate_blood_overlay(force = FALSE)
	if(blood_overlay && !force)
		return
	if(global.blood_overlay_cache["[icon]" + icon_state])
		blood_overlay = global.blood_overlay_cache["[icon]" + icon_state]
		return
	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
	blood_overlay = image(I)
	blood_overlay.appearance_flags |= NO_CLIENT_COLOR|RESET_COLOR
	global.blood_overlay_cache["[icon]" + icon_state] = blood_overlay

/obj/item/proc/showoff(mob/user)
	for(var/mob/M in view(user))
		if(!user.is_invisible_to(M))
			M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>", 1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && I.simulated)
		I.showoff(src)

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

	events_repository.register(/decl/observ/destroyed, user, src, /obj/item/proc/unzoom)
	events_repository.register(/decl/observ/moved, user, src, /obj/item/proc/unzoom)
	events_repository.register(/decl/observ/dir_set, user, src, /obj/item/proc/unzoom)
	events_repository.register(/decl/observ/item_unequipped, src, src, /obj/item/proc/zoom_drop)
	if(isliving(user))
		events_repository.register(/decl/observ/stat_set, user, src, /obj/item/proc/unzoom)

/obj/item/proc/zoom_drop(var/obj/item/I, var/mob/user)
	unzoom(user)

/obj/item/proc/unzoom(var/mob/user)
	if(!zoom)
		return
	zoom = 0

	events_repository.unregister(/decl/observ/destroyed, user, src, /obj/item/proc/unzoom)
	events_repository.unregister(/decl/observ/moved, user, src, /obj/item/proc/unzoom)
	events_repository.unregister(/decl/observ/dir_set, user, src, /obj/item/proc/unzoom)
	events_repository.unregister(/decl/observ/item_unequipped, src, src, /obj/item/proc/zoom_drop)
	if(isliving(user))
		events_repository.unregister(/decl/observ/stat_set, user, src, /obj/item/proc/unzoom)

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

/obj/item/is_burnable()
	return simulated

/obj/item/lava_act()
	. = (!throwing) ? ..() : FALSE

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

/obj/item/proc/fill_from_pressurized_fluid_source(obj/structure/source, mob/user)
	if(!istype(source) || !source.is_pressurized_fluid_source())
		return FALSE
	var/free_space =  FLOOR(REAGENTS_FREE_SPACE(reagents))
	if(free_space <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is full!"))
		return TRUE
	if(istype(source, /obj/structure/reagent_dispensers))
		free_space = min(free_space, source.reagents?.total_volume)
		if(free_space <= 0)
			to_chat(user, SPAN_WARNING("There is not enough fluid in \the [source] to fill \the [src]."))
			return TRUE
	if(free_space > 0)
		if(istype(source, /obj/structure/reagent_dispensers/watertank))
			source.reagents.trans_to_obj(src, free_space)
		else
			reagents.add_reagent(/decl/material/liquid/water, free_space)
		if(reagents && reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("You fill \the [src] with [free_space] unit\s from \the [source]."))
			reagents.touch(src)
			return TRUE
	return FALSE

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

// Updates the icons of the mob wearing the clothing item, if any.
/obj/item/proc/update_clothing_icon()
	return
