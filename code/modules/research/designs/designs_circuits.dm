/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5

/datum/design/circuit/ModifyDesignName()
	if(build_path)
		var/obj/item/stock_parts/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([name])"
		else
			name = "Circuit design ([name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/stock_parts/circuitboard/arcade/battle

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/stock_parts/circuitboard/arcade/orion_trail

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	build_path = /obj/item/stock_parts/circuitboard/prisoner

/datum/design/circuit/operating
	name = "patient monitoring console"
	build_path = /obj/item/stock_parts/circuitboard/operating

/datum/design/circuit/optable
	name = "operating table"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/optable

/datum/design/circuit/bodyscanner
	name = "body scanner"
	req_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/bodyscanner

/datum/design/circuit/body_scanconsole
	name = "body scanner console"
	req_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/body_scanconsole

/datum/design/circuit/sleeper
	name = "sleeper"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 5, TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/sleeper

/datum/design/circuit/body_scan_display
	name = "body scanner display"
	req_tech = list(TECH_BIO = 2, TECH_DATA = 2)
	build_path = /obj/item/stock_parts/circuitboard/body_scanconsole/display

/datum/design/circuit/bioprinter
	name = "bioprinter"
	req_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/bioprinter

/datum/design/circuit/roboprinter
	name = "prosthetic organ fabricator"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/roboprinter

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 5)
	build_path = /obj/item/stock_parts/circuitboard/teleporter

/datum/design/circuit/robocontrol
	name = "robotics control console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/robotics

/datum/design/circuit/rdconsole
	name = "R&D control console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/rdconsole

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/comm_server

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/stock_parts/circuitboard/message_monitor

/datum/design/circuit/message_server
	name = "message server board"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/message_server
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/guestpass
	name = "guest pass terminal"
	build_path = /obj/item/stock_parts/circuitboard/guestpass

/datum/design/circuit/accounts
	name = "account database terminal"
	build_path = /obj/item/stock_parts/circuitboard/account_database

/datum/design/circuit/holo
	name = "holodeck control console"
	build_path = /obj/item/stock_parts/circuitboard/holodeckcontrol
	req_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 2)

/datum/design/circuit/aiupload
	name = "AI upload console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/aiupload

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/borgupload

/datum/design/circuit/cryopodcontrol
	name = "cryogenic oversight console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/cryopodcontrol

/datum/design/circuit/robot_storage
	name = "robotic storage control"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/robotstoragecontrol

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/destructive_analyzer

/datum/design/circuit/protolathe
	name = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/protolathe

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/circuit_imprinter

/datum/design/circuit/autolathe
	name = "autolathe board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/autolathe

/datum/design/circuit/replicator
	name = "replicator board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_BIO = 3)
	build_path = /obj/item/stock_parts/circuitboard/replicator

/datum/design/circuit/microlathe
	name = "microlathe board"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/autolathe/micro

/datum/design/circuit/autobinder
	name = "autobinder board"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/autolathe/book

/datum/design/circuit/mining_console
	name = "mining console board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/mineral_processing

/datum/design/circuit/mining_processor
	name = "mining processor board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/mining_processor

/datum/design/circuit/mining_unloader
	name = "ore unloader board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/mining_unloader

/datum/design/circuit/mining_stacker
	name = "sheet stacker board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/mining_stacker

/datum/design/circuit/suspension_gen
	name = "suspension generator board"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 4)
	build_path = /obj/item/stock_parts/circuitboard/suspension_gen

/datum/design/circuit/artifact_analyser
	name = "suspension generator board"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/artifact_analyser

/datum/design/circuit/artifact_harvester
	name = "artifact harvester board"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/artifact_harvester

/datum/design/circuit/artifact_scanner
	name = "artifact scanner board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_path = /obj/item/stock_parts/circuitboard/artifact_scanner

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	name = "R&D server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/rdserver

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/mechfab

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/mech_recharger

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/recharge_station

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	build_path = /obj/item/stock_parts/circuitboard/atmos_alert

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	build_path = /obj/item/stock_parts/circuitboard/air_management

/datum/design/circuit/dronecontrol
	name = "drone control console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/drone_control

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	build_path = /obj/item/stock_parts/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	name = "solar control console"
	build_path = /obj/item/stock_parts/circuitboard/solar_control

/datum/design/circuit/supermatter_control
	name = "core monitoring console"
	build_path = /obj/item/stock_parts/circuitboard/air_management/supermatter_core

/datum/design/circuit/injector
	name = "injector control console"
	build_path = /obj/item/stock_parts/circuitboard/air_management/injector_control

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/pacman

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/stock_parts/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/stock_parts/circuitboard/pacman/mrs

/datum/design/circuit/pacmanpotato
	name = "PTTO-3 nuclear generator"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 4, TECH_ESOTERIC = 4)
	build_path = /obj/item/stock_parts/circuitboard/pacman/super/potato

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/batteryrack

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/stock_parts/circuitboard/smes

