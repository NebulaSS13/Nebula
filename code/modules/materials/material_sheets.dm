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
	material_composition = null
	pickup_sound = 'sound/foley/tooldrop3.ogg'
	drop_sound = 'sound/foley/tooldrop2.ogg'
	var/material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/Initialize(mapload, var/amount, var/_material, var/_reinf_material)
	. = ..(mapload, amount, _material)
	var/decl/material/material = get_primary_material()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	base_state = icon_state
	if(!stacktype)
		stacktype = material.stack_type
	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
	update_strings()

/obj/item/stack/material/list_recipes(mob/user, recipes_sublist)
	var/decl/material/material = get_primary_material()
	if(material)
		recipes = material.get_recipes(get_reinforcing_material_type())
	..() 

/obj/item/stack/material/get_codex_value()
	var/decl/material/material = get_primary_material()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.solid_name)] (material)" : ..()

/obj/item/stack/material/update_matter()
	create_material_composition()

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	var/decl/material/material = get_primary_material()
	if(!material)
		singular_name = initial(singular_name)
		plural_name = initial(plural_name)
	else
		if(material_flags & USE_MATERIAL_SINGULAR_NAME)
			singular_name = material.sheet_singular_name
		if(material_flags & USE_MATERIAL_PLURAL_NAME)
			plural_name = material.sheet_plural_name

	if(amount>1)
		if(material)
			SetName("[material.use_name] [plural_name]")
			desc = "A stack of [material.use_name] [plural_name]."
		else
			SetName(plural_name)
			desc = "A stack of [plural_name]."
		gender = PLURAL
	else
		if(material)
			SetName("[material.use_name] [singular_name]")
			desc = "A [singular_name] of [material.use_name]."
		else
			SetName(singular_name)
			desc = "A [singular_name]."
		gender = NEUTER

	var/decl/material/reinf_material = get_reinforcing_material()
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
	if(get_primary_material() != M.get_primary_material())
		return FALSE
	if(get_reinforcing_material() != M.get_reinforcing_material())
		return FALSE
	return TRUE

/obj/item/stack/material/update_strings()
	. = ..()
	var/decl/material/material = get_primary_material()
	var/decl/material/reinf_material = get_reinforcing_material()
	if(material?.stack_origin_tech)
		origin_tech = material.stack_origin_tech
	else if(reinf_material?.stack_origin_tech)
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
		set_primary_material(other.get_primary_material())
		set_reinforcing_material(other.get_reinforcing_material())
		update_strings()
		update_icon()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/material))
		if(is_same(W))
			..()
		else if(!get_reinforcing_material())
			var/decl/material/material = W.get_primary_material()
			if(material)
				material.reinforce(user, W, src)
		return

	var/decl/material/reinf_material = get_reinforcing_material()
	if(reinf_material && reinf_material.stack_type && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn() && WT.get_fuel() > 2 && use(2))
			WT.remove_fuel(2, user)
			to_chat(user,"<span class='notice'>You recover some [reinf_material.use_name] from the [src].</span>")
			reinf_material.place_sheet(get_turf(user), 1)
			return
	return ..()

