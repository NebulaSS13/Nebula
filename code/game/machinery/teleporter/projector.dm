/obj/machinery/tele_projector
	name = "teleporter projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "station"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 2000

	var/obj/machinery/computer/teleporter/computer


/obj/machinery/tele_projector/Destroy()
	if (computer)
		computer.lost_projector()
	clear_computer()
	return ..()


/obj/machinery/tele_projector/proc/clear_computer()
	if (!computer)
		return
	GLOB.destroyed_event.unregister(computer, src, /obj/machinery/tele_projector/proc/lost_computer)
	computer = null


/obj/machinery/tele_projector/proc/lost_computer()
	clear_computer()
	update_icon()


/obj/machinery/tele_projector/proc/set_computer(obj/machinery/computer/teleporter/_computer)
	if (computer == _computer)
		return
	clear_computer()
	computer = _computer
	GLOB.destroyed_event.register(computer, src, /obj/machinery/tele_projector/proc/lost_computer)


/obj/machinery/tele_projector/proc/update_active()
	if (computer?.active)
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	update_icon()


/obj/machinery/tele_projector/on_update_icon()
	cut_overlays()
	var/use_state
	if (computer?.active)
		use_state = "[initial(icon_state)]_active_overlay"
	else if (operable())
		use_state = "[initial(icon_state)]_idle_overlay"

	if (use_state)
		var/image/I = image(icon, src, use_state)
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		add_overlay(I)
