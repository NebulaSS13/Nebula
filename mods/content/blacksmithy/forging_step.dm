/decl/forging_step
	abstract_type = /decl/forging_step
	/// Base name, generated from billet_name and billet_name_prefix.
	var/name
	/// Name to use for the actual billet item.
	var/billet_name = "billet"
	/// Name prefix to use for the billet at this stage.
	var/billet_name_prefix
	/// Description to use for the billet at this stage.
	var/billet_desc
	/// Icon state modifier to use for the billet at this stage.
	var/billet_icon_state
	/// Icon to use for the billet (for modpacks/downstreams)
	var/billet_icon = 'mods/content/blacksmithy/icons/billet.dmi'
	/// List of available /decl/forging_step instances.
	var/list/steps
	/// Probability of failing this step if we're below skill_level.
	var/skill_fail_prob = 30
	/// Impact of skill against probability of failure.
	var/skill_factor = 1
	/// Skill level where failing this step becomes impossible.
	var/skill_level = SKILL_ADEPT
	/// What skill this step requires.
	var/work_skill = SKILL_CONSTRUCTION
	/// Descriptive string for this action.
	var/work_verb = "forged"

/decl/forging_step/Initialize()

	// Resolve our types now to get it out of the way.
	for(var/step in steps)
		steps -= step
		steps += GET_DECL(step)

	if(billet_name_prefix)
		name = jointext(list(billet_name_prefix, billet_name), " ")
	else
		name = billet_name

	. = ..()

/decl/forging_step/validate()
	. = ..()
	if(!istext(name))
		. += "null or invalid name"
	if(!istext(billet_desc))
		. += "null or invalid billet_desc"
	if(!length(steps) && !istype(src, /decl/forging_step/product))
		. += "null or empty steps list"
	if(billet_icon_state)
		if(billet_icon)
			if(!check_state_in_icon("[ICON_STATE_WORLD]-[billet_icon_state]", billet_icon))
				. += "missing billet icon state '[ICON_STATE_WORLD]-[billet_icon_state]' from icon '[billet_icon]'"
		else
			. += "missing billet_icon"

/decl/forging_step/proc/get_product_name(decl/material/billet_material)
	. = billet_name
	if(billet_material)
		. = "[billet_material.adjective_name] [.]"
	if(billet_name_prefix)
		. = "[billet_name_prefix] [.]"

/decl/forging_step/proc/get_radial_choices()
	for(var/decl/forging_step/step in steps)
		var/image/radial_button = new
		radial_button.name = capitalize(step.name)
		LAZYSET(., step, radial_button)

/decl/forging_step/proc/apply_to(obj/item/billet/billet)
	return billet

// There are effectively finished products.
/decl/forging_step/product
	// Dummy strings to avoid validate() fails; shouldn't be used anywhere.
	name        = "finished product"
	billet_desc        = "A finished product."
	abstract_type      = /decl/forging_step/product
	var/product_type   = /obj/item/stick

/decl/forging_step/product/get_product_name(decl/material/billet_material)
	return atom_info_repository.get_name_for(product_type, billet_material?.type)

/decl/forging_step/product/apply_to(obj/item/billet/billet)
	var/obj/item/thing = new product_type(null, billet.material?.type)
	thing.dropInto(billet.loc)
	thing.pixel_x     = billet.pixel_x
	thing.pixel_y     = billet.pixel_y
	thing.pixel_w     = billet.pixel_w
	thing.pixel_z     = billet.pixel_z
	thing.temperature = billet.temperature
	thing.update_heat_glow(anim_time = 0)

	if(billet.paint_color)
		thing.paint_color = billet.paint_color
		thing.update_icon()
	qdel(billet)
	thing.base_name = name
	thing.update_name()
	return thing
