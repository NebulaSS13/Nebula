/****************************************************
				EXTERNAL ORGANS
****************************************************/

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	dir = SOUTH
	organ_tag = "limb"
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	scale_max_damage_to_species_health = TRUE

	var/slowdown = 0
	var/tmp/icon_cache_key
	// Strings
	var/broken_description             // fracture string if any.
	var/damage_state = "00"            // Modifier used for generating the on-mob damage overlay for this limb.

	// Damage vars.
	var/brute_dam = 0                  // Actual current brute damage.
	var/brute_ratio = 0                // Ratio of current brute damage to max damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/burn_ratio = 0                 // Ratio of current burn damage to max damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/pain = 0                       // How much the limb hurts.
	var/pain_disability_threshold      // Point at which a limb becomes unusable due to pain.

	// A bitfield for a collection of limb behavior flags.
	var/limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

	// Appearance vars.
	var/body_part = null               // Part flag
	var/icon_position = 0              // Used in mob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.
	var/icon/mob_icon                  // Cached icon for use in mob overlays.
	var/skin_tone                      // Skin tone.
	var/skin_colour                    // skin colour
	var/skin_blend = ICON_ADD          // How the skin colour is applied.
	var/hair_colour                    // hair colour
	var/list/markings                  // Markings (body_markings) to apply to the icon
	var/render_alpha = 255
	var/skip_body_icon_draw = FALSE    // Set to true to skip including this organ on the human body sprite.

	// Wound and structural data.
	var/wound_update_accuracy = 1      // how often wounds should be updated, a higher number means less often
	var/list/wounds                    // wound datum list.
	var/number_wounds = 0              // number of wounds, which is NOT wounds.len!
	var/obj/item/organ/external/parent // Master-limb.
	var/list/children                  // Sub-limbs.
	var/list/internal_organs           // Internal organs of this body part
	var/list/implants                  // Currently implanted objects.
	var/base_miss_chance = 20          // Chance of missing.
	var/genetic_degradation = 0        // Amount of current genetic damage.

	//Forensics stuff
	var/list/autopsy_data              // Trauma data for forensics.

	// Joint/state stuff.
	var/joint = "joint"                // Descriptive string used in dislocation.
	var/amputation_point               // Descriptive string used in amputation.
	var/encased                        // Needs to be opened with a saw to access the organs.
	var/artery_name = "artery"         // Flavour text for cartoid artery, aorta, etc.
	var/arterial_bleed_severity = 1    // Multiplier for bleeding in a limb.
	var/tendon_name = "tendon"         // Flavour text for Achilles tendon, etc.
	var/cavity_name = "cavity"

	// Surgery vars.
	var/cavity_max_w_class = ITEM_SIZE_TINY //this is increased if bigger organs spawn by default inside
	var/hatch_state = 0
	var/stage = 0
	var/cavity = 0

	var/list/unarmed_attacks

	var/atom/movable/applied_pressure
	var/atom/movable/splinted

	var/internal_organs_size = 0       // Currently size cost of internal organs in this body part

	// HUD element variable, see organ_icon.dm get_damage_hud_image()
	var/image/hud_damage_image

/obj/item/organ/external/proc/get_fingerprint()

	if((limb_flags & ORGAN_FLAG_FINGERPRINT) && dna && !BP_IS_PROSTHETIC(src))
		return md5(dna.uni_identity)

	for(var/obj/item/organ/external/E in children)
		var/print = E.get_fingerprint()
		if(print)
			return print

/obj/item/organ/external/afterattack(atom/A, mob/user, proximity)
	..()
	if(proximity && get_fingerprint())
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(src, /datum/extension/forensic_evidence)
		var/datum/fingerprint/F = new()
		F.full_print = get_fingerprint()
		F.completeness = rand(10,90)
		forensics.add_data(/datum/forensics/fingerprints, F)

/obj/item/organ/external/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL && isnull(pain_disability_threshold))
		pain_disability_threshold = (max_damage * 0.75)

/obj/item/organ/external/Destroy()
	//Update the hierarchy BEFORE clearing all the vars and refs
	. = ..()
	//Clear all leftover refs
	splinted = null //Splints got deleted in parent proc
	parent = null
	applied_pressure = null
	QDEL_NULL_LIST(wounds)
	LAZYCLEARLIST(autopsy_data)
	LAZYCLEARLIST(children)
	LAZYCLEARLIST(internal_organs)
	LAZYCLEARLIST(implants)

	if(owner)
		LAZYREMOVE(owner.bad_external_organs, src)

/obj/item/organ/external/set_species(specie_name)
	. = ..()
	skin_blend = bodytype.limb_blend
	slowdown = species.get_slowdown(owner) // TODO make this a getter so octopodes can override it based on flooding
	for(var/attack_type in species.unarmed_attacks)
		var/decl/natural_attack/attack = GET_DECL(attack_type)
		if(istype(attack) && (organ_tag in attack.usable_with_limbs))
			LAZYADD(unarmed_attacks, attack_type)
	get_icon()

/obj/item/organ/external/proc/check_pain_disarm()
	if(owner && prob((pain/max_damage)*100))
		owner.grasp_damage_disarm(src)
		. = TRUE

/obj/item/organ/external/emp_act(severity)

	if(!is_robotic())
		return

	if(owner && BP_IS_CRYSTAL(src)) // Crystalline robotics == piezoelectrics.
		SET_STATUS_MAX(owner, STAT_WEAK, 4 - severity)
		SET_STATUS_MAX(owner, STAT_CONFUSE, 6 - (severity * 2))
		return

	var/burn_damage = 0
	switch (severity)
		if (1)
			burn_damage = 30
		if (2)
			burn_damage = 15
		if (3)
			burn_damage = 7.5

	var/power = 4 - severity //stupid reverse severity
	for(var/obj/item/I in implants)
		if(I.obj_flags & OBJ_FLAG_CONDUCTIBLE)
			burn_damage += I.w_class * rand(power, 3*power)

	if(owner && burn_damage)
		owner.custom_pain("Something inside your [src] burns a [severity < 2 ? "bit" : "lot"]!", power * 15) //robotic organs won't feel it anyway
		take_external_damage(0, burn_damage, 0, used_weapon = "Hot metal")
		check_pain_disarm()

	if(owner && (limb_flags & ORGAN_FLAG_CAN_STAND))
		owner.stance_damage_prone(src)

