/area/fairpoint
	name = "Fairpoint"
	icon_state = "grey"
	sound_env = CITY
	requires_power = FALSE
	always_unpowered = FALSE
	base_turf = /turf/exterior/dirt
	open_turf = /turf/exterior/dirt

/area/fairpoint/street
	name = "Downtown Street"
	icon_state = "green"
	sound_env = ALLEY

/area/fairpoint/street/west
	name = "Downtown West"
	icon_state = "green"
	sound_env = ALLEY

/area/fairpoint/street/north
	name = "Downtown North"
	icon_state = "green"
	sound_env = ALLEY

/area/fairpoint/street/east
	name = "Downtown East"
	icon_state = "green"
	sound_env = ALLEY

/area/fairpoint/street/outskirts
	name = "Downtown Outskirts"
	icon_state = "green"

// SUPPLY SHUTTLE
/area/fairpoint/supply_shuttle_dock
	name = "Supply Shuttle Dock"
	icon_state = "yellow"
	base_turf = /turf/simulated/floor/plating //Needed for shuttles
	open_turf = /turf/exterior/dirt
	req_access = list(access_cargo)
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_EXTERNAL

//COMMAND.

/area/fairpoint/cityhall
	name = "\improper City Hall"
	icon_state = "bridge"
	req_access = list(access_bridge)

/area/fairpoint/cityhall/meeting_room
	name = "\improper City Council Meeting Room"
	icon_state = "bridge"
	sound_env = MEDIUM_SOFTFLOOR

/area/fairpoint/panicroom
	name = "\improper City Hall Panic Room"
	icon_state = "bridge"
	req_access = list(access_bridge)

//CAPTAIN'S QUARTERS.

/area/fairpoint/crew_quarters/mayor
	name = "\improper City Hall - Mayor's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)

//COMMAND QUARTERS.


/area/fairpoint/engineering/ce
	name = "\improper Maintenance - Director' Office"
	req_access = list(access_ce)

/area/fairpoint/engineering/sysadmin
	name = "\improper Maintenance | City Hall - System Administrator's Office"
	req_access = list(access_ce)

/area/fairpoint/police/cop
	name = "\improper Police - CoP's Office"
	req_access = list(access_hos)

/area/fairpoint/cityhall/hop
	name = "\improper City Hall - Clerk's Office"
	req_access = list(access_hop)

/area/fairpoint/science/rd
	name = "\improper Research - RD's Office"
	req_access = list(access_rd)

/area/fairpoint/medical/cmo
	name = "\improper Hospital - Director's Office"
	req_access = list(access_cmo)

//TCOMS.

/area/fairpoint/maintenance/telecomms
	name = "Telecommunications Array"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_tcomsat)


//STORAGE.

/area/fairpoint/engineering/tech
	name = "Technical Storage"
	icon_state = "storage"
	req_access = list(access_tech_storage)

//ENGINEERING.

/area/fairpoint/engineering
	name = "\improper Maintenance"
	icon_state = "engineering"
	ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')
	req_access = list(access_engine)

//Generic
/area/fairpoint/engineering/foyer
	name = "\improper Maintenance Team Foyer"
	icon_state = "engineering_foyer"

/area/fairpoint/engineering/locker_room
	name = "\improper Maintenance Team Locker Room"
	icon_state = "engineering_locker"

/area/fairpoint/engineering/storage
	name = "\improper Maintenance Team Storage"
	icon_state = "engineering_storage"


//Monitoring and misc

/area/fairpoint/engineering/break_room
	name = "\improper Maintenance Team Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/fairpoint/engineering/drone_fabrication
	name = "\improper Maintenance Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/fairpoint/engineering/workshop
	name = "\improper Maintenance Workshop"
	icon_state = "engineering_workshop"

/area/fairpoint/engineering/sublevel_access
	name = "\improper Maintenance Sewer Access"


//MEDICAL.

/area/fairpoint/medical
	req_access = list(access_medical)

//Reception and such

/area/fairpoint/medical/reception
	name = "\improper Hospital Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

//Hallways

/area/fairpoint/medical/medbay
	name = "\improper Hospital Interior"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

//Main

/area/fairpoint/medical/chemistry
	name = "\improper Pharmacy"
	icon_state = "chem"
	req_access = list(access_chemistry)

/area/fairpoint/medical/morgue
	name = "\improper Hospital Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')
	req_access = list(access_morgue)

/area/fairpoint/medical/sleeper
	name = "\improper Emergency Treatment Centre"
	icon_state = "exam_room"

