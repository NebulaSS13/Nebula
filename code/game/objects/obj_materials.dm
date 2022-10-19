/**
 * Returns the material the object is made of, if applicable.
 */
/obj/proc/get_material()
	return material

/**
 * Returns the reinforcing material if applicable.
 */
/obj/proc/get_reinf_material()
	return

/**
 * Sets the primary material of this obj, and triggers material related updates. 
 * Can take either null, a path to a material decl, or the material decl itself. 
 * If keep_heath is true, the health won't be reset to max_health after updating the material's max_health.
 * If update_material is true, the proc will call material updates, if false it will skip them.
 */
/obj/proc/set_material(var/new_material, var/keep_heath = FALSE, var/update_material = TRUE)
	if(ispath(new_material, /decl/material))
		material = GET_DECL(new_material)
	else
		material = new_material
	
	if(update_material)
		update_material(keep_heath)
	return TRUE

/**
 * Sets the reinforcing material of this obj, and triggers material related updates. 
 * Can take either null, a path to a material decl, or the material decl itself.
 * If keep_heath is true, the health won't be reset to max_health after updating the material's max_health.
 * If update_material is true, the proc will call material updates, if false it will skip them.
 */
/obj/proc/set_reinforcing_material(var/new_material, var/keep_heath = FALSE, var/update_material = TRUE)
	return FALSE

/**
 * Make sure the properties set by materials are properly updated. 
 * Also ensure properties applied when there are no materials set are properly applied.
 * If keep_health is true, the health var will not be set to max_health, otherwise it will be.
 */
/obj/proc/update_material(var/keep_health = FALSE, var/should_update_icon = TRUE)
	update_material_health(null, keep_health)
	update_material_properties()
	update_material_armor()
	update_matter()

	//Appearence stuff
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		update_material_name()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		update_material_desc()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		update_material_colour()
	update_material_sounds()

	if(should_update_icon)
		update_icon()

/**
 * Updates the obj name from the material currently set.
 * override_name will replace the name set in the definition with that given value and add a prefix based on the material.
 */
/obj/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	if(istype(material))
		SetName("[material.solid_name] [base_name]")
	else
		SetName(base_name)

/**
 * Updates the description from the material currently set.
 * override_desc will replace the desc set in the definition with that given value, and append the material desc.
 */
/obj/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	if(istype(material))
		desc = "[base_desc] This one is made of [material.solid_name]."
	else
		desc = base_desc

/**
 * Updates the obj color and transparency from the material currently set.
 * override_colour will bypass using the material's color with that given color instead.
 * override_alpha will bypass using the alpha calculation, and just assign the specified alpha
 */
/obj/proc/update_material_colour(var/override_colour, var/override_alpha)
	if(istype(material))
		color = override_colour || material.color
		alpha = override_alpha  || clamp((50 + (material.opacity * 255)), 0, 255)
	else
		color = override_colour || initial(color)
		alpha = override_alpha  || initial(alpha)
	
	if((alpha / 255) < 0.5)
		set_opacity(FALSE)
	else
		set_opacity(initial(opacity))

/** 
 * Updates the armor values a material provides to this obj. 
 * Will merge armor values set at definition with the armor values of the materials, with the definition taking preceedence.
 * overriden_armor allows passing the armor values and bypass this proc's behavior to set from a proc override, so the proc will simply set the armor and run update_armor().
 */
/obj/proc/update_material_armor(var/list/overriden_armor)
	if(overriden_armor)
		//If armor is overriden, use that
		armor = overriden_armor
	else if(!istype(material) || (istype(material) && !material_armor_multiplier))
		//If no materials take the value that was set in the definition
		armor = initial(armor)
		armor_degradation_speed = initial(armor_degradation_speed)
	else
		//If we have a material, and a material_armor_multiplier, get the armor from the material
		armor_degradation_speed = material.armor_degradation_speed
		if(length(initial(armor)))
			//Allow the material's armor resistances to be partially overriden by the user
			armor = material.get_armor(material_armor_multiplier) | initial(armor)
		else
			armor = material.get_armor(material_armor_multiplier)

	update_armor()

/** Updates material dependent sound effects to match the current material. Unless there was a value set in the definition for a given sound. */
/obj/proc/update_material_sounds()
	if(istype(material))
		hitsound = !initial(hitsound)? material.hitsound : hitsound
	else
		hitsound = initial(hitsound)

/** Updates misc properties that are taken from material(s). Such as the conductible flag, and material processing. */
/obj/proc/update_material_properties()
	if(istype(material))
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)

		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	else
		//Set back the conductive flag only if it was set in definition, make sure we don't mess with the other flags
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
		obj_flags |= (initial(obj_flags) & OBJ_FLAG_CONDUCTIBLE)

/**
 * Update the health of the object from either the override_max_health arg, the max_health set in the definition, or from the material(s).
 * If keep_health is true, the health var will not be set to max_health, unless it was at max_health previously.
 */
/obj/proc/update_material_health(var/override_max_health, var/keep_health = FALSE)
	if(!can_take_damage())
		return

	var/old_max_health = max_health
	if(override_max_health)
		max_health = override_max_health //If we got an overriden max_health use that first
	else if(initial(max_health) != null)
		max_health = initial(max_health) //If we set max_health in the definition, that takes priority
	else if(istype(material))
		//Otherwise if we got a material fall back to using the material's integrity
		max_health = round(material.integrity * get_material_health_modifier(), 0.01) 
		//Add extra health given by the reinf material
		var/decl/material/reinf = get_reinf_material()
		if(reinf)
			max_health += round(reinf.integrity * get_material_health_modifier(), 0.01) 
	else
		CRASH("This should have been intercepted by !can_take_damage()!!!") 

	if(max_health < 1)
		//Make sure to warn us if the values we set make the max_health be under 1
		if(material)
			log_warning("The 'max_health' of '[src]'([type]) made out of '[material]' was calculated as [get_material_health_modifier()] * [material.integrity] == [max_health], which is smaller than 1.")
		else
			log_warning("The 'max_health' of '[src]'([type]) was set to '[max_health]', which is smaller than 1.")
	
	//only set health if we didn't specify one already, so damaged objects on spawn and etc can be a thing
	if(health != old_max_health)
		health = keep_health ? min(health, max_health) : max_health
	else
		health = max_health //If health was set to the old max_health value before, just keep it at max_health

/**
 * Updates the matter amounts in the matter list depending on what main material, or any extra materials, is currently set. 
 * If matter_override is set, it will use that list instead of the matter list in the definition. It will still apply the material amount modifier to all entries.
 */
/obj/proc/update_matter(var/list/matter_override)
	//Grab matter from definition
	matter = matter_override || initial(matter)

	//Add primary materials
	var/decl/material/primary = get_material()
	if(istype(primary))
		LAZYSET(matter, primary.type, MATTER_AMOUNT_PRIMARY)
	
	//Add any reinforced material
	var/decl/material/reinf = get_reinf_material()
	if(istype(reinf))
		LAZYSET(matter, reinf.type, MATTER_AMOUNT_REINFORCEMENT)

	//Apply amount modifier
	for(var/mat in matter)
		matter[mat] = round(matter[mat] * get_matter_amount_modifier())

	UNSETEMPTY(matter)