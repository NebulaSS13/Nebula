/////////////////////////////////////////////////////
//Direction Signs
/////////////////////////////////////////////////////

///Signs for showing the way to passerby. The dir of the sign is the direction it points towards. The icon of the sign itself is always south facing.
/obj/structure/sign/directions
	name               = "direction sign"
	desc               = "A direction sign, claiming to know the way."
	icon               = 'icons/obj/signs/directions.dmi'
	icon_state         = "direction"
	//Direction signs are always meant to face south! The arrow on the sign matches the direction it points to.
	directional_offset = @'{"NORTH":{"y":32}, "SOUTH":{"y":32}, "WEST":{"y":32}, "EAST":{"y":32}}'

/obj/structure/sign/directions/update_description()
	desc = "A direction sign, pointing out \the [name] is [global.dir_name(dir)]."

/////////////////////////////////////////////////////
//Direction Signs Definition
/////////////////////////////////////////////////////

/obj/structure/sign/directions/science
	name       = "\improper Research Division"
	icon_state = "direction_sci"

/obj/structure/sign/directions/science/xeno
	name       = "\improper Xenobiology"
	icon_state = "direction_xeno"

/obj/structure/sign/directions/science/xenoarch
	name       = "\improper Xenoarchaeology"
	icon_state = "direction_xenoarch"

/obj/structure/sign/directions/science/xenoflora
	name       = "\improper Xenoflora"
	icon_state = "direction_xflora"

/obj/structure/sign/directions/science/xenobiology
	icon_state = "direction_xbio"

/obj/structure/sign/directions/science/exploration
	name       = "\improper Exploration"
	icon_state = "direction_explo"

/obj/structure/sign/directions/science/toxins
	name       = "\improper Toxins"
	icon_state = "direction_toxins"

/obj/structure/sign/directions/science/robotics
	name       = "\improper Robotics"
	icon_state = "direction_robotics"

/obj/structure/sign/directions/science/rnd
	name       = "\improper Research and Development"
	icon_state = "direction_rnd"

/obj/structure/sign/directions/engineering
	name       = "\improper Engineering Bay"
	icon_state = "direction_eng"

/obj/structure/sign/directions/engineering/solars
	name       = "\improper Solar Array"
	icon_state = "direction_solar"

/obj/structure/sign/directions/engineering/engeqp
	name       = "\improper Engineering Equipment"
	icon_state = "direction_engeqp"

/obj/structure/sign/directions/engineering/reactor
	name       = "\improper Reactor Core"
	icon_state = "direction_core"

/obj/structure/sign/directions/engineering/atmospherics
	name       = "\improper Atmospherics"
	icon_state = "direction_atmos"

/obj/structure/sign/directions/cargo
	name       = "\improper Cargo"
	icon_state = "direction_crg"

/obj/structure/sign/directions/cargo/supply
	name       = "\improper Supply Office"
	icon_state = "direction_supply"

/obj/structure/sign/directions/cargo/mining
	name       = "\improper Mining"
	icon_state = "direction_mining"

/obj/structure/sign/directions/cargo/refinery
	name       = "\improper Refinery"
	icon_state = "direction_refinery"

/obj/structure/sign/directions/security
	name       = "\improper Security Wing"
	icon_state = "direction_sec"

/obj/structure/sign/directions/security/interrogation
	name       = "\improper Interrogation"
	icon_state = "direction_interrogation"

/obj/structure/sign/directions/security/internal_affairs
	name       = "\improper Internal Affairs"
	icon_state = "direction_intaff"

/obj/structure/sign/directions/security/forensics
	name       = "\improper Forensics"
	icon_state = "direction_forensics"

/obj/structure/sign/directions/security/forensics/alt
	name       = "\improper Forensics Laboratory"
	icon_state = "direction_lab"

/obj/structure/sign/directions/security/brig
	name       = "\improper Security Brig"
	icon_state = "direction_brig"

/obj/structure/sign/directions/security/armory
	name       = "\improper Security Armory"
	icon_state = "direction_armory"

/obj/structure/sign/directions/security/seceqp
	name       = "\improper Security Equipment"
	icon_state = "direction_seceqp"

/obj/structure/sign/directions/medical
	name       = "\improper Medical Bay"
	icon_state = "direction_med"

/obj/structure/sign/directions/medical/morgue
	name       = "\improper Morgue"
	icon_state = "direction_morgue"

