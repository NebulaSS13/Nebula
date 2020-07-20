// Blackout tool, used to trigger massive electricity outttage on ship or station, including connected levels.
// It may have additional shots to use, but currently balanced to one shot.

/datum/uplink_item/item/tools/blackout
	name = "High Pulse Electricity Outage Tool"
	item_cost = 24
	path = /obj/item/blackout
	desc = "A device wich can create power virus in terminal, spread it in power network and temporally creating blackout."

/obj/item/blackout
	name = "high pulse electricity outage tool"
	desc = "A unknown device, probably only experienced electrics know what this can do."
	icon = 'icons/obj/items/blackout.dmi'
	icon_state = "device_blackout-off"

	var/severity = 2
	var/shots = 1
	var/lastUse = 0
	var/Cooldown = (20 MINUTES)

/obj/item/blackout/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(!istype(target))
		return

	target.add_fingerprint(user)

	if(istype(target, /obj/machinery/power/terminal))
		var/obj/machinery/power/terminal/terminal = target

		if(!terminal.powernet)
			to_chat(user, SPAN_WARNING("This power station isn't connected to power net."))
			return

		if(check_to_use())
			to_chat(user, SPAN_WARNING("Device does not respond. Perhaps you need to try later."))
			return

		if(!shots)
			to_chat(user, SPAN_WARNING("Device does not respond."))
			return

		hacktheenergy(terminal, user)

/obj/item/blackout/proc/hacktheenergy(obj/machinery/power/terminal/terminal_in, mob/user)
	if(!istype(terminal_in) || !user) return

	src.audible_message("<font color=Maroon><b>HackTheEnergy.exe Assistant</b></font> says, \
	\"-- Starting. Connecting to the therminal. --\"")
	if(!do_after(user, 30, terminal_in)) return

	src.audible_message("<font color=Maroon><b>HackTheEnergy.exe Assistant</b></font> says, \
	\"-- Successful Ñonnection to the terminal. Getting information about the powergrid ... --\"")
	if(!do_after(user, 80, terminal_in)) return

	src.audible_message("<font color=Maroon><b>HackTheEnergy.exe Assistant</b></font> says, \
	\"-- Powernet scan succeeded. Starting the pulsation procedure. --\"")

	icon_state = "device_blackout-on"
	playsound(src, 'sound/items/goggles_charge.ogg', 50, 1)

	if(!do_after(user, 40, terminal_in)) return
	src.audible_message("<font color=Maroon><b>HackTheEnergy.exe Assistant</b></font> says, \
	\"-- Done. Pulsing is complete. We wish you a successful and productive mission. --\"")

	shots--
	Cooldown = world.time

	var/datum/powernet/powernet = terminal_in.powernet
	for(var/obj/machinery/power/terminal/terminal_out in powernet.nodes)
		if(istype(terminal_out.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = terminal_out.master
			A.energy_fail(rand(30 * severity, 60 * severity))
		if(istype(terminal_out.master, /obj/machinery/power/smes/buildable))
			var/obj/machinery/power/smes/buildable/S = terminal_out.master
			S.energy_fail(rand(15 * severity, 30 * severity))

	log_and_message_admins("used \the [src] on \the [terminal_in] to shutdown powernet.", user)
	icon_state = "device_blackout-off"

/obj/item/blackout/proc/check_to_use()
	return lastUse <= (world.time - Cooldown)