//Surgery

/area/fairpoint/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"

/area/fairpoint/medical/surgery2
	name = "\improper Operating Theatre 2"
	icon_state = "surgery"

/area/fairpoint/medical/surgeryobs
	name = "\improper Operation Observation Room"
	icon_state = "surgery"

/area/fairpoint/medical/surgeryprep
	name = "\improper Pre-Op Prep Room"
	icon_state = "surgery"

//Cryo

/area/fairpoint/medical/cryo
	name = "\improper Hospital Sleepers"
	icon_state = "cryo"

/area/fairpoint/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

//Misc

/area/fairpoint/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_psychiatrist)

/area/fairpoint/crew_quarters/medbreak
	name = "\improper Hospital Break Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_medical)

/area/fairpoint/medical/biostorage
	name = "\improper Hospital Storage"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

//Patient wing

/area/fairpoint/medical/patient_a
	name = "\improper Isolation A"
	icon_state = "patients"

/area/fairpoint/medical/patient_b
	name = "\improper Isolation B"
	icon_state = "patients"

/area/fairpoint/medical/patient_c
	name = "\improper Isolation C"
	icon_state = "patients"

/area/fairpoint/medical/patient_wing
	name = "\improper Patient Wing"
	icon_state = "patients"

/area/fairpoint/medical/patient_wing/washroom
	name = "\improper Patient Wing Washroom"
	req_access = list()

/area/fairpoint/medical/ward
	name = "\improper Recovery Ward"
	icon_state = "patients"

// Virology

/area/fairpoint/medical/virology
	name = "\improper Virology"
	icon_state = "virology"
	req_access = list(access_virology)


//RESEARCH. UNTOUCHED FOR NOW, PENDING DIRECTION FOR THEME

/area/fairpoint/research
	name = "\improper Research and Development"
	icon_state = "research"
	req_access = list(access_research)

//Labs

/area/fairpoint/research/lab
	name = "\improper Research Lab"
	icon_state = "toxlab"

/area/fairpoint/research/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "toxmisc"

/area/fairpoint/research/xenobiology
	name = "\improper Xenobiology Lab"
	icon_state = "xeno_lab"
	req_access = list(access_xenobiology, access_research)

/area/fairpoint/research/xenobiology/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/fairpoint/research/xenobiology/xenoflora_storage
	name = "\improper Xenoflora Storage"
	icon_state = "xeno_f_store"

//Robotics

/area/fairpoint/research/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"
	req_access = list(access_robotics)

/area/fairpoint/research/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"
	req_access = list(access_robotics)

//Misc

/area/fairpoint/research/docking
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/fairpoint/research/server
	name = "\improper Research Server Room"
	icon_state = "server"
	req_access = list(access_rd)

//SECURITY.

/area/fairpoint/police
	name = "\improper Police Station"
	area_flags = AREA_FLAG_SECURITY
	req_access = list(access_security)

//Lobby and such

/area/fairpoint/police/lobby
	name = "\improper Precinct Lobby"
	icon_state = "security"
	req_access = list()

//Main

/area/fairpoint/police/main
	name = "\improper PD Office"
	icon_state = "security"

/area/fairpoint/police/meeting
	name = "\improper Police Station Meeting Room"
	icon_state = "security"

/area/fairpoint/police/checkpoint
	name = "\improper PD - Checkpoint"
	icon_state = "checkpoint1"

//Warden and such

/area/fairpoint/police/armoury
	name = "\improper PD - Armory"
	icon_state = "Warden"
	req_access = list(access_armory)

/area/fairpoint/police/tactical
	name = "\improper PD - Tactical Equipment"
	icon_state = "Tactical"
	req_access = list(access_armory)

/area/fairpoint/police/warden
	name = "\improper PD - Watch Officer's Office"
	icon_state = "Warden"
	req_access = list(access_armory)

//Brig

/area/fairpoint/police/brig
	name = "\improper PD - Cells"
	req_access = list(access_brig)

/area/fairpoint/police/brig/processing
	name = "\improper PD - Processing"
	icon_state = "brig"

/area/fairpoint/police/brig/interrogation
	name = "\improper PD - Interrogation"
	icon_state = "brig"

/area/fairpoint/police/brig/solitaryA
	name = "\improper PD - Solitary 1"
	icon_state = "sec_prison"

/area/fairpoint/police/brig/solitaryB
	name = "\improper PD - Solitary 2"
	icon_state = "sec_prison"

