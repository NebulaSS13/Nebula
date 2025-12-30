/turf/wall/wattle
	icon_state = "wattle"
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color
	girder_material = null
	floor_type = /turf/floor/dirt
	min_dismantle_amount = 3
	max_dismantle_amount = 5
	shutter_icon = 'icons/turf/walls/square_shutter.dmi'
	var/decl/skill/daubing_skill = SKILL_CONSTRUCTION
	var/decl/material/daubing_material // todo: daubing as a material made from clay/soil and plant matter?
	var/const/matter_to_daub = MATTER_AMOUNT_REINFORCEMENT
	// Currently, plastering is done via painting... undecided if that should change in the future.

/turf/wall/wattle/Initialize(ml, materialtype, rmaterialtype)
	if(ispath(daubing_material))
		daubing_material = GET_DECL(daubing_material)
	return ..()

/turf/wall/wattle/get_turf_validation_corner_states()
	return list("", "paint") // paint should always be available because of plastering!

// Daubing with clay or soil
/turf/wall/wattle/attackby(obj/item/used_item, mob/user, click_params)
	if(isnull(daubing_material))
		var/static/list/daub_materials = list( // Does not include subtypes.
			/decl/material/solid/soil = TRUE,
			/decl/material/solid/clay = TRUE
		)
		if(istype(used_item, /obj/item/stack/material) && daub_materials[used_item.material?.type])
			if(!user.check_dexterity(DEXTERITY_WIELD_ITEM))
				return TRUE
			var/obj/item/stack/material/stack = used_item
			var/sheets_to_use = stack.matter_units_to_sheets(matter_to_daub)
			if(stack.can_use(sheets_to_use) && user.do_skilled(1 SECOND, daubing_skill, target = src) && stack.can_use(sheets_to_use))
				to_chat(user, SPAN_NOTICE("You daub \the [src] with \the [stack]."))
				daubing_material = stack.material
				stack.use(sheets_to_use)
			else if(stack.can_use(sheets_to_use)) // failed the do_skilled
				to_chat(user, SPAN_WARNING("You have to stay still to daub \the [src] with \the [stack]."))
			else
				to_chat(user, SPAN_WARNING("You need [stack.get_string_for_amount(sheets_to_use)] to daub \the [src]."))
			return TRUE
	return ..()

/turf/wall/wattle/get_dismantle_stack_type()
	return /obj/item/stack/material/log // temp?

// daubed walls have the color of their daubing
/turf/wall/wattle/get_base_color()
	if(daubing_material)
		return "#795946" // daubing_material.color // sorry, but using the daubing material color looks bad
	return ..()

// don't plaster over our damn reinforcements
/turf/wall/wattle/get_reinf_color()
	return reinf_material?.color

/turf/wall/wattle/get_wall_icon()
	if(isnull(daubing_material))
		return 'icons/turf/walls/wattle.dmi'
	else
		return 'icons/turf/walls/wattledaub.dmi'

/turf/wall/wattle/get_dismantle_sound()
	return 'sound/foley/wooden_drop.ogg'

/turf/wall/wattle/update_strings()
	if(isnull(daubing_material))
		if(reinf_material)
			SetName("[reinf_material.solid_name]-framed [material.adjective_name] wattle wall")
			desc = "A wattle wall made of [material.adjective_name] strips and framed with [reinf_material.solid_name]."
		else
			SetName("[material.solid_name] wattle wall")
			desc = "A wattle wall made of [material.adjective_name] strips."
	else if(paint_color)
		if(reinf_material)
			SetName("[reinf_material.solid_name]-framed plastered wall")
			desc = "A plastered wall framed with [reinf_material.solid_name]."
		else
			SetName("plastered wall")
			desc = "A plastered wall."
	else
		if(reinf_material)
			SetName("[reinf_material.solid_name]-framed [material.adjective_name] wattle and daub wall")
			desc = "A daubed wattle wall made of [material.adjective_name] strips and framed with [reinf_material.solid_name]."
		else
			SetName("[material.solid_name] wattle and daub wall")
			desc = "A daubed wattle wall made of [material.adjective_name] strips."

/turf/wall/wattle/daubed
	icon_state = "wattledaub"
	daubing_material = /decl/material/solid/clay
	color = "#795946" // temporary mapping preview colour taken from get_base_color()
	// the daub is lost when destroyed/deconstructed, since it's dried anyway

/turf/wall/wattle/daubed/plastered
	icon_state = "plaster"
	paint_color = "#c2b8a1" // this is what applies the plaster... icky
	color = "#c2b8a1" // preview color for plaster

/turf/wall/wattle/daubed/plastered/framed
	icon_state = "framed"
	reinf_material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color // preview, still painted

// Subtypes.
#define WATTLE_WALL_SUBTYPE(material_name) \
/turf/wall/wattle/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
	color = /decl/material/solid/organic/wood/##material_name::color; \
}; \
/turf/wall/wattle/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "wattle_shutter"; \
}; \
/turf/wall/wattle/##material_name/shutter/open { \
	shutter_state = TRUE; \
}; \
/turf/wall/wattle/daubed/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
}; \
/turf/wall/wattle/daubed/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "wattle_shutter"; \
}; \
/turf/wall/wattle/daubed/##material_name/shutter/open { \
	shutter_state = TRUE; \
}; \
/turf/wall/wattle/daubed/plastered/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
}; \
/turf/wall/wattle/daubed/plastered/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "wattle_shutter"; \
}; \
/turf/wall/wattle/daubed/plastered/##material_name/shutter/open { \
	shutter_state = TRUE; \
}; \
/turf/wall/wattle/daubed/plastered/framed/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
	reinf_material = /decl/material/solid/organic/wood/##material_name; \
	color = /decl/material/solid/organic/wood/##material_name::color; \
}; \
/turf/wall/wattle/daubed/plastered/framed/##material_name/shutter { \
	shutter_state = FALSE; \
	icon_state = "wattle_shutter"; \
}; \
/turf/wall/wattle/daubed/plastered/framed/##material_name/shutter/open { \
	shutter_state = TRUE; \
}
WATTLE_WALL_SUBTYPE(fungal)
WATTLE_WALL_SUBTYPE(ebony)
WATTLE_WALL_SUBTYPE(walnut)
WATTLE_WALL_SUBTYPE(maple)
WATTLE_WALL_SUBTYPE(mahogany)
WATTLE_WALL_SUBTYPE(bamboo)
WATTLE_WALL_SUBTYPE(yew)

#undef WATTLE_WALL_SUBTYPE