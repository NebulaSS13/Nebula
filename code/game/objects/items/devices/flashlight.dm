#define FLASHLIGHT_ALWAYS_ON 1
#define FLASHLIGHT_SINGLE_USE 2

/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY

	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

	action_button_name = "Toggle Flashlight"

	var/on = FALSE
	var/activation_sound = 'sound/effects/flashlight.ogg'

	var/flashlight_range = 4 // range of light when on, can be negative
	var/flashlight_power     // brightness of light when on
	var/flashlight_flags = 0 // FLASHLIGHT_ bitflags

	light_wedge = LIGHT_WIDE
	var/spawn_dir // a way for mappers to force which way a flashlight faces upon spawning

/obj/item/flashlight/Initialize()
	. = ..()

	set_flashlight()
	update_icon()

/obj/item/flashlight/on_update_icon()
	. = ..()
	if (flashlight_flags & FLASHLIGHT_ALWAYS_ON)
		return // Prevent update_icon shennanigans with objects that won't have on/off variant sprites

	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/flashlight/attack_self(mob/user)
	if (flashlight_flags & FLASHLIGHT_ALWAYS_ON)
		to_chat(user, "You cannot toggle the [name].")
		return 0

	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the [name] on while in this [user.loc].")//To prevent some lighting anomalities.
		return 0

	if (flashlight_flags & FLASHLIGHT_SINGLE_USE && on)
		to_chat(user, "The [name] is already lit.")
		return 0

	on = !on
	if(on && activation_sound)
		playsound(get_turf(src), activation_sound, 75, 1)
	set_flashlight()
	update_icon()
	user.update_action_buttons()
	return 1

/obj/item/flashlight/proc/set_flashlight()
	if(light_wedge)
		set_dir(pick(NORTH, SOUTH, EAST, WEST))
		if(spawn_dir)
			set_dir(spawn_dir)
	if (on)
		set_light(flashlight_range, flashlight_power, light_color)
	else
		set_light(0)

/obj/item/flashlight/examine(mob/user, distance)
	. = ..()
	if(light_wedge && isturf(loc))
		to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] is facing [dir2text(dir)].")))

/obj/item/flashlight/dropped(mob/user)
	. = ..()
	if(light_wedge)
		set_dir(user.dir)
		update_light()

/obj/item/flashlight/throw_at()
	. = ..()
	if(light_wedge)
		var/new_dir = pick(NORTH, SOUTH, EAST, WEST)
		set_dir(new_dir)
		update_light()

/obj/item/flashlight/attack(mob/living/M, mob/living/user)
	add_fingerprint(user)
	if(on && user.get_target_zone() == BP_EYES)

		if((MUTATION_CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/slot in global.standard_headgear_slots)
				var/obj/item/clothing/C = H.get_equipped_item(slot)
				if(istype(C) && (C.body_parts_covered & SLOT_EYES))
					to_chat(user, "<span class='warning'>You're going to need to remove [C] first.</span>")
					return

			var/obj/item/organ/vision
			if(!H.species.vision_organ || !H.should_have_organ(H.species.vision_organ))
				to_chat(user, "<span class='warning'>You can't find anything on [H] to direct [src] into!</span>")
				return

			vision = GET_INTERNAL_ORGAN(H, H.species.vision_organ)
			if(!vision)
				vision = H.species.has_organ[H.species.vision_organ]
				var/decl/pronouns/G = H.get_pronouns()
				to_chat(user, "<span class='warning'>\The [H] is missing [G.his] [initial(vision.name)]!</span>")
				return

			user.visible_message("<span class='notice'>\The [user] directs [src] into [M]'s [vision.name].</span>", \
								 "<span class='notice'>You direct [src] into [M]'s [vision.name].</span>")

			inspect_vision(vision, user)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/flashlight/proc/inspect_vision(obj/item/organ/vision, mob/living/user)
	var/mob/living/carbon/human/H = vision.owner

	if(H == user)	//can't look into your own eyes buster
		return

	if(!BP_IS_PROSTHETIC(vision))

		if(vision.owner.stat == DEAD || H.blinded)	//mob is dead or fully blind
			to_chat(user, "<span class='warning'>\The [H]'s pupils do not react to the light!</span>")
			return
		if(MUTATION_XRAY in H.mutations)
			to_chat(user, "<span class='notice'>\The [H]'s pupils give an eerie glow!</span>")
		if(vision.damage)
			to_chat(user, "<span class='warning'>There's visible damage to [H]'s [vision.name]!</span>")
		else if(HAS_STATUS(H, STAT_BLURRY))
			to_chat(user, "<span class='notice'>\The [H]'s pupils react slower than normally.</span>")
		if(H.getBrainLoss() > 15)
			to_chat(user, "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>")

		var/static/list/pinpoint = list(
			/decl/material/liquid/painkillers/strong = 5,
			/decl/material/liquid/amphetamines = 1
		)
		var/static/list/dilating = list(
			/decl/material/liquid/psychoactives = 5,
			/decl/material/liquid/hallucinogenics = 1,
			/decl/material/liquid/adrenaline = 1
		)

		var/datum/reagents/ingested = H.get_ingested_reagents()
		if(H.reagents.has_any_reagent(pinpoint) || ingested?.has_any_reagent(pinpoint))
			to_chat(user, "<span class='notice'>\The [H]'s pupils are already pinpoint and cannot narrow any more.</span>")
		else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || ingested?.has_any_reagent(dilating))
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow slightly, but are still very dilated.</span>")
		else
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow.</span>")

	//if someone wants to implement inspecting robot eyes here would be the place to do it.