/obj/structure/sign/directions/medical/equipment
	name       = "\improper Medical Equipment"
	icon_state = "direction_medeqp"

/obj/structure/sign/directions/medical/virology
	name       = "\improper Virology"
	icon_state = "direction_viro"

/obj/structure/sign/directions/medical/surgery
	name       = "\improper Surgery"
	icon_state = "direction_surgery"

/obj/structure/sign/directions/medical/operating_1
	name       = "\improper Operating Theatre 1"
	icon_state = "direction_op1"

/obj/structure/sign/directions/medical/operating_2
	name       = "\improper Operating Theatre 2"
	icon_state = "direction_op2"

/obj/structure/sign/directions/medical/cloning
	name       = "\improper Cloning"
	icon_state = "direction_cloning"

/obj/structure/sign/directions/medical/resleeve
	name       = "\improper Resleeving"
	icon_state = "direction_resleeve"

/obj/structure/sign/directions/medical/chemlab
	name       = "\improper Chemistry Laboratory"
	icon_state = "direction_chemlab"

/obj/structure/sign/directions/evac
	name       = "\improper Evacuation Wing"
	icon_state = "direction_evac"

/obj/structure/sign/directions/bridge
	name       = "\improper Bridge"
	icon_state = "direction_bridge"

/obj/structure/sign/directions/infirmary
	name       = "\improper Infirmary"
	icon_state = "direction_infirm"

/obj/structure/sign/directions/pods
	name       = "\improper Escape Pods"
	icon_state = "direction_pods"

/obj/structure/sign/directions/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "direction_cryo"

/obj/structure/sign/directions/elevator
	name       = "\improper Elevator"
	icon_state = "direction_elv"

/obj/structure/sign/directions/command
	name       = "\improper Command"
	icon_state = "direction_command"

/obj/structure/sign/directions/dorms
	name       = "\improper Dormitories"
	icon_state = "direction_dorms"

/obj/structure/sign/directions/teleporter
	name       = "\improper Teleporter"
	icon_state = "direction_teleport"

/obj/structure/sign/directions/roomnum
	name       = "\improper Private Room"
	icon_state = "direction_roomnum" // TODO: move this to signs.dmi or something.

/obj/structure/sign/directions/recreation
	name       = "\improper Recreation"
	icon_state = "direction_recreation"

/obj/structure/sign/directions/pool
	name       = "\improper Pool"
	icon_state = "direction_pool"

/obj/structure/sign/directions/janitor
	name       = "\improper Custodial Office"
	icon_state = "direction_janitor"

/obj/structure/sign/directions/eva
	name       = "\improper EVA"
	icon_state = "direction_eva"

/obj/structure/sign/directions/bar
	name       = "\improper Bar"
	icon_state = "direction_bar"

/obj/structure/sign/directions/ai_core
	name       = "\improper AI Core"
	icon_state = "direction_ai_core"

/obj/structure/sign/directions/gravity
	name       = "\improper Gravity Management"
	icon_state = "direction_grav"

/obj/structure/sign/directions/telecomms
	name       = "\improper Telecommunications"
	icon_state = "direction_tcomms"

/obj/structure/sign/directions/kitchen
	name       = "\improper Kitchen"
	icon_state = "direction_kitchen"

/obj/structure/sign/directions/tram
	name       = "\improper Transit"
	icon_state = "direction_tram"

/obj/structure/sign/directions/chapel
	name       = "\improper Chapel"
	icon_state = "direction_chapel"

/obj/structure/sign/directions/library
	name       = "\improper Library"
	icon_state = "direction_library"

/obj/structure/sign/directions/dock
	name       = "\improper Dock"
	icon_state = "direction_dock"

/obj/structure/sign/directions/gym
	name       = "\improper Gymnasium"
	icon_state = "direction_gym"

/obj/structure/sign/directions/exit
	name       = "\improper Emergency Exit"
	icon_state = "exit_sign"

/obj/structure/sign/directions/stairs
	name       = "\improper Stairwell"
	icon_state = "stairwell"

/obj/structure/sign/directions/stairs/up
	icon_state = "stairs_up"

/obj/structure/sign/directions/stairs/down
	icon_state = "stairs_down"

/obj/structure/sign/directions/ladder
	name       = "\improper Ladder"
	icon_state = "ladderwell"

/obj/structure/sign/directions/ladder/up
	icon_state = "ladder_up"

/obj/structure/sign/directions/ladder/down
	icon_state = "ladder_down"
