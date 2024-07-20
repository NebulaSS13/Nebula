/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures/window.dmi'
	density = TRUE
	w_class = ITEM_SIZE_NORMAL

	color = GLASS_COLOR
	layer = SIDE_WINDOW_LAYER
	anchored = TRUE
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CAN_BE_PAINTED
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_MOVES_UNSUPPORTED
	alpha = 180
	material = /decl/material/solid/glass
	rad_resistance_modifier = 0.5
	atmos_canpass = CANPASS_PROC
	handle_generic_blending = TRUE
	hitsound = 'sound/effects/Glasshit.ogg'
	max_health = 100

	var/damage_per_fire_tick = 2 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/const/CONSTRUCTION_STATE_NO_FRAME = 0
	var/const/CONSTRUCTION_STATE_IN_FRAME = 1
	var/const/CONSTRUCTION_STATE_FASTENED = 2
	var/construction_state = CONSTRUCTION_STATE_FASTENED
	var/id
	var/polarized = 0
	var/basestate = "window"
	var/reinf_basestate = "rwindow"
	var/list/connections
	var/list/other_connections

/obj/structure/window/clear_connections()
	connections = null
	other_connections = null

/obj/structure/window/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/window/update_materials(var/keep_health)
	. = ..()
	name = "[reinf_material ? "reinforced " : ""][material.solid_name] window"
	desc = "A window pane made from [material.solid_name]."

/obj/structure/window/Initialize(var/ml, var/_mat, var/_reinf_mat, var/dir_to_set, var/anchored)
	. = ..(ml, _mat, _reinf_mat)
	if(!istype(material))
		. = INITIALIZE_HINT_QDEL
	if(. != INITIALIZE_HINT_QDEL)
		if(!isnull(anchored))
			set_anchored(anchored)
		if(!isnull(dir_to_set))
			set_dir(dir_to_set)
		if(is_fulltile())
			layer = FULL_WINDOW_LAYER
		. = INITIALIZE_HINT_LATELOAD

// Updating connections may depend on material properties.
/obj/structure/window/LateInitialize()
	..()
	update_connections(1)
	update_icon()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Destroy()
	set_density(0)
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	if(istype(location) && location != loc)
		for(var/obj/structure/S in orange(location, 1))
			S.update_connections()
			S.update_icon()

/obj/structure/window/CanFluidPass(var/coming_from)
	return (!is_fulltile() && coming_from != dir)

/obj/structure/window/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	. = shatter()

/obj/structure/window/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	. = ..()
	if(. && damage_type == BRUTE)
		playsound(loc, "glasscrack", 100, 1)

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message(SPAN_DANGER("\The [src] shatters!"))

	var/debris_count = is_fulltile() ? 4 : 1
	var/list/shards = material.place_shards(loc, debris_count)
	if(paint_color)
		for(var/obj/item/thing in shards)
			thing.set_color(paint_color)

	if(reinf_material)
		reinf_material.create_object(loc, debris_count, /obj/item/stack/material/rods)
	qdel(src)

/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return
	..()
	take_damage(proj_damage, Proj.atom_damage_type)

/obj/structure/window/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity != 3 || prob(50)))
		physically_destroyed()

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(air_group && !anchored)
		return 1
	if(is_fulltile())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1

