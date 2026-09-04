/obj/item/pen/fancy
	name              = "fountain pen"
	icon              = 'icons/obj/items/pens/pen_fancy.dmi'
	sharp             = TRUE
	stroke_color      = "#1c1713" //dark ashy brownish
	stroke_color_name = "dark ashy brownish"
	material          = /decl/material/solid/metal/steel
	pen_flag          = PEN_FLAG_ACTIVE | PEN_FLAG_FANCY
	pen_quality       = TOOL_QUALITY_GOOD
	pen_font          = PEN_FONT_FANCY_PEN

/obj/item/pen/fancy/make_pen_description()
	desc = "A high quality [istype(material)?"[material.name] ":null]traditional [stroke_color_name] [medium_name] fountain pen with an internal reservoir and an extra fine gold-platinum nib. Guaranteed never to leak."
