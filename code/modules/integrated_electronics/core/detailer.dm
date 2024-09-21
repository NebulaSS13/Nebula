#define SCAN_COLOR "SCAN"

/obj/item/integrated_electronics/detailer
	name = "assembly detailer"
	desc = "A combination autopainter and flash anodizer designed to give electronic assemblies a colorful, wear-resistant finish."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "detailer"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	var/scanning_color = FALSE
	var/detail_color = COLOR_ASSEMBLY_WHITE
	var/list/color_list = list(
		"black" = COLOR_ASSEMBLY_BLACK,
		"gray" = COLOR_GRAY40,
		"machine gray" = COLOR_ASSEMBLY_BGRAY,
		"white" = COLOR_ASSEMBLY_WHITE,
		"red" = COLOR_ASSEMBLY_RED,
		"orange" = COLOR_ASSEMBLY_ORANGE,
		"beige" = COLOR_ASSEMBLY_BEIGE,
		"brown" = COLOR_ASSEMBLY_BROWN,
		"gold" = COLOR_ASSEMBLY_GOLD,
		"yellow" = COLOR_ASSEMBLY_YELLOW,
		"gurkha" = COLOR_ASSEMBLY_GURKHA,
		"light green" = COLOR_ASSEMBLY_LGREEN,
		"green" = COLOR_ASSEMBLY_GREEN,
		"light blue" = COLOR_ASSEMBLY_LBLUE,
		"blue" = COLOR_ASSEMBLY_BLUE,
		"purple" = COLOR_ASSEMBLY_PURPLE,
		"\[SCAN FROM ASSEMBLY\]" = SCAN_COLOR
		)

/obj/item/integrated_electronics/detailer/Initialize()
	.=..()
	update_icon()

/obj/item/integrated_electronics/detailer/on_update_icon()
	. = ..()
	add_overlay(overlay_image('icons/obj/assemblies/electronic_tools.dmi', "detailer-color", detail_color))

/obj/item/integrated_electronics/detailer/attack_self(mob/user)
	var/color_choice = input(user, "Select color.", "Assembly Detailer") as null|anything in color_list
	if(!color_list[color_choice])
		return
	if(!in_range(src, user))
		return
	if(color_choice == SCAN_COLOR)
		scanning_color = TRUE
		detail_color = initial(detail_color)
		return
	scanning_color = FALSE
	detail_color = color_list[color_choice]
	update_icon()

/obj/item/integrated_electronics/detailer/afterattack(atom/target, mob/living/user, proximity)
	. = ..()
	if(!scanning_color || !proximity)
		return .
	visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
	to_chat(user, "<span class='notice'>You set \the [src]'s detailing color to match [target.name] \[Ref\]. The color matcher is \
	now off.</span>")
	scanning_color = FALSE
	if(isitem(target))
		var/obj/item/I = target
		detail_color = I.get_assembly_detail_color()

/obj/item/integrated_electronics/detailer/get_assembly_detail_color()
	return detail_color