/obj/item/stack/material/on_update_icon()
	if(material_flags & USE_MATERIAL_COLOR)
		var/decl/material/material = get_primary_material()
		if(material)
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
	material_composition = list(/decl/material/solid/metal/iron = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material_composition = list(/decl/material/solid/stone/sandstone = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	material_composition = list(/decl/material/solid/stone/marble = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/marble/ten
	amount = 10

/obj/item/stack/material/marble/fifty
	amount = 50

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	material_composition = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/diamond/ten
	amount = 10

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-faery-uranium"
	plural_icon_state = "sheet-faery-uranium-mult"
	max_icon_state = "sheet-faery-uranium-max"
	material_composition = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/uranium/ten
	amount = 10

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/plastic/ten
	amount = 10

/obj/item/stack/material/plastic/fifty
	amount = 50

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/gold/ten
	amount = 10

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/silver/ten
	amount = 10

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/platinum = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/platinum/ten
	amount = 10

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	material_composition = list(/decl/material/solid/metallic_hydrogen = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/mhydrogen/ten
	amount = 10

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	material_composition = list(/decl/material/gas/hydrogen/tritium = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/tritium/ten
	amount = 10

/obj/item/stack/material/tritium/fifty
	amount = 50

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/osmium = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/osmium/ten
	amount = 10

/obj/item/stack/material/ocp
	name = "osmium-carbide plasteel"
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	material_composition = list(/decl/material/solid/metal/plasteel/ocp = MATTER_AMOUNT_PRIMARY)

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
	material_composition = list(/decl/material/gas/hydrogen/deuterium = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/deuterium/fifty
	amount = 50

/obj/item/stack/material/steel
	name = "steel"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)

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
	material_composition = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/aluminium/ten
	amount = 10

/obj/item/stack/material/aluminium/fifty
	amount = 50

/obj/item/stack/material/copper
	name = "copper"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/copper = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/copper/ten
	amount = 10

/obj/item/stack/material/copper/fifty
	amount = 50

/obj/item/stack/material/tin
	name = "tin"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/tin = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/tin/ten
	amount = 10

/obj/item/stack/material/tin/fifty
	amount = 50

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/lead = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/lead/ten
	amount = 10

/obj/item/stack/material/lead/fifty
	amount = 50

/obj/item/stack/material/zinc
	name = "zinc"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/zinc = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/zinc/ten
	amount = 10

/obj/item/stack/material/zinc/fifty
	amount = 50

/obj/item/stack/material/tungsten
	name = "tungsten"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	material_composition = list(/decl/material/solid/metal/tungsten = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/tungsten/ten
	amount = 10

/obj/item/stack/material/tungsten/fifty
	amount = 50

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_PRIMARY)

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
	material_composition = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/plasteel/ten
	amount = 10

/obj/item/stack/material/plasteel/fifty
	amount = 50

/obj/item/stack/material/bronze
	name = "bronze"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/bronze = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/bronze/ten
	amount = 10

/obj/item/stack/material/bronze/fifty
	amount = 50

/obj/item/stack/material/brass
	name = "brass"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/brass = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/brass/ten
	amount = 10

/obj/item/stack/material/brass/fifty
	amount = 50

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	material_composition = list(/decl/material/solid/wood/maple = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	material_composition = list(/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	material_composition = list(/decl/material/solid/wood/bamboo = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

/obj/item/stack/material/wood/yew
	name = "yew plank"
	material_composition = list(/decl/material/solid/wood/yew = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/wood/yew/ten
	amount = 10

/obj/item/stack/material/wood/yew/twentyfive
	amount = 25

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	material_composition = list(/decl/material/solid/cloth = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/cloth/ten
	amount = 10 

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	material_composition = list(/decl/material/solid/cardboard = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cardboard/ten
	amount = 10

/obj/item/stack/material/cardboard/fifty
	amount = 50

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material_composition = list(/decl/material/solid/leather = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/leather/ten
	amount = 10

/obj/item/stack/material/leather/synth
	name = "synth leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material_composition = list(/decl/material/solid/leather/synth = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/leather/synth/ten
	amount = 10

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	material_composition = list(/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/glass/on_update_icon()
	var/decl/material/reinf_material = get_reinforcing_material()
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
	material_composition = list(
		/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

/obj/item/stack/material/glass/borosilicate
	name = "borosilicate glass"
	material_composition = list(/decl/material/solid/glass/borosilicate = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/glass/reinforced_borosilicate
	name = "reinforced borosilicate glass"
	material_composition = list(
		/decl/material/solid/glass/borosilicate = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)

/obj/item/stack/material/glass/reinforced_borosilicate/ten
	amount = 10

/obj/item/stack/material/aliumium
	name = "alien alloy"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	material_composition = list(/decl/material/solid/metal/aliumium = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/aliumium/ten
	amount = 10

/obj/item/stack/material/generic
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	var/decl/material/material = get_primary_material()
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