/datum/design/circuit/alerts
	name = "alerts console"
	build_path = /obj/item/stock_parts/circuitboard/stationalert

/datum/design/circuit/gas_heater
	name = "gas heating system"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/unary_atmos/heater

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/unary_atmos/cooler

/datum/design/circuit/oxyregenerator
	name = "oxygen regenerator"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/oxyregenerator

/datum/design/circuit/reagent_heater
	name = "chemical heating system"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/reagent_heater

/datum/design/circuit/reagent_cooler
	name = "chemical cooling system"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/reagent_heater/cooler

/datum/design/circuit/atmos_control
	name = "atmospherics control console"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/atmoscontrol

/datum/design/circuit/pipe_dispenser
	name = "pipe dispenser"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5)
	build_path = /obj/item/stock_parts/circuitboard/pipedispensor

/datum/design/circuit/pipe_dispenser/disposal
	name = "disposal pipe dispenser"
	build_path = /obj/item/stock_parts/circuitboard/pipedispensor/disposal

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure

/datum/design/circuit/portable_scrubber
	name = "portable scrubber"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/portable_scrubber

/datum/design/circuit/portable_pump
	name = "portable pump"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/portable_scrubber/pump

/datum/design/circuit/portable_scrubber_huge
	name = "large portable scrubber"
	req_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/stock_parts/circuitboard/portable_scrubber/huge

/datum/design/circuit/portable_scrubber_stat
	name = "large stationary portable scrubber"
	req_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/stock_parts/circuitboard/portable_scrubber/huge/stationary

/datum/design/circuit/thruster
	name = "gas thruster"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/unary_atmos/engine

/datum/design/circuit/helms
	name = "helm control console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/stock_parts/circuitboard/helm

/datum/design/circuit/nav
	name = "navigation control console"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/nav

/datum/design/circuit/nav/tele
	name = "navigation telescreen"
	build_path = /obj/item/stock_parts/circuitboard/nav/tele

/datum/design/circuit/sensors
	name = "ship sensor control console"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/sensors

/datum/design/circuit/engine
	name = "ship engine control console"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/engine

/datum/design/circuit/shuttle
	name = "basic shuttle console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/shuttle_console

/datum/design/circuit/shuttle_long
	name = "long range shuttle console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/shuttle_console/explore

/datum/design/circuit/biogenerator
	name = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/stock_parts/circuitboard/biogenerator

/datum/design/circuit/hydro_tray
	name = "hydroponics tray"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_DATA = 1)
	build_path = /obj/item/stock_parts/circuitboard/tray

/datum/design/circuit/dehumidifier
	name = "dehumidifier"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/dehumidifier

/datum/design/circuit/space_heater
	name = "space heater"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/space_heater

/datum/design/circuit/ice_cream
	name = "ice cream vat"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/ice_cream

/datum/design/circuit/smartfridge
	name = "smartfridge (selectable type)"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/fridge

/datum/design/circuit/miningdrill
	name = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/miningdrill

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/miningdrillbrace

/datum/design/circuit/floodlight
	name = "emergency floodlight"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/floodlight

/datum/design/circuit/disperserfront
	name = "obstruction field disperser beam generator"
	req_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/circuitboard/disperserfront

/datum/design/circuit/dispersermiddle
	name = "obstruction field disperser fusor"
	req_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/circuitboard/dispersermiddle

/datum/design/circuit/disperserback
	name = "obstruction field disperser material deconstructor"
	req_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/circuitboard/disperserback

/datum/design/circuit/disperser_console
	name = "obstruction field disperser control console"
	req_tech = list(TECH_DATA = 2, TECH_COMBAT = 5, TECH_BLUESPACE = 5)
	build_path = /obj/item/stock_parts/circuitboard/disperser

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/ModifyDesignName()
	name = "Telecommunications machinery circuit design ([name])"

/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	name = "processor unit"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/hub

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/stock_parts/circuitboard/telecomms/receiver

/datum/design/circuit/bluespace_relay
	name = "bluespace relay"
	req_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 5, TECH_PHORON = 5)
	build_path = /obj/item/stock_parts/circuitboard/bluespacerelay

/datum/design/circuit/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/shield_generator

/datum/design/circuit/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/stock_parts/circuitboard/shield_diffuser

