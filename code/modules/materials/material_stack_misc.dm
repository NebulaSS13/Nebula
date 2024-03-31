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

// Hacky fix for grass crafting.
/obj/item/stack/material/bundle/special_crafting_check()
	return !dried_type || drying_wetness <= 0

/obj/item/stack/material/bundle/grass
	material = /decl/material/solid/organic/plantmatter/grass

/obj/item/stack/material/bundle/grass/dry
	material = /decl/material/solid/organic/plantmatter/grass/dry

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
