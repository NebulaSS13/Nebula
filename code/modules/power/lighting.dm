// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
#define LIGHTING_POWER_FACTOR 5		//5W per luminosity * range


#define LIGHTMODE_EMERGENCY "emergency_lighting"
#define LIGHTMODE_READY "ready"

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_map"
	desc = "A lighting fixture."
	anchored = 1
	layer = ABOVE_HUMAN_LAYER  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list

	var/on = 0					// 1 if on, 0 if off
	var/flickering = 0
	var/light_type = /obj/item/light/tube		// the type of light item
	var/accepts_light_type = /obj/item/light/tube
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread

	var/obj/item/light/lightbulb

	var/current_mode = null
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable
	)
	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	base_type = /obj/machinery/light/buildable
	frame_type = /obj/item/frame/light

/obj/machinery/light/buildable
	uncreated_component_parts = null

// the smaller bulb light fixture
/obj/machinery/light/small
	icon_state = "bulb_map"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	accepts_light_type = /obj/item/light/bulb
	base_type = /obj/machinery/light/small/buildable
	frame_type = /obj/item/frame/light/small

/obj/machinery/light/small/buildable
	uncreated_component_parts = null

/obj/machinery/light/small/emergency
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/small/red
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	desc = "A more robust socket for light tubes that demand more power."
	light_type = /obj/item/light/tube/large
	accepts_light_type = /obj/item/light/tube/large
	base_type = /obj/machinery/light/spot/buildable
	frame_type = /obj/item/frame/light/spot

/obj/machinery/light/spot/buildable
	uncreated_component_parts = null

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()

	s.set_up(1, 1, src)

	if(populate_parts)
		lightbulb = new light_type(src)
		if(prob(lightbulb.broken_chance))
			broken(1)

	on = powered()
	update_icon(0)

/obj/machinery/light/Destroy()
	QDEL_NULL(lightbulb)
	QDEL_NULL(s)
	. = ..()

/obj/machinery/light/on_update_icon(var/trigger = 1)
	// Handle pixel offsets
	pixel_y = 0
	pixel_x = 0
	var/turf/T = get_step(get_turf(src), src.dir)
	if(istype(T) && T.density)
		if(src.dir == NORTH)
			pixel_y = 21
		else if(src.dir == EAST)
			pixel_x = 10
		else if(src.dir == WEST)
			pixel_x = -10

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
		if(LIGHT_EMPTY)
			on = 0
		if(LIGHT_BURNED)
			_state = "[base_state]_burned"
			on = 0
		if(LIGHT_BROKEN)
			_state = "[base_state]_broken"
			on = 0

	if(istype(lightbulb, /obj/item/light))
		var/image/I = image(icon, _state)
		I.color = lightbulb.b_colour
		if(on)
			I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
		add_overlay(I)

	if(on)

		update_use_power(POWER_USE_ACTIVE)

		var/changed = 0
		if(current_mode && (current_mode in lightbulb.lighting_modes))
			changed = set_light(arglist(lightbulb.lighting_modes[current_mode]))
		else
			changed = set_light(lightbulb.b_max_bright, lightbulb.b_inner_range, lightbulb.b_outer_range, lightbulb.b_curve, lightbulb.b_colour)

		if(trigger && changed && get_status() == LIGHT_OK)
			switch_check()
	else
		update_use_power(POWER_USE_OFF)
		set_light(0)
	change_power_consumption((light_outer_range * light_max_bright) * LIGHTING_POWER_FACTOR, POWER_USE_ACTIVE)

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
		update_icon(0)

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
	queue_icon_update()