/obj/item/flashlight/upgraded
	name = "\improper LED flashlight"
	desc = "An energy efficient flashlight."
	icon_state = "biglight"
	item_state = "biglight"
	flashlight_range = 6
	flashlight_power = 3

/obj/item/flashlight/flashdark
	name = "flashdark"
	desc = "A strange device manufactured with mysterious elements that somehow emits darkness. Or maybe it just sucks in light? Nobody knows for sure."
	icon_state = "flashdark"
	item_state = "flashdark"
	w_class = ITEM_SIZE_NORMAL
	flashlight_range = 8
	flashlight_power = -6

/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_TINY
	flashlight_range = 2
	light_wedge = LIGHT_OMNI

/obj/item/flashlight/pen/Initialize()
	set_extension(src, /datum/extension/tool, list(TOOL_PEN = TOOL_QUALITY_DEFAULT), list(TOOL_PEN = list(TOOL_PROP_COLOR = "black", TOOL_PROP_COLOR_NAME = "black")))
	. = ..()

/obj/item/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	item_state = "maglight"
	force = 10
	attack_verb = list ("smacked", "thwacked", "thunked")
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	light_wedge = LIGHT_NARROW

/******************************Lantern*******************************/
/obj/item/flashlight/lantern
	name = "lantern"
	desc = "A mining lantern."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lantern"
	item_state = "lantern"
	force = 10
	attack_verb = list ("bludgeoned", "bashed", "whack")
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	flashlight_range = 2
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/obj/item/flashlight/lantern/on_update_icon()
	. = ..()
	if(on)
		item_state = "lantern-on"
	else
		item_state = "lantern"

/******************************Lantern*******************************/

/obj/item/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_TINY
	flashlight_range = 2


// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	flashlight_range = 5
	light_wedge = LIGHT_OMNI
	on = 1

// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	light_color = "#ffc58f"
	flashlight_range = 4

/obj/item/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEM_SIZE_TINY
	light_color = "#e58775"
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	activation_sound = 'sound/effects/flare.ogg'
	flashlight_flags = FLASHLIGHT_SINGLE_USE

	flashlight_range = 5
	flashlight_power = 3
	light_wedge = LIGHT_OMNI

	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

/obj/item/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.v
	update_icon()

/obj/item/flashlight/flare/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/Process()
	if(produce_heat)
		var/turf/T = get_turf(src)
		if(T)
			T.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if (fuel <= 0)
		on = FALSE
	if(!on)
		update_damage()
		set_flashlight()
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/attack_self(var/mob/user)
	if(fuel <= 0)
		to_chat(user,"<span class='notice'>\The [src] is spent.</span>")
		return 0

	. = ..()

	if(.)
		activate(user)
		update_damage()
		set_flashlight()
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O) && on)
		O.HandleObjectHeating(src, user, 500)
	..()

/obj/item/flashlight/flare/proc/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] pulls the cord on \the [src], activating it.</span>", "<span class='notice'>You pull the cord on \the [src], activating it!</span>")

