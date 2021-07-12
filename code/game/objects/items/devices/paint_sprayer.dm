#define AIRLOCK_REGION_PAINT    "Paint"
#define AIRLOCK_REGION_STRIPE   "Stripe"
#define AIRLOCK_REGION_WINDOW   "Window"

/obj/item/paint_sprayer
	name = "paint sprayer"
	icon = 'icons/obj/items/device/paint_sprayer.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A slender and none-too-sophisticated device capable of applying paint on floors, walls, exosuits and certain airlocks."

	var/decal =        "Quarter-turf"
	var/paint_dir =    "Precise"
	var/paint_color = COLOR_GRAY15
	var/color_picker = FALSE

	var/list/decals = list(
		"Quarter-turf" =      list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "colored" = 1),
		"Monotile full" =     list("path" = /obj/effect/floor_decal/corner/white/mono, "colored" = 1),
		"Monotile halved" =   list("path" = /obj/effect/floor_decal/corner/white/half, "colored" = 1),
		"Hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warning),
		"Corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		"Hatched marking" =   list("path" = /obj/effect/floor_decal/industrial/hatch, "colored" = 1),
		"Dashed outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "colored" = 1),
		"Loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
		"Mosaic, large" =     list("path" = /obj/effect/floor_decal/chapel),
		"1" =                 list("path" = /obj/effect/floor_decal/sign),
		"2" =                 list("path" = /obj/effect/floor_decal/sign/two),
		"A" =                 list("path" = /obj/effect/floor_decal/sign/a),
		"B" =                 list("path" = /obj/effect/floor_decal/sign/b),
		"C" =                 list("path" = /obj/effect/floor_decal/sign/c),
		"D" =                 list("path" = /obj/effect/floor_decal/sign/d),
		"M" =                 list("path" = /obj/effect/floor_decal/sign/m),
		"V" =                 list("path" = /obj/effect/floor_decal/sign/v),
		"CMO" =               list("path" = /obj/effect/floor_decal/sign/cmo),
		"Ex" =                list("path" = /obj/effect/floor_decal/sign/ex),
		"Psy" =               list("path" = /obj/effect/floor_decal/sign/p),
		"Remove all decals" = list("path" = /obj/effect/floor_decal/reset),
		"Remove top decal" =  list("path" = /obj/effect/floor_decal/undo)
		)

	var/list/paint_dirs = list(
		"North" =       NORTH,
		"Northwest" =   NORTHWEST,
		"West" =        WEST,
		"Southwest" =   SOUTHWEST,
		"South" =       SOUTH,
		"Southeast" =   SOUTHEAST,
		"East" =        EAST,
		"Northeast" =   NORTHEAST,
		"Precise" = 0
		)

	var/list/preset_colors = list(
		"Beasty brown" =   COLOR_BEASTY_BROWN,
		"Blue" =           COLOR_BLUE_GRAY,
		"Civvie green" =   COLOR_CIVIE_GREEN,
		"Command blue" =   COLOR_COMMAND_BLUE,
		"Cyan" =           COLOR_CYAN,
		"Green" =          COLOR_GREEN,
		"Bottle green" =   COLOR_PALE_BTL_GREEN,
		"Nanotrasen red" = COLOR_NT_RED,
		"Orange" =         COLOR_ORANGE,
		"Pale orange" =    COLOR_PALE_ORANGE,
		"Red" =            COLOR_RED,
		"Sky blue" =       COLOR_DEEP_SKY_BLUE,
		"Titanium" =       COLOR_TITANIUM,
		"Aluminium"=       COLOR_ALUMINIUM,
		"Violet" =         COLOR_VIOLET,
		"White" =          COLOR_WHITE,
		"Yellow" =         COLOR_AMBER,
		"Hull blue" =      COLOR_HULL,
		"Bulkhead black" = COLOR_WALL_GUNMETAL
		)


/obj/item/paint_sprayer/Initialize()
	. = ..()
	var/random_preset = pick(preset_colors)
	change_color(preset_colors[random_preset])


/obj/item/paint_sprayer/on_update_icon()
	cut_overlays()
	add_overlay(overlay_image(icon, "[icon_state]_color", paint_color))
	add_overlay(color_picker ? "[icon_state]_red" : "[icon_state]_blue")
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/paint_sprayer/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(ret)
		var/bodytype = lowertext(user_mob?.get_bodytype_category())
		var/image/overlay = overlay_image(ret.icon, "[bodytype]-slot_[slot]_color", paint_color)
		ret.add_overlay(overlay)
	return ret

