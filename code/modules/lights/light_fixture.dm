// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_map"
	desc = "A lighting fixture."
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	layer = ABOVE_HUMAN_LAYER  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc
	)
	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	base_type = /obj/machinery/light
	frame_type = /obj/item/frame/light
	directional_offset = @'{"NORTH":{"y":21}, "EAST":{"x":10}, "WEST":{"x":-10}}'

	var/on = 0					// 1 if on, 0 if off
	var/flickering = 0
	var/light_type = /obj/item/light/tube		// the type of light item
	var/accepts_light_type = /obj/item/light/tube
	/// A debounce var to prevent lights from causing infinite loops due to machinery power updates.
	var/currently_updating = FALSE

	var/obj/item/light/lightbulb

	var/current_mode = null

/obj/machinery/light/get_color()
	return lightbulb?.get_color()

/obj/machinery/light/set_color(color)
	. = lightbulb?.set_color(color)
	if(.)
		update_light_status(TRUE)
		update_icon()

// the smaller bulb light fixture
/obj/machinery/light/small
	icon_state = "bulb_map"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	accepts_light_type = /obj/item/light/bulb
	base_type = /obj/machinery/light/small
	frame_type = /obj/item/frame/light/small

/obj/machinery/light/small/emergency
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/small/red
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	desc = "A more robust socket for light tubes that demand more power."
	light_type = /obj/item/light/tube/large
	accepts_light_type = /obj/item/light/tube/large
	base_type = /obj/machinery/light/spot
	frame_type = /obj/item/frame/light/spot

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()

	switch (dir)
		if (NORTH)
			light_offset_y = WORLD_ICON_SIZE * 0.5
		if (SOUTH)
			light_offset_y = WORLD_ICON_SIZE * -0.5
		if (EAST)
			light_offset_x = WORLD_ICON_SIZE * 0.5
		if (WEST)
			light_offset_x = WORLD_ICON_SIZE * -0.5

	if(populate_parts && ispath(light_type))
		lightbulb = new light_type(src)
		if(prob(lightbulb.broken_chance))
			broken(1)

	on = expected_to_be_on()
	update_light_status(FALSE)
	update_icon()

/obj/machinery/light/Destroy()
	QDEL_NULL(lightbulb)
	. = ..()

/// Handles light updates that were formerly done in update_icon.
/// * trigger (BOOL): if TRUE, this can trigger effects like burning out, rigged light explosions, etc.
/obj/machinery/light/proc/update_light_status(trigger = TRUE)
	if(currently_updating) // avoid infinite loops during power usage updates
		return
	currently_updating = TRUE
	if(get_status() == LIGHT_OK) // we can't reuse this value later because update_use_power might change our status
		atom_flags |= ATOM_FLAG_CAN_BE_PAINTED
	else
		atom_flags &= ~ATOM_FLAG_CAN_BE_PAINTED
		on = FALSE
	if(on)
		update_use_power(POWER_USE_ACTIVE)
		if(current_mode && (current_mode in lightbulb.lighting_modes))
			set_light(arglist(lightbulb.lighting_modes[current_mode]))
		else
			set_light(lightbulb.b_range, lightbulb.b_power, lightbulb.b_color)
		if(trigger && get_status() == LIGHT_OK)
			switch_check()
	else
		update_use_power(POWER_USE_OFF)
		set_light(0)
	change_power_consumption((light_range * light_power) * LIGHTING_POWER_FACTOR, POWER_USE_ACTIVE)
	currently_updating = FALSE

/obj/machinery/light/update_use_power(new_use_power)
	. = ..()
	update_light_status(TRUE)

/obj/machinery/light/on_update_icon()
	// Update icon state
	cut_overlays()
	if(istype(construct_state))
		switch(construct_state.type) //Never use the initial state. That'll just reset it to the mapping icon.
			if(/decl/machine_construction/wall_frame/no_wires/simple)
				icon_state = "[base_state]-construct-stage1"
				return
			if(/decl/machine_construction/wall_frame/panel_open/simple)
				icon_state = "[base_state]-construct-stage2"
				return

	icon_state = "[base_state]_empty"

	// Extra overlays if we're active
	var/_state
	switch(get_status())		// set icon_states
		if(LIGHT_OK)
			_state = "[base_state][on]"
		if(LIGHT_BURNED)
			_state = "[base_state]_burned"
		if(LIGHT_BROKEN)
			_state = "[base_state]_broken"

	if(istype(lightbulb, /obj/item/light))
		var/image/overlay_image = image(icon, _state)
		overlay_image.color = get_mode_color()
		add_overlay(overlay_image)

	if(on)
		compile_overlays() // force a compile so that we update prior to the light being set

/obj/machinery/light/proc/get_status()
	if(!lightbulb)
		return LIGHT_EMPTY
	else
		return lightbulb.status

