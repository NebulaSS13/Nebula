// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEM_SIZE_LARGE
	throw_speed = 3
	throw_range = 3
	max_amount = 60
	randpixel = 3
	icon = 'icons/obj/materials.dmi'
	matter = null

	var/decl/material/reinf_material
	var/material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/Initialize(mapload, var/amount, var/_material, var/_reinf_material)
	. = ..(mapload, amount, _material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(!_reinf_material)
		_reinf_material = reinf_material
	if(_reinf_material)
		reinf_material = decls_repository.get_decl(_reinf_material)
		if(!istype(reinf_material))
			reinf_material = null
	base_state = icon_state
	if(!stacktype)
		stacktype = material.stack_type
	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	update_strings()

/obj/item/stack/material/list_recipes(mob/user, recipes_sublist)
	if(!material)
		return
	recipes = material.get_recipes(reinf_material && reinf_material.type)
	..() 

/obj/item/stack/material/get_codex_value()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.solid_name)] (material)" : ..()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/update_matter()
	create_matter()

/obj/item/stack/material/create_matter()
	matter = list()
	if(istype(material))
		matter[material.type] = MATTER_AMOUNT_PRIMARY * get_matter_amount_modifier()
	if(istype(reinf_material))
		matter[reinf_material.type] = MATTER_AMOUNT_REINFORCEMENT * get_matter_amount_modifier()

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	if(material_flags & USE_MATERIAL_SINGULAR_NAME)
		singular_name = material.sheet_singular_name

	if(material_flags & USE_MATERIAL_PLURAL_NAME)
		plural_name = material.sheet_plural_name
	
	if(amount>1)
		SetName("[material.use_name] [plural_name]")
		desc = "A stack of [material.use_name] [plural_name]."
		gender = PLURAL
	else
		SetName("[material.use_name] [singular_name]")
		desc = "A [singular_name] of [material.use_name]."
		gender = NEUTER
	if(reinf_material)
		SetName("reinforced [name]")
		desc = "[desc]\nIt is reinforced with the [reinf_material.use_name] lattice."

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()

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

/obj/item/stack/material/update_strings()
	. = ..()
	if(material.stack_origin_tech)
		origin_tech = material.stack_origin_tech
	else if(reinf_material && reinf_material.stack_origin_tech)
		origin_tech = reinf_material.stack_origin_tech
	else
		origin_tech = initial(origin_tech)

/obj/item/stack/material/transfer_to(obj/item/stack/material/M, var/tamount=null, var/type_verified)
	if(!is_same(M))
		return 0
	var/transfer = ..(M,tamount,1)
	if(!QDELETED(src))
		update_strings()
	if(!QDELETED(M))
		M.update_strings()
	return transfer

/obj/item/stack/material/copy_from(var/obj/item/stack/material/other)
	..()
	if(istype(other))
		material = other.material
		reinf_material = other.reinf_material
		update_strings()
		update_icon()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/material))
		if(is_same(W))
			..()
		else if(!reinf_material)
			material.reinforce(user, W, src)
		return
	else if(reinf_material && reinf_material.stack_type && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn() && WT.get_fuel() > 2 && use(2))
			WT.remove_fuel(2, user)
			to_chat(user,"<span class='notice'>You recover some [reinf_material.use_name] from the [src].</span>")
			reinf_material.place_sheet(get_turf(user), 1)
			return
	return ..()

/obj/item/stack/material/on_update_icon()
	if(material_flags & USE_MATERIAL_COLOR)
		color = material.color
		alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = /decl/material/solid/metal/iron

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material = /decl/material/solid/stone/sandstone

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material = /decl/material/solid/stone/marble

/obj/item/stack/material/marble/ten
	amount = 10

/obj/item/stack/material/marble/fifty
	amount = 50

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	material = /decl/material/solid/gemstone/diamond

/obj/item/stack/material/diamond/ten
	amount = 10

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-faery-uranium"
	plural_icon_state = "sheet-faery-uranium-mult"
	max_icon_state = "sheet-faery-uranium-max"
	material = /decl/material/solid/metal/uranium
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/uranium/ten
	amount = 10

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	material = /decl/material/solid/plastic

/obj/item/stack/material/plastic/ten
	amount = 10

/obj/item/stack/material/plastic/fifty
	amount = 50

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = /decl/material/solid/metal/gold

/obj/item/stack/material/gold/ten
	amount = 10

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = /decl/material/solid/metal/silver

/obj/item/stack/material/silver/ten
	amount = 10

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = /decl/material/solid/metal/platinum