/obj/item/paint_sprayer/afterattack(var/atom/A, var/mob/user, var/proximity, var/params)
	if (!proximity)
		return

	add_fingerprint(user)

	if (color_picker)
		var/new_color
		if (istype(A, /turf/simulated/floor))
			new_color = pick_color_from_floor(A, user)
		else if (istype(A, /obj/machinery/door/airlock))
			new_color = pick_color_from_airlock(A, user)
		else
			new_color = A.get_color()
		change_color(new_color, user)

	else if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		A.set_color(paint_color)
		. = TRUE

	else if (istype(A, /turf/simulated/floor))
		. = paint_floor(A, user, params)

	else if (istype(A, /obj/machinery/door/airlock))
		. = paint_airlock(A, user)

	else if (istype(A, /mob/living/exosuit))
		to_chat(user, SPAN_WARNING("You can't paint an active exosuit. Dismantle it first."))
		. = FALSE

	else
		to_chat(user, SPAN_WARNING("\The [src] can only be used on floors, windows, walls, exosuits or certain airlocks."))
		. = FALSE

	if (.)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .


/obj/item/paint_sprayer/proc/paint_floor(var/turf/simulated/floor/F, var/mob/user, var/params)
	if(!F.flooring)
		to_chat(user, SPAN_WARNING("You need flooring to paint on."))
		return FALSE

	if(!F.flooring.can_paint || F.broken || F.burnt)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint \the [F.name]."))
		return FALSE

	var/list/decal_data = decals[decal]
	var/config_error
	if(!islist(decal_data))
		config_error = 1
	var/painting_decal
	if(!config_error)
		painting_decal = decal_data["path"]
		if(!ispath(painting_decal))
			config_error = 1

	if(config_error)
		to_chat(user, SPAN_WARNING("\The [src] flashes an error light. You might need to reconfigure it."))
		return FALSE

	if(F.decals && F.decals.len > 5 && painting_decal != /obj/effect/floor_decal/reset)
		to_chat(user, SPAN_WARNING("\The [F] has been painted too much; you need to clear it off."))
		return FALSE

	var/painting_dir = 0
	if(paint_dir == "Precise")
		if(!decal_data["precise"])
			painting_dir = user.dir
		else
			var/list/mouse_control = params2list(params)
			var/mouse_x = text2num(mouse_control["icon-x"])
			var/mouse_y = text2num(mouse_control["icon-y"])
			if(isnum(mouse_x) && isnum(mouse_y))
				if(mouse_x <= 16)
					if(mouse_y <= 16)
						painting_dir = WEST
					else
						painting_dir = NORTH
				else
					if(mouse_y <= 16)
						painting_dir = SOUTH
					else
						painting_dir = EAST
			else
				painting_dir = user.dir
	else if(paint_dirs[paint_dir])
		painting_dir = paint_dirs[paint_dir]

	var/painting_color
	if(decal_data["colored"] && paint_color)
		painting_color = paint_color

	new painting_decal(F, painting_dir, painting_color)
	return TRUE


/obj/item/paint_sprayer/proc/pick_color_from_floor(var/turf/simulated/floor/F, var/mob/user)
	if (!F.decals || !F.decals.len)
		return FALSE
	var/list/available_colors = list()
	for (var/image/I in F.decals)
		available_colors |= I.color
	var/picked_color = available_colors[1]
	if (available_colors.len > 1)
		picked_color = input(user, "Which color do you wish to select?") as null|anything in available_colors
		if (user.incapacitated() || !user.Adjacent(F))
			return FALSE
	return picked_color


/obj/item/paint_sprayer/proc/paint_airlock(var/obj/machinery/door/airlock/D, var/mob/user)
	if (!D.paintable)
		to_chat(user, SPAN_WARNING("You can't paint this airlock type."))
		return FALSE

	switch (select_airlock_region(D, user, "What do you wish to paint?"))
		if (AIRLOCK_REGION_PAINT)
			D.paint_airlock(paint_color)
		if (AIRLOCK_REGION_STRIPE)
			D.stripe_airlock(paint_color)
		if (AIRLOCK_REGION_WINDOW)
			D.paint_window(paint_color)
		else
			return FALSE
	return TRUE