/obj/item/organ/external/attack_self(var/mob/user)
	if((owner && loc == owner) || !contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I) && user.get_empty_hand_slot())
			user.put_in_hands(I)
		user.visible_message(SPAN_DANGER("\The [user] rips \the [I] out of \the [src]!"))
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 || isghost(user))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			to_chat(user, "<span class='danger'>There is \a [I] sticking out of it.</span>")
		var/ouchies = get_wounds_desc()
		if(ouchies != "nothing")
			to_chat(user, "<span class='notice'>There is [ouchies] visible on it.</span>")

	return

/obj/item/organ/external/show_decay_status(mob/user)
	..(user)
	for(var/obj/item/organ/external/child in children)
		child.show_decay_status(user)

/obj/item/organ/external/attackby(obj/item/W, mob/user)

	var/obj/item/organ/external/E = W
	if(BP_IS_PROSTHETIC(src) && istype(E) && BP_IS_PROSTHETIC(E))

		var/combined = FALSE
		if(E.organ_tag == parent_organ)

			if(length(E.children))
				to_chat(usr, SPAN_WARNING("You cannot connect additional limbs to \the [E]."))
				return

			var/mob/M = loc
			if(istype(M))
				M.try_unequip(src, E)
			else
				dropInto(loc)
				forceMove(E)

			if(loc != E)
				return

			if(istype(E.owner))
				E.owner.add_organ(src, E)
			else
				do_install(null, E)

			combined = TRUE

		else if(E.parent_organ == organ_tag)

			if(LAZYLEN(children))
				to_chat(usr, SPAN_WARNING("You cannot connect additional limbs to \the [src]."))
				return

			if(!user.try_unequip(E, src))
				return

			if(istype(E.owner))
				E.owner.add_organ(E, src)
			else
				E.do_install(null, src)

			combined = TRUE

		else
			to_chat(user, SPAN_WARNING("\The [E] cannot be connected to \the [src]."))
			return

		if(combined)
			to_chat(user, SPAN_NOTICE("You connect \the [E] to \the [src]."))
			compile_icon()
			update_icon()
			E.compile_icon()
			E.update_icon()
			return

	//Remove sub-limbs
	if(W.get_tool_quality(TOOL_SAW) && LAZYLEN(children) && try_saw_off_child(W, user))
		return
	//Remove internal items/organs/implants
	if(try_remove_internal_item(W, user))
		return
	..()

//Handles removing internal organs/implants/items still in the detached limb.
/obj/item/organ/external/proc/try_remove_internal_item(var/obj/item/W, var/mob/user)
	switch(stage)
		if(0)
			if(W.sharp)
				user.visible_message(SPAN_DANGER("<b>[user]</b> cuts [src] open with [W]!"))
				stage++
				return TRUE
		if(1)
			if(istype(W))
				user.visible_message(SPAN_DANGER("<b>[user]</b> cracks [src] open like an egg with [W]!"))
				stage++
				return TRUE
		if(2)
			if(W.sharp || istype(W,/obj/item/hemostat) || IS_WIRECUTTER(W))
				var/list/radial_buttons = make_item_radial_menu_choices(get_contents_recursive())
				if(LAZYLEN(radial_buttons))
					var/obj/item/removing = show_radial_menu(user, src, radial_buttons, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(src))
					if(removing)
						if(istype(removing, /obj/item/organ))
							var/obj/item/organ/O = removing
							O.do_uninstall()
						removing.forceMove(get_turf(user))

						if(user.get_empty_hand_slot())
							user.put_in_hands(removing)
						user.visible_message(SPAN_DANGER("<b>[user]</b> extracts [removing] from [src] with [W]!"))
				else
					user.visible_message(SPAN_DANGER("<b>[user]</b> fishes around fruitlessly in [src] with [W]."))
				return TRUE
	return FALSE

//Handles removing child limbs from the detached limb.
/obj/item/organ/external/proc/try_saw_off_child(var/obj/item/W, var/mob/user)

	//Add icons to radial menu
	var/list/radial_buttons = make_item_radial_menu_choices(get_limbs_recursive())
	if(!LAZYLEN(radial_buttons))
		return

	//Display radial menu
	var/obj/item/organ/external/removing = show_radial_menu(user, src, radial_buttons, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(src))
	if(!istype(removing))
		return TRUE

	var/cutting_result = !W.do_tool_interaction(TOOL_SAW, user, src, 3 SECONDS, "cutting \the [removing] off")
	//Check if the limb is still in the hierarchy
	if(cutting_result == 1 || !(removing in get_limbs_recursive()))
		if(cutting_result != -1)
			user.visible_message(SPAN_DANGER("<b>[user]</b> stops trying to cut \the [removing]."))
		return TRUE

	//Actually remove it
	removing.do_uninstall()
	removing.forceMove(get_turf(user))
	compile_icon()
	update_icon()
	removing.compile_icon()
	removing.update_icon()
	if(user.get_empty_hand_slot())
		user.put_in_hands(removing)
	user.visible_message(SPAN_DANGER("<b>[user]</b> cuts off \the [removing] from [src] with [W]!"))
	return TRUE

/**
 *  Get a list of contents of this organ and all the child organs
 */
/obj/item/organ/external/proc/get_contents_recursive()
	var/list/all_items = list()

	if(LAZYLEN(implants))
		all_items.Add(implants)
	if(LAZYLEN(internal_organs))
		all_items.Add(internal_organs)

	for(var/obj/item/organ/external/child in children)
		all_items.Add(child.get_contents_recursive())

	return all_items

/obj/item/organ/external/proc/get_limbs_recursive()
	var/list/all_limbs = list()
	for(var/obj/item/organ/external/child in children)
		all_limbs += child
		var/list/sublimbs = child.get_limbs_recursive()
		if(sublimbs)
			all_limbs += sublimbs
	return all_limbs

/obj/item/organ/external/proc/is_dislocated()
	return (status & ORGAN_DISLOCATED) || is_parent_dislocated() //if any parent is dislocated, we are considered dislocated as well

/obj/item/organ/external/proc/is_parent_dislocated()
	var/obj/item/organ/external/O = parent
	while(O && (O.limb_flags & ORGAN_FLAG_CAN_DISLOCATE))
		if(O.status & ORGAN_DISLOCATED)
			return TRUE
		O = O.parent
	return FALSE

/obj/item/organ/external/proc/update_internal_organs_cost()
	internal_organs_size = 0
	for(var/obj/item/organ/internal/org in internal_organs)
		internal_organs_size += org.get_storage_cost()

