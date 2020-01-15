/area/ship/scrap
	name = "\improper Generic Ship"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')

/area/ship/scrap/crew
	name = "\improper Crew Compartements"
	icon_state = "crew_quarters"

/area/ship/scrap/crew/hallway/port
	name = "\improper Crew Hallway - Port"

/area/ship/scrap/crew/hallway/starboard
	name = "\improper Crew Hallway - Starboard"

/area/ship/scrap/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/scrap/crew/dorms1
	name = "\improper Crew Cabin #1"
	icon_state = "green"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/crew/dorms2
	name = "\improper Crew Cabin #2"
	icon_state = "purple"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/crew/dorms3
	name = "\improper Crew Cabin #3"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/crew/saloon
	name = "\improper Saloon"
	icon_state = "conference"

/area/ship/scrap/crew/toilets
	name = "\improper Bathrooms"
	icon_state = "toilet"
	turf_initializer = /decl/turf_initializer/maintenance

/area/ship/scrap/crew/wash
	name = "\improper Washroom"
	icon_state = "locker"

/area/ship/scrap/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/cargo/lower
	name = "Loading Bay"

/area/ship/scrap/dock
	name = "\improper Docking Bay"
	icon_state = "entry_1"

/area/ship/scrap/aft_port_underside_maint
	name = "\improper Underside - Aft Port Maintenance"
	icon_state = "medbay"

/area/ship/scrap/aft_starboard_underside_maint
	name = "\improper Underside - Aft Starboard Maintenance"
	icon_state = "toilet"

/area/ship/scrap/loading_bay
	name = "\improper Underside - Loading Bay"
	icon_state = "entry_1"

/area/ship/scrap/fore_port_underside_maint
	name = "\improper Underside - Fore Port Maintenance"
	icon_state = "green"

/area/ship/scrap/fore_starboard_underside_maint
	name = "\improper Underside - Fore Starboard Maintenance"
	icon_state = "locker"

/area/ship/scrap/enclave
	name = "\improper Underside - Enclave"
	icon_state = "yellow"

/area/ship/scrap/garden
	name = "\improper Garden"
	icon_state = "green"

/area/ship/scrap/unused
	name = "\improper Compartment 2-B"
	icon_state = "yellow"
	turf_initializer = /decl/turf_initializer/maintenance
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/ship/scrap/hidden
	name = "\improper Unknown" //shielded compartment
	icon_state = "auxstorage"

/area/ship/scrap/escape_port
	name = "\improper Port Escape Pods"
	icon_state = "green"

/area/ship/scrap/escape_star
	name = "\improper Starboard Escape Pods"
	icon_state = "yellow"

/area/ship/scrap/science
	name = "\improper Research Bay"
	icon_state = "green"
	req_access = list(access_research)

/area/ship/scrap/science/fabricaton
	name = "\improper Fabrication Bay"
	icon_state = "yellow"

/area/ship/scrap/crew/medbay/chemistry
	name = "\improper Chemistry Bay"
	icon_state = "cave"
	req_access = list(access_medical)

/area/ship/scrap/maintenance
	name = "\improper Maintenance Compartments"
	icon_state = "amaint"

/area/ship/scrap/maintenance/hallway
	name = "\improper Maintenance Corridors"

/area/ship/scrap/maintenance/lower
	name = "\improper Lower Deck Maintenance Compartments"
	icon_state = "sub_maint_aft"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/scrap/maintenance/storage
	name = "\improper Tools Storage"
	icon_state = "engineering_storage"

/area/ship/scrap/maintenance/techstorage
	name = "\improper Parts Storage"
	icon_state = "engineering_supply"

/area/ship/scrap/maintenance/eva
	name = "\improper EVA Storage"
	icon_state = "eva"

/area/ship/scrap/maintenance/engineering
	name = "\improper Engineering Bay"
	icon_state = "engineering_supply"
	req_access = list(access_engine)

/area/ship/scrap/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')
	req_access = list(access_engine)

/area/ship/scrap/maintenance/power
	name = "\improper Power Compartment"
	icon_state = "engine_smes"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/scrap/maintenance/engine
	icon_state = "engine"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/scrap/maintenance/engine/aft
	name = "\improper Main Engine Bay"

/area/ship/scrap/maintenance/engine/port
	name = "\improper Port Thruster"

/area/ship/scrap/maintenance/engine/starboard
	name = "\improper Starboard Thruster"

/area/ship/scrap/command/hallway
	name = "\improper Command Deck"
	icon_state = "centcom"
	req_access = list(access_heads)

/area/ship/scrap/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	req_access = list(access_heads)

/area/ship/scrap/command/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain"
	req_access = list(access_captain)

/area/ship/scrap/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')

/area/ship/scrap/shuttle/outgoing
  name = "\improper Exploration Shuttle"
  icon_state = "tcomsatcham"

/area/ship/scrap/shuttle/lift
  name = "\improper Cargo Lift"
  icon_state = "shuttle3"
  base_turf = /turf/simulated/open

/area/ship/scrap/shuttle/lift/alert_on_fall(var/mob/living/carbon/human/H)
	if(H.client && SSpersistence.elevator_fall_shifts > 0)
		SSwebhooks.send(WEBHOOK_ELEVATOR_FALL, list("text" = "We managed to make it [SSpersistence.elevator_fall_shifts] shift\s without someone falling down an elevator shaft."))
		SSpersistence.elevator_fall_shifts = -1

/area/ship/scrap/maintenance/solars
  name = "\improper Solar Array Access"
  icon_state = "SolarcontrolA"

/area/ship/scrap/maintenance/robot
  name = "\improper Robot Storage"
  icon_state = "ai_cyborg"