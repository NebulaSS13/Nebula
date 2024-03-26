/obj/item/pill_bottle/foil_pack
	name = "foil pack"
	desc = "A package of pills."
	icon = 'icons/obj/pill_pack.dmi'
	icon_state = "pill_pack"
	pop_sound = 'sound/effects/pop.ogg'
	color = COLOR_GRAY80
	storage = /datum/storage/pillbottle/foil
	var/pill_type
	var/pill_count = 4
	var/pill_positions

/obj/item/pill_bottle/foil_pack/painkillers
	pill_type = /obj/item/chems/pill/painkillers

/obj/item/pill_bottle/foil_pack/Initialize()
	. = ..()
	if(pill_type && pill_count)
		for(var/i = 1 to pill_count)
			var/pill = new pill_type(src)
			LAZYSET(pill_positions, pill, i)
	if(length(pill_positions))
		var/obj/item/chems/pill = pill_positions[1]
		SetName("[initial(name)] ([pill.name])")
	update_icon()

/obj/item/pill_bottle/foil_pack/pop_pill(var/mob/user)
	. = ..()
	update_icon()

/obj/item/pill_bottle/foil_pack/Destroy()
	pill_positions = null
	. = ..()

/obj/item/pill_bottle/foil_pack/on_update_icon()
	..()
	var/offset = 0
	for(var/obj/item/chems/pill/pill in pill_positions)
		var/image/I = image(icon, "pill")
		I.color = pill.color
		I.appearance_flags |= RESET_COLOR
		I.pixel_y = offset
		add_overlay(I)
		I = image(icon, "pill")
		I.color = COLOR_LIGHT_CYAN
		I.alpha = 80
		I.appearance_flags |= RESET_COLOR
		I.pixel_y = offset
		add_overlay(I)
		offset -= 3

/obj/item/pill_bottle/foil_pack/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has the following pills in it:"))
	for(var/obj/item/chems/pill/C in pill_positions)
		to_chat(user, SPAN_NOTICE("[html_icon(C)] [C.name]"))
