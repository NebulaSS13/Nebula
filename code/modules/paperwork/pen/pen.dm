/obj/item/pen
	name                   = "pen"
	desc                   = ""
	icon                   = 'icons/obj/items/pens/pen.dmi'
	icon_state             = ICON_STATE_WORLD
	slot_flags             = SLOT_LOWER_BODY | SLOT_EARS
	w_class                = ITEM_SIZE_TINY
	throw_speed            = 7
	throw_range            = 15
	material               = /decl/material/solid/organic/plastic
	var/pen_flag           = PEN_FLAG_ACTIVE                     //Properties/state of the pen used.
	var/stroke_color      = "black"                             //What colour the ink is! Can be hexadecimal colour or a colour name string.
	var/stroke_color_name = "black"                             //Human readable name of the stroke colour. Used in text strings, and to identify the nearest colour to the stroke colour.
	var/medium_name        = "ink"                               //Whatever the pen uses to leave its mark. Used in text strings.
	var/max_uses           = -1                                  //-1 for unlimited uses.
	var/pen_quality        = TOOL_QUALITY_DEFAULT                //What will be set as tool quality for the pen
	///The type of font this pen's written text will be represented with
	var/pen_font           = PEN_FONT_DEFAULT

/obj/item/pen/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool,
		list(
			TOOL_SURGICAL_DRILL = TOOL_QUALITY_WORST,
			TOOL_PEN   = pen_quality),

		list(
			TOOL_PEN   = list(
				TOOL_PROP_COLOR_NAME = stroke_color_name,
				TOOL_PROP_COLOR      = stroke_color,
				TOOL_PROP_PEN_FLAG   = pen_flag,
				TOOL_PROP_USES       = max_uses,
				TOOL_PROP_PEN_FONT   = pen_font)))
	make_pen_description()

/obj/item/pen/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(user.a_intent == I_HELP && user.get_target_zone() == BP_HEAD)
		var/obj/item/organ/external/head/head = target.get_organ(BP_HEAD, /obj/item/organ/external/head)
		if(istype(head))
			head.write_on(user, "[stroke_color_name] [medium_name]")
			return TRUE

	if(istype(target, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = target
		head.write_on(user, "[stroke_color_name] [medium_name]")
		return TRUE

	return ..()

/obj/item/pen/proc/toggle()
	if(pen_flag & PEN_FLAG_ACTIVE)
		pen_flag &= ~PEN_FLAG_ACTIVE
	else
		pen_flag |= PEN_FLAG_ACTIVE
	playsound(src, 'sound/items/penclick.ogg', 5, 0, -4)
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_FLAG, pen_flag)
	update_icon()

/obj/item/pen/proc/set_medium_color(var/_color, var/_color_name)
	stroke_color      = _color
	stroke_color_name = _color_name
	set_tool_property(TOOL_PEN, TOOL_PROP_COLOR,      stroke_color)
	set_tool_property(TOOL_PEN, TOOL_PROP_COLOR_NAME, stroke_color_name)
	make_pen_description()

/obj/item/pen/proc/make_pen_description()
	desc = "Its [ADD_ARTICLE(stroke_color_name)] [medium_name] [istype(material)? material.name : ""] pen."

/obj/item/pen/blue
	name              = "blue pen"
	icon              = 'icons/obj/items/pens/pen_blue.dmi'
	stroke_color      = "blue"
	stroke_color_name = "blue"

/obj/item/pen/red
	name              = "red pen"
	icon              = 'icons/obj/items/pens/pen_red.dmi'
	stroke_color      = "red"
	stroke_color_name = "red"

/obj/item/pen/green
	name              = "green pen"
	icon              = 'icons/obj/items/pens/pen_green.dmi'
	stroke_color      = "green"
	stroke_color_name = "green"

/obj/item/pen/invisible
	name              = "pen"
	stroke_color      = "white"
	stroke_color_name = "transluscent"
