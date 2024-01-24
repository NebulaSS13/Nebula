/obj/item/pen/multi
	name                    = "multicoloured pen"
	desc                    = "It's a pen with multiple colors of ink!"
	pen_quality             = TOOL_QUALITY_MEDIOCRE
	var/colour_idx          = 1
	var/stroke_colors      = list("black", "blue", "red", "green")
	var/stroke_color_names = list("black", "blue", "red", "green")
	var/colour_icons        = list(
		'icons/obj/items/pens/pen.dmi',
		'icons/obj/items/pens/pen_blue.dmi',
		'icons/obj/items/pens/pen_red.dmi',
		'icons/obj/items/pens/pen_green.dmi',
	)

/obj/item/pen/multi/Initialize(ml, material_key)
	. = ..()
	change_colour(colour_idx)

/obj/item/pen/multi/make_pen_description()
	desc = "It's [istype(material)?"[ADD_ARTICLE(material.name)]":"a"] pen with multiple colors of ink! It's currently set to [stroke_color_name] [medium_name]."

/obj/item/pen/multi/proc/change_colour(var/new_idx)
	colour_idx = new_idx
	if(colour_idx > length(stroke_colors))
		colour_idx = 1
	icon = colour_icons[colour_idx]
	set_medium_color(stroke_colors[colour_idx], stroke_color_names[colour_idx])

/obj/item/pen/multi/attack_self(mob/user)
	change_colour((++colour_idx))
	to_chat(user, SPAN_NOTICE("Changed color to '[stroke_color_name] [medium_name].'"))
