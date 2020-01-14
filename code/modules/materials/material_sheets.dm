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

	var/material/reinf_material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
	var/matter_multiplier = 1

/obj/item/stack/material/Initialize(mapload, var/amount, var/_material, var/_reinf_material)
	. = ..(mapload, amount, _material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(!_reinf_material)
		_reinf_material = reinf_material
	if(_reinf_material)
		reinf_material = SSmaterials.get_material_by_name(_reinf_material)
		if(!istype(reinf_material))
			reinf_material = null
	base_state = icon_state
	
	if(!stacktype)
		stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	update_strings()

/obj/item/stack/material/list_recipes(mob/user, recipes_sublist)
	if(!material)
		return
	recipes = material.get_recipes(reinf_material && reinf_material.name)
	..() 

/obj/item/stack/material/get_codex_value()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.display_name)] (material)" : ..()

/obj/item/stack/material/proc/set_amount(var/_amount)
	amount = max(1, min(_amount, max_amount))
	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	matter = material.get_matter()
	for(var/mat in matter)
		matter[mat] = round(matter[mat]*matter_multiplier*amount)
	if(reinf_material)
		var/list/rmatter = reinf_material.get_matter()
		for(var/mat in rmatter)
			rmatter[mat] = round(0.5*rmatter[mat]*matter_multiplier*amount)
			matter[mat] += rmatter[mat]

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
	return

/obj/item/stack/material/proc/is_same(obj/item/stack/material/M)
	if(!istype(M))
		return FALSE
	if(matter_multiplier != M.matter_multiplier)
		return FALSE
	if(material.name != M.material.name)
		return FALSE
	if((reinf_material && reinf_material.name) != (M.reinf_material && M.reinf_material.name))
		return FALSE
	return TRUE

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
	if(isCoil(W))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/material))
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
		color = material.icon_colour
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
	material = MATERIAL_IRON

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material = MATERIAL_SANDSTONE

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material = MATERIAL_MARBLE

/obj/item/stack/material/marble/ten
	amount = 10

/obj/item/stack/material/marble/fifty
	amount = 50

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	material = MATERIAL_DIAMOND

/obj/item/stack/material/diamond/ten
	amount = 10

/obj/item/stack/material/uranium
	name = "nuranium"
	icon_state = "sheet-faery-uranium"
	plural_icon_state = "sheet-faery-uranium-mult"
	max_icon_state = "sheet-faery-uranium-max"
	material = MATERIAL_URANIUM
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/uranium/ten
	amount = 10

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	plural_icon_state = "sheet-phoron-mult"
	max_icon_state = "sheet-phoron-max"
	material = MATERIAL_PHORON
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/phoron/ten
	amount = 10

/obj/item/stack/material/phoron/fifty
	amount = 50

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	material = MATERIAL_PLASTIC

/obj/item/stack/material/plastic/ten
	amount = 10

/obj/item/stack/material/plastic/fifty
	amount = 50

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = MATERIAL_GOLD

/obj/item/stack/material/gold/ten
	amount = 10

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = MATERIAL_SILVER

/obj/item/stack/material/silver/ten
	amount = 10

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = MATERIAL_PLATINUM

/obj/item/stack/material/platinum/ten
	amount = 10

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	material = MATERIAL_HYDROGEN
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/mhydrogen/ten
	amount = 10

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	material = MATERIAL_TRITIUM

/obj/item/stack/material/tritium/ten
	amount = 10

/obj/item/stack/material/tritium/fifty
	amount = 50

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material = MATERIAL_OSMIUM

/obj/item/stack/material/osmium/ten
	amount = 10

/obj/item/stack/material/ocp
	name = "osmium-carbide plasteel"
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	material = MATERIAL_OSMIUM_CARBIDE_PLASTEEL

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
	material = MATERIAL_DEUTERIUM

/obj/item/stack/material/deuterium/fifty
	amount = 50

/obj/item/stack/material/steel
	name = "steel"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material = MATERIAL_STEEL

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
	material = MATERIAL_ALUMINIUM

/obj/item/stack/material/aluminium/ten
	amount = 10

/obj/item/stack/material/aluminium/fifty
	amount = 50

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	material = MATERIAL_TITANIUM

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
	material = MATERIAL_PLASTEEL

/obj/item/stack/material/plasteel/ten
	amount = 10

/obj/item/stack/material/plasteel/fifty
	amount = 50

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	material = MATERIAL_WOOD

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	material = MATERIAL_MAHOGANY

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	material = MATERIAL_MAPLE

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	material = MATERIAL_EBONY

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	material = MATERIAL_WALNUT

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	material = MATERIAL_BAMBOO

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

/obj/item/stack/material/wood/yew
	name = "yew plank"
	material = MATERIAL_YEW

/obj/item/stack/material/wood/yew/ten
	amount = 10

/obj/item/stack/material/wood/yew/twentyfive
	amount = 25

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	material = MATERIAL_CLOTH

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	material = MATERIAL_CARDBOARD
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cardboard/ten
	amount = 10

/obj/item/stack/material/cardboard/fifty
	amount = 50

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material = MATERIAL_LEATHER_GENERIC
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	material = MATERIAL_GLASS

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
	material = MATERIAL_GLASS
	reinf_material = MATERIAL_STEEL

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	material = MATERIAL_PHORON_GLASS

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	material = MATERIAL_PHORON_GLASS
	reinf_material = MATERIAL_STEEL

/obj/item/stack/material/glass/phoronrglass/ten
	amount = 10

/obj/item/stack/material/aliumium
	name = "alien alloy"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material = MATERIAL_ALIENALLOY

/obj/item/stack/material/aliumium/ten
	amount = 10

/obj/item/stack/material/generic
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	if(material) color = material.icon_colour

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
