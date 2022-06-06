/obj/item/pen
	desc                   = "It's a normal black ink pen."
	name                   = "pen"
	icon                   = 'icons/obj/items/pens/pen.dmi'
	icon_state             = ICON_STATE_WORLD
	slot_flags             = SLOT_LOWER_BODY | SLOT_EARS
	w_class                = ITEM_SIZE_TINY
	throwforce             = 0
	throw_speed            = 7
	throw_range            = 15
	material               = /decl/material/solid/plastic
	var/pen_flag           = PEN_FLAG_ACTIVE                     //Properties of the pen used
	var/stroke_colour      = "black"                             //what colour the ink is! Can be hex or string.
	var/stroke_colour_name = "black"                             //Human readable name of the ink color.
	var/medium_name        = "ink"                               //Whatever the pen uses to leave its mark
	var/max_uses           = -1                                  //-1 for unlimited uses

/obj/item/pen/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool,
		list(
				TOOL_DRILL = TOOL_QUALITY_WORST,
				TOOL_PEN   = TOOL_QUALITY_DECENT,),
		list(
				TOOL_PEN   = list(
					TOOL_PROP_COLOR_NAME = stroke_colour_name, 
					TOOL_PROP_COLOR      = stroke_colour, 
					TOOL_PROP_PEN_FLAG   = pen_flag,
					TOOL_PROP_USES       = max_uses,)))

/obj/item/pen/attack(atom/A, mob/user, target_zone)
	if(ismob(A))
		var/mob/M = A
		if(ishuman(A) && user.a_intent == I_HELP && target_zone == BP_HEAD)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD, /obj/item/organ/external/head)
			if(istype(head))
				head.write_on(user, "[stroke_colour_name] [medium_name]")
		else
			to_chat(user, SPAN_WARNING("You stab [M] with \the [src]."))
			admin_attack_log(user, M, "Stabbed using \a [src]", "Was stabbed with \a [src]", "used \a [src] to stab")

	else if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, "[stroke_colour_name] [medium_name]")

/obj/item/pen/proc/toggle()
	if(pen_flag & PEN_FLAG_ACTIVE)
		pen_flag &= ~PEN_FLAG_ACTIVE
	else
		pen_flag |= PEN_FLAG_ACTIVE
	playsound(src, 'sound/items/penclick.ogg', 5, 0, -4)
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_FLAG, pen_flag)
	update_icon()

/obj/item/pen/proc/set_ink_color(var/_color, var/_color_name)
	stroke_colour      = _color
	stroke_colour_name = _color_name
	set_tool_property(TOOL_PEN, TOOL_PROP_COLOR,      stroke_colour)
	set_tool_property(TOOL_PEN, TOOL_PROP_COLOR_NAME, stroke_colour_name)

/obj/item/pen/blue
	name               = "blue pen"
	desc               = "It's a normal blue ink pen."
	icon               = 'icons/obj/items/pens/pen_blue.dmi'
	stroke_colour      = "blue"
	stroke_colour_name = "blue"

/obj/item/pen/red
	name               = "red pen"
	desc               = "It's a normal red ink pen."
	icon               = 'icons/obj/items/pens/pen_red.dmi'
	stroke_colour      = "red"
	stroke_colour_name = "red"

/obj/item/pen/green
	name               = "green pen"
	desc               = "It's a normal green ink pen."
	icon               = 'icons/obj/items/pens/pen_green.dmi'
	stroke_colour      = "green"
	stroke_colour_name = "green"

/obj/item/pen/invisible
	desc               = "It's an invisble pen marker."
	stroke_colour      = "white"
	stroke_colour_name = "transluscent"