// examine verb
/obj/machinery/light/examine(mob/user)
	. = ..()
	var/fitting = get_fitting_name()
	switch(get_status())
		if(LIGHT_OK)
			to_chat(user, "It is turned [on? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "The [fitting] has been removed.")
		if(LIGHT_BURNED)
			to_chat(user, "The [fitting] is burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "The [fitting] has been smashed.")

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/light/L = light_type
	return initial(L.name)

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/proc/insert_bulb(obj/item/light/L)
	L.forceMove(src)
	lightbulb = L

	on = powered()
	update_icon()

/obj/machinery/light/proc/remove_bulb()
	. = lightbulb
	lightbulb.dropInto(loc)
	lightbulb.update_icon()
	lightbulb = null
	update_icon()

/obj/machinery/light/cannot_transition_to(state_path, mob/user)
	if(lightbulb && !ispath(state_path, /decl/machine_construction/wall_frame/panel_closed))
		return SPAN_WARNING("You must first remove the lightbulb!")
	return ..()

/obj/machinery/light/attackby(obj/item/W, mob/user)
	. = ..()
	if(. || panel_open)
		return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(lightbulb)
			to_chat(user, "There is a [get_fitting_name()] already inserted.")
			return
		if(!istype(W, accepts_light_type))
			to_chat(user, "This type of light requires a [get_fitting_name()].")
			return
		if(!user.unEquip(W, src))
			return
		to_chat(user, "You insert [W].")
		insert_bulb(W)
		src.add_fingerprint(user)

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(lightbulb && (lightbulb.status != LIGHT_BROKEN))

		if(prob(1 + W.force * 5))

			user.visible_message("<span class='warning'>[user.name] smashed the light!</span>", "<span class='warning'>You smash the light!</span>", "You hear a tinkle of breaking glass")
			if(on && (W.obj_flags & OBJ_FLAG_CONDUCTIBLE))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(!lightbulb)
		to_chat(user, "You stick \the [W] into the light socket!")
		if(powered() && (W.obj_flags & OBJ_FLAG_CONDUCTIBLE))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/powered()
	var/area/A = get_area(src)
	return A && A.lightswitch && ..(power_channel)

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && get_status() == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(get_status() != LIGHT_OK) break
				on = !on
				update_icon(0)
				sleep(rand(5, 15))
			on = (get_status() == LIGHT_OK)
			update_icon(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/physical_attack_hand(mob/living/user)
	if(!lightbulb)
		to_chat(user, "There is no [get_fitting_name()] in this light.")
		return TRUE

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			visible_message("<span class='warning'>[user.name] smashed the light!</span>", 3, "You hear a tinkle of breaking glass")
			broken()
			return TRUE

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						prot = 1
		else
			prot = 1

		if(prot > 0 || (MUTATION_COLD_RESISTANCE in user.mutations))
			to_chat(user, "You remove the [get_fitting_name()]")
		else if(istype(user) && user.is_telekinetic())
			to_chat(user, "You telekinetically remove the [get_fitting_name()].")
		else if(user.a_intent != I_HELP)
			var/obj/item/organ/external/hand = H.organs_by_name[user.get_active_held_item_slot()]
			if(hand && hand.is_usable() && !hand.can_feel_pain())
				user.apply_damage(3, BURN, hand.organ_tag, used_weapon = src)
				user.visible_message(SPAN_WARNING("\The [user]'s [hand] burns and sizzles as \he touches the hot [get_fitting_name()]."), SPAN_WARNING("Your [hand] burns and sizzles as you remove the hot [get_fitting_name()]."))
		else
			to_chat(user, "You try to remove the [get_fitting_name()], but it's too hot and you don't want to burn your hand.")
			return TRUE
	else
		to_chat(user, "You remove the [get_fitting_name()].")

	// create a light tube/bulb item and put it in the user's hand
	user.put_in_active_hand(remove_bulb())	//puts it in our active hand
	return TRUE

// ghost attack - make lights flicker like an AI, but even spookier!
/obj/machinery/light/attack_ghost(mob/user)
	if(round_is_spooky())
		src.flicker(rand(2,5))
	else return ..()

// break the light and make sparks if was on
/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(!lightbulb)
		return

	if(!skip_sound_and_sparks)
		if(lightbulb && !(lightbulb.status == LIGHT_BROKEN))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			s.set_up(3, 1, src)
			s.start()
	lightbulb.status = LIGHT_BROKEN
	update_icon()

/obj/machinery/light/proc/fix()
	if(get_status() == LIGHT_OK || !lightbulb)
		return
	lightbulb.status = LIGHT_OK
	on = 1
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
	spawn(10)
		seton(powered())

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

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
	base_type = /obj/machinery/light/navigation/buildable
	frame_type = /obj/item/frame/light/nav

/obj/machinery/light/navigation/on_update_icon()
	. = ..() // this will handle pixel offsets
	overlays.Cut()
	icon_state = "nav[delay][!!(lightbulb && on)]"

/obj/machinery/light/navigation/attackby(obj/item/W, mob/user)
	. = ..()
	if(!. && isMultitool(W))
		delay = 5 + ((delay + 1) % 5)
		to_chat(user, SPAN_NOTICE("You adjust the delay on \the [src]"))
		return TRUE

/obj/machinery/light/navigation/buildable
	uncreated_component_parts = null

/obj/machinery/light/navigation/delay2
	delay = 2

/obj/machinery/light/navigation/delay3
	delay = 3

/obj/machinery/light/navigation/delay4
	delay = 4

/obj/machinery/light/navigation/delay5
	delay = 5

/obj/machinery/light/navigation/powered()
	return TRUE


// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = ITEM_SIZE_TINY
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	material = /decl/material/solid/metal/steel
	var/rigged = 0		// true if rigged to explode
	var/broken_chance = 2

	var/b_max_bright = 0.9
	var/b_inner_range = 1
	var/b_outer_range = 5
	var/b_curve = 2
	var/b_colour = "#fffee0"
	var/list/lighting_modes = list()
	var/sound_on
	var/random_tone = TRUE
	var/static/list/random_tone_options = list(
		"#fffee0",
		"#e0fefe",
		"#fefefe",
	)

/obj/item/light/Initialize()
	. = ..()
	if (random_tone)
		b_colour = pick(random_tone_options)
		update_icon()

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)

	b_outer_range = 5
	b_colour = "#fffee0"
	lighting_modes = list(
		LIGHTMODE_EMERGENCY = list(l_outer_range = 4, l_max_bright = 1, l_color = "#da0205"),
		)
	sound_on = 'sound/machines/lightson.ogg'

/obj/item/light/tube/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_colour = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/light/tube/large
	w_class = ITEM_SIZE_SMALL
	name = "large light tube"
	b_max_bright = 0.95
	b_inner_range = 2
	b_outer_range = 8
	b_curve = 2.5

/obj/item/light/tube/large/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_colour = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	broken_chance = 3
	material = /decl/material/solid/glass

	b_max_bright = 0.6
	b_inner_range = 0.1
	b_outer_range = 4
	b_curve = 3
	b_colour = "#fcfcc7"
	lighting_modes = list(
		LIGHTMODE_EMERGENCY = list(l_outer_range = 3, l_max_bright = 1, l_color = "#da0205"),
		)

/obj/item/light/bulb/red
	color = "#da0205"
	b_colour = "#da0205"
	random_tone = FALSE

/obj/item/light/bulb/red/readylight
	lighting_modes = list(
		LIGHTMODE_READY = list(l_outer_range = 5, l_max_bright = 1, l_color = "#00ff00"),
		)

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	material = /decl/material/solid/glass

// update the icon state and description of the light
/obj/item/light/on_update_icon()
	color = b_colour
	var/broken
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]_burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]_broken"
			desc = "A broken [name]."
			broken = TRUE
	var/image/I = image(icon, src, "[base_state]_attachment[broken ? "_broken" : ""]")
	I.color = null
	overlays += I

