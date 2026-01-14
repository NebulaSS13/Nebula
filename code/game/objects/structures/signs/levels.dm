/obj/structure/sign/levels
	icon               = 'icons/obj/signs/levels.dmi'
	icon_state         = "level"
	//Level signs are always meant to face south! The arrow on the sign matches the direction it points to.
	directional_offset = @'{"NORTH":{"y":32}, "SOUTH":{"y":32}, "WEST":{"y":32}, "EAST":{"y":32}}'

/obj/structure/sign/levels/update_description()
	desc = "A sign indicating your position within \the [name]."

/obj/structure/sign/levels/engineering
	name               = "\improper Engineering"
	icon_state         = "level_eng"

/obj/structure/sign/levels/engineering/core
	name               = "\improper Reactor Core"
	icon_state         = "level_core"

/obj/structure/sign/levels/engineering/solar
	name               = "\improper Solar Array"
	icon_state         = "level_solar"

/obj/structure/sign/levels/engineering/atmos
	name               = "\improper Atmospherics"
	icon_state         = "level_atmos"

/obj/structure/sign/levels/engineering/gravity
	name               = "\improper Gravity Control"
	icon_state         = "level_grav"

/obj/structure/sign/levels/engineering/equipment
	name               = "\improper Engineering Equipment"
	icon_state         = "level_engeqp"

/obj/structure/sign/levels/medical
	name               = "\improper Medical"
	icon_state         = "level_med"

/obj/structure/sign/levels/medical/virology
	name               = "\improper Virology"
	icon_state         = "level_viro"

/obj/structure/sign/levels/medical/morgue
	name               = "\improper Morgue"
	icon_state         = "level_morgue"

/obj/structure/sign/levels/medical/surgery
	name               = "\improper Surgery"
	icon_state         = "level_surgery"

/obj/structure/sign/levels/medical/cloning
	name               = "\improper Cloning"
	icon_state         = "level_cloning"

/obj/structure/sign/levels/medical/resleeve
	name               = "\improper Resleeving"
	icon_state         = "level_resleeve"

/obj/structure/sign/levels/medical/chemlab
	name               = "\improper Chemistry"
	icon_state         = "level_chemlab"

/obj/structure/sign/levels/medical/equipment
	name               = "\improper Medical Equipment"
	icon_state         = "level_medeqp"

/obj/structure/sign/levels/medical/operating_1
	name               = "\improper Operating Theatre 1"
	icon_state         = "level_op1"

/obj/structure/sign/levels/medical/operating_2
	name               = "\improper Operating Theatre 2"
	icon_state         = "level_op2"

/obj/structure/sign/levels/security
	name               = "\improper Security"
	icon_state         = "level_sec"

/obj/structure/sign/levels/security/seceqp
	name               = "\improper Security Equipment"
	icon_state         = "level_seceqp"

/obj/structure/sign/levels/security/interrogation
	name               = "\improper Interrogation"
	icon_state         = "level_interrogation"

/obj/structure/sign/levels/security/forensics
	name               = "\improper Forensics"
	icon_state         = "level_forensics"

/obj/structure/sign/levels/security/brig
	name               = "\improper Security Brig"
	icon_state         = "level_brig"

/obj/structure/sign/levels/security/armory
	name               = "\improper Security Armory"
	icon_state         = "level_armory"

/obj/structure/sign/levels/security/internalaffairs
	name               = "\improper Internal Affairs"
	icon_state         = "level_intaff"

/obj/structure/sign/levels/cryo
	name               = "\improper Cryogenics"
	icon_state         = "level_cry"

/obj/structure/sign/levels/evac
	name               = "\improper Evac Wing"
	icon_state         = "level_evac"

/obj/structure/sign/levels/eva
	name               = "\improper EVA"
	icon_state         = "level_eva"

/obj/structure/sign/levels/command
	name               = "\improper Command"
	icon_state         = "level_command"

/obj/structure/sign/levels/science
	name               = "\improper Research Wing"
	icon_state         = "level_sci"

/obj/structure/sign/levels/science/xenoflora
	name               = "\improper Xenoflora"
	icon_state         = "level_xflora"

/obj/structure/sign/levels/science/xenobiology
	name               = "\improper Xenobiology"
	icon_state         = "level_xbio"

/obj/structure/sign/levels/science/exploration
	name               = "\improper Exploration"
	icon_state         = "level_explo"

/obj/structure/sign/levels/science/robotics
	name               = "\improper Robotics"
	icon_state         = "level_robotics"

/obj/structure/sign/levels/science/toxins
	name               = "\improper Toxins"
	icon_state         = "level_toxins"

/obj/structure/sign/levels/science/xenoarch
	name               = "\improper Xenoarchaeology"
	icon_state         = "level_xenoarch"

/obj/structure/sign/levels/science/rnd
	name               = "\improper Research and Development"
	icon_state         = "level_rnd"

/obj/structure/sign/levels/dorms
	name               = "\improper Dormitories"
	icon_state         = "level_dorms"

/obj/structure/sign/levels/cargo
	name               = "\improper Cargo"
	icon_state         = "level_crg"

/obj/structure/sign/levels/cargo/mining
	name               = "\improper Mining"
	icon_state         = "level_mining"

/obj/structure/sign/levels/cargo/refinery
	name               = "\improper Refinery"
	icon_state         = "level_refinery"

/obj/structure/sign/levels/recreation
	name               = "\improper Recreation"
	icon_state         = "level_recreation"

/obj/structure/sign/levels/laboratory
	name               = "\improper Laboratory"
	icon_state         = "level_lab"

/obj/structure/sign/levels/xeno
	name               = "\improper Xenobiology"
	icon_state         = "level_xeno"

/obj/structure/sign/levels/ai_core
	name               = "\improper AI Core"
	icon_state         = "level_ai_core"

/obj/structure/sign/levels/bridge
	name               = "\improper Bridge"
	icon_state         = "level_bridge"

/obj/structure/sign/levels/teleporter
	name               = "\improper Teleporter"
	icon_state         = "level_teleport"

/obj/structure/sign/levels/telecomms
	name               = "\improper Telecommunications"
	icon_state         = "level_tcomms"

/obj/structure/sign/levels/elevator
	name               = "\improper Elevator"
	icon_state         = "level_elv"

/obj/structure/sign/levels/bar
	name               = "\improper Bar"
	icon_state         = "level_bar"

/obj/structure/sign/levels/kitchen
	name               = "\improper Kitchen"
	icon_state         = "level_kitchen"

/obj/structure/sign/levels/tram
	name               = "\improper Tram"
	icon_state         = "level_tram"

/obj/structure/sign/levels/janitor
	name               = "\improper Janitor"
	icon_state         = "level_janitor"

/obj/structure/sign/levels/chapel
	name               = "\improper Chapel"
	icon_state         = "level_chapel"

/obj/structure/sign/levels/library
	name               = "\improper Library"
	icon_state         = "level_library"

/obj/structure/sign/levels/dock
	name               = "\improper Docks"
	icon_state         = "level_dock"

/obj/structure/sign/levels/gym
	name               = "\improper Gymnasium"
	icon_state         = "level_gym"

/obj/structure/sign/levels/pool
	name               = "\improper Pool"
	icon_state         = "level_pool"
