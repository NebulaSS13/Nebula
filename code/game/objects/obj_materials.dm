/////////////////////////////////////////////////////////
// Material Properties Handling
/////////////////////////////////////////////////////////
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
 * If keep_health is true, the health won't be reset to max_health after updating the material's max_health.
 * If skip_update_material is true, the proc will skip material updates, if false it will run them.
 * If skip_update_matter is true the matter list will not be changed.
 */
/obj/proc/set_material(var/new_material, var/keep_health = FALSE, var/skip_update_material = FALSE, var/skip_update_matter = FALSE)
	var/decl/material/old_material = material
	if(ispath(new_material, /decl/material))
		material = GET_DECL(new_material)
	else
		material = new_material

	if(!skip_update_matter)
		var/mat_units = get_primary_matter_amount()
		if(istype(old_material))
			subtract_matter(old_material, mat_units) //Remove the matter we added for the previous material if applicable
		add_matter(material, mat_units)

	if(!skip_update_material)
		update_material(keep_health)
	return TRUE

/**
 * Sets the reinforcing material of this obj, and triggers material related updates.
 * Can take either null, a path to a material decl, or the material decl itself.
 * If keep_health is true, the health won't be reset to max_health after updating the material's max_health.
 * If skip_update_material is true, the proc will skip material updates, if false it will run them.
 * If skip_update_matter is true the matter list will not be changed.
 */
/obj/proc/set_reinf_material(var/new_material, var/keep_health = FALSE, var/skip_update_material = FALSE, var/skip_update_matter = FALSE)
	return FALSE //Stub

/**
 * Make sure the properties set by materials are properly updated.
 * Also ensure properties applied when there are no materials set are properly applied.
 * Its important that this is run EVEN IF there are no materials set.
 * If keep_health is true, the health var will not be set to max_health, otherwise it will be.
 */
/obj/proc/update_material(var/keep_health = FALSE, var/should_update_icon = TRUE)
	update_material_health(null, keep_health)
	update_material_properties()
	update_material_armor()

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
	return //#TODO: Fill this up when obj damage update is in

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
	return //#TODO: Fill this up when obj damage update is in

/////////////////////////////////////////////////////////
// Matter List Handling
/////////////////////////////////////////////////////////

/**
 * Initialize the matter list contents.
 */
/obj/proc/create_matter()
	//Apply matter multiplier to matter list
	var/amount_modifier = get_matter_amount_modifier()
	for(var/M in matter)
		matter[M] = round(matter[M] * amount_modifier)

	//Add primary material, and any reinforced material
	add_matter(get_material(),       get_primary_matter_amount())
	add_matter(get_reinf_material(), get_reinf_matter_amount())

	UNSETEMPTY(matter)

/**
 * Updates the matter amounts in the matter list depending on what main material, or any extra materials, is currently set.
 * Used by a few specific things.
 */
// /obj/proc/update_matter()
// 	return //#TODO: Might remove this from the base class since it's not that useful in here

/**
 * Remove the amount of matter units from the given material type if present in the matter list. Meant to be used internally, with /decl/material instances only.
 */
/obj/proc/subtract_matter(var/decl/material/_material, var/amount)
	if(!length(matter))
		return
	return add_matter(_material, (amount * -1))

/**
 * Add a given matter units amount to the given material type in our matter list. For internal use only.
 */
/obj/proc/add_matter(var/decl/material/_material, var/amount)
	if(!istype(_material))
		return
	var/new_amount = max(0, round(LAZYACCESS(matter, _material.type) + amount))
	LAZYSET(matter, _material.type, new_amount)
	if(new_amount <= 0)
		LAZYREMOVE(matter, _material.type)
	return new_amount

/**
 * Return the modifier used to scale the matter amounts in the matter list.
 */
/obj/proc/get_matter_amount_modifier()
	. = CEILING(w_class * BASE_OBJECT_MATTER_MULTPLIER)
	if(obj_flags & OBJ_FLAG_HOLLOW)
		. *= HOLLOW_OBJECT_MATTER_MULTIPLIER

/**
 * Since some things override the amount of matter that is assigned to the primary, secondary and reinforcing material, we have to handle it here.
 */
/obj/proc/get_primary_matter_amount()
	return MATTER_AMOUNT_PRIMARY * get_matter_amount_modifier()

/**
 * Since some things override the amount of matter that is assigned to the primary, secondary and reinforcing material, we have to handle it here.
 */
/obj/proc/get_reinf_matter_amount()
	return MATTER_AMOUNT_REINFORCEMENT * get_matter_amount_modifier()