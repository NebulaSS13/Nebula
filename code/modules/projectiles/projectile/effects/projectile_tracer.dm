/proc/generate_tracer_between_points(var/obj/item/projectile/source, datum/point/starting, datum/point/ending, beam_type, color, qdel_in = 5)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	if(starting.z != ending.z)
		PRINT_STACK_TRACE("Projectile tracer generation of cross-Z beam detected. This feature is not supported!")			//Do it anyways though.
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type
	source.update_effect(PB)
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	. = PB
	if(qdel_in)
		QDEL_IN(PB, qdel_in)

/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/effects/projectiles/tracer.dmi'

/obj/effect/projectile/tracer/laser
	name = "laser"
	icon_state = "beam"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/tracer/laser/blue
	icon_state = "beam_blue"
	light_color = LIGHT_COLOR_BLUE

/obj/effect/projectile/tracer/disabler
	name = "disabler"
	icon_state = "beam_omni"
	light_color = LIGHT_COLOR_CYAN

/obj/effect/projectile/tracer/xray
	name = "xray laser"
	icon_state = "xray"
	light_color = LIGHT_COLOR_GREEN

/obj/effect/projectile/tracer/pulse
	name = "pulse laser"
	icon_state = "u_laser"
	light_color = LIGHT_COLOR_BLUE

/obj/effect/projectile/tracer/plasma_cutter
	name = "plasma blast"
	icon_state = "plasmacutter"
	light_color = LIGHT_COLOR_CYAN

/obj/effect/projectile/tracer/stun
	name = "stun beam"
	icon_state = "stun"
	light_color = LIGHT_COLOR_YELLOW

/obj/effect/projectile/tracer/heavy_laser
	name = "heavy laser"
	icon_state = "beam_heavy"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/tracer/cult
	name = "arcane beam"
	icon_state = "cult"
	light_color = LIGHT_COLOR_VIOLET
	appearance_flags = NO_CLIENT_COLOR

/obj/effect/projectile/tracer/cult/heavy
	name = "heavy arcane beam"
	icon_state = "hcult"

/obj/effect/projectile/tracer/solar
	name = "solar energy"
	icon_state = "solar"
	light_color = LIGHT_COLOR_FIRE

/obj/effect/projectile/tracer/eyelaser
	icon_state = "eye"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/tracer/emitter
	icon_state = "emitter"
	light_color = LIGHT_COLOR_GREEN

/obj/effect/projectile/tracer/tachyon
	name = "particle beam"
	icon_state = "invisible"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/tracer/bfg
	icon_state = "bfg"
	light_color = LIGHT_COLOR_GREEN

/obj/effect/projectile/tracer/particle
	name = "particle beam"
	icon_state = "particle"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/tracer/darkmatter
	name = "darkmatter beam"
	icon_state = "darkmatter"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/tracer/darkmattertaser
	name = "darktaser beam"
	icon_state = "darkt"
	light_color = LIGHT_COLOR_VIOLET

/obj/effect/projectile/tracer/incen
	icon_state = "incen"
	light_color = LIGHT_COLOR_RED

/obj/effect/projectile/tracer/pd
	icon_state = "pd"
	light_color = LIGHT_COLOR_YELLOW

/obj/effect/projectile/tracer/variable
	icon_state = "beam_white"
	overlay_state = "_overlay"
	light_color = COLOR_WHITE

/obj/effect/projectile/tracer/variable_heavy
	icon_state = "beam_heavy_white"
	overlay_state = "_overlay"
	light_color = COLOR_WHITE
