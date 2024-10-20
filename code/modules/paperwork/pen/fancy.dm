/obj/item/pen/fancy
	name              = "fountain pen"
	icon              = 'icons/obj/items/pens/pen_fancy.dmi'
	sharp             = 1 //pointy
	stroke_color      = "#1c1713" //dark ashy brownish
	stroke_color_name = "dark ashy brownish"
	material          = /decl/material/solid/metal/steel
	pen_flag          = PEN_FLAG_ACTIVE | PEN_FLAG_FANCY
	pen_quality       = TOOL_QUALITY_GOOD
	pen_font          = PEN_FONT_FANCY_PEN

/obj/item/pen/fancy/make_pen_description()
	desc = "A high quality [istype(material)?"[material.name] ":null]traditional [stroke_color_name] [medium_name] fountain pen with an internal reservoir and an extra fine gold-platinum nib. Guaranteed never to leak."

/obj/item/pen/fancy/quill
	name        = "quill pen"
	icon        = 'icons/obj/items/pens/pen_quill.dmi'
	sharp       = 0
	material    = /decl/material/solid/organic/skin/feathers
	pen_quality = TOOL_QUALITY_DEFAULT

/obj/item/pen/fancy/quill/make_pen_description()
	desc = "A large feather, sharpened and cut to hold ink for scribing."

/obj/item/pen/fancy/quill/goose
	name        = "dire goose quill"
	pen_quality = TOOL_QUALITY_BEST

/obj/item/pen/fancy/quill/goose/make_pen_description()
	desc = "A quill fashioned from a feather of the dire goose makes an excellent writing instrument, as well as a valuable trophy."
