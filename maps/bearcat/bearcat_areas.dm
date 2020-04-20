/area/ship/bearcat
	name = "\improper Bearcat Base Area"

/area/ship/bearcat/crew
	name = "\improper Crew Compartements"
	icon_state = "crew_quarters"

/area/ship/bearcat/crew/hallway/port
	name = "\improper Crew Hallway - Port"

/area/ship/bearcat/crew/hallway/starboard
	name = "\improper Crew Hallway - Starboard"

/area/ship/bearcat/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/bearcat/crew/cryo
	name = "\improper Cryo Storage"
	icon_state = "cryo"

/area/ship/bearcat/crew/dorms1
	name = "\improper Crew Cabin #1"
	icon_state = "green"

/area/ship/bearcat/crew/dorms2
	name = "\improper Crew Cabin #2"
	icon_state = "purple"

/area/ship/bearcat/crew/dorms3
	name = "\improper Crew Cabin #3"
	icon_state = "yellow"

/area/ship/bearcat/crew/saloon
	name = "\improper Saloon"
	icon_state = "conference"

/area/ship/bearcat/crew/toilets
	name = "\improper Bathrooms"
	icon_state = "toilet"
	turf_initializer = /decl/turf_initializer/maintenance

/area/ship/bearcat/crew/wash
	name = "\improper Washroom"
	icon_state = "locker"

/area/ship/bearcat/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/ship/bearcat/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"

/area/ship/bearcat/cargo/lower
	name = "\improper Lower Cargo Hold"

/area/ship/bearcat/dock
	name = "\improper Docking Bay"
	icon_state = "entry_1"

/area/ship/bearcat/garden
	name = "\improper Garden"
	icon_state = "green"

/area/ship/bearcat/unused
	name = "\improper Compartment 2-B"
	icon_state = "yellow"
	turf_initializer = /decl/turf_initializer/maintenance
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/ship/bearcat/hidden
	name = "\improper Unknown" //shielded compartment
	icon_state = "auxstorage"

/area/ship/bearcat/escape_port
	name = "\improper Port Escape Pods"
	icon_state = "green"

/area/ship/bearcat/escape_star
	name = "\improper Starboard Escape Pods"
	icon_state = "yellow"

/area/ship/bearcat/broken1
	name = "\improper Robotic Maintenance"
	icon_state = "green"

/area/ship/bearcat/broken2
	name = "\improper Compartment 1-B"
	icon_state = "yellow"

/area/ship/bearcat/gambling
	name = "\improper Compartment 1-C"
	icon_state = "cave"

/area/ship/bearcat/maintenance
	name = "\improper Maintenance Compartments"
	icon_state = "amaint"

/area/ship/bearcat/maintenance/hallway
	name = "\improper Maintenance Corridors"

/area/ship/bearcat/maintenance/lower
	name = "\improper Lower Deck Maintenance Compartments"
	icon_state = "sub_maint_aft"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/bearcat/maintenance/storage
	name = "\improper Tools Storage"
	icon_state = "engineering_storage"

/area/ship/bearcat/maintenance/techstorage
	name = "\improper Parts Storage"
	icon_state = "engineering_supply"

/area/ship/bearcat/maintenance/eva
	name = "\improper EVA Storage"
	icon_state = "eva"

/area/ship/bearcat/maintenance/engineering
	name = "\improper Engineering Bay"
	icon_state = "engineering_supply"
	req_access = list(access_engine)

/area/ship/bearcat/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')
	req_access = list(access_engine)

/area/ship/bearcat/maintenance/power
	name = "\improper Power Compartment"
	icon_state = "engine_smes"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/bearcat/maintenance/engine
	icon_state = "engine"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	req_access = list(access_engine)

/area/ship/bearcat/maintenance/engine/aft
	name = "\improper Main Engine Bay"

/area/ship/bearcat/maintenance/engine/port
	name = "\improper Port Thruster"

/area/ship/bearcat/maintenance/engine/starboard
	name = "\improper Starboard Thruster"

/area/ship/bearcat/command/hallway
	name = "\improper Command Deck"
	icon_state = "centcom"
	req_access = list(access_heads)

/area/ship/bearcat/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	req_access = list(access_heads)

/area/ship/bearcat/command/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain"
	req_access = list(access_captain)

/area/ship/bearcat/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')

/area/ship/bearcat/shuttle/outgoing
  name = "\improper Exploration Shuttle"
  icon_state = "tcomsatcham"

/area/ship/bearcat/shuttle/lift
  name = "\improper Cargo Lift"
  icon_state = "shuttle3"
  base_turf = /turf/simulated/open