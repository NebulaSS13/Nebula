/client/proc/spawn_tanktransferbomb()
	set category = "Debug"
	set desc = "Spawn a tank transfer valve bomb"
	set name = "Instant TTV"

	if(!check_rights(R_SPAWN)) return

	var/obj/effect/spawner/newbomb/proto = /obj/effect/spawner/newbomb/radio/custom

	var/p = input("Enter accelerant amount (mol):","Accelerant", initial(proto.accelerant_amount)) as num|null
	if(p == null) return

	var/o = input("Enter oxidizer amount (mol):","Oxidizer", initial(proto.oxidizer_amount)) as num|null
	if(o == null) return

	var/c = input("Enter filler gas amount (mol):","Filler Gas", initial(proto.filler_amount)) as num|null
	if(c == null) return

	new /obj/effect/spawner/newbomb/radio/custom(get_turf(mob), p, o, c)

/obj/effect/spawner/newbomb
	name = "TTV bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/filler_type =          /decl/material/gas/carbon_dioxide
	var/accelerant_type =      DEFAULT_GAS_ACCELERANT
	var/accelerant_tank_type = /obj/item/tank/hydrogen
	var/oxidizer_type =        DEFAULT_GAS_OXIDIZER
	var/oxidizer_tank_type =   /obj/item/tank/oxygen

	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/accelerant_amount = 12
	var/oxidizer_amount = 18
	var/filler_amount = 0

/obj/effect/spawner/newbomb/traitor
	name = "TTV bomb - traitor"
	assembly_type = /obj/item/assembly/signaler
	accelerant_amount = 14
	oxidizer_amount = 21

/obj/effect/spawner/newbomb/timer
	name = "TTV bomb - timer"
	assembly_type = /obj/item/assembly/timer

/obj/effect/spawner/newbomb/timer/syndicate
	name = "TTV bomb - merc"
	//High yield bombs. Yes, it is possible to make these with toxins
	accelerant_amount = 18.5
	oxidizer_amount = 28.5

/obj/effect/spawner/newbomb/proximity
	name = "TTV bomb - proximity"
	assembly_type = /obj/item/assembly/prox_sensor

/obj/effect/spawner/newbomb/radio/custom/Initialize(mapload, ph, ox, co)
	if(ph != null) accelerant_amount = ph
	if(ox != null) oxidizer_amount = ox
	if(co != null) filler_amount = co
	. = ..()

/obj/effect/spawner/newbomb/Initialize()
	..()
	var/obj/item/transfer_valve/V = new(src.loc)
	var/obj/item/tank/PT = new accelerant_tank_type(V)
	var/obj/item/tank/OT = new oxidizer_tank_type(V)

	V.tank_one = PT
	V.tank_two = OT

	PT.master = V
	OT.master = V

	PT.valve_welded = TRUE
	PT.air_contents.gas = list()
	PT.air_contents.gas[accelerant_type] = accelerant_amount
	PT.air_contents.gas[filler_type] = filler_amount
	PT.air_contents.total_moles = accelerant_amount + filler_amount
	PT.air_contents.temperature = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE+1
	PT.air_contents.update_values()

	OT.valve_welded = TRUE
	OT.air_contents.gas = list()
	OT.air_contents.gas[oxidizer_type] = oxidizer_amount
	OT.air_contents.total_moles = oxidizer_amount
	OT.air_contents.temperature = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE+1
	OT.air_contents.update_values()

	var/obj/item/assembly/S = new assembly_type(V)
	V.attached_device = S
	S.holder = V
	S.toggle_secure()
	V.update_icon()
	return INITIALIZE_HINT_QDEL

///////////////////////
//One Tank Bombs, WOOOOOOO! -Luke
///////////////////////

/obj/effect/spawner/onetankbomb
	name = "Single-tank bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

//	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/accelerant_amount = 0
	var/oxidizer_amount = 0

/obj/effect/spawner/onetankbomb/Initialize()
	..()
	new /obj/item/tank/onetankbomb(get_turf(loc))
	return INITIALIZE_HINT_QDEL
