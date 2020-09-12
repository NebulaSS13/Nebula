/area/ship/trade
	name = "\improper Generic Ship"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')

/area/ship/trade/crew
	name = "\improper Crew Compartements"
	icon_state = "crew_quarters"

/area/ship/trade/crew/hallway/port
	name = "\improper Crew Hallway - Port"

/area/ship/trade/crew/hallway/starboard
	name = "\improper Crew Hallway - Starboard"

/area/ship/trade/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/trade/crew/dorms1
	name = "\improper Crew Cabin #1"
	icon_state = "green"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/crew/dorms2
	name = "\improper Crew Cabin #2"
	icon_state = "purple"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/crew/saloon
	name = "\improper Saloon"
	icon_state = "conference"

/area/ship/trade/crew/toilets
	name = "\improper Bathrooms"
	icon_state = "toilet"
	turf_initializer = /decl/turf_initializer/maintenance

/area/ship/trade/crew/wash
	name = "\improper Washroom"
	icon_state = "locker"

/area/ship/trade/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/cargo/lower
	name = "Loading Bay"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/dock
	name = "\improper Docking Bay"
	icon_state = "entry_1"

/area/ship/trade/aft_port_underside_maint
	name = "\improper Underside - Aft Port Maintenance"
	icon_state = "medbay"

/area/ship/trade/aft_starboard_underside_maint
	name = "\improper Underside - Aft Starboard Maintenance"
	icon_state = "toilet"

/area/ship/trade/loading_bay
	name = "\improper Underside - Loading Bay"
	icon_state = "entry_1"

/area/ship/trade/fore_port_underside_maint
	name = "\improper Underside - Fore Port Maintenance"
	icon_state = "green"

/area/ship/trade/livestock
	name = "\improper Underside - Livestock Handling"
	icon_state = "red"
	req_access = list(access_xenobiology)

/area/ship/trade/fore_starboard_underside_maint
	name = "\improper Underside - Fore Starboard Maintenance"
	icon_state = "locker"

/area/ship/trade/disused
	name = "\improper Underside - Disused"
	icon_state = "yellow"

/area/ship/trade/undercomms
	name = "\improper Underside - Communications Relay"
	icon_state = "blue"

/area/ship/trade/garden
	name = "\improper Garden"
	icon_state = "green"

/area/ship/trade/unused
	name = "\improper Compartment 2-B"
	icon_state = "yellow"
	turf_initializer = /decl/turf_initializer/maintenance
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/ship/trade/hidden
	name = "\improper Unknown" //shielded compartment
	icon_state = "auxstorage"

/area/ship/trade/escape_port
	name = "\improper Port Escape Pods"
	icon_state = "green"

/area/ship/trade/escape_star
	name = "\improper Starboard Escape Pods"
	icon_state = "yellow"

/area/ship/trade/science
	name = "\improper Research Bay"
	icon_state = "green"
	req_access = list(access_research)

/area/ship/trade/science/fabricaton
	name = "\improper Fabrication Bay"
	icon_state = "yellow"
	req_access = list(access_research)

/area/ship/trade/crew/medbay/chemistry
	name = "\improper Chemistry Bay"
	icon_state = "cave"
	req_access = list(access_medical)

/area/ship/trade/maintenance
	name = "\improper Maintenance Compartments"
	icon_state = "amaint"

/area/ship/trade/maintenance/hallway
	name = "\improper Maintenance Corridors"

/area/ship/trade/maintenance/lower
	name = "\improper Lower Deck Maintenance Compartments"
	icon_state = "sub_maint_aft"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/maintenance/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"
	req_access = list(access_engine)

/area/ship/trade/maintenance/techstorage
	name = "\improper Parts Storage"
	icon_state = "engineering_supply"

/area/ship/trade/maintenance/eva
	name = "\improper EVA Storage"
	icon_state = "eva"
	req_access = list(access_eva)

/area/ship/trade/maintenance/engineering
	name = "\improper Engineering Bay"
	icon_state = "engineering_supply"
	req_access = list(access_engine)

/area/ship/trade/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')
	req_access = list(access_engine)

/area/ship/trade/maintenance/power
	name = "\improper Power Compartment"
	icon_state = "engine_smes"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/trade/maintenance/engine
	icon_state = "engine"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/trade/maintenance/engine/aft
	name = "\improper Main Engine Bay"

/area/ship/trade/maintenance/engine/port
	name = "\improper Port Thruster"

/area/ship/trade/maintenance/engine/starboard
	name = "\improper Starboard Thruster"

/area/ship/trade/command/hallway
	name = "\improper Command Deck"
	icon_state = "centcom"

/area/ship/trade/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	req_access = list(access_heads)

/area/ship/trade/command/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain"
	req_access = list(access_captain)

/area/ship/trade/command/fmate
	name = "\improper First Mate's Office"
	icon_state = "heads_hop"
	req_access = list(access_hop)

/area/ship/trade/shieldbay
	name = "\improper Auxillary Shield Bay"
	icon_state = "engine"
	req_access = list(access_engine_equip)

/area/ship/trade/command/bridge_upper
	name = "\improper Upper Bridge"
	icon_state = "blue"
	req_access = list(access_heads)

/area/ship/trade/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')

/area/ship/trade/bridge_unused
	name = "\improper Bridge Starboard Storage"
	icon_state = "armory"

/area/ship/trade/shuttle
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/trade/shuttle/outgoing
	name = "\improper Exploration Shuttle"
	icon_state = "tcomsatcham"

/area/ship/trade/maintenance/solars
	name = "\improper Solar Array Access"
	icon_state = "SolarcontrolA"
	req_access = list(access_engine)

/area/ship/trade/artifact_storage
	name = "\improper Artifact Storage"
	icon_state = "ai_cyborg"
	req_access = list(access_xenoarch)

/area/ship/trade/drunk_tank
	name = "Drunk Tank"
	icon_state = "brig"
	req_access = list(access_brig)
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/turbolift
	name = "\improper Cargo Elevator"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	sound_env = STANDARD_STATION
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')
	arrival_sound = null
	lift_announce_str = null

/area/turbolift/alert_on_fall(var/mob/living/carbon/human/H)
	if(H.client && SSpersistence.elevator_fall_shifts > 0)
		SSwebhooks.send(WEBHOOK_ELEVATOR_FALL, list("text" = "We managed to make it [SSpersistence.elevator_fall_shifts] shift\s without someone falling down an elevator shaft."))
		SSpersistence.elevator_fall_shifts = -1

/area/turbolift/tradeship_enclave
	name = "Disused Sublevel"
	base_turf = /turf/simulated/floor

/area/turbolift/tradeship_cargo
	name = "Lower Cargo Bay"
	base_turf = /turf/simulated/open

/area/turbolift/tradeship_upper
	name = "Upper Cargo Bay"
	base_turf = /turf/simulated/open

/area/turbolift/tradeship_roof
	name = "Solar Array Access"
	base_turf = /turf/simulated/open