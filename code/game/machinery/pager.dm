/obj/machinery/network/pager
	name = "departmental pager button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "doorbell"
	desc = "A button used to request the presence of anyone in the department."
	anchored = TRUE
	density = FALSE
	idle_power_usage = 2
	var/area/location
	var/last_paged
	var/acknowledged = FALSE
	var/department

/obj/machinery/network/pager/Initialize()
	. = ..()
	if(!department)
		department = SSjobs.departments_by_type[1]
	if(!location)
		location = get_area(src)

/obj/machinery/network/pager/interface_interact(mob/living/user)
	if(!CanInteract(user, global.default_topic_state))
		return FALSE
	playsound(src, "button", 60)
	flick("doorbellpressed",src)
	activate(user)
	return TRUE

/obj/machinery/network/pager/proc/activate(mob/living/user)
	if(stat & NOPOWER)
		return
	var/obj/machinery/network/message_server/MS = get_message_server(z)
	if(!MS)
		return
	if(world.time < last_paged + 5 SECONDS)
		return
	last_paged = world.time
	var/paged = MS.send_to_department(department,"Department page to <b>[location.proper_name]</b> received. <a href='?src=\ref[src];ack=1'>Take</a>", "*page*")
	acknowledged = 0
	if(paged)
		playsound(src, 'sound/machines/ping.ogg', 60)
		to_chat(user,"<span class='notice'>Page received by [paged] devices.</span>")
	else
		to_chat(user,"<span class='warning'>No valid destinations were found for the page.</span>")

/obj/machinery/network/pager/Topic(href, href_list)
	if(..())
		return 1
	if(stat & NOPOWER)
		return
	if(!acknowledged && href_list["ack"])
		playsound(src, 'sound/machines/ping.ogg', 60)
		visible_message("<span class='notice'>Page acknowledged.</span>")
		acknowledged = 1
		var/obj/machinery/network/message_server/MS = get_message_server(z)
		if(!MS)
			return
		MS.send_to_department(department,"Page to <b>[location.proper_name]</b> was acknowledged.", "*ack*")