//Prison

/area/fairpoint/police/prison
	name = "\improper PD - Prison Wing"
	icon_state = "sec_prison"
	req_access = list(access_brig)
	area_flags = AREA_FLAG_PRISON

/area/fairpoint/police/prison/restroom
	name = "\improper PD - Prison Wing Restroom"
	icon_state = "sec_prison"

/area/fairpoint/police/prison/dorm
	name = "\improper PD - Prison Wing Dormitory"
	icon_state = "sec_prison"

//Misc

/area/fairpoint/police/detectives_office
	name = "\improper PD - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_forensics_lockers)

/area/fairpoint/police/vault
	name = "\improper Secure Vault"
	icon_state = "nuke_storage"
	req_access = list(access_heads_vault)

/area/fairpoint/police/vacantoffice
	name = "\improper PD Locker Room"
	icon_state = "security"
	req_access = list()

/area/fairpoint/police/range
	name = "\improper PD - Firing Range"
	icon_state = "firingrange"

//CARGO.

/area/fairpoint/shipping
	name = "\improper Shipping"
	icon_state = "quart"
	req_access = list(access_cargo)

/area/fairpoint/shipping/office
	name = "\improper Shipping Office"
	icon_state = "quartoffice"
	req_access = list(list(access_cargo, access_mining))

/area/fairpoint/shipping/storage
	name = "\improper Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/fairpoint/shipping/miningdock
	name = "\improper Shipping Mining Access"
	icon_state = "mining"
	req_access = list(access_mining)

//qm

/area/fairpoint/shipping/qm
	name = "\improper Shipping - Manager's Office"
	icon_state = "quart"
	req_access = list(access_qm)

//CREW.

/area/fairpoint/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/fairpoint/crew_quarters/sleep
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/fairpoint/crew_quarters/sleep/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"

/area/fairpoint/crew_quarters/sleep/engi_wash
	name = "\improper Maintenance Washroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/fairpoint/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/fairpoint/crew_quarters/locker/locker_toilet
	name = "\improper Locker Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/fairpoint/crew_quarters/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/fairpoint/crew_quarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/fairpoint/library
	name = "\improper Library"
	icon_state = "library"
	sound_env = LARGE_SOFTFLOOR


//Service and such

/area/fairpoint/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"
	req_access = list(access_kitchen, access_bar)

/area/fairpoint/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/fairpoint/crew_quarters/bar/cabin
	name = "\improper Bartender's Room"
	req_access = list(access_bar)

/area/fairpoint/janitor
	name = "\improper Custodial Closet"
	icon_state = "janitor"
	req_access = list(access_janitor)

/area/fairpoint/hydroponics
	name = "\improper Farm - Hydroponics Room"
	icon_state = "hydro"
	req_access = list(access_hydroponics)

/area/fairpoint/hydroponics/garden
	name = "\improper Farm"
	icon_state = "garden"
	req_access = list()

/area/fairpoint/chapel
	area_flags = AREA_FLAG_HOLY

/area/fairpoint/chapel/main
	name = "\improper Church"
	icon_state = "chapel"
	sound_env = LARGE_ENCLOSED
	ambience = list(
		'sound/ambience/ambicha1.ogg',
		'sound/ambience/ambicha2.ogg',
		'sound/ambience/ambicha3.ogg',
		'sound/ambience/ambicha4.ogg',
		'sound/music/traitor.ogg'
	)

/area/fairpoint/chapel/office
	name = "\improper Church Office"
	icon_state = "chapeloffice"
	req_access = list(access_chapel_office)

/area/fairpoint/law
	name = "\improper Courtroom"
	icon_state = "law"
	req_access = list()

/area/fairpoint/law/lawoffice
	name = "\improper Legal Offices"
	icon_state = "law"
	req_access = list(access_lawyer)

/area/fairpoint/law/judge
	name = "\improper Judge Office"
	icon_state = "law"
	req_access = list(access_heads)

//MESSAGING SERVER ROOM

/area/fairpoint/turret_protected/ai_server_room
	name = "Communications and Server Rooms"
	icon_state = "ai_server"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_tcomsat)

//SHUTTLE.

/area/shuttle/arrival
	name = "\improper Arrival Train"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape_shuttle
	name = "\improper Evacuation Train"


//MAINTENANCE.

/area/fairpoint/maintenance
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = /decl/turf_initializer/maintenance
	forced_ambience = list('sound/ambience/maintambience.ogg')
	req_access = list(access_maint_tunnels)

