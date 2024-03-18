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
		log_warning("[src] ([x],[y],[z]) was deleted because it didn't have a valid material set('[material]')!")
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
	return (material && !material.hidden_from_codex) ? "[lowertext(material.codex_name)] (substance)" : ..()

/obj/item/stack/material/get_reinforced_material()
	return reinf_material

/obj/item/stack/material/create_matter()
	// Set our reinf material in the matter list so that the base
	// stack material population runs properly and includes it.
	if(istype(reinf_material))
		LAZYSET(matter, reinf_material.type, MATTER_AMOUNT_REINFORCEMENT)  // No matter_multiplier as this is applied in parent.
	..()

/obj/item/stack/material/proc/update_strings()
	if(amount>1)
		SetName("[material.use_name] [plural_name]")
		desc = "A stack of [material.use_name] [plural_name]."
		gender = PLURAL
	else
		SetName("[material.use_name] [singular_name]")
		desc = "\A [singular_name] of [material.use_name]."
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

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)

	if(can_be_reinforced && istype(W, /obj/item/stack/material))
		if(is_same(W))
			return ..()
		if(!reinf_material)
			material.reinforce(user, W, src)
		return TRUE

	if(can_be_pulverized && IS_HAMMER(W) && material?.hardness >= MAT_VALUE_RIGID)
		if(W.material?.hardness < material.hardness)
			to_chat(user, SPAN_WARNING("\The [W] is not hard enough to pulverize [material.solid_name]."))
			return TRUE
		var/converting = clamp(get_amount(), 0, 5)
		if(converting)
			// TODO: make a gravel type?
			// TODO: pass actual stone material to gravel?
			new /obj/item/stack/material/ore/sand(get_turf(user), converting)
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

	return ..()

/obj/item/stack/material/get_max_drying_wetness()
	return 120

/obj/item/stack/material/on_update_icon()
	. = ..()
	color = material?.color
	alpha = 100 + max(1, amount/25)*(material.opacity * 255)
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

/obj/item/stack/material/ingot
	name = "ingots"
	singular_name = "ingot"
	plural_name = "ingots"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	stack_merge_type = /obj/item/stack/material/ingot
	crafting_stack_type = /obj/item/stack/material/ingot
	can_be_pulverized = TRUE

/obj/item/stack/material/sheet
	name = "sheets"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	stack_merge_type = /obj/item/stack/material/sheet
	crafting_stack_type = /obj/item/stack/material/sheet

/obj/item/stack/material/panel
	name = "panels"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	singular_name = "panel"
	plural_name = "panels"
	stack_merge_type = /obj/item/stack/material/panel
	crafting_stack_type = /obj/item/stack/material/panel

/obj/item/stack/material/skin
	name = "skin"
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"
	singular_name = "length"
	plural_name = "lengths"
	stack_merge_type = /obj/item/stack/material/skin
	crafting_stack_type = /obj/item/stack/material/skin

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
	crafting_stack_type = /obj/item/stack/material/bone
	craft_verb = "carve"
	craft_verbing = "carving"

/obj/item/stack/material/brick
	name = "bricks"
	singular_name = "brick"
	plural_name = "bricks"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	stack_merge_type = /obj/item/stack/material/brick
	crafting_stack_type = /obj/item/stack/material/brick
	can_be_pulverized = TRUE

/obj/item/stack/material/bolt
	name = "bolts"
	icon_state = "sheet-cloth"
	singular_name = "bolt"
	plural_name = "bolts"
	stack_merge_type = /obj/item/stack/material/bolt
	crafting_stack_type = /obj/item/stack/material/bolt
	craft_verb = "tailor"
	craft_verbing = "tailoring"

/obj/item/stack/material/pane
	name = "panes"
	singular_name = "pane"
	plural_name = "panes"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	stack_merge_type = /obj/item/stack/material/pane
	crafting_stack_type = /obj/item/stack/material/pane
	can_be_reinforced = TRUE

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
	crafting_stack_type = /obj/item/stack/material/cardstock
	craft_verb = "fold"
	craft_verbing = "folding"

/obj/item/stack/material/gemstone
	name = "gems"
	singular_name = "gem"
	plural_name = "gems"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	stack_merge_type = /obj/item/stack/material/gemstone
	crafting_stack_type = /obj/item/stack/material/gemstone
	can_be_pulverized = TRUE

/obj/item/stack/material/puck
	name = "pucks"
	singular_name = "puck"
	plural_name = "pucks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/puck
	crafting_stack_type = /obj/item/stack/material/puck
	can_be_pulverized = TRUE

/obj/item/stack/material/aerogel
	name = "aerogel"
	singular_name = "gel block"
	plural_name = "gel blocks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/aerogel
	crafting_stack_type = /obj/item/stack/material/aerogel