/obj/item/organ/external/proc/dislocate()
	if(owner && (owner.status_flags & GODMODE))
		return
	if(!(limb_flags & ORGAN_FLAG_CAN_DISLOCATE))
		return

	status |= ORGAN_DISLOCATED
	if(owner)
		if(can_feel_pain())
			add_pain(20)
			owner.apply_effect(5, STUN)
		owner.verbs |= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/proc/undislocate(var/skip_pain = FALSE)
	if(!(limb_flags & ORGAN_FLAG_CAN_DISLOCATE))
		return

	status &= (~ORGAN_DISLOCATED)
	if(owner)
		if(!skip_pain && can_feel_pain())
			add_pain(20)
			owner.apply_effect(2, STUN)

		//check to see if we still need the verb
		for(var/obj/item/organ/external/limb in owner.get_external_organs())
			if(limb.is_dislocated())
				return
		owner.verbs -= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))
	return

//If "in_place" is TRUE will make organs skip their install/uninstall effects and  the sub-limbs and internal organs
/obj/item/organ/external/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	if(!(. = ..()))
		return

	//If attached to an owner mob
	if(istype(owner))
		//If we expect a parent organ set it up here
		if(!affected && parent_organ)
			parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
		else
			parent = affected

		//
		//If we contain any child organs add them to the owner
		//
		for(var/obj/item/organ/organ in internal_organs)
			owner.add_organ(organ, src, in_place, update_icon, detached)

		for(var/obj/item/organ/external/organ in children)
			owner.add_organ(organ, src, in_place, update_icon, detached)

		//
		//Add any existing organs in the owner that have us as parent
		//
		for(var/obj/item/organ/internal/I in owner.get_internal_organs())
			if(I.parent_organ == organ_tag)
				LAZYDISTINCTADD(internal_organs, I)
		update_internal_organs_cost()

		for(var/obj/item/organ/external/E in owner.get_external_organs())
			if(E.parent_organ == organ_tag)
				E.parent = src
				LAZYDISTINCTADD(children, E)

		//Add any existing implants that should be refering us
		for(var/obj/implant in implants)
			implant.forceMove(owner)
			if(istype(implant, /obj/item/implant))
				var/obj/item/implant/imp_device = implant
				// we can't use implanted() here since it's often interactive
				imp_device.imp_in = owner
				imp_device.implanted = TRUE

			//Since limbs attached during surgery have their internal organs detached, we want to re-attach them if we're doing the proper install of the parent limb
			else if(istype(implant, /obj/item/organ) && !detached)
				var/obj/item/organ/O = implant
				if(O.parent_organ == organ_tag)
					//The add_organ chain will automatically handle properly removing the detached flag, and moving it to the proper lists
					owner.add_organ(O, src, in_place, update_icon, detached)
	else
		//Handle installing into a stand-alone parent limb to keep dropped limbs in some kind of coherent state
		if(!affected)
			affected = loc
		if(istype(affected))
			if(parent_organ != affected.organ_tag)
				log_warning("obj/item/organ/external/do_install(): The parent organ in the parameters '[affected]'('[affected.organ_tag]') doesn't match the expected parent organ ('[parent_organ]') for '[src]'!")
			parent = affected

		//When no owner, make sure we update all our children. Everything else should be implicitely at the right place
		for(var/obj/item/organ/external/organ in children)
			organ.do_install(null, src, in_place, update_icon, detached)

	//This proc refers to owner's species and all kind of risky stuff, so it cannot be done in_place
	if(!in_place)
		update_wounds()

	//Parent hieracrchy handling
	if(parent)
		//Add ourselves to our parent organ's data
		LAZYDISTINCTADD(parent.children, src) //Even when detached the limb has to be in the children list, because of the way limbs icon are handled

		//Remove any stump wound for this slot
		for(var/datum/wound/lost_limb/W in parent.wounds)
			if(W.limb_tag == organ_tag)
				qdel(W) //Removes itself from parent.wounds
				break

		if(!in_place)
			parent.update_wounds()

/obj/item/organ/external/proc/drop_equipped_clothing()
	if(!owner)
		return
	if((body_part & SLOT_FOOT_LEFT) || (body_part & SLOT_FOOT_RIGHT))
		owner.drop_from_inventory(owner.get_equipped_item(slot_shoes_str))
	if((body_part & SLOT_HAND_LEFT) || (body_part & SLOT_HAND_RIGHT))
		owner.drop_from_inventory(owner.get_equipped_item(slot_gloves_str))
	if(body_part & SLOT_HEAD)
		owner.drop_from_inventory(owner.get_equipped_item(slot_head_str))
		owner.drop_from_inventory(owner.get_equipped_item(slot_glasses_str))
		owner.drop_from_inventory(owner.get_equipped_item(slot_l_ear_str))
		owner.drop_from_inventory(owner.get_equipped_item(slot_r_ear_str))
		owner.drop_from_inventory(owner.get_equipped_item(slot_wear_mask_str))

