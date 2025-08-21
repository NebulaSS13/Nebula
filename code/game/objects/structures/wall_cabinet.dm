// A wall-mounted storage object.
/obj/structure/wall_cabinet
	name = "cabinet"
	desc = "A wall-mounted cabinet used to store various goods and sundries, and also make use of all that wasted wall-space."
	icon = 'icons/obj/structures/furniture/cabinet_duo.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	layer = ABOVE_HUMAN_LAYER
	material_alteration = MAT_FLAG_ALTERATION_ALL
	directional_offset = @'{"NORTH":{"y":-1},"SOUTH":{"y":24}}'
	storage = /datum/storage/wall_cabinet

/obj/structure/wall_cabinet/on_update_icon()
	. = ..()
	if(storage?.opened)
		// todo: door material? glass cabinet doors could be interesting if we add a 'full' sprite
		var/image/open_overlay = overlay_image(icon, "[icon_state]_open", get_color(), RESET_COLOR|KEEP_APART)
		open_overlay.layer = ABOVE_HUMAN_LAYER + 0.005
		add_overlay(open_overlay)

/datum/storage/wall_cabinet
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_GARGANTUAN) // smaller than structure fwiw
	open_sound = 'sound/foley/drawer-open.ogg'
	close_sound = 'sound/foley/drawer-close.ogg'

/obj/structure/wall_cabinet/walnut
	color = /decl/material/solid/organic/wood/walnut::color
	material = /decl/material/solid/organic/wood/walnut
	reinf_material = /decl/material/solid/organic/wood/walnut

/obj/structure/wall_cabinet/ebony
	color = /decl/material/solid/organic/wood/ebony::color
	material = /decl/material/solid/organic/wood/ebony
	reinf_material = /decl/material/solid/organic/wood/ebony