/obj/item/paint_sprayer/proc/pick_color_from_airlock(var/obj/machinery/door/airlock/D, var/mob/user)
	if (!D.paintable)
		return FALSE

	switch (select_airlock_region(D, user, "Where do you wish to select the color from?"))
		if (AIRLOCK_REGION_PAINT)
			return D.door_color
		if (AIRLOCK_REGION_STRIPE)
			return D.stripe_color
		if (AIRLOCK_REGION_WINDOW)
			return D.window_color
		else
			return FALSE


/obj/item/paint_sprayer/proc/select_airlock_region(var/obj/machinery/door/airlock/D, var/mob/user, var/input_text)
	var/choice
	var/list/choices = list()
	if (D.paintable & AIRLOCK_PAINTABLE)
		choices |= AIRLOCK_REGION_PAINT
	if (D.paintable & AIRLOCK_STRIPABLE)
		choices |= AIRLOCK_REGION_STRIPE
	if (D.paintable & AIRLOCK_WINDOW_PAINTABLE)
		choices |= AIRLOCK_REGION_WINDOW
	choice = input(user, input_text) as null|anything in sortTim(choices, /proc/cmp_text_asc)
	if (user.incapacitated() || !D || !user.Adjacent(D))
		return FALSE
	return choice


/obj/item/paint_sprayer/attack_self(var/mob/user)
	switch(input("What do you wish to change?") as null|anything in list("Decal","Direction", "Color", "Preset Color", "Mode"))
		if("Decal")
			choose_decal()
		if("Direction")
			choose_direction()
		if("Color")
			choose_color()
		if("Preset Color")
			choose_preset_color()
		if("Mode")
			toggle_mode()


/obj/item/paint_sprayer/proc/change_color(var/new_color, var/mob/user)
	if (new_color && new_color != paint_color)
		paint_color = new_color
		if (user)
			to_chat(user, SPAN_NOTICE("You set \the [src] to paint with <span style='color:[paint_color]'>a new color</span>."))
		update_icon()


/obj/item/paint_sprayer/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to produce the '[decal]' decal with a direction of '[paint_dir]' using [paint_color] paint.")


/obj/item/paint_sprayer/AltClick()
	if (!isturf(loc))
		choose_preset_color()
	else
		. = ..()


/obj/item/paint_sprayer/CtrlClick()
	if (!isturf(loc))
		toggle_mode()
	else
		. = ..()


/obj/item/paint_sprayer/verb/choose_color()
	set name = "Choose color"
	set desc = "Choose a color."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_color = input(usr, "Choose a color.", name, paint_color) as color|null
	if (usr.incapacitated())
		return
	change_color(new_color, usr)

/obj/item/paint_sprayer/verb/choose_preset_color()
	set name = "Choose Preset color"
	set desc = "Choose a preset color."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/preset = input(usr, "Choose a color.", name, paint_color) as null|anything in preset_colors
	if(usr.incapacitated())
		return
	change_color(preset_colors[preset], usr)

/obj/item/paint_sprayer/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a flooring decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_decal = input("Select a decal.") as null|anything in decals
	if(usr.incapacitated())
		return
	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		to_chat(usr, SPAN_NOTICE("You set \the [src] decal to '[decal]'."))

/obj/item/paint_sprayer/verb/choose_direction()
	set name = "Choose Direction"
	set desc = "Choose a decal direction."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_dir = input("Select a direction.") as null|anything in paint_dirs
	if(usr.incapacitated())
		return
	if(new_dir && !isnull(paint_dirs[new_dir]))
		paint_dir = new_dir
		to_chat(usr, SPAN_NOTICE("You set \the [src] direction to '[paint_dir]'."))

/obj/item/paint_sprayer/verb/toggle_mode()
	set name = "Toggle Painter Mode"
	set desc = "Toggle to switch between color picking and paint spraying."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	color_picker = !color_picker
	if(color_picker)
		to_chat(usr, SPAN_NOTICE("You set \the [src] to color picking mode, scanning colors off objects."))
	else
		to_chat(usr, SPAN_NOTICE("You set \the [src] to painting mode."))
	playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)
	update_icon()

#undef AIRLOCK_REGION_PAINT
#undef AIRLOCK_REGION_STRIPE
#undef AIRLOCK_REGION_WINDOW
