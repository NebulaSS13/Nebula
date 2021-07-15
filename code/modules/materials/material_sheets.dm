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
	pickup_sound = 'sound/foley/tooldrop3.ogg'
	drop_sound = 'sound/foley/tooldrop2.ogg'
	singular_name = "sheet"
	plural_name = "sheets"
	var/decl/material/reinf_material

/obj/item/stack/material/Initialize(mapload, var/amount, var/_material, var/_reinf_material)
	. = ..(mapload, amount, _material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(!_reinf_material)
		_reinf_material = reinf_material
	if(_reinf_material)
		reinf_material = GET_DECL(_reinf_material)
		if(!istype(reinf_material))
			reinf_material = null
	base_state = icon_state
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

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/material))
		if(is_same(W))
			..()
		else if(!reinf_material)
			material.reinforce(user, W, src)
		return
	else if(reinf_material && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn() && WT.get_fuel() > 2 && use(2))
			WT.remove_fuel(2, user)
			to_chat(user,"<span class='notice'>You recover some [reinf_material.use_name] from the [src].</span>")
			reinf_material.create_object(get_turf(user), 1)
			return
	return ..()

/obj/item/stack/material/on_update_icon()
	color = material.color
	alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	update_state_from_amount()

/obj/item/stack/material/proc/update_state_from_amount()
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

/obj/item/stack/material/ingot
	name = "ingots"
	singular_name = "ingot"
	plural_name = "ingots"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	stack_merge_type = /obj/item/stack/material/ingot

/obj/item/stack/material/sheet
	name = "sheets"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	stack_merge_type = /obj/item/stack/material/sheet

/obj/item/stack/material/panel
	name = "panels"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	singular_name = "panel"
	plural_name = "panels"
	stack_merge_type = /obj/item/stack/material/panel

/obj/item/stack/material/skin
	name = "skin"
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"
	singular_name = "length"
	plural_name = "lengths"
	stack_merge_type = /obj/item/stack/material/skin

/obj/item/stack/material/skin/pelt
	name = "pelts"
	singular_name = "pelt"
	plural_name = "pelts"
	stack_merge_type = /obj/item/stack/material/skin/pelt

/obj/item/stack/material/skin/feathers
	name = "feathers"
	singular_name = "feather"
	plural_name = "feathers"
	stack_merge_type = /obj/item/stack/material/skin/feathers

/obj/item/stack/material/bone
	name = "bones"
	icon_state = "bone"
	plural_icon_state = "bone-mult"
	max_icon_state = "bone-max"
	singular_name = "length"
	plural_name = "lengths"
	stack_merge_type = /obj/item/stack/material/bone

/obj/item/stack/material/brick
	name = "bricks"
	singular_name = "brick"
	plural_name = "bricks"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	stack_merge_type = /obj/item/stack/material/brick

/obj/item/stack/material/bolt
	name = "bolts"
	icon_state = "sheet-cloth"
	singular_name = "bolt"
	plural_name = "bolts"
	stack_merge_type = /obj/item/stack/material/bolt

/obj/item/stack/material/pane
	name = "panes"
	singular_name = "pane"
	plural_name = "panes"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	stack_merge_type = /obj/item/stack/material/pane

/obj/item/stack/material/pane/update_state_from_amount()
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

/obj/item/stack/material/cardstock
	icon_state = "sheet-card"
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	stack_merge_type = /obj/item/stack/material/cardstock

/obj/item/stack/material/gemstone
	name = "gems"
	singular_name = "gem"
	plural_name = "gems"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	stack_merge_type = /obj/item/stack/material/gemstone

/obj/item/stack/material/puck
	name = "pucks"
	singular_name = "puck"
	plural_name = "pucks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/puck

/obj/item/stack/material/aerogel
	name = "aerogel"
	singular_name = "gel block"
	plural_name = "gel blocks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	stack_merge_type = /obj/item/stack/material/aerogel

/obj/item/stack/material/plank
	name = "planks"
	singular_name = "plank"
	plural_name = "planks"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	stack_merge_type = /obj/item/stack/material/plank

/obj/item/stack/material/segment
	name = "segments"
	singular_name = "segment"
	plural_name = "segments"
	icon_state = "sheet-mythril"
	stack_merge_type = /obj/item/stack/material/segment

/obj/item/stack/material/reinforced
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	stack_merge_type = /obj/item/stack/material/reinforced
/obj/item/stack/material/shiny
	icon_state = "sheet-sheen"
	item_state = "sheet-shiny"
	plural_icon_state = "sheet-sheen-mult"
	max_icon_state = "sheet-sheen-max"
	stack_merge_type = /obj/item/stack/material/shiny

/obj/item/stack/material/cubes
	name = "cube"
	desc = "Some featureless cubes."
	singular_name = "cube"
	plural_name = "cubes"
	icon_state = "cube"
	plural_icon_state = "cube-mult"
	max_icon_state = "cube-max"
	max_amount = 100
	attack_verb = list("cubed")
	stack_merge_type = /obj/item/stack/material/cubes

/obj/item/stack/material/lump
	name = "lumps"
	singular_name = "lump"
	plural_name = "lumps"
	icon_state = "lump"
	plural_icon_state = "lump-mult"
	max_icon_state = "lump-max"
	stack_merge_type = /obj/item/stack/material/lump

/obj/item/stack/material/slab
	name = "slabs"
	singular_name = "slab"
	plural_name = "slabs"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/slab

