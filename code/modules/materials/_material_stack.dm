// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	name = "material sheet"
	force = 5
	throwforce = 5
	w_class = ITEM_SIZE_LARGE
	throw_speed = 3
	throw_range = 3
	max_amount = 60
	randpixel = 3
	icon = 'icons/obj/items/stacks/materials.dmi'
	material = null //! Material will be set only during Initialize, or the stack is invalid.
	matter = null   //! As with material, these stacks should only set this in Initialize as they are abstract 'shapes' rather than discrete objects.
	pickup_sound = 'sound/foley/tooldrop3.ogg'
	drop_sound = 'sound/foley/tooldrop2.ogg'
	singular_name = "sheet"
	plural_name = "sheets"
	abstract_type = /obj/item/stack/material
	is_spawnable_type = FALSE // Mapped subtypes set this so they can be spawned from the verb.
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	var/can_be_pulverized = FALSE
	var/can_be_reinforced = FALSE
	var/decl/material/reinf_material

/obj/item/stack/material/Initialize(mapload, var/amount, var/_material, var/_reinf_material)

	if(!_reinf_material)
		_reinf_material = reinf_material

	if(_reinf_material)
		reinf_material = GET_DECL(_reinf_material)
		if(!istype(reinf_material))
			reinf_material = null

	. = ..(mapload, amount, _material)
	if(!istype(material))
		PRINT_STACK_TRACE("[src] ([x],[y],[z]) was deleted because it didn't have a valid material set('[material]')!")
		return INITIALIZE_HINT_QDEL

	base_state = icon_state
	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	//Sound setup
	if(material.sound_manipulate)
		pickup_sound = material.sound_manipulate
	if(material.sound_dropped)
		drop_sound = material.sound_dropped
	update_strings()
	update_icon()

/obj/item/stack/material/get_codex_value()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.codex_name || material.name)] (substance)" : ..()

/obj/item/stack/material/get_reinforced_material()
	return reinf_material

/obj/item/stack/material/create_matter()
	// Set our reinf material in the matter list so that the base
	// stack material population runs properly and includes it.
	if(istype(reinf_material))
		LAZYSET(matter, reinf_material.type, MATTER_AMOUNT_REINFORCEMENT)  // No matter_multiplier as this is applied in parent.
	..()

/obj/item/stack/material/proc/special_crafting_check()
	return TRUE

/obj/item/stack/material/proc/update_strings()
	var/prefix_name = name_modifier ? "[name_modifier] " : ""
	if(amount>1)
		SetName("[prefix_name][material.use_name] [plural_name]")
		desc = "A stack of [prefix_name][material.use_name] [plural_name]."
		gender = PLURAL
	else
		SetName("[prefix_name][material.use_name] [singular_name]")
		desc = "\A [prefix_name][singular_name] of [material.use_name]."
		gender = NEUTER
	if(reinf_material)
		SetName("reinforced [name]")
		desc = "[desc]\nIt is reinforced with the [reinf_material.use_name] lattice."

	if(material.stack_origin_tech)
		origin_tech = material.stack_origin_tech
	else if(reinf_material && reinf_material.stack_origin_tech)
		origin_tech = reinf_material.stack_origin_tech
	else
		origin_tech = initial(origin_tech)

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()

/obj/item/stack/material/clear_matter()
	..()
	reinf_material = null
	matter_per_piece = null

/obj/item/stack/material/proc/is_same(obj/item/stack/material/M)
	if(!istype(M))
		return FALSE
	if(matter_multiplier != M.matter_multiplier)
		return FALSE
	if(material.type != M.material.type)
		return FALSE
	if((reinf_material && reinf_material.type) != (M.reinf_material && M.reinf_material.type))
		return FALSE
	return TRUE

/obj/item/stack/material/transfer_to(obj/item/stack/material/M, var/tamount=null)
	if(!is_same(M))
		return 0
	. = ..(M,tamount,1)
	if(!QDELETED(src))
		update_strings()
	if(!QDELETED(M))
		M.update_strings()

/obj/item/stack/material/copy_from(var/obj/item/stack/material/other)
	..()
	if(istype(other))
		material = other.material
		reinf_material = other.reinf_material
		update_strings()
		update_icon()

