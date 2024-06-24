/obj/item/tool/axe
	name                             = "hand axe"
	desc                             = "A handheld tool for chopping things, wood, food, or people."
	icon_state                       = "preview"
	icon                             = 'icons/obj/items/tool/axes/handaxe.dmi'
	sharp                            = TRUE
	edge                             = TRUE
	force                            = 10
	handle_material                  = /decl/material/solid/organic/wood
	material_force_multiplier        = 0.3
	thrown_material_force_multiplier = 0.25 // 15 with weight 60 (steel)
	max_force                        = 15
	item_flags                       = ITEM_FLAG_IS_WEAPON
	origin_tech                      = @'{"materials":2,"combat":1}'
	attack_verb                      = list("chopped", "torn", "cut")
	hitsound                         = "chop"

/obj/item/tool/axe/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HATCHET   = TOOL_QUALITY_DEFAULT
	)
	return tool_qualities

/obj/item/tool/axe/ebony
	handle_material = /decl/material/solid/organic/wood/ebony

// Legacy SS13 hatchet.
/obj/item/tool/axe/hatchet
	name                             = "hatchet"
	desc                             = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon                             = 'icons/obj/items/tool/axes/hatchet.dmi'
	material_force_multiplier        = 0.2 // 12 with hardness 60 (steel)
	w_class                          = ITEM_SIZE_SMALL
	material_alteration              = MAT_FLAG_ALTERATION_NAME
	handle_material                  = /decl/material/solid/organic/plastic

/obj/item/tool/axe/hatchet/get_handle_color()
	return null

/obj/item/tool/axe/hatchet/unbreakable
	max_health = ITEM_HEALTH_NO_DAMAGE