/obj/item/flashlight/flare/proc/update_damage()
	if(on)
		force = on_damage
		damtype = BURN
	else
		force = initial(force)
		damtype = initial(damtype)

/obj/item/flashlight/flare/on_update_icon()
	. = ..()
	if(!on && fuel <= 0)
		icon_state = "[initial(icon_state)]-empty"

//Glowsticks
/obj/item/flashlight/flare/glowstick
	name = "green glowstick"
	desc = "A military-grade glowstick."
	w_class = ITEM_SIZE_SMALL
	color = "#49f37c"
	icon_state = "glowstick"
	item_state = "glowstick"
	randpixel = 12
	produce_heat = 0
	activation_sound = 'sound/effects/glowstick.ogg'

	flashlight_range = 3
	flashlight_power = 2

/obj/item/flashlight/flare/glowstick/Initialize()
	. = ..()
	fuel = rand(1600, 2000)
	light_color = color

/obj/item/flashlight/flare/glowstick/on_update_icon()
	var/nofuel = fuel <= 0
	if(nofuel)
		on = FALSE
	. = ..()
	icon_state = nofuel? "glowstick-empty" : icon_state
	item_state = initial(item_state)
	if(on)
		var/image/I = overlay_image(icon, "glowstick-on", color)
		I.blend_mode = BLEND_ADD
		add_overlay(I)
		item_state = "glowstick-on"
	update_held_icon()

/obj/item/flashlight/flare/glowstick/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")

/obj/item/flashlight/flare/glowstick/red
	name = "red glowstick"
	color = "#fc0f29"

/obj/item/flashlight/flare/glowstick/blue
	name = "blue glowstick"
	color = "#599dff"

/obj/item/flashlight/flare/glowstick/orange
	name = "orange glowstick"
	color = "#fa7c0b"

/obj/item/flashlight/flare/glowstick/yellow
	name = "yellow glowstick"
	color = "#fef923"

/obj/item/flashlight/flare/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#ff00ff"

/obj/item/flashlight/flare/glowstick/random/Initialize()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	. = ..()

/obj/item/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = ITEM_SIZE_TINY
	on = TRUE //Bio-luminesence has one setting, on.
	flashlight_flags = FLASHLIGHT_ALWAYS_ON

	flashlight_range = 5
	light_wedge = LIGHT_OMNI

//hand portable floodlights for emergencies. Less bulky than the large ones. But also less light. Unused green variant in the sheet.

/obj/item/flashlight/lamp/floodlamp
	name = "flood lamp"
	desc = "A portable emergency flood light with a ultra-bright LED."
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "floodlamp"
	item_state = "lamp"
	on = 0
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_ROTATABLE

	flashlight_power = 1
	flashlight_range = 7
	light_wedge = LIGHT_WIDE

/obj/item/flashlight/lamp/floodlamp/green
	icon_state = "greenfloodlamp"

//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/flashlight/lamp/lava
	name = "lava lamp"
	desc = "A kitchy throwback decorative light. Noir Edition."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lavalamp"
	on = 0
	action_button_name = "Toggle lamp"
	flashlight_range = 3 //range of light when on
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/flashlight/lamp/lava/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "lavalamp-[on ? "on" : "off"]", light_color))

/obj/item/flashlight/lamp/lava/red
	desc = "A kitchy red decorative light."
	light_color = COLOR_RED

/obj/item/flashlight/lamp/lava/blue
	desc = "A kitchy blue decorative light"
	light_color = COLOR_BLUE

/obj/item/flashlight/lamp/lava/cyan
	desc = "A kitchy cyan decorative light"
	light_color = COLOR_CYAN

/obj/item/flashlight/lamp/lava/green
	desc = "A kitchy green decorative light"
	light_color = COLOR_GREEN

/obj/item/flashlight/lamp/lava/orange
	desc = "A kitchy orange decorative light"
	light_color = COLOR_ORANGE

/obj/item/flashlight/lamp/lava/purple
	desc = "A kitchy purple decorative light"
	light_color = COLOR_PURPLE
/obj/item/flashlight/lamp/lava/pink
	desc = "A kitchy pink decorative light"
	light_color = COLOR_PINK

/obj/item/flashlight/lamp/lava/yellow
	desc = "A kitchy yellow decorative light"
	light_color = COLOR_YELLOW

#undef FLASHLIGHT_ALWAYS_ON
#undef FLASHLIGHT_SINGLE_USE
