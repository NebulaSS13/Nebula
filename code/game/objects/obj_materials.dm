/**Returns the material the object is made of, if applicable.
 * Will we ever need to return more than one value here? Or should we just return the "dominant" material.*/
/obj/proc/get_material()
	return material

/**Can take either a path to a material decl, or the material decl itself. */
/obj/proc/set_material(var/new_material)
	if(ispath(new_material, /decl/material))
		material = GET_DECL(new_material)
	else
		material = new_material

	if(istype(material))
		//Only set the health if health is null. Some things define their own health value.
		if(isnull(max_health))
			max_health = round(get_material_health_modifier() * material.integrity, 0.01)
			if(max_health < 1)
				//Make sure to warn us if the values we set make the max_health be under 1
				log_warning("The 'max_health' of '[src]'([type]) made out of '[material]' was calculated as [get_material_health_modifier()] * [material.integrity] == [max_health], which is smaller than 1.")
				
		if(isnull(health)) //only set health if we didn't specify one already, so damaged objects on spawn and etc can be a thing
			health = max_health
		
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)

		//Appearence stuff
		if(material_alteration & MAT_FLAG_ALTERATION_NAME)
			update_material_name()
		if(material_alteration & MAT_FLAG_ALTERATION_DESC)
			update_material_desc()
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			update_material_colour()
		if((alpha / 255) < 0.5)
			set_opacity(FALSE)
		else
			set_opacity(initial(opacity))
		
		//Sound
		if(!hitsound)
			hitsound = material?.hitsound

		//Armor
		if(material_armor_multiplier)
			//Allow the material's armor resistances to be partially overriden by the user
			if(length(armor))
				//Merge the resistances from the material with the ones we specified, exluding those already defined by the definition
				armor |= material.get_armor(material_armor_multiplier)
			else
				armor = material.get_armor(material_armor_multiplier)

			armor_degradation_speed = material.armor_degradation_speed
			update_armor()

	queue_icon_update()

/obj/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	if(istype(material))
		SetName("[material.solid_name] [base_name]")
	else
		SetName(base_name)

/obj/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	if(istype(material))
		desc = "[base_desc] This one is made of [material.solid_name]."
	else
		desc = base_desc

/obj/proc/update_material_colour(var/override_colour)
	if(istype(material))
		color = override_colour || material.color
		alpha = clamp((50 + material.opacity * 255), 0, 255)
	else
		color = override_colour || initial(color)
		alpha = initial(alpha)
