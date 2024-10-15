/obj/item/pen/crayon
	name                 = "crayon"
	icon                 = 'icons/obj/items/crayon.dmi'
	attack_verb          = list("attacked", "coloured", "crayon'd")
	stroke_color         = COLOR_RED
	color                = COLOR_RED
	stroke_color_name    = "red"
	medium_name          = "crayon"
	pen_flag             = PEN_FLAG_ACTIVE | PEN_FLAG_CRAYON | PEN_FLAG_DEL_EMPTY
	pen_quality          = TOOL_QUALITY_BAD //Writing with those things is awkward
	max_uses             = 30
	pen_font             = PEN_FONT_CRAYON
	material             = /decl/material/solid/organic/wax
	var/shade_color      = "#220000" //RGB
	var/pigment_type     = /decl/material/liquid/pigment
	var/use_stroke_color = TRUE

/obj/item/pen/crayon/Initialize()
	. = ..()
	if(use_stroke_color)
		color = stroke_color

/obj/item/pen/crayon/make_pen_description()
	desc = "A colourful [stroke_color_name] [istype(material)?"[material.name] ":null][medium_name]. Please refrain from eating it or putting it in your nose."

/obj/item/pen/crayon/set_medium_color(_color, _color_name, var/_shade_color)
	. = ..(_color, _color_name)
	shade_color = _shade_color
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_SHADE_COLOR, shade_color)

/obj/item/pen/crayon/afterattack(turf/target, mob/user, proximity)
	if(!proximity)
		return

	if(istype(target) && target.is_floor())
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		var/draw_message = "drawing"
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list(global.alphabet)
				draw_message = "drawing a letter"
			if("graffiti")
				draw_message = "drawing graffiti"
			if("rune")
				draw_message = "drawing a rune"
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				draw_message = "drawing an arrow"

		if(do_tool_interaction(TOOL_PEN, user, target, 5 SECONDS, draw_message, "drawing on", fuel_expenditure = 1))
			new /obj/effect/decal/cleanable/crayon(target, stroke_color, shade_color, drawtype)
			target.add_fingerprint(user) // Adds their fingerprints to the floor the crayon is drawn on.
	return

/obj/item/pen/crayon/red
	stroke_color      = "#da0000"
	shade_color       = "#810c0c"
	stroke_color_name = "red"
	pigment_type      = /decl/material/liquid/pigment/red

/obj/item/pen/crayon/orange
	stroke_color      = "#ff9300"
	stroke_color_name = "orange"
	shade_color       = "#a55403"
	pigment_type      = /decl/material/liquid/pigment/orange

/obj/item/pen/crayon/yellow
	stroke_color      = "#fff200"
	shade_color       = "#886422"
	stroke_color_name = "yellow"
	pigment_type      = /decl/material/liquid/pigment/yellow

/obj/item/pen/crayon/green
	stroke_color      = "#a8e61d"
	shade_color       = "#61840f"
	stroke_color_name = "green"
	pigment_type      = /decl/material/liquid/pigment/green

/obj/item/pen/crayon/blue
	stroke_color      = "#00b7ef"
	shade_color       = "#0082a8"
	stroke_color_name = "blue"
	pigment_type      = /decl/material/liquid/pigment/blue

/obj/item/pen/crayon/purple
	stroke_color      = "#da00ff"
	shade_color       = "#810cff"
	stroke_color_name = "purple"
	pigment_type      = /decl/material/liquid/pigment/purple

/obj/item/pen/crayon/mime
	icon              = 'icons/obj/items/crayon_mime.dmi'
	color             = null
	stroke_color      = "#ffffff"
	shade_color       = "#000000"
	stroke_color_name = "mime"
	max_uses          = -1 //Infinite
	pigment_type      = null
	use_stroke_color  = FALSE

/obj/item/pen/crayon/mime/make_pen_description()
	desc = "A very sad-looking crayon."

/obj/item/pen/crayon/mime/attack_self(mob/user) //inversion
	if(stroke_color != "#ffffff" && shade_color != "#000000")
		set_medium_color("#ffffff", stroke_color_name, "#000000")
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		set_medium_color("#000000", stroke_color_name, "#ffffff")
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon              = 'icons/obj/items/crayon_rainbow.dmi'
	color             = null
	stroke_color      = "#fff000"
	shade_color       = "#000fff"
	stroke_color_name = "rainbow"
	max_uses          = -1
	pigment_type      = null
	use_stroke_color  = FALSE

/obj/item/pen/crayon/rainbow/make_pen_description()
	desc = "A very colourful [istype(material)?"[material.name] ":null][medium_name]. Please refrain from eating it or putting it in your nose."

/obj/item/pen/crayon/rainbow/attack_self(mob/user)
	stroke_color = input(user, "Please select the main colour.",  "Crayon colour") as color
	shade_color  = input(user, "Please select the shade colour.", "Crayon colour") as color
	set_medium_color(stroke_color, stroke_color_name, shade_color)