/obj/item/stack/material/platinum/ten
	amount = 10

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	material = /decl/material/solid/metallic_hydrogen
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/mhydrogen/ten
	amount = 10

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	material = /decl/material/gas/hydrogen/tritium

/obj/item/stack/material/tritium/ten
	amount = 10

/obj/item/stack/material/tritium/fifty
	amount = 50

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = /decl/material/solid/metal/osmium

/obj/item/stack/material/osmium/ten
	amount = 10

/obj/item/stack/material/ocp
	name = "osmium-carbide plasteel"
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	material = /decl/material/solid/metal/plasteel/ocp

/obj/item/stack/material/ocp/ten
	amount = 10

/obj/item/stack/material/ocp/fifty
	amount = 50

// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	material = /decl/material/gas/hydrogen/deuterium

/obj/item/stack/material/deuterium/fifty
	amount = 50

/obj/item/stack/material/steel
	name = "steel"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material = /decl/material/solid/metal/steel

/obj/item/stack/material/steel/ten
	amount = 10

/obj/item/stack/material/steel/fifty
	amount = 50

/obj/item/stack/material/aluminium
	name = "aluminium"
	icon_state = "sheet-sheen"
	item_state = "sheet-shiny"
	plural_icon_state = "sheet-sheen-mult"
	max_icon_state = "sheet-sheen-max"
	material = /decl/material/solid/metal/aluminium

/obj/item/stack/material/aluminium/ten
	amount = 10

/obj/item/stack/material/aluminium/fifty
	amount = 50

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	material = /decl/material/solid/metal/titanium

/obj/item/stack/material/titanium/ten
	amount = 10

/obj/item/stack/material/titanium/fifty
	amount = 50

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	material = /decl/material/solid/metal/plasteel

/obj/item/stack/material/plasteel/ten
	amount = 10

/obj/item/stack/material/plasteel/fifty
	amount = 50

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	material = /decl/material/solid/wood

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	material = /decl/material/solid/wood/mahogany

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	material = /decl/material/solid/wood/maple

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	material = /decl/material/solid/wood/ebony

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	material = /decl/material/solid/wood/walnut

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	material = /decl/material/solid/wood/bamboo

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

/obj/item/stack/material/wood/yew
	name = "yew plank"
	material = /decl/material/solid/wood/yew

/obj/item/stack/material/wood/yew/ten
	amount = 10

/obj/item/stack/material/wood/yew/twentyfive
	amount = 25

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	material = /decl/material/solid/cloth

/obj/item/stack/material/cloth/ten
	amount = 10 

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	material = /decl/material/solid/cardboard
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cardboard/ten
	amount = 10

/obj/item/stack/material/cardboard/fifty
	amount = 50

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material = /decl/material/solid/leather
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/leather/ten
	amount = 10

/obj/item/stack/material/leather/synth
	name = "synth leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material = /decl/material/solid/leather/synth
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/leather/synth/ten
	amount = 10

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	material = /decl/material/solid/glass

/obj/item/stack/material/glass/on_update_icon()
	if(reinf_material) 
		icon_state = "sheet-glass-reinf"
		base_state = icon_state
		plural_icon_state = "sheet-glass-reinf-mult"
		max_icon_state = "sheet-glass-reinf-max"
	else
		icon_state = "sheet-clear"
		base_state = icon_state
		plural_icon_state = "sheet-clear-mult"
		max_icon_state = "sheet-clear-max"
	..()

/obj/item/stack/material/glass/ten
	amount = 10

/obj/item/stack/material/glass/fifty
	amount = 50

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-reinf"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	material = /decl/material/solid/glass
	reinf_material = /decl/material/solid/metal/steel

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

/obj/item/stack/material/glass/borosilicate
	name = "borosilicate glass"
	material = /decl/material/solid/glass/borosilicate

/obj/item/stack/material/glass/reinforced_borosilicate
	name = "reinforced borosilicate glass"
	material = /decl/material/solid/glass/borosilicate
	reinf_material = /decl/material/solid/metal/steel

/obj/item/stack/material/glass/reinforced_borosilicate/ten
	amount = 10

/obj/item/stack/material/aliumium
	name = "alien alloy"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material = /decl/material/solid/metal/aliumium

/obj/item/stack/material/aliumium/ten
	amount = 10

/obj/item/stack/material/generic
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	if(material)
		color = material.color

/obj/item/stack/material/generic/skin
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"

/obj/item/stack/material/generic/bone
	icon_state = "bone"
	plural_icon_state = "bone-mult"
	max_icon_state = "bone-max"

/obj/item/stack/material/generic/brick
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