/obj/machinery/light/proc/switch_check()
	lightbulb.switch_on()
	if(get_status() != LIGHT_OK)
		set_light(0)

/obj/machinery/light/proc/set_mode(var/new_mode)
	if(current_mode != new_mode)
		current_mode = new_mode
		update_light_status(FALSE)
		update_icon()

/obj/machinery/light/proc/get_mode_color()
	if (current_mode && (current_mode in lightbulb.lighting_modes))
		return lightbulb.lighting_modes[current_mode]["l_color"]
	else
		return lightbulb.b_color

/obj/machinery/light/proc/set_emergency_lighting(var/enable)
	if(!lightbulb)
		return

	if(enable)
		if(LIGHTMODE_EMERGENCY in lightbulb.lighting_modes)
			set_mode(LIGHTMODE_EMERGENCY)
			update_power_channel(ENVIRON)
	else
		if(current_mode == LIGHTMODE_EMERGENCY)
			set_mode(null)
			update_power_channel(initial(power_channel))

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/state)
	on = (state && get_status() == LIGHT_OK)
	update_light_status(TRUE)
	update_icon()

// examine verb
/obj/machinery/light/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/fitting = get_fitting_name()
	switch(get_status())
		if(LIGHT_OK)
			. += "It is turned [on? "on" : "off"]."
		if(LIGHT_EMPTY)
			. += "The [fitting] has been removed."
		if(LIGHT_BURNED)
			. += "The [fitting] is burnt out."
		if(LIGHT_BROKEN)
			. += "The [fitting] has been smashed."

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/light/L = light_type
	return initial(L.name)

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/proc/insert_bulb(obj/item/light/L)
	L.forceMove(src)
	lightbulb = L

	on = expected_to_be_on()
	update_light_status(TRUE)
	update_icon()

/obj/machinery/light/proc/remove_bulb()
	. = lightbulb
	lightbulb.dropInto(loc)
	lightbulb.update_icon()
	lightbulb = null
	update_light_status(TRUE)
	update_icon()

// Just... skip the entire test. We don't need to remove the bulbs from every single light just to test this.
/obj/machinery/light/fail_construct_state_unit_test()
	return FALSE

/obj/machinery/light/cannot_transition_to(state_path, mob/user)
	if(lightbulb && !ispath(state_path, /decl/machine_construction/wall_frame/panel_closed))
		return SPAN_WARNING("You must first remove the lightbulb!")
	return ..()

/obj/machinery/light/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(. || panel_open)
		return

	// attempt to insert light
	if(istype(used_item, /obj/item/light))
		if(lightbulb)
			to_chat(user, "There is a [get_fitting_name()] already inserted.")
			return
		if(!istype(used_item, accepts_light_type))
			to_chat(user, "This type of light requires a [get_fitting_name()].")
			return
		if(!user.try_unequip(used_item, src))
			return
		to_chat(user, "You insert [used_item].")
		insert_bulb(used_item)
		src.add_fingerprint(user)

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(lightbulb && (lightbulb.status != LIGHT_BROKEN) && !user.check_intent(I_FLAG_HELP))

		if(prob(1 + used_item.expend_attack_force(user) * 5))

			user.visible_message("<span class='warning'>[user.name] smashed the light!</span>", "<span class='warning'>You smash the light!</span>", "You hear a tinkle of breaking glass.")
			if(on && (used_item.obj_flags & OBJ_FLAG_CONDUCTIBLE))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(!lightbulb)
		to_chat(user, "You stick \the [used_item] into the light socket!")
		if(expected_to_be_on() && (used_item.obj_flags & OBJ_FLAG_CONDUCTIBLE))
			spark_at(src, cardinal_only = TRUE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light is expected to be on, disregarding internal state other than power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/expected_to_be_on()
	var/area/A = get_area(src)
	return A?.lightswitch && !(stat & NOPOWER)

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && get_status() == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(get_status() != LIGHT_OK) break
				on = !on
				update_light_status(FALSE)
				sleep(rand(5, 15))
			on = (get_status() == LIGHT_OK)
			update_light_status(FALSE)
			update_icon()
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/living/silicon/ai/user)
	src.flicker(1)

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/physical_attack_hand(mob/living/user)
	if(!lightbulb)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return TRUE

	if(user.can_shred())
		visible_message(
			SPAN_DANGER("\The [user] smashes the light!"),
			blind_message = "You hear a tinkle of breaking glass."
		)
		broken()
		return TRUE

	// make it burn hands if not wearing fire-insulated gloves
	if(on)

		var/prot = FALSE
		var/mob/living/human/H = user
		if(istype(H))
			var/obj/item/clothing/gloves/gloves = H.get_equipped_item(slot_gloves_str)
			if(istype(gloves) && gloves.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
				prot = TRUE

		if(prot > 0 || user.has_genetic_condition(GENE_COND_COLD_RESISTANCE))
			to_chat(user, "You remove the [get_fitting_name()].")
		else if(istype(user) && user.is_telekinetic())
			to_chat(user, "You telekinetically remove the [get_fitting_name()].")
		else if(!user.check_intent(I_FLAG_HELP))
			var/obj/item/organ/external/hand = GET_EXTERNAL_ORGAN(H, user.get_active_held_item_slot())
			if(hand && hand.is_usable() && !hand.can_feel_pain())
				user.apply_damage(3, BURN, hand.organ_tag, used_weapon = src)
				var/decl/pronouns/pronouns = user.get_pronouns()
				user.visible_message( \
					SPAN_DANGER("\The [user]'s [hand.name] burns and sizzles as [pronouns.he] touch[pronouns.es] the hot [get_fitting_name()]."), \
					SPAN_DANGER("Your [hand.name] burns and sizzles as you remove the hot [get_fitting_name()]."))
		else
			to_chat(user, SPAN_WARNING("You try to remove the [get_fitting_name()], but it's too hot and you don't want to burn your hand."))
			return TRUE
	else
		to_chat(user, SPAN_NOTICE("You remove the [get_fitting_name()]."))

	// create a light tube/bulb item and put it in the user's hand
	user.put_in_active_hand(remove_bulb())	//puts it in our active hand
	return TRUE

// break the light and make sparks if was on
/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(!lightbulb)
		return

	if(!skip_sound_and_sparks)
		if(lightbulb && !(lightbulb.status == LIGHT_BROKEN))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			spark_at(src, cardinal_only = TRUE)
	lightbulb.status = LIGHT_BROKEN
	update_light_status(TRUE)
	update_icon()

/obj/machinery/light/proc/fix()
	if(get_status() == LIGHT_OK || !lightbulb)
		return
	lightbulb.status = LIGHT_OK
	on = TRUE
	update_light_status(TRUE)
	update_icon()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src))
		if(severity == 1)
			physically_destroyed()
		else if((severity == 2 && prob(75)) || (severity == 3 && prob(50)))
			broken()

