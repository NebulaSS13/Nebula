/obj/machinery/computer/area_atmos
	name = "area air control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = "#e6ffff"

	var/list/connectedscrubbers = new()
	var/status = ""

	var/range = 25

	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to 25 meters."

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()
	scanscrubbers()

/obj/machinery/computer/area_atmos/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/area_atmos/interact(mob/user)
	var/dat = {"
	<html>
		<head>
			<style type="text/css">
				a.green:link
				{
					color:#00cc00;
				}
				a.green:visited
				{
					color:#00cc00;
				}
				a.green:hover
				{
					color:#00cc00;
				}
				a.green:active
				{
					color:#00cc00;
				}
				a.red:link
				{
					color:#ff0000;
				}
				a.red:visited
				{
					color:#ff0000;
				}
				a.red:hover
				{
					color:#ff0000;
				}
				a.red:active
				{
					color:#ff0000;
				}
			</style>
		</head>
		<body>
			<center><h1>Area Air Control</h1></center>
			<font color="red">[status]</font><br>
			<a href="byond://?src=\ref[src];scan=1">Scan</a>
			<table border="1" width="90%">"}
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		dat += {"
				<tr>
					<td>
						[scrubber.name]<br>
						Pressure: [round(scrubber.air_contents.return_pressure(), 0.01)] kPa<br>
						Flow Rate: [round(scrubber.last_flow_rate,0.1)] L/s<br>
					</td>
					<td width="150">
						<a class="green" href="byond://?src=\ref[src];scrub=\ref[scrubber];toggle=1">Turn On</a>
						<a class="red" href="byond://?src=\ref[src];scrub=\ref[scrubber];toggle=0">Turn Off</a><br>
						Load: [round(scrubber.last_power_draw)] W
					</td>
				</tr>"}

	dat += {"
			</table><br>
			<i>[zone]</i>
		</body>
	</html>"}
	show_browser(user, "[dat]", "window=miningshuttle;size=400x400")
	status = ""

/obj/machinery/computer/area_atmos/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)


	if(href_list["scan"])
		scanscrubbers()
	else if(href_list["toggle"])
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list["scrub"])

		if(!validscrubber(scrubber))
			spawn(20)
				status = "ERROR: Couldn't connect to scrubber! (timeout)"
				connectedscrubbers -= scrubber
				src.updateUsrDialog()
			return

		scrubber.update_use_power(text2num(href_list["toggle"]) ? POWER_USE_ACTIVE : POWER_USE_IDLE)

/obj/machinery/computer/area_atmos/proc/validscrubber(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
		return 0

	return 1

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = new()

	var/found = 0
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		if(istype(scrubber))
			found = 1
			connectedscrubbers += scrubber

	if(!found)
		status = "ERROR: No scrubber found!"

	src.updateUsrDialog()


/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

/obj/machinery/computer/area_atmos/area/validscrubber(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	return isobj(scrubber) && (get_area(scrubber) == get_area(src))

/obj/machinery/computer/area_atmos/area/scanscrubbers()

	var/area/A = get_area(src)
	if(!A)
		return

	connectedscrubbers = list()
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in SSmachines.machinery)
		var/turf/T2 = get_turf(scrubber)
		if(get_area(T2) == A)
			connectedscrubbers += scrubber
	if(!length(connectedscrubbers))
		status = "ERROR: No scrubber found!"
	updateUsrDialog()

/obj/machinery/computer/area_atmos/tag
	name = "heavy scrubber control"
	zone = "This computer is operating industrial scrubbers nearby."
	var/last_scan

/obj/machinery/computer/area_atmos/tag/scanscrubbers()
	if(last_scan && ((world.time - last_scan) < 20 SECONDS))
		return FALSE
	else
		last_scan = world.time

	connectedscrubbers.Cut()

	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in SSmachines.machinery)
		if(scrubber.id_tag == id_tag)
			connectedscrubbers += scrubber

	updateUsrDialog()

/obj/machinery/computer/area_atmos/tag/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(scrubber.id_tag == id_tag)
		return TRUE
	return FALSE