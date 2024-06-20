/datum/event/prison_break/medical
	areaType = list(/area/ministation/medical)

/datum/event/prison_break/science
	areaType = list(/area/ministation/science)

/datum/event/prison_break/station
	areaType = list(/area/ministation/security)

/area/ministation
	name = "\improper Ministation"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')
	icon = 'maps/ministation/ministation_areas.dmi'
	icon_state = "default"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/ministation/supply_dock
	name = "Supply Shuttle Dock"
	icon_state = "yellow"
	base_turf = /turf/space
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/ministation/supply
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	req_access = list(access_cargo)
	requires_power = 0
	holomap_color = HOLOMAP_AREACOLOR_CARGO

//Hallways
/area/ministation/hall
	icon_state = "white"
	area_flags = AREA_FLAG_HALLWAY
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/ministation/hall/n
	name = "\improper Forward Hallway"

// first floor hallways

/area/ministation/hall/s1
	name = "\improper L1 Aft Hallway"

//  second floor hallways

/area/ministation/hall/w2
	name = "\improper L2 Port Hallway"

/area/ministation/hall/e2
	name = "\improper L2 Starboard Hallway"

// third floor hallways

/area/ministation/hall/s3
	name = "\improper L3 Aft Hallway"

/area/ministation/hall/n3
	name = "\improper L3 Forward Hallway"

//Maintenance
/area/ministation/maint
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_MAINTENANCE
	req_access = list(access_maint_tunnels)
	turf_initializer = /decl/turf_initializer/maintenance
	icon_state = "orange"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MAINTENANCE

// First floor maint

/area/ministation/maint/westatmos
	name = "\improper West Atmos Maintenance"

/area/ministation/maint/eastatmos
	name = "\improper East Atmos Maintenance"

// /area/ministation/maint/l1nw
//	name = "\improper Level One North West Maintenance"

/area/ministation/maint/l1ne
	name = "\improper Level One North East Maintenance"

/area/ministation/maint/l1central
	name = "\improper Level One Central Maintenance"

// Second Floor Maint

/area/ministation/maint/l2centraln
	name = "\improper Level Two Central North Maintenance"

/area/ministation/maint/l2centrals
	name = "\improper Level Two Central South Maintenance"

/area/ministation/maint/secmaint
	name = "\improper Security Maintenance"

/area/ministation/maint/hydromaint
	name = "\improper Hydro Maintenance"

/area/ministation/maint/l2underpass
	name = "\improper Level Two Maintenance Underpass"

// Third Floor Maint

/area/ministation/maint/l3nw
	name = "\improper Level Three Northwest Maintenance"

/area/ministation/maint/l3ne
	name = "\improper Level Three Northeast Maintenance"

/area/ministation/maint/l3central
	name = "\improper Level Three Central Maintenance"

/area/ministation/maint/l3sw
	name = "\improper Level Three Southwest Maintenance"

/area/ministation/maint/l3se
	name = "\improper Level Three Southeast Maintenance"

// Fourth Floor Maint
/area/ministation/maint/l4central
	name = "\improper Level Four Central Maintenance"

/area/ministation/maint/l4overpass
	name = "\improper Level Four Maintenance Overpass"

//Maint Bypasses

/area/ministation/maint/sebypass
	name = "\improper Southeast Maintenance Shaft"

/area/ministation/maint/nebypass
	name = "\improper Northeast Maintenance Shaft"

//Departments
/area/ministation/hop
	name = "\improper Lieutenant's Office"
	req_access = list(access_hop)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/janitor
	name = "\improper Custodial Closet"
	req_access = list(access_janitor)
	icon_state = "janitor"

/area/ministation/trash
	name = "\improper Trash Room"
	req_access = list(access_janitor)
	icon_state = "janitor"

/area/ministation/cargo
	name = "\improper Cargo Bay"
	req_access = list(access_mining)
	icon_state = "brown"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/ministation/mining
	name = "\improper Mineral Processing"
	req_access = list(access_mining)
	icon_state = "mining_production"
	secure = TRUE

/area/ministation/bridge
	name = "\improper Bridge"
	req_access = list(access_heads)
	secure = TRUE
	icon_state = "dark_blue"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/ministation/bridge/vault
	name = "\improper Vault"
	req_access = list(access_heads_vault)
	ambience = list()
	icon_state = "green"