/obj/structure/window/CheckExit(atom/movable/O, target)
	if(istype(O) && O.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/window/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	if(.)
		visible_message(SPAN_DANGER("[src] was hit by [AM]."))
		var/tforce = AM.get_thrown_attack_force() * (TT.speed/THROWFORCE_SPEED_DIVISOR)
		if(reinf_material)
			tforce *= 0.25
		if(current_health - tforce <= 7 && !reinf_material)
			set_anchored(FALSE)
			step(src, get_dir(AM, src))
		take_damage(tforce)

/obj/structure/window/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (user.a_intent && user.a_intent == I_HURT)

		if (ishuman(user))
			var/mob/living/human/H = user
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		user.visible_message(SPAN_DANGER("\The [user] bangs against \the [src]!"),
							SPAN_DANGER("You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.visible_message("[user.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return TRUE

/obj/structure/window/do_simple_ranged_interaction(var/mob/user)
	visible_message(SPAN_NOTICE("Something knocks on \the [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
	return TRUE

/obj/structure/window/handle_default_screwdriver_attackby(mob/user, obj/item/screwdriver)
	var/tool_sound = screwdriver.get_tool_sound(TOOL_SCREWDRIVER) || 'sound/items/Screwdriver.ogg'
	if(reinf_material) // reinforced windows have construction states
		if(construction_state >= CONSTRUCTION_STATE_IN_FRAME) // if the window is in the frame
			playsound(loc, tool_sound, 75, 1)
			switch(construction_state)
				if(CONSTRUCTION_STATE_IN_FRAME)
					construction_state = CONSTRUCTION_STATE_FASTENED
					to_chat(user, SPAN_NOTICE("You have fastened the window to the frame."))
				if(CONSTRUCTION_STATE_FASTENED)
					construction_state = CONSTRUCTION_STATE_IN_FRAME
					to_chat(user, SPAN_NOTICE("You have unfastened the window from the frame."))
			update_nearby_icons()
			return TRUE
		else // if unanchored
			set_anchored(!anchored) // sets construction_state for us
			playsound(loc, tool_sound, 75, 1)
			to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the frame to the floor.") : SPAN_NOTICE("You have unfastened the frame from the floor.")))
			return TRUE
	else // basic windows can only be anchored or unanchored
		set_anchored(!anchored)
		playsound(loc, tool_sound, 75, 1)
		to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the window to the floor.") : SPAN_NOTICE("You have unfastened the window.")))
		return TRUE

/obj/structure/window/handle_default_crowbar_attackby(mob/user, obj/item/crowbar)
	if(!reinf_material || !anchored || construction_state > CONSTRUCTION_STATE_IN_FRAME)
		return FALSE // ineligible, allow other interactions to proceed
	switch(construction_state)
		if(CONSTRUCTION_STATE_NO_FRAME) // pry the window into the frame
			construction_state = CONSTRUCTION_STATE_IN_FRAME
			to_chat(user, SPAN_NOTICE("You have pried the window into the frame."))
		if(CONSTRUCTION_STATE_IN_FRAME)
			construction_state = CONSTRUCTION_STATE_NO_FRAME
			to_chat(user, SPAN_NOTICE("You have pried the window out of the frame."))
	playsound(loc, crowbar.get_tool_sound(TOOL_CROWBAR) || 'sound/items/Crowbar.ogg', 75, 1)
	return TRUE

/obj/structure/window/handle_default_wrench_attackby(mob/user, obj/item/wrench)
	if(anchored || (reinf_material && construction_state > CONSTRUCTION_STATE_NO_FRAME))
		return FALSE // ineligible, allow other interactions to proceed
	if(!material) // is this even necessary now? indestructible admin level window types maybe?
		to_chat(user, SPAN_NOTICE("You're not sure how to dismantle \the [src] properly."))
		return TRUE // prevent other interactions
	playsound(loc, wrench.get_tool_sound(TOOL_WRENCH) || 'sound/items/Ratchet.ogg', 75, 1)
	visible_message(SPAN_NOTICE("[user] dismantles \the [src]."))
	dismantle_structure(user)
	return TRUE

/obj/structure/window/handle_default_cable_attackby(mob/user, obj/item/stack/cable_coil/coil)
	if(!is_fulltile())
		return FALSE // ineligible, allow other interactions to proceed
	if(polarized)
		to_chat(user, SPAN_WARNING("\The [src] is already polarized."))
		return TRUE // prevent further interactions
	if(coil.use(1))
		playsound(loc, 'sound/effects/sparks1.ogg', 75, 1)
		polarized = TRUE
		to_chat(user, SPAN_NOTICE("You wire and polarize \the [src]."))
	else
		to_chat(user, SPAN_WARNING("You need at least one length of [coil.plural_name] to polarize \the [src]!"))
	return TRUE

/obj/structure/window/handle_default_wirecutter_attackby(mob/user, obj/item/wirecutters/wirecutters)
	if (!polarized)
		to_chat(user, SPAN_WARNING("\The [src] is not polarized."))
		return TRUE // prevent other interactions
	var/obj/item/stack/cable_coil/product = new /obj/item/stack/cable_coil(get_turf(user), 1)
	if(product.add_to_stacks(user, TRUE))
		user.put_in_hands(product)
	if (opacity)
		toggle() // must toggle off BEFORE unsetting the polarization var
	polarized = FALSE
	id = null
	playsound(loc, wirecutters.get_tool_sound(TOOL_WIRECUTTERS) || 'sound/items/Wirecutter.ogg', 75, 1)
	to_chat(user, SPAN_NOTICE("You cut the wiring and remove the polarization from \the [src]."))
	return TRUE

/obj/structure/window/attackby(obj/item/W, mob/user)
	// bespoke interactions not handled by the prior procs
	if(IS_MULTITOOL(W))
		if (!polarized)
			to_chat(user, SPAN_WARNING("\The [src] is not polarized."))
			return TRUE
		if (anchored)
			playsound(loc, 'sound/effects/pop.ogg', 75, 1)
			to_chat(user, SPAN_NOTICE("You toggle \the [src]'s tinting."))
			toggle()
		else
			var/response = input(user, "New Window ID:", name, id) as null | text
			if (isnull(response) || user.incapacitated() || !user.Adjacent(src) || user.get_active_held_item() != W)
				return TRUE
			id = sanitize_safe(response, MAX_NAME_LEN)
			to_chat(user, SPAN_NOTICE("The new ID of \the [src] is [id]."))
		return TRUE
	else if(istype(W, /obj/item/gun/energy/plasmacutter) && anchored)
		var/obj/item/gun/energy/plasmacutter/cutter = W
		if(!cutter.slice(user))
			return TRUE // failed to finish or otherwise failed, prevent further interactions
		playsound(src, 'sound/items/Welder.ogg', 80, 1)
		visible_message(SPAN_NOTICE("[user] has started slicing through the window's frame!"))
		if(do_after(user, 2 SECONDS, src))
			visible_message(SPAN_WARNING("[user] has sliced through the window's frame!"))
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			set_anchored(FALSE)
	if (istype(W, /obj/item/paint_sprayer))
		return FALSE // allow afterattack to run
	return ..() // handle generic interactions, bashing, etc

/obj/structure/window/bash(obj/item/weapon, mob/user)
	if(isliving(user) && user.a_intent == I_HELP)
		return FALSE
	if(!weapon.user_can_attack_with(user))
		return FALSE
	if(weapon.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	// physical damage types that can impart force; swinging a bat or energy sword
	if(weapon.atom_damage_type == BRUTE || weapon.atom_damage_type == BURN)
		user.do_attack_animation(src)
		hit(weapon.get_attack_force(user))
		if(current_health <= 7)
			set_anchored(FALSE)
			step(src, get_dir(user, src))
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return TRUE // bash successful

// TODO: generalize to matter list and parts_type.
/obj/structure/window/create_dismantled_products(turf/T)
	SHOULD_CALL_PARENT(FALSE)
	. = material.create_object(loc, 1)
	if(reinf_material)
		for(var/obj/item/stack/material/S in .)
			S.reinf_material = reinf_material
			S.update_strings()
			S.update_icon()
	if(paint_color)
		for(var/obj/item/thing in .)
			thing.set_color(paint_color)

/obj/structure/window/grab_attack(var/obj/item/grab/G)
	if (G.assailant.a_intent != I_HURT)
		return TRUE
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_DANGER("You need a better grip to do that!"))
		return TRUE
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(!istype(affecting_mob))
		attackby(G.affecting, G.assailant)
		return TRUE
	var/def_zone = ran_zone(BP_HEAD, 20, affecting_mob)
	if(G.damage_stage() < 2)
		G.affecting.visible_message(SPAN_DANGER("[G.assailant] bashes [G.affecting] against \the [src]!"))
		if(prob(50))
			SET_STATUS_MAX(affecting_mob, STAT_WEAK, 2)
		affecting_mob.apply_damage(10, BRUTE, def_zone, used_weapon = src)
		hit(25)
		qdel(G)
	else
		G.affecting.visible_message(SPAN_DANGER("[G.assailant] crushes [G.affecting] against \the [src]!"))
		SET_STATUS_MAX(affecting_mob, STAT_WEAK, 5)
		affecting_mob.apply_damage(20, BRUTE, def_zone, used_weapon = src)
		hit(50)
		qdel(G)
	return TRUE

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	// TODO: use reinf_material properties, paper reinforcement should be worse than plasteel reinforcement
	if(reinf_material) damage *= 0.5
	take_damage(damage)

/obj/structure/window/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if (anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/set_dir(ndir)
	. = ..()
	if(is_fulltile())
		atom_flags &= ~ATOM_FLAG_CHECKS_BORDER
	else
		atom_flags |= ATOM_FLAG_CHECKS_BORDER

/obj/structure/window/update_nearby_tiles(need_rebuild)
	. = ..()
	for(var/obj/structure/S in orange(loc, 1))
		if(S == src)
			continue
		S.update_connections()
		S.update_icon()

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/examine(mob/user)
	. = ..(user)
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("It is reinforced with the [reinf_material.solid_name] lattice."))
	if (reinf_material)
		switch (construction_state)
			if (CONSTRUCTION_STATE_NO_FRAME)
				to_chat(user, SPAN_WARNING("The window is not in the frame."))
			if (CONSTRUCTION_STATE_IN_FRAME)
				to_chat(user, SPAN_WARNING("The window is pried into the frame but not yet fastened."))
			if (CONSTRUCTION_STATE_FASTENED)
				to_chat(user, SPAN_NOTICE("The window is fastened to the frame."))
	if (anchored)
		to_chat(user, SPAN_NOTICE("It is fastened to \the [get_turf(src)]."))
	else
		to_chat(user, SPAN_WARNING("It is not fastened to anything."))
	if (polarized)
		to_chat(user, SPAN_NOTICE("It appears to be wired."))

/obj/structure/window/proc/set_anchored(var/new_anchored)
	if(anchored == new_anchored)
		return
	anchored = new_anchored
	update_connections(1)
	update_nearby_icons()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

// Visually connect with every type of window as long as it's full-tile.
/obj/structure/window/can_visually_connect()
	return ..() && is_fulltile()

/obj/structure/window/can_visually_connect_to(var/obj/structure/S)
	return istype(S, /obj/structure/window)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/on_update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	if(reinf_material)
		basestate = reinf_basestate
	else
		basestate = initial(basestate)

	..()

	color = get_color()
	layer = FULL_WINDOW_LAYER
	if(!is_fulltile())
		layer = SIDE_WINDOW_LAYER
		icon_state = basestate
		return

	var/image/I
	icon_state = ""
	if(is_on_frame())
		for(var/i = 1 to 4)
			var/conn = connections ? connections[i] : "0"
			if(other_connections && other_connections[i] != "0")
				I = image(icon, "[basestate]_other_onframe[conn]", dir = BITFLAG(i-1))
			else
				I = image(icon, "[basestate]_onframe[conn]", dir = BITFLAG(i-1))
			I.color = paint_color
			add_overlay(I)
	else
		for(var/i = 1 to 4)
			var/conn = connections ? connections[i] : "0"
			if(other_connections && other_connections[i] != "0")
				I = image(icon, "[basestate]_other[conn]", dir = BITFLAG(i-1))
			else
				I = image(icon, "[basestate][conn]", dir = BITFLAG(i-1))
			I.color = paint_color
			add_overlay(I)

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/damage_point = material.temperature_damage_threshold
	if(reinf_material)
		damage_point += 0.25*reinf_material.temperature_damage_threshold
	if(exposed_temperature > damage_point)
		hit(damage_per_fire_tick, 0)
	..()

/obj/structure/window/basic
	icon_state = "window"
	color = GLASS_COLOR

/obj/structure/window/basic/full
	dir = NORTHEAST
	icon_state = "window_full"

/obj/structure/window/basic/full/polarized
	polarized = TRUE

/obj/structure/window/borosilicate
	name = "borosilicate window"
	color = GLASS_COLOR_SILICATE
	material = /decl/material/solid/glass/borosilicate

/obj/structure/window/borosilicate/full
	dir = NORTHEAST
	icon_state = "window_full"

/obj/structure/window/borosilicate_reinforced
	name = "reinforced borosilicate window"
	icon_state = "rwindow"
	color = GLASS_COLOR_SILICATE
	material = /decl/material/solid/glass/borosilicate
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/window/borosilicate_reinforced/full
	dir = NORTHEAST
	icon_state = "window_full"

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	material = /decl/material/solid/glass
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/window/reinforced/full
	dir = NORTHEAST
	icon_state = "rwindow_full"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	opacity = TRUE
	color = GLASS_COLOR_TINTED

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	color = GLASS_COLOR_FROSTED

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/structures/podwindows.dmi'
	basestate = "w"
	reinf_basestate = "w"
	dir = NORTHEAST

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	basestate = "rwindow"
	polarized = TRUE

/obj/structure/window/reinforced/polarized/full
	dir = NORTHEAST
	icon_state = "rwindow_full"

/obj/structure/window/proc/toggle()
	if(!polarized)
		return
	if(opacity)
		animate(src, color=get_color(), time=5)
		set_opacity(FALSE)
	else
		animate(src, color=GLASS_COLOR_TINTED, time=5)
		set_opacity(TRUE)

/obj/structure/window/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for electrochromic windows."
	var/range = 7
	stock_part_presets = null // This isn't a radio-enabled button; it communicates with nearby structures in view.
	frame_type = /obj/item/frame/button/light_switch/windowtint
	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	base_type = /obj/machinery/button/windowtint

/obj/machinery/button/windowtint/attackby(obj/item/W, mob/user)
	if(IS_MULTITOOL(W))
		var/t = sanitize_safe(input(user, "Enter the ID for the button.", name, id_tag), MAX_NAME_LEN)
		if(!CanPhysicallyInteract(user))
			return TRUE
		t = sanitize_safe(t, MAX_NAME_LEN)
		if (t)
			id_tag = t
			to_chat(user, SPAN_NOTICE("The new ID of the button is '[id_tag]'."))
		return TRUE
	return ..()

/obj/machinery/button/windowtint/activate()
	if(operating)
		return
	for(var/obj/structure/window/W in range(src,range))
		if(W.polarized && (W.id == id_tag || !W.id))
			W.toggle()
	..()

/obj/machinery/button/windowtint/power_change()
	. = ..()
	if(active && (stat & NOPOWER))
		activate()

/obj/machinery/button/windowtint/on_update_icon()
	icon_state = "light[active]"

//Centcomm windows
/obj/structure/window/reinforced/crescent/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/structure/window/reinforced/crescent/hitby()
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/obj/structure/window/reinforced/crescent/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	return

/obj/structure/window/reinforced/crescent/shatter()
	return

/proc/place_window(mob/user, loc, dir_to_set, obj/item/stack/material/ST)
	var/required_amount = (dir_to_set & (dir_to_set - 1)) ? 4 : 1
	if (!ST.can_use(required_amount))
		to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == dir_to_set)
			to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
			return
		if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1))) //two fulltile windows
			to_chat(user, SPAN_NOTICE("There is already a window there."))
			return
	to_chat(user, SPAN_NOTICE("You start placing the window."))
	if(do_after(user,20))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
				to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
				return
			if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1)))
				to_chat(user, SPAN_NOTICE("There is already a window there."))
				return

		if (ST.use(required_amount))
			var/obj/structure/window/WD = new(loc, ST.material.type, ST.reinf_material?.type, dir_to_set, FALSE)
			to_chat(user, SPAN_NOTICE("You place [WD]."))
			WD.set_anchored(FALSE) // handles setting construction state for us
		else
			to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
			return