//Helper proc used by various tools for repairing robot limbs
/obj/item/organ/external/proc/robo_repair(var/repair_amount, var/damage_type, var/damage_desc, obj/item/tool, mob/living/user)
	if((!BP_IS_PROSTHETIC(src)))
		return 0

	var/damage_amount
	switch(damage_type)
		if(BRUTE) damage_amount = brute_dam
		if(BURN)  damage_amount = burn_dam
		else return 0

	if(!damage_amount)
		if(src.hatch_state != HATCH_OPENED)
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
		return 0

	if(damage_amount >= ROBOLIMB_SELF_REPAIR_CAP)
		to_chat(user, SPAN_WARNING("The damage is far too severe to patch over externally."))
		return 0

	if(user == src.owner)
		var/grasp
		if(user.get_equipped_item(BP_L_HAND) == tool && (src.body_part & (SLOT_ARM_LEFT|SLOT_HAND_LEFT)))
			grasp = BP_L_HAND
		else if(user.get_equipped_item(BP_R_HAND) == tool && (src.body_part & (SLOT_ARM_RIGHT|SLOT_HAND_RIGHT)))
			grasp = BP_R_HAND

		if(grasp)
			to_chat(user, SPAN_WARNING("You can't reach your [src.name] while holding [tool] in your [owner.get_bodypart_name(grasp)]."))
			return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!do_mob(user, owner, 10))
		to_chat(user, SPAN_WARNING("You must stand still to do that."))
		return 0

	switch(damage_type)
		if(BRUTE) src.heal_damage(repair_amount, 0, 0, 1)
		if(BURN)  src.heal_damage(0, repair_amount, 0, 1)
	owner.refresh_visible_overlays()
	if(user == src.owner)
		var/decl/pronouns/G = user.get_pronouns()
		user.visible_message(SPAN_NOTICE("\The [user] patches [damage_desc] on [G.his] [name] with \the [tool]."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] patches [damage_desc] on \the [owner]'s [name] with \the [tool]."))
	return 1

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate(var/ignore_prosthetic_prefs)

	damage_state = "00"
	brute_dam = 0
	brute_ratio = 0
	burn_dam = 0
	burn_ratio = 0
	germ_level = 0
	genetic_degradation = 0
	pain = 0

	for(var/datum/wound/wound in wounds)
		qdel(wound)
	number_wounds = 0


	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate(ignore_prosthetic_prefs)

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			LAZYREMOVE(implants, implanted_object)

	undislocate(TRUE)

	. = ..() // Clear damage, reapply aspects.

	if(owner)
		owner.updatehealth()

//#TODO: Rejuvination hacks should probably be removed
/obj/item/organ/external/remove_rejuv()
	if(owner)
		owner.remove_organ(src, FALSE, FALSE, TRUE, TRUE, FALSE)
	for(var/obj/item/organ/external/E in children)
		E.remove_rejuv()
	LAZYCLEARLIST(children)
	for(var/obj/item/organ/internal/I in internal_organs)
		I.remove_rejuv()
	..()

/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage, var/surgical)

	if(!owner || damage <= 0)
		return

	if(BP_IS_CRYSTAL(src) && (damage >= 15 || prob(1)))
		type = SHATTER
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 40, 1) // Crash!

	//moved these before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Brute damage can possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if(!surgical && (type in list(CUT, PIERCE, BRUISE)) && damage > 15 && local_damage > 30)

		var/internal_damage
		if(prob(damage) && sever_artery())
			internal_damage = TRUE
		if(prob(CEILING(damage/4)) && sever_tendon())
			internal_damage = TRUE
		if(internal_damage)
			owner.custom_pain("You feel something rip in your [name]!", 50, affecting = src)

	//Burn damage can cause fluid loss due to blistering and cook-off
	if((type in list(BURN, LASER)) && (damage > 5 || damage + burn_dam >= 15) && !BP_IS_PROSTHETIC(src))
		var/fluid_loss_severity
		switch(type)
			if(BURN)  fluid_loss_severity = FLUIDLOSS_WIDE_BURN
			if(LASER) fluid_loss_severity = FLUIDLOSS_CONC_BURN
		var/fluid_loss = (damage/(owner.maxHealth - config.health_threshold_dead)) * SPECIES_BLOOD_DEFAULT * fluid_loss_severity
		owner.remove_blood(fluid_loss)

	// first check whether we can widen an existing wound
	if(!surgical && LAZYLEN(wounds) && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(owner && prob(25))
					if(BP_IS_CRYSTAL(src))
						owner.visible_message("<span class='danger'>The cracks in \the [owner]'s [name] spread.</span>",\
						"<span class='danger'>The cracks in your [name] spread.</span>",\
						"<span class='danger'>You hear the cracking of crystal.</span>")
					else if(BP_IS_PROSTHETIC(src))
						owner.visible_message("<span class='danger'>The damage to \the [owner]'s [name] worsens.</span>",\
						"<span class='danger'>The damage to your [name] worsens.</span>",\
						"<span class='danger'>You hear the screech of abused metal.</span>")
					else
						owner.visible_message("<span class='danger'>The wound on \the [owner]'s [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>The wound on your [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>You hear a nasty ripping noise, as if flesh is being torn apart.</span>")
				return W

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage, src, surgical)

		//Check whether we can add the wound to an existing wound
		if(surgical)
			W.autoheal_cutoff = 0
		else
			for(var/datum/wound/other in wounds)
				if(other.can_merge_wounds(W))
					other.merge_wound(W)
					return
		LAZYADD(wounds, W)
		return W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !splinted))

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()

	if(length(ailments))
		return TRUE

	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DEAD|ORGAN_MUTATED|ORGAN_DISLOCATED))
		return TRUE

	if((brute_dam || burn_dam) && !BP_IS_PROSTHETIC(src)) //Robot limbs don't autoheal and thus don't need to process when damaged
		return TRUE

	if(get_genetic_damage())
		return TRUE

	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.getToxLoss())
			return TRUE

	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return TRUE

	last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/Process()
	if(owner)
		if(pain)
			pain -= owner.lying ? 3 : 1
			if(pain<0)
				pain = 0
		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()
		//Infections
		update_germs()
	else
		pain = 0
	..()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs and rest will be required to recover
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on antibiotics and get rest to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	if(BP_IS_PROSTHETIC(src) || BP_IS_CRYSTAL(src) || (owner.species && owner.species.species_flags & SPECIES_FLAG_IS_PLANT)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/turf/simulated/T = get_turf(owner)
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if(max(istype(T) && T.dirt*10, 2*owner.germ_level) > W.germ_level && W.infection_check())
			W.germ_level++

	var/antibiotics = GET_CHEMICAL_EFFECT(owner, CE_ANTIBIOTIC)
	if (!antibiotics)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level || prob(min(W.germ_level, 30)))
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/handle_germ_effects()

	if(germ_level < INFECTION_LEVEL_TWO)
		return ..()

	var/antibiotics = REAGENT_VOLUME(owner.reagents, /decl/material/liquid/antibiotics)

	if(germ_level >= INFECTION_LEVEL_TWO)
		//spread the infection to internal organs
		var/obj/item/organ/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		for(var/obj/item/organ/external/child in children)
			if (child.germ_level < germ_level && !BP_IS_PROSTHETIC(child))
				if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && !BP_IS_PROSTHETIC(parent))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < REAGENTS_OVERDOSE)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, "<span class='notice'>You can't feel your [name] anymore...</span>")
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	var/update_surgery
	if(BP_IS_PROSTHETIC(src) || BP_IS_CRYSTAL(src)) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)  //and they disappear right away
				qdel(W)    //TODO: robot wounds for robot limbs
				update_surgery = TRUE
		if(owner && update_surgery)
			owner.update_surgery()
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + (10 MINUTES) <= world.time)
			qdel(W)
			update_surgery = TRUE
			continue
			// let the GC handle the deletion of the wound

		// slow healing
		var/heal_amt = 0
		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (owner && !GET_CHEMICAL_EFFECT(owner, CE_TOXIN) && W.can_autoheal() && W.wound_damage() && brute_ratio < 0.5 && burn_ratio < 0.5)
			heal_amt += 0.5

		// we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		// configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * config.organ_regeneration_multiplier
		// Apply a modifier based on how stressed we currently are.
		if(owner)
			var/stress_modifier = owner.get_stress_modifier()
			if(stress_modifier)
				heal_amt *= 1-(config.stress_healing_recovery_constant * stress_modifier)
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (LAZYLEN(wounds) + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		var/dam_type = BRUTE
		if(W.damage_type == BURN)
			dam_type = BURN
		if(owner?.can_autoheal(dam_type))
			W.heal_damage(heal_amt)

	// sync the organ's damage with its wounds
	update_damages()
	if(owner)
		if(update_surgery)
			owner.update_surgery()
		if (update_damstate())
			owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	//update damage counts
	var/bleeds = (!BP_IS_PROSTHETIC(src) && !BP_IS_CRYSTAL(src))
	for(var/datum/wound/W in wounds)

		if(W.damage <= 0)
			qdel(W)
			continue

		if(W.damage_type == BURN)
			burn_dam += W.damage
		else
			brute_dam += W.damage

		if(bleeds && W.bleeding() && (H && H.should_have_organ(BP_HEART)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped
		number_wounds += W.amount

	damage = brute_dam + burn_dam
	update_damage_ratios()

/obj/item/organ/external/proc/update_damage_ratios()
	var/limb_loss_threshold = max_damage
	brute_ratio = brute_dam / (limb_loss_threshold * 2)
	burn_ratio = burn_dam / (limb_loss_threshold * 2)

//Returns 1 if damage_state changed
/obj/item/organ/external/proc/update_damstate()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/
/obj/item/organ/external/proc/get_droplimb_messages_for(var/droptype, var/clean)

	if(BP_IS_CRYSTAL(src))
		playsound(src, "shatter", 70, 1)
		return list(
			"\The [owner]'s [src.name] shatters into a thousand pieces!",
			"Your [src.name] shatters into a thousand pieces!",
			"You hear the sound of something shattering!"
		)
	else
		switch(droptype)
			if(DISMEMBER_METHOD_EDGE)
				if(!clean)
					var/gore_sound = "[BP_IS_PROSTHETIC(src) ? "tortured metal" : "ripping tendons and flesh"]"
					return list(
						"\The [owner]'s [src.name] flies off in an arc!",
						"Your [src.name] goes flying off!",
						"You hear a terrible sound of [gore_sound]."
						)
			if(DISMEMBER_METHOD_BURN)
				var/gore = "[BP_IS_PROSTHETIC(src) ? "": " of burning flesh"]"
				return list(
					"\The [owner]'s [src.name] flashes away into ashes!",
					"Your [src.name] flashes away into ashes!",
					"You hear a crackling sound[gore]."
					)
			if(DISMEMBER_METHOD_ACID)
				var/gore = "[BP_IS_PROSTHETIC(src) ? "": " of melting flesh"]"
				return list(
					"\The [owner]'s [src.name] dissolves!",
					"Your [src.name] dissolves!",
					"You hear a hissing sound[gore]."
					)
			if(DISMEMBER_METHOD_BLUNT)
				var/gore = "[BP_IS_PROSTHETIC(src) ? "": " in shower of gore"]"
				var/gore_sound = "[BP_IS_PROSTHETIC(src) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
				return list(
					"\The [owner]'s [src.name] explodes[gore]!",
					"Your [src.name] explodes[gore]!",
					"You hear the [gore_sound]."
					)
/obj/item/organ/external/proc/place_remains_from_dismember_method(var/dismember)

	var/dropturf = get_turf(src)
	switch(dismember)
		if(DISMEMBER_METHOD_BURN)
			. = new /obj/effect/decal/cleanable/ash(dropturf)
		if(DISMEMBER_METHOD_ACID)
			. = new /obj/effect/decal/cleanable/mucus(dropturf)
		if(DISMEMBER_METHOD_BLUNT)
			if(BP_IS_CRYSTAL(src))
				. = new /obj/item/shard(dropturf, /decl/material/solid/gemstone/crystal)
			else if(BP_IS_PROSTHETIC(src))
				. = new /obj/effect/decal/cleanable/blood/gibs/robot(dropturf)
			else
				. = new /obj/effect/decal/cleanable/blood/gibs(dropturf)

	if(species && istype(., /obj/effect/decal/cleanable/blood/gibs))
		var/obj/effect/decal/cleanable/blood/gibs/G = .
		G.fleshcolor = species.get_flesh_colour(owner)
		G.basecolor =  species.get_blood_color(owner)
		G.update_icon()

//Handles dismemberment
/obj/item/organ/external/proc/dismember(var/clean, var/disintegrate = DISMEMBER_METHOD_EDGE, var/ignore_children, var/silent, var/ignore_last_organ)

	if(!(limb_flags & ORGAN_FLAG_CAN_AMPUTATE) || !owner)
		return

	disintegrate = bodytype.check_dismember_type_override(disintegrate)

	if(BP_IS_CRYSTAL(src))
		disintegrate = DISMEMBER_METHOD_BLUNT //splut

	var/list/organ_msgs = get_droplimb_messages_for(disintegrate, clean)
	if(LAZYLEN(organ_msgs) >= 3)
		owner.visible_message("<span class='danger'>[organ_msgs[1]]</span>", \
			"<span class='moderate'><b>[organ_msgs[2]]</b></span>", \
			"<span class='danger'>[organ_msgs[3]]</span>")

	add_pain(60)
	if(!clean)
		owner.shock_stage += min_broken_damage

	var/obj/item/organ/external/original_parent = parent
	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	owner.remove_organ(src, TRUE, FALSE, ignore_children, update_icon = FALSE)
	var/remaining_organs = victim.get_external_organs()
	if(istype(victim) && !QDELETED(victim))
		// If they are down to their last organ, just spawn the organ and delete them.
		if(!ignore_last_organ && LAZYLEN(remaining_organs) == 1)
			for(var/obj/item/organ/external/organ in remaining_organs)
				victim.remove_organ(organ, TRUE, TRUE, update_icon = FALSE)
				if(organ.place_remains_from_dismember_method(disintegrate))
					qdel(organ)
			victim.dump_contents()
			qdel(victim)
		else // We deliberately skip queuing this via remove_organ() above due to potentially immediately deleting the mob.
			victim.regenerate_body_icon = TRUE
			victim.queue_icon_update()

	if(original_parent)

		// Traumatic amputation is messy.
		if(!clean && disintegrate != DISMEMBER_METHOD_BURN)
			original_parent.sever_artery()

		// Leave a big ol hole.
		var/datum/wound/lost_limb/W = new(src, disintegrate, clean)
		W.parent_organ = original_parent
		LAZYADD(original_parent.wounds, W)
		original_parent.update_damages()

	if(QDELETED(src))
		return

	// Edged attacks cause the limb to sail off in an arc.
	if(disintegrate == DISMEMBER_METHOD_EDGE)

		compile_icon()
		add_blood(victim)
		set_rotation(rand(180))
		forceMove(get_turf(src))
		if(!clean)
			// Throw limb around.
			if(src && isturf(loc))
				throw_at(get_edge_target_turf(src, pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)

	else
		// Other attacks can destroy the limb entirely and place an item or decal.
		var/atom/movable/gore = place_remains_from_dismember_method(disintegrate)
		if(gore)
			if(disintegrate == DISMEMBER_METHOD_BURN || disintegrate == DISMEMBER_METHOD_ACID)
				for(var/obj/item/I in src)
					if(I.w_class > ITEM_SIZE_SMALL && !istype(I,/obj/item/organ))
						I.dropInto(loc)
			else if(disintegrate == DISMEMBER_METHOD_BLUNT)
				gore.throw_at(get_edge_target_turf(src,pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)
				for(var/obj/item/organ/I in internal_organs)
					I.do_uninstall() //No owner so run uninstall directly
					I.dropInto(get_turf(loc))
					if(!QDELETED(I) && isturf(loc))
						I.throw_at(get_edge_target_turf(src,pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)
				for(var/obj/item/I in src)
					I.dropInto(loc)
					I.throw_at(get_edge_target_turf(src,pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)
			if(!QDELETED(src))
				qdel(src)

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	var/obj/item/cuffs = holder.get_equipped_item(slot_handcuffed_str)
	if(cuffs && (body_part in list(SLOT_ARM_LEFT, SLOT_ARM_RIGHT, SLOT_HAND_LEFT, SLOT_HAND_RIGHT)))
		holder.visible_message(\
			"\The [cuffs] falls off of [holder.name].",\
			"\The [cuffs] falls off you.")
		holder.try_unequip(cuffs)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.bandaged
		W.bandaged = 1
	if(rval)
		owner.update_surgery()
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp_organ()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/clamped()
	for(var/datum/wound/W in wounds)
		if(W.clamped)
			return 1

/obj/item/organ/external/proc/remove_clamps()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= W.clamped
		W.clamped = 0
	return rval

// open incisions and expose implants
// this is the retract step of surgery
/obj/item/organ/external/proc/open_incision()
	var/datum/wound/W = get_incision()
	if(!W)	return
	W.open_wound(min(W.damage * 2, W.damage_list[1] - W.damage))

	if(!encased)
		for(var/obj/item/implant/I in implants)
			I.exposed()

/obj/item/organ/external/proc/fracture()
	if(!config.bones_can_break)
		return
	if(BP_IS_PROSTHETIC(src))
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || !(limb_flags & ORGAN_FLAG_CAN_BREAK))
		return

	if(owner)
		owner.visible_message(\
			"<span class='danger'>You hear a loud cracking sound coming from \the [owner].</span>",\
			"<span class='danger'>Something feels like it shattered in your [name]!</span>",\
			"<span class='danger'>You hear a sickening crack.</span>")
		jostle_bone()
		if(can_feel_pain())
			owner.emote("scream")

	playsound(src.loc, "fracture", 100, 1, -2)
	status |= ORGAN_BROKEN
	stage = 0
	broken_description = pick("broken","fracture","hairline fracture")

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	var/obj/item/clothing/suit/space/rig/suit = owner.get_equipped_item(slot_wear_suit_str)
	if(!splinted && owner && istype(suit))
		suit.handle_fracture(owner, src)

/obj/item/organ/external/proc/mend_fracture()
	if(BP_IS_PROSTHETIC(src))
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/apply_splint(var/atom/movable/splint)
	if(!splinted)
		splinted = splint
		if(!applied_pressure)
			applied_pressure = splint
		return 1
	return 0

/obj/item/organ/external/proc/remove_splint()
	if(splinted)
		if(splinted.loc == src)
			splinted.dropInto(owner? owner.loc : src.loc)
		if(applied_pressure == splinted)
			applied_pressure = null
		splinted = null
		return 1
	return 0

/obj/item/organ/external/proc/get_dexterity()
	if(model)
		var/decl/prosthetics_manufacturer/R = GET_DECL(model)
		if(R)
			return R.manual_dexterity
	if(species)
		return species.get_manual_dexterity(owner)

//Completely override, so we can slap in the model
/obj/item/organ/external/setup_as_prosthetic()
	. = ..(model ? model : /decl/prosthetics_manufacturer/basic_human)

/obj/item/organ/external/robotize(var/company = /decl/prosthetics_manufacturer/basic_human, var/skip_prosthetics = 0, var/keep_organs = 0, var/apply_material = /decl/material/solid/metal/steel, var/check_bodytype, var/check_species)
	. = ..()

	slowdown = 0

	// Don't override our existing model unless a specific model is being passed in.
	if(!company)
		company = model || /decl/prosthetics_manufacturer

	var/decl/prosthetics_manufacturer/R
	if(istype(company, /decl/prosthetics_manufacturer))
		//Handling for decl
		R = company
		company = R.type
	else
		//Handling for paths
		if(!ispath(company))
			PRINT_STACK_TRACE("Limb [type] robotize() was supplied a null or non-decl manufacturer: '[company]'")
			company = /decl/prosthetics_manufacturer/basic_human
		R = GET_DECL(company)

	if(!check_species)
		check_species = owner?.get_species_name() || global.using_map.default_species
	if(!check_bodytype)
		if(owner)
			check_bodytype = owner.get_bodytype_category()
		else
			var/decl/species/species_data = get_species_by_key(check_species)
			if(species_data)
				check_bodytype = species_data.default_bodytype.bodytype_category
			else
				check_bodytype = global.using_map.default_bodytype

	//If can't install fallback to defaults.
	if(!R.check_can_install(organ_tag, check_bodytype, check_species))
		company = /decl/prosthetics_manufacturer/basic_human
		R = GET_DECL(company)

	model = company
	name = "[R ? R.modifier_string : "robotic"] [initial(name)]"
	desc = "[R.desc] It looks like it was produced by [R.name]."
	origin_tech = R.limb_tech
	slowdown = R.movement_slowdown
	max_damage *= R.hardiness
	min_broken_damage *= R.hardiness
	status &= (~ORGAN_DISLOCATED)
	limb_flags &= (~ORGAN_FLAG_CAN_DISLOCATE)
	remove_splint()
	update_icon(1)
	unmutate()

	for(var/obj/item/organ/external/T in children)
		T.robotize(company, 1)

	if(owner)

		if(!skip_prosthetics)
			owner.full_prosthetic = null // Will be rechecked next isSynthetic() call.

		if(!keep_organs)
			for(var/obj/item/organ/thing in internal_organs)
				if(!thing.is_vital_to_owner() && !BP_IS_PROSTHETIC(thing))
					qdel(thing)

		owner.refresh_modular_limb_verbs()

	return 1

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return (brute_dam+burn_dam)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/is_usable()
	. = ..()
	if(.)
		if(is_malfunctioning())
			return FALSE
		if(is_broken() && !splinted)
			return FALSE
		if(status & ORGAN_TENDON_CUT)
			return FALSE
		if(brute_ratio >= 1 || burn_ratio >= 1)
			return FALSE
		if(get_pain() >= pain_disability_threshold)
			return FALSE

/obj/item/organ/external/proc/is_malfunctioning()
	return (is_robotic() && (brute_dam + burn_dam) >= 10 && prob(brute_dam + burn_dam))

/obj/item/organ/external/proc/embed(var/obj/item/W, var/silent = 0, var/supplied_message, var/datum/wound/supplied_wound)
	if(!owner || loc != owner)
		return
	if(species.species_flags & SPECIES_FLAG_NO_EMBED)
		return
	if(!silent)
		if(supplied_message)
			owner.visible_message("<span class='danger'>[supplied_message]</span>")
		else
			owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")

	if(!supplied_wound)
		for(var/datum/wound/wound in wounds)
			if((wound.damage_type == CUT || wound.damage_type == PIERCE) && wound.damage >= W.w_class * 5)
				supplied_wound = wound
				break
	if(!supplied_wound)
		supplied_wound = createwound(PIERCE, W.w_class * 5)

	if(!supplied_wound || (W in supplied_wound.embedded_objects)) // Just in case.
		return

	LAZYDISTINCTADD(supplied_wound.embedded_objects, W)
	LAZYDISTINCTADD(implants, W)

	owner.embedded_flag = 1
	owner.verbs += /mob/proc/yank_out_object
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_from_inventory(W)
	W.forceMove(owner)

/obj/item/organ/external/do_uninstall(in_place, detach, ignore_children, update_icon)
	var/mob/living/carbon/human/victim = owner //parent proc clears owner
	if(!(. = ..()))
		return

	if(victim)
		if(in_place)
			//When removing in place, we don't bother with moving child organs and implants, we just clear the refs
			for(var/obj/item/implant/I in implants)
				I.removed()
			//Remove the parent ref from all childs limbs until we replace the organ in place
			for(var/obj/item/organ/external/E in children)
				E.parent = null

			implants = null
			children = null
			internal_organs = null
		else
			//Move over our implants/items into us, and drop whatever else is too big or not an object(??)
			for(var/atom/movable/implant in implants)
				//large items and non-item objs fall to the floor, everything else stays
				var/obj/item/I = implant
				if(QDELETED(implant))
					LAZYREMOVE(implants, implant)
					continue
				if(istype(I) && I.w_class < ITEM_SIZE_NORMAL)
					if(istype(I, /obj/item/implant))
						var/obj/item/implant/imp = I
						imp.removed()
					implant.forceMove(src)
				else
					//Dumpt the rest on the turf
					LAZYREMOVE(implants, implant)
					implant.forceMove(get_turf(src))

			if(!ignore_children)
				//Move our chilren limb into our contents
				for(var/obj/item/organ/external/O in children)
					victim.remove_organ(O, FALSE, FALSE, FALSE, in_place, update_icon)
					if(QDELETED(O))
						LAZYREMOVE(children, O)
						continue
					O.do_install(null, src, FALSE, update_icon, FALSE) //Forcemove the organ and properly set it up in our internal data

			// Grab all the children internal organs
			for(var/obj/item/organ/internal/organ in internal_organs)
				victim.remove_organ(organ, FALSE, FALSE, FALSE, in_place, update_icon)
				if(QDELETED(organ))
					LAZYREMOVE(internal_organs, organ)
					continue
				organ.do_install(null, src, FALSE, update_icon, FALSE) //Forcemove the organ and properly set it up in our internal data

	//Note that we don't need to change our own hierarchy when not removing from a mob

	// Remove parent references
	if(parent)
		LAZYREMOVE(parent.children, src)
	parent = null

/obj/item/organ/external/on_remove_effects(mob/living/last_owner)
	. = ..()
	drop_equipped_clothing()
	remove_splint()
	release_restraints(last_owner)

	//Robotic limbs explode if sabotaged.
	if(BP_IS_PROSTHETIC(src) && (status & ORGAN_SABOTAGED))
		last_owner.visible_message(
			SPAN_DANGER("\The [last_owner]'s [src.name] explodes violently!"),\
			SPAN_DANGER("Your [src.name] explodes!"),\
			SPAN_DANGER("You hear an explosion!"))
		explosion(get_turf(last_owner),-1,-1,2,3)
		spark_at(last_owner, 5, holder=last_owner)
		qdel(src)

/obj/item/organ/external/set_detached(is_detached)
	if(BP_IS_PROSTHETIC(src))
		is_detached = FALSE //External prosthetics are never detached
	return ..(is_detached)

/obj/item/organ/external/proc/disfigure(var/type = BRUTE)
	if(status & ORGAN_DISFIGURED)
		return
	if(owner)
		if(type == BRUTE)
			owner.visible_message("<span class='danger'>You hear a sickening cracking sound coming from \the [owner]'s [name].</span>",	\
			"<span class='danger'>Your [name] becomes a mangled mess!</span>",	\
			"<span class='danger'>You hear a sickening crack.</span>")
		else
			owner.visible_message("<span class='danger'>\The [owner]'s [name] melts away, turning into mangled mess!</span>",	\
			"<span class='danger'>Your [name] melts away!</span>",	\
			"<span class='danger'>You hear a sickening sizzle.</span>")
	status |= ORGAN_DISFIGURED

/obj/item/organ/external/proc/get_incision(var/strict)

	var/datum/wound/incision
	if(BP_IS_CRYSTAL(src))
		for(var/datum/wound/shatter/other in wounds)
			if(!incision || incision.damage < other.damage)
				incision = other
	else
		for(var/datum/wound/cut/W in wounds)
			if(W.bandaged || W.current_stage > W.max_bleeding_stage) // Shit's unusable
				continue
			if(strict && !W.is_surgical()) //We don't need dirty ones
				continue
			if(!incision)
				incision = W
				continue
			var/same = W.is_surgical() == incision.is_surgical()
			if(same) //If they're both dirty or both are surgical, just get bigger one
				if(W.damage > incision.damage)
					incision = W
			else if(W.is_surgical()) //otherwise surgical one takes priority
				incision = W
	return incision

/obj/item/organ/external/proc/how_open()
	. = 0
	var/datum/wound/incision = get_incision()
	if(incision)
		if(BP_IS_CRYSTAL(src))
			. = SURGERY_RETRACTED
			if(encased && (status & ORGAN_BROKEN))
				. = SURGERY_ENCASED
		else
			var/total_health_coefficient = scale_max_damage_to_species_health ? (species.total_health / DEFAULT_SPECIES_HEALTH) : 1
			var/smol_threshold = max(1, FLOOR(min_broken_damage * 0.4 * total_health_coefficient))
			var/beeg_threshold = max(1, FLOOR(min_broken_damage * 0.6 * total_health_coefficient))
			if(!incision.autoheal_cutoff == 0) //not clean incision
				smol_threshold *= 1.5
				beeg_threshold = max(beeg_threshold, min(beeg_threshold * 1.5, incision.damage_list[1])) //wounds can't achieve bigger
			if(incision.damage >= smol_threshold) //smol incision
				. = SURGERY_OPEN
			if(incision.damage >= beeg_threshold) //beeg incision
				. = SURGERY_RETRACTED
			if(. == SURGERY_RETRACTED && encased && (status & ORGAN_BROKEN))
				. = SURGERY_ENCASED

/obj/item/organ/external/proc/jostle_bone(force)
	if(!(status & ORGAN_BROKEN)) //intact bones stay still
		return
	if(brute_dam + force < min_broken_damage/5)	//no papercuts moving bones
		return
	if(LAZYLEN(internal_organs) && prob(brute_dam + force))
		owner.custom_pain("A piece of bone in your [encased ? encased : name] moves painfully!", 50, affecting = src)
		var/obj/item/organ/internal/I = pick(internal_organs)
		I.take_internal_damage(rand(3,5))

/obj/item/organ/external/proc/jointlock(mob/attacker)
	if(!can_feel_pain())
		return

	var/armor = 100 * owner.get_blocked_ratio(owner, BRUTE, damage = 30)
	if(armor < 70)
		to_chat(owner, "<span class='danger'>You feel extreme pain!</span>")

		var/max_halloss = round(owner.species.total_health * 0.8 * ((100 - armor) / 100)) //up to 80% of passing out, further reduced by armour
		add_pain(clamp(0, max_halloss - owner.getHalLoss(), 30))

//Adds autopsy data for used_weapon.
/obj/item/organ/external/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/key = used_weapon
	var/data = used_weapon
	if(istype(used_weapon, /obj/item))
		var/obj/item/I = used_weapon
		key = I.name
		data = english_list(I.get_autopsy_descriptors())
	var/datum/autopsy_data/W = LAZYACCESS(autopsy_data, key)
	if(!W)
		W = new()
		W.weapon = data
		LAZYSET(autopsy_data, key, W)

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

/obj/item/organ/external/proc/has_genitals()
	return !BP_IS_PROSTHETIC(src) && bodytype?.get_vulnerable_location() == organ_tag

// Added to the mob's move delay tally if this organ is being used to move with.
/obj/item/organ/external/proc/get_movement_delay(max_delay)
	. = 0
	if(splinted)
		. += max_delay/8
	else if(status & ORGAN_BROKEN)
		. += max_delay * 3/8
	else if(BP_IS_PROSTHETIC(src))
		. += max_delay * CLAMP01(damage/max_damage)

/obj/item/organ/external/proc/is_robotic()
	. = FALSE
	if(BP_IS_PROSTHETIC(src) && model)
		var/decl/prosthetics_manufacturer/R = GET_DECL(model)
		. = R && R.is_robotic

/obj/item/organ/external/proc/has_growths()
	return FALSE

/obj/item/organ/external/add_ailment(var/datum/ailment/ailment)
	. = ..()
	if(. && owner)
		LAZYDISTINCTADD(owner.bad_external_organs, src)

/obj/item/organ/external/die() //External organs dying on a dime causes some real issues in combat
	if(!BP_IS_PROSTHETIC(src) && !BP_IS_CRYSTAL(src))
		var/decay_rate = damage/(max_damage*2)
		germ_level += round(rand(decay_rate,decay_rate*1.5)) //So instead, we're going to say the damage is so severe its functions are slowly failing due to the extensive damage
	else //TODO: more advanced system for synths
		if(istype(src,/obj/item/organ/external/chest) || istype(src,/obj/item/organ/external/groin))
			return
		status |= ORGAN_DEAD
	if(status & ORGAN_DEAD) //The organic dying part is covered in germ handling
		STOP_PROCESSING(SSobj, src)
		QDEL_NULL_LIST(ailments)
		death_time = REALTIMEOFDAY

/obj/item/organ/external/is_internal()
	return FALSE

// This likely seems excessive, but refer to organ explosion_act() to see how it should be handled before reaching this point.
/obj/item/organ/external/physically_destroyed(skip_qdel)
	if(owner)
		if(limb_flags & ORGAN_FLAG_CAN_AMPUTATE)
			dismember(FALSE, DISMEMBER_METHOD_BLUNT)
		else
			owner.gib()
	else
		return ..()

/obj/item/organ/external/is_vital_to_owner()
	if(isnull(vital_to_owner))
		. = ..()
		if(!.)
			for(var/obj/item/organ/O in children)
				if(O.is_vital_to_owner())
					vital_to_owner = TRUE
					break
	return vital_to_owner
