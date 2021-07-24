/decl/hierarchy/supply_pack/engineering
	name = "Engineering"

/decl/hierarchy/supply_pack/engineering/smes_circuit
	name = "Electronics - Superconducting magnetic energy storage unit circuitry"
	contains = list(/obj/item/stock_parts/circuitboard/smes)
	containername = "superconducting magnetic energy storage unit circuitry crate"

/decl/hierarchy/supply_pack/engineering/smescoil
	name = "Parts - Superconductive magnetic coil"
	contains = list(/obj/item/stock_parts/smes_coil)
	containername = "superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_weak
	name = "Parts - Basic superconductive magnetic coil"
	contains = list(/obj/item/stock_parts/smes_coil/weak)
	containername = "basic superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_capacity
	name = "Parts - Superconductive capacitance coil"
	contains = list(/obj/item/stock_parts/smes_coil/super_capacity)
	containername = "superconductive capacitance coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_io
	name = "Parts- Superconductive Transmission Coil"
	contains = list(/obj/item/stock_parts/smes_coil/super_io)
	containername = "Superconductive Transmission Coil crate"

/decl/hierarchy/supply_pack/engineering/electrical
	name = "Gear - Electrical maintenance"
	contains = list(
		/obj/item/storage/toolbox/electrical = 1,
		/obj/item/storage/toolbox/repairs = 1,
		/obj/item/clothing/gloves/insulated = 2,
		/obj/item/cell = 2,
		/obj/item/cell/high = 2
	)
	containername = "electrical maintenance crate"

/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Gear - Mechanical maintenance"
	contains = list(/obj/item/storage/belt/utility/full = 3,
					/obj/item/clothing/suit/storage/hazardvest = 3,
					/obj/item/clothing/head/welding = 2,
					/obj/item/clothing/head/hardhat)
	containername = "mechanical maintenance crate"

/decl/hierarchy/supply_pack/engineering/solar
	name = "Power - Solar pack"
	contains  = list(/obj/item/solar_assembly = 14,
					/obj/item/stock_parts/circuitboard/solar_control,
					/obj/item/tracker_electronics,
					/obj/item/paper/solar
					)
	containername = "solar pack crate"

/decl/hierarchy/supply_pack/engineering/solar_assembly
	name = "Power - Solar assembly"
	contains  = list(/obj/item/solar_assembly = 16)
	containername = "solar assembly crate"

/decl/hierarchy/supply_pack/engineering/emitter
	name = "Equipment - Emitter"
	contains = list(/obj/machinery/power/emitter = 2)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "emitter crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/field_gen
	name = "Equipment - Field generator"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/large
	containername = "field generator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/sing_gen
	name = "Equipment - Singularity generator"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "singularity generator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/collector
	name = "Power - Collector"
	contains = list(/obj/machinery/power/rad_collector = 2)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "collector crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/PA
	name = "Equipment - Particle accelerator"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	containertype = /obj/structure/largecrate
	containername = "particle accelerator crate"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/pacman_parts
	name = "Power - portable fusion generator parts"
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/circuitboard/pacman)
	containername = "\improper Portable Fusion Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage

/decl/hierarchy/supply_pack/engineering/super_pacman_parts
	name = "Power - portable fission generator parts"
	contains = list(/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/circuitboard/pacman/super)
	containername = "portable fission generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage

/decl/hierarchy/supply_pack/engineering/teg
	name = "Power - Mark I Thermoelectric Generator"
	contains = list(/obj/machinery/power/generator)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Mk1 TEG crate"
	access = access_engine_equip

/decl/hierarchy/supply_pack/engineering/circulator
	name = "Equipment - Binary atmospheric circulator"
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "atmospheric circulator crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/air_dispenser
	name = "Equipment - Pipe Dispenser"
	contains = list(/obj/machinery/fabricator/pipe)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "pipe dispenser crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	name = "Equipment - Disposals pipe dispenser"
	contains = list(/obj/machinery/fabricator/pipe/disposal)
	containertype = /obj/structure/closet/crate/secure/large
	containername = "disposal dispenser crate"
	access = access_atmospherics

/decl/hierarchy/supply_pack/engineering/shield_generator
	name = "Equipment - Shield generator construction kit"
	contains = list(/obj/item/stock_parts/circuitboard/shield_generator, /obj/item/stock_parts/capacitor, /obj/item/stock_parts/micro_laser, /obj/item/stock_parts/smes_coil, /obj/item/stock_parts/console_screen)
	containertype = /obj/structure/closet/crate/secure
	containername = "shield generator construction kit crate"
	access = access_engine

/decl/hierarchy/supply_pack/engineering/inertial_damper
	name = "Equipment - inertial damper construction kit"
	contains = list(/obj/item/stock_parts/circuitboard/inertial_damper, /obj/item/stock_parts/capacitor, /obj/item/stock_parts/micro_laser, /obj/item/stock_parts/console_screen)
	containertype = /obj/structure/closet/crate/secure
	containername = "inertial damper construction kit crate"
	access = access_engine

/decl/hierarchy/supply_pack/engineering/smbig
	name = "Power - Supermatter core"
	contains = list(/obj/machinery/power/supermatter)
	containertype = /obj/structure/closet/crate/secure/large/supermatter
	containername = "\improper Supermatter crate (CAUTION)"
	access = access_ce

/decl/hierarchy/supply_pack/engineering/robotics
	name = "Parts - Robotics assembly"
	contains = list(/obj/item/assembly/prox_sensor = 3,
					/obj/item/storage/toolbox/electrical,
					/obj/item/flash = 4,
					/obj/item/cell/high = 2)
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "robotics assembly crate"
	access = access_robotics

/decl/hierarchy/supply_pack/engineering/radsuit
	name = "Gear - Radiation protection gear"
	contains = list(/obj/item/clothing/suit/radiation = 6,
			/obj/item/clothing/head/radiation = 6)
	containertype = /obj/structure/closet/radiation
	containername = "radiation suit locker"

/decl/hierarchy/supply_pack/engineering/commrelay
	name = "Parts - Emergency Communication Relay parts"
	contains = list(/obj/item/stock_parts/circuitboard/commsrelay,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/subspace/filter,
					/obj/item/stock_parts/subspace/crystal,
					/obj/item/storage/toolbox/electrical)
	containername = "emergency communication relay assembly kit"

/decl/hierarchy/supply_pack/engineering/firefighter
	name = "Gear - Firefighting equipment"
	contains = list(/obj/item/clothing/suit/fire,
			/obj/item/clothing/mask/gas,
			/obj/item/tank/emergency/oxygen/double/red,
			/obj/item/extinguisher,
			/obj/item/clothing/head/hardhat/red)
	containertype = /obj/structure/closet/firecloset
	containername = "fire-safety closet"

/decl/hierarchy/supply_pack/engineering/voidsuit_engineering
	name = "EVA - Voidsuit, Engineering"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engine