/obj/item/light/Initialize(mapload, obj/machinery/light/fixture = null)
	. = ..()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject flammable liquids to make it explode
/obj/item/light/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/chems/syringe) && I.reagents?.total_volume)
		var/obj/item/chems/syringe/S = I
		to_chat(user, "You inject the solution into \the [src].")
		for(var/rtype in S.reagents?.reagent_volumes)
			var/decl/material/R = decls_repository.get_decl(rtype)
			if(R.fuel_value)
				rigged = TRUE
				log_and_message_admins("injected a light with flammable reagents, rigging it to explode.", user)
				break
		S.reagents.clear_reagents()
		return TRUE
	. = ..()

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/light/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("<span class='warning'>[name] shatters.</span>","<span class='warning'>You hear a small glass object shatter.</span>")
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update_icon()

/obj/item/light/proc/switch_on()
	switchcount++
	if(rigged)
		log_and_message_admins("Rigged light explosion, last touched by [fingerprintslast]")
		var/turf/T = get_turf(src.loc)
		spawn(0)
			sleep(2)
			explosion(T, 0, 0, 3, 5)
			sleep(1)
			qdel(src)
		status = LIGHT_BROKEN
	else if(prob(min(60, switchcount*switchcount*0.01)))
		status = LIGHT_BURNED
	else if(sound_on)
		playsound(src, sound_on, 75)
	return status

/obj/machinery/light/do_simple_ranged_interaction(var/mob/user)
	if(lightbulb)
		remove_bulb()
	return TRUE