// Aerogel melting point is below 0 as it is a physical container for gas; hack around that here.
/obj/item/stack/material/aerogel/ProcessAtomTemperature()
	return PROCESS_KILL

/obj/item/stack/material/plank
	name = "planks"
	singular_name = "plank"
	plural_name = "planks"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	pickup_sound = 'sound/foley/wooden_drop.ogg'
	drop_sound = 'sound/foley/wooden_drop.ogg'
	stack_merge_type = /obj/item/stack/material/plank
	crafting_stack_type = /obj/item/stack/material/plank

/obj/item/stack/material/log
	name = "logs"
	singular_name = "log"
	plural_name = "logs"
	icon_state = "log"
	plural_icon_state = "log-mult"
	max_icon_state = "log-max"
	stack_merge_type = /obj/item/stack/material/log
	crafting_stack_type = /obj/item/stack/material/log
	craft_verb = "whittle"
	craft_verbing = "whittling"
	var/plank_type = /obj/item/stack/material/plank

/obj/item/stack/material/log/attackby(obj/item/W, mob/user)
	if(plank_type && (IS_HATCHET(W) || IS_SAW(W)))
		var/tool_type = W.get_tool_quality(TOOL_HATCHET) >= W.get_tool_quality(TOOL_SAW) ? TOOL_HATCHET : TOOL_SAW
		if(W.do_tool_interaction(tool_type, user, src, 1 SECOND, set_cooldown = TRUE) && !QDELETED(src))
			var/obj/item/stack/planks = new plank_type(get_turf(src), rand(2,4), material?.type, reinf_material?.type) // todo: change plank amount based on carpentry skillcheck
			playsound(loc, 'sound/foley/wooden_drop.ogg', 40, TRUE)
			use(1)
			if(planks.add_to_stacks(user, TRUE))
				user.put_in_hands(planks)
		return TRUE
	return ..()

/obj/item/stack/material/segment
	name = "segments"
	singular_name = "segment"
	plural_name = "segments"
	icon_state = "sheet-mythril"
	stack_merge_type = /obj/item/stack/material/segment
	crafting_stack_type = /obj/item/stack/material/segment

/obj/item/stack/material/sheet/reinforced
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	stack_merge_type = /obj/item/stack/material/sheet/reinforced

/obj/item/stack/material/sheet/shiny
	icon_state = "sheet-sheen"
	item_state = "sheet-shiny"
	plural_icon_state = "sheet-sheen-mult"
	max_icon_state = "sheet-sheen-max"
	stack_merge_type = /obj/item/stack/material/sheet/shiny

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
	crafting_stack_type = /obj/item/stack/material // cubes can be used for any crafting
	can_be_pulverized = TRUE

/obj/item/stack/material/lump
	name = "lumps"
	singular_name = "lump"
	plural_name = "lumps"
	icon_state = "lump"
	plural_icon_state = "lump-mult"
	max_icon_state = "lump-max"
	stack_merge_type = /obj/item/stack/material/lump
	crafting_stack_type = /obj/item/stack/material/lump
	craft_verb = "sculpt"
	craft_verbing = "sculpting"
	can_be_pulverized = TRUE

/obj/item/stack/material/slab
	name = "slabs"
	singular_name = "slab"
	plural_name = "slabs"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/slab
	crafting_stack_type = /obj/item/stack/material/slab
	can_be_pulverized = TRUE

/obj/item/stack/material/bundle
	name = "bundles"
	singular_name = "bundle"
	plural_name = "bundles"
	icon_state = "bundle"
	plural_icon_state = "bundle-mult"
	max_icon_state = "bundle-max"
	stack_merge_type = /obj/item/stack/material/bundle
	crafting_stack_type = /obj/item/stack/material/bundle
	craft_verb = "weave"
	craft_verbing = "weaving"

/obj/item/stack/material/strut
	name = "struts"
	singular_name = "strut"
	plural_name = "struts"
	icon_state = "sheet-strut"
	plural_icon_state = "sheet-strut-mult"
	max_icon_state = "sheet-strut-max"
	stack_merge_type = /obj/item/stack/material/strut
	crafting_stack_type = /obj/item/stack/material/strut

/obj/item/stack/material/strut/cyborg
	name = "metal strut synthesizer"
	desc = "A device that makes metal strut."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	material = /decl/material/solid/metal/steel
	max_health = ITEM_HEALTH_NO_DAMAGE
	is_spawnable_type = FALSE

/obj/item/stack/material/bar
	name = "bar"
	singular_name = "bar"
	plural_name = "bars"
	icon_state = "bar"
	plural_icon_state = "bar-mult"
	max_icon_state = "bar-max"
	stack_merge_type = /obj/item/stack/material/bar
	crafting_stack_type = /obj/item/stack/material/bar