/area/ministation/security
	name = "\improper Security Office"
	req_access = list(access_security)
	secure = TRUE
	icon_state = "red"
	area_flags = AREA_FLAG_SECURITY

/area/ministation/detective
	name = "\improper Detective Office"
	req_access = list(access_forensics_lockers)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/court
	name = "\improper Court Room"
	req_access =list(access_lawyer)
	secure = TRUE
	icon_state = "pink"

/area/ministation/library
	name = "\improper Library"
	icon_state = "LIB"

/area/ministation/atmospherics
	name = "\improper Atmospherics"
	req_access = list(access_atmospherics)
	icon_state = "ATMOS"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/science
	name = "\improper Research & Development Laboratory"
	req_access = list(access_robotics)
	secure = TRUE
	icon_state = "purple"

/area/ministation/eva
	name = "\improper EVA Storage"
	req_access = list(access_eva)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/medical
	name = "\improper Infirmary"
	req_access = list(access_medical)
	icon_state = "light_blue"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/ministation/cryo
	name = "\improper Medical Cryogenics"
	req_access = list()
	icon_state = "green"
	secure = FALSE

/area/ministation/dorms
	name = "\improper Dormatories"
	req_access = list()
	icon_state = "red"
	secure = FALSE

/area/ministation/hydro
	name = "\improper Hydroponics"
	req_access = list(access_hydroponics)
	icon_state = "green"

/area/ministation/cafe // no access requirement to get in. inner doors need access kitchen
	name = "\improper Cafeteria"
	icon_state = "red"
	secure = TRUE

/area/ministation/engine
	name = "Engineering"
	req_access = list(access_engine_equip)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "yellow"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/supermatter
	name = "\improper Supermatter Engine"
	req_access = list(access_engine)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "brown"

/area/ministation/smcontrol
	name = "\improper Supermatter Control"
	req_access = list(access_engine)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "red"

/area/ministation/telecomms
	name = "\improper Telecommunications Control"
	req_access = list(list(access_engine),list(access_heads)) //can get inside to monitor but not actually access anything important. Inner doors have tcomm access
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')
	secure = TRUE
	icon_state = "light_blue"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/tradehouse_rep
	name = "\improper Tradehouse Representative Chamber"
	req_access = list(access_lawyer)
	icon_state = "brown"

/area/ministation/arrival
	name = "\improper Arrival Shuttle" // I hate this ugly thing
	icon_state = "white"
	requires_power = 0

/area/ministation/shuttle/outgoing
	name = "\improper Science Shuttle"
	icon_state = "shuttle"

//satellite
/area/ministation/ai_sat
	name = "\improper Satellite"
	secure = TRUE
	turf_initializer = /decl/turf_initializer/maintenance
	icon_state = "brown"

/area/ministation/ai_core
	name = "\improper AI Core"
	req_access = list(access_ai_upload)
	secure = TRUE
	icon_state = "green"

/area/ministation/ai_upload
	name = "\improper AI Upload Control"
	secure = TRUE
	req_access = list(access_ai_upload)
	icon_state = "light_blue"

/area/shuttle/escape_shuttle
	name = "\improper Emergency Shuttle"
	icon_state = "shuttle"

//Elevator

/area/turbolift
	name = "\improper Elevator"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = TRUE
	sound_env = STANDARD_STATION
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	ambience = list(
		'sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg'
	)

	arrival_sound = null
	lift_announce_str = null

/area/turbolift/alert_on_fall(var/mob/living/human/H)
	if(H.client && SSpersistence.elevator_fall_shifts > 0)
		SSwebhooks.send(WEBHOOK_ELEVATOR_FALL, list("text" = "We managed to make it [SSpersistence.elevator_fall_shifts] shift\s without someone falling down an elevator shaft."))
		SSpersistence.elevator_fall_shifts = -1

/area/turbolift/l1
	name = "Station Level 1"
	base_turf = /turf/floor

/area/turbolift/l2
	name = "Station Level 2"
	base_turf = /turf/open

/area/turbolift/l3
	name = "Station Level 3"
	base_turf = /turf/open