// timed process
// use power

// called when area power state changes
/obj/machinery/light/power_change()
	. = ..()
	if(.)
		delay_and_set_on(expected_to_be_on(), 1 SECOND)

/obj/machinery/light/proc/delay_and_set_on(var/new_state, var/delay)
	set waitfor = FALSE
	sleep(delay)
	seton(new_state)

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()
	return ..()

/obj/machinery/light/small/readylight
	light_type = /obj/item/light/bulb/red/readylight
	var/state = 0

/obj/machinery/light/small/readylight/proc/set_state(var/new_state)
	state = new_state
	if(state)
		set_mode(LIGHTMODE_READY)
	else
		set_mode(null)

/obj/machinery/light/navigation
	name = "navigation light"
	desc = "A periodically flashing light."
	icon = 'icons/obj/lighting_nav.dmi'
	icon_state = "nav10"
	base_state = "nav1"
	light_type = /obj/item/light/tube/large
	accepts_light_type = /obj/item/light/tube/large
	on = TRUE
	var/delay = 1
	base_type = /obj/machinery/light/navigation
	frame_type = /obj/item/frame/light/nav
	stat_immune = NOPOWER | NOINPUT | NOSCREEN

/obj/machinery/light/navigation/on_update_icon()
	. = ..() // this will handle pixel offsets
	icon_state = "nav[delay][!!(lightbulb && on)]"

/obj/machinery/light/navigation/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(!. && IS_MULTITOOL(used_item))
		delay = 5 + ((delay + 1) % 5)
		to_chat(user, SPAN_NOTICE("You adjust the delay on \the [src]."))
		return TRUE

/obj/machinery/light/navigation/delay2
	delay = 2

/obj/machinery/light/navigation/delay3
	delay = 3

/obj/machinery/light/navigation/delay4
	delay = 4

/obj/machinery/light/navigation/delay5
	delay = 5

/obj/machinery/light/do_simple_ranged_interaction(var/mob/user)
	if(lightbulb)
		remove_bulb()
	return TRUE

// Partially-constructed presets for mapping
/obj/machinery/light/fixture
	icon_state = "tube-construct-stage1"

/obj/machinery/light/fixture/Initialize(mapload, d, populate_parts)
	. = ..(mapload, d, populate_parts = FALSE)
	construct_state.post_construct(src)

/obj/machinery/light/small/fixture
	icon_state = "bulb-construct-stage1"

/obj/machinery/light/small/fixture/Initialize(mapload, d, populate_parts)
	. = ..(mapload, d, populate_parts = FALSE)
	construct_state.post_construct(src)