/datum/design/circuit/pointdefense
	name = "Point defense battery"
	desc = "Allows for the construction of a point defense battery circuit board."
	req_tech = list(TECH_COMBAT = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/pointdefense

/datum/design/circuit/pointdefense_control
	name = "Fire Assist Mainframe"
	desc = "Allows for the construction of a fire assist mainframe circuit board."
	req_tech = list(TECH_COMBAT = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/pointdefense_control

/datum/design/circuit/washer
	name = "washing machine"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/washer

/datum/design/circuit/microwave
	name = "microwave"
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/microwave

/datum/design/circuit/gibber
	name = "meat gibber"
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/gibber

/datum/design/circuit/cooker
	name = "kitchen appliance (assorted)"
	desc = "Allows for the construction of an interchangable cooking appliance circuit board. Use a multitool to select appliance."
	req_tech = list(TECH_BIO = 1, TECH_MATERIAL = 1)
	build_path = /obj/item/stock_parts/circuitboard/cooker

/datum/design/circuit/honey_extractor
	name = "honey extractor"
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/honey

/datum/design/circuit/seed_extractor
	name = "seed extractor"
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/honey/seed

/datum/design/circuit/vending
	name = "vending machine"
	req_tech = list(TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/vending

/datum/design/circuit/aicore
	name = "AI core"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/stock_parts/circuitboard/aicore

/datum/design/circuit/ionengine
	name = "ion propulsion system"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/stock_parts/circuitboard/engine/ion

/datum/design/circuit/vitals
	name = "vitals monitor"
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/vitals_monitor

/datum/design/circuit/modular_computer
	name = "general-purpose computer"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/modular_computer

/datum/design/circuit/shipsensors
	name = "ship sensors"
	build_path = /obj/item/stock_parts/circuitboard/shipsensors

/datum/design/circuit/grinder
	name = "industrial grinder board"
	req_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/stock_parts/circuitboard/grinder

/datum/design/circuit/juicer
	name = "blender board"
	req_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/juicer

/datum/design/circuit/recharger
	name = "recharger board"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/recharger

/datum/design/circuit/wall_recharger
	name = "wall recharger board"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/recharger/wall

/datum/design/circuit/cell_charger
	name = "cell charger board"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/stock_parts/circuitboard/cell_charger
/datum/design/circuit/suit_cycler
	name = "suit cycler board (selectable options)"
	build_path = /obj/item/stock_parts/circuitboard/suit_cycler
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/seed_storage
	name = "seed storage"
	build_path = /obj/item/stock_parts/circuitboard/seed_storage
	req_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 3)

/datum/design/circuit/seed_storage_xeno
	name = "advanced seed storage"
	build_path = /obj/item/stock_parts/circuitboard/seed_storage/advanced
	req_tech = list(TECH_BIO = 6, TECH_ENGINEERING = 3)

/datum/design/circuit/turbine
	name = "small turbine board"
	build_path = /obj/item/stock_parts/circuitboard/turbine
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/turbine_motor
	name = "small turbine motor board"
	build_path = /obj/item/stock_parts/circuitboard/turbine/motor
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/turbine_big
	name = "turbine board"
	build_path = /obj/item/stock_parts/circuitboard/big_turbine
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/turbine_motor_big
	name = "turbine motor board"
	build_path = /obj/item/stock_parts/circuitboard/big_turbine/center
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/turbine_teg
	name = "TEG turbine board"
	build_path = /obj/item/stock_parts/circuitboard/teg_turbine
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/turbine_motor_teg
	name = "TEG motor board"
	build_path = /obj/item/stock_parts/circuitboard/teg_turbine/motor
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/cryopod
	name = "cryo unit board"
	build_path = /obj/item/stock_parts/circuitboard/cryopod
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6, TECH_BLUESPACE = 6)

/datum/design/circuit/breaker_box
	name = "breaker box board"
	build_path = /obj/item/stock_parts/circuitboard/breaker
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)

/datum/design/circuit/merchant_pad
	name = "merchant pad board"
	build_path = /obj/item/stock_parts/circuitboard/merchant_pad
	req_tech = list(TECH_DATA = 6, TECH_BLUESPACE = 6, TECH_ESOTERIC = 1)

/datum/design/circuit/jukebox
	name = "jukebox board"
	build_path = /obj/item/stock_parts/circuitboard/jukebox
	req_tech = list(TECH_DATA = 5)

/datum/design/circuit/forensic
	name = "forensic omnianalyzer board"
	build_path = /obj/item/stock_parts/circuitboard/forensic
	req_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 6, TECH_BIO = 6)

/datum/design/circuit/forensic_microscope
	name = "forensic microscope board"
	build_path = /obj/item/stock_parts/circuitboard/forensic_microscope
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3, TECH_BIO = 3)

/datum/design/circuit/forensic_dna_analyzer
	name = "forensic DNA analyzer board"
	build_path = /obj/item/stock_parts/circuitboard/forensic_dna_analyzer
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3, TECH_BIO = 3)

/datum/design/circuit/net_mainframe
	name = "network mainframe board"
	build_path = /obj/item/stock_parts/circuitboard/mainframe
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/net_router
	name = "network router board"
	build_path = /obj/item/stock_parts/circuitboard/router
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3)

/datum/design/circuit/net_relay
	name = "network relay board"
	build_path = /obj/item/stock_parts/circuitboard/relay
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3)