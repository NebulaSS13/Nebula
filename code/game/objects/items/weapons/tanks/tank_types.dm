/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Hydrogen
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon = 'icons/obj/items/tanks/tank_blue.dmi'
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(/decl/material/gas/oxygen = 6*ONE_ATMOSPHERE)
	volume = 180

/obj/item/tank/oxygen/yellow
	desc = "A tank of oxygen. This one is yellow."
	icon = 'icons/obj/items/tanks/tank_yellow.dmi'

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon = 'icons/obj/items/tanks/tank_blue.dmi'
	starting_pressure = list(/decl/material/gas/oxygen = 6*ONE_ATMOSPHERE*O2STANDARD, /decl/material/gas/nitrogen = 6*ONE_ATMOSPHERE*N2STANDARD)
	volume = 180

/*
 * Hydrogen
 */
/obj/item/tank/hydrogen
	name = "hydrogen tank"
	desc = "Contains hydrogen. Warning: flammable."
	icon = 'icons/obj/items/tanks/tank_orange.dmi'
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null
	starting_pressure = list(/decl/material/gas/hydrogen = 3*ONE_ATMOSPHERE)

/*
 * Emergency Oxygen
 */
/obj/item/tank/emergency
	name = "emergency tank"
	icon = 'icons/obj/items/tanks/tank_emergency.dmi'
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	force = 5
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 40 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon = 'icons/obj/items/tanks/tank_emergency.dmi'
	gauge_icon = "indicator_emergency"
	starting_pressure = list(/decl/material/gas/oxygen = 10*ONE_ATMOSPHERE)

/obj/item/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon = 'icons/obj/items/tanks/tank_emergency_engineer.dmi'
	volume = 60

/obj/item/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon = 'icons/obj/items/tanks/tank_emergency_double.dmi'
	gauge_icon = "indicator_emergency_double"
	volume = 90
	w_class = ITEM_SIZE_NORMAL

/obj/item/tank/emergency/oxygen/double/red	//firefighting tank, fits on belt, back or suitslot
	name = "self contained breathing apparatus"
	desc = "A self contained breathing apparatus, well known as SCBA. Generally filled with oxygen."
	icon = 'icons/obj/items/tanks/tank_scuba.dmi'
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK

/*
 * Nitrogen
 */
/obj/item/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon = 'icons/obj/items/tanks/tank_red.dmi'
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(/decl/material/gas/nitrogen = 10*ONE_ATMOSPHERE)
	volume = 180