/area/fairpoint/maintenance/arrivals
	name = "\improper Sewers"
	icon_state = "maint_arrivals"

/area/fairpoint/maintenance/bar
	name = "\improper Bar Maintenance"
	icon_state = "maint_bar"
	req_access = list(list(access_bar, access_kitchen, access_maint_tunnels))

/area/fairpoint/maintenance/cargo
	name = "\improper Cargo Maintenance"
	icon_state = "maint_cargo"
	req_access = list(list(access_cargo, access_maint_tunnels))

/area/fairpoint/maintenance/dormitory
	name = "\improper Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/fairpoint/maintenance/library
	name = "\improper Library Maintenance"
	icon_state = "maint_library"
	req_access = list(list(access_library, access_maint_tunnels))

/area/fairpoint/maintenance/hospital
	name = "\improper Hospital Maintenance"
	icon_state = "maint_medbay"
	req_access = list(list(access_medical, access_maint_tunnels))

/area/fairpoint/maintenance/research_port
	name = "\improper Research Maintenance"
	icon_state = "maint_research_port"

/area/fairpoint/maintenance/research_starboard
	name = "\improper Research Maintenance - Starboard"
	icon_state = "maint_research_starboard"

/area/fairpoint/maintenance/police
	name = "\improper Precinct Maintenance"
	icon_state = "maint_security_starboard"

//MISC. MAINTENANCE.

/area/fairpoint/maintenance/surface
	name = "\improper Surface Maintenance"
	icon_state = "maint_security_starboard"
	turf_initializer = /decl/turf_initializer/maintenance
	req_access = list(access_maint_tunnels)

/area/fairpoint/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/fairpoint/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

//SUBLEVEL MAINTENANCE.

/area/fairpoint/maintenance/sub
	turf_initializer = /decl/turf_initializer/maintenance/heavy
	ambience = list(
		'sound/ambience/ambiatm1.ogg',
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
		'sound/ambience/ambimine.ogg',
		'sound/ambience/ambimo2.ogg',
		'sound/ambience/ambisin4.ogg',
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
	)

/////////////
//ELEVATORS//
/////////////

/area/turbolift/sewer_exit
	name = "Sewer Access - Maintenance"
	lift_announce_str = "Exiting Sewers"

/area/turbolift/sewer_entrance
	name = "Sewer Access - Maintenance"
	lift_announce_str = "Arriving at the sewer access level"
	base_turf = /turf/simulated/floor/plating

/area/turbolift/sewer_exit/mining
	name = "Sewer Access - Mining Surface"
	lift_announce_str = "Ascending from the sewers, mining access."

/area/turbolift/sewer_entrance/mining
	name = "Sewer Access - Mining Sewers"
	lift_announce_str = "Descending to the Sewers, mining access"
	base_turf = /turf/simulated/floor/plating

/area/turbolift/metro_station
	name = "Metro Station - Surface"
	lift_announce_str = "Arriving at the Fairpoint Downtown Metro Station, surface level."

/area/turbolift/metro_maintenance
	name = "Metro Station - Underground"
	lift_announce_str = "Arriving at the Fairpoint Downtown Metro Station, underground level."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/pd_ground
	name = "Police Station - Ground Floor"
	lift_announce_str = "Now arriving at: Station Main, Floor One."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/pd_top
	name = "Police Station - Top Floor"
	lift_announce_str = "Now arriving at: Prison Wing and Senior Staff Wing, Floor Two."

/area/turbolift/hospital_top
	name = "Hospital - Top Floor"
	lift_announce_str = "Now arriving at: Psychiatric Wing, Storage and Offices, Floor Two."

/area/turbolift/hospital_surface
	name = "Hospital - Ground Floor"
	lift_announce_str = "Now arriving at: Hospital Main, Ground Floor."

/area/turbolift/hospital_sewers
	name = "Hospital - Morgue"
	lift_announce_str = "Now arriving at: Morgue, Recovery and Cold Storage, Basement."
	base_turf = /turf/simulated/floor/plating


/////////////////
//ELEVATORS END//
/////////////////

//HALLWAYS.

/area/fairpoint/hallway/secondary/exit
	name = "\improper Metro Station"
	icon_state = "escape"


/area/shuttle/supply_shuttle
	name = "Supply Barge"
	icon_state = "shuttle3"
	req_access = list(access_cargo)

/area/shuttle/escape_shuttle
	name = "\improper Evacuation Train"
	icon_state = "shuttle"