/obj/item/stack/material/proc/get_stack_conversion_dictionary()
	return

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)

	if(can_be_reinforced && istype(W, /obj/item/stack/material))
		if(is_same(W))
			return ..()
		if(!reinf_material)
			material.reinforce(user, W, src)
		return TRUE

	// TODO: convert to converts_into entry.
	if(can_be_pulverized && IS_HAMMER(W) && material?.hardness >= MAT_VALUE_RIGID && user.a_intent == I_HURT)

		if(W.material?.hardness < material.hardness)
			to_chat(user, SPAN_WARNING("\The [W] is not hard enough to pulverize [material.solid_name]."))
			return TRUE

		var/converting = clamp(get_amount(), 0, 5)
		if(converting && W.do_tool_interaction(TOOL_HAMMER, user, src, 1 SECOND, "pulverizing", "pulverizing", set_cooldown = TRUE) && !QDELETED(src) && get_amount() >= converting)
			// TODO: make a gravel type?
			// TODO: pass actual stone material to gravel?
			new /obj/item/stack/material/ore/handful/sand(get_turf(user), converting)
			user.visible_message("\The [user] pulverizes [converting == 1 ? "a [singular_name]" : "some [plural_name]"] with \the [W].")
			use(converting)

		return TRUE

	if(reinf_material?.default_solid_form && IS_WELDER(W))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn() && WT.get_fuel() > 2 && use(2))
			WT.weld(2, user)
			to_chat(user, SPAN_NOTICE("You recover some [reinf_material.use_name] from \the [src]."))
			reinf_material.create_object(get_turf(user), 1)
			return TRUE

	var/list/can_be_converted_into = get_stack_conversion_dictionary()
	if(length(can_be_converted_into) && user.a_intent != I_HURT)

		var/convert_tool
		var/obj/item/stack/convert_type
		for(var/tool_type in can_be_converted_into)
			if(IS_TOOL(W, tool_type))
				convert_tool = tool_type
				convert_type = can_be_converted_into[tool_type]
				break

		if(convert_type)

			var/product_per_sheet         = matter_multiplier / initial(convert_type.matter_multiplier)
			var/minimum_per_one_product   = ceil(1 / product_per_sheet)

			if(get_amount() < minimum_per_one_product)
				to_chat(user, SPAN_WARNING("You will need [minimum_per_one_product] [minimum_per_one_product == 1 ? singular_name : plural_name] to produce [product_per_sheet] [product_per_sheet == 1 ? initial(convert_type.singular_name) : initial(convert_type.plural_name)]."))
			else if(W.do_tool_interaction(convert_tool, user, src, 1 SECOND, set_cooldown = TRUE) && !QDELETED(src) && get_amount() >= minimum_per_one_product)
				var/obj/item/stack/product = new convert_type(loc, ceil(product_per_sheet), material?.type, reinf_material?.type)
				product.dropInto(loc)
				use(minimum_per_one_product)
				if(product.add_to_stacks(user, TRUE))
					user.put_in_hands(product)
			return TRUE

	return ..()

/obj/item/stack/material/get_max_drying_wetness()
	return 120

/obj/item/stack/material/on_update_icon()
	. = ..()
	if(material)
		alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	else
		alpha = initial(alpha)
	update_state_from_amount()
	if(drying_wetness > 0)
		var/image/I = new(icon, icon_state)
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		I.alpha = 255 * (get_max_drying_wetness() / drying_wetness)
		I.color = COLOR_GRAY40
		I.blend_mode = BLEND_MULTIPLY
		add_overlay(I)

/obj/item/stack/material/ProcessAtomTemperature()
	. = ..()
	if(!QDELETED(src))
		update_strings()

/obj/item/stack/material/proc/update_state_from_amount()
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

/obj/item/stack/material/get_string_for_amount(amount)
	. = "[reinf_material ? "reinforced " : null][material.use_name]"
	if(amount == 1)
		. += " [singular_name]"
		return indefinite_article ? "[indefinite_article] [.]" : ADD_ARTICLE(.)
	return "[amount] [.] [plural_name]"
