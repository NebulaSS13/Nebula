/decl/vermin_spawn/spiders
	spawn_types = list(/obj/effect/spider/spiderling)
	max_number = 3
	vermstring = "spiders"

/decl/vermin_spawn/spiders/spawn_at(atom/target)
	var/obj/effect/spider/spiderling/spiderling = ..()
	if(istype(spiderling))
		spiderling.amount_grown = -1

/datum/event/infestation/New()
	vermin_spawn_types |= /decl/vermin_spawn/spiders

var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 90
	var/spawncount = 1

/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(3 * severity, 5 * severity)	//spiderlings only have a 50% chance to grow big and strong
	sent_spiders_to_station = 0

/datum/event/spider_infestation/announce()
	global.using_map.unidentified_lifesigns_announcement()

/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in SSmachines.machinery)
		if(!temp_vent.welded && LAZYLEN(temp_vent.nodes_to_networks) && (temp_vent.loc.z in affecting_z))
			var/datum/pipe_network/net = temp_vent.nodes_to_networks[temp_vent.nodes_to_networks[1]]
			if(net.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--

/datum/event_container/moderate/New()
	available_events +=  new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation", /datum/event/spider_infestation, 25, list(ASSIGNMENT_SECURITY = 15), 1)
	..()
