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
	directional_offset = "{'NORTH':{'y':32}, 'SOUTH':{'y':32}, 'WEST':{'y':32}, 'EAST':{'y':32}}"

/obj/structure/sign/directions/update_description()
	desc = "A direction sign, pointing out \the [name] is [global.dir_name(dir)]."

/////////////////////////////////////////////////////
//Direction Signs Definition
/////////////////////////////////////////////////////

/obj/structure/sign/directions/science
	name       = "\improper Research Division"
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name       = "\improper Engineering Bay"
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name       = "\improper Security Wing"
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name       = "\improper Medical Bay"
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name       = "\improper Evacuation Wing"
	icon_state = "direction_evac"

/obj/structure/sign/directions/bridge
	name       = "\improper Bridge"
	icon_state = "direction_bridge"

/obj/structure/sign/directions/supply
	name       = "\improper Supply Office"
	icon_state = "direction_supply"

/obj/structure/sign/directions/infirmary
	name       = "\improper Infirmary"
	icon_state = "direction_infirm"

/obj/structure/sign/directions/pods
	name       = "\improper ESCAPE PODS"
	icon_state = "direction_pods"

/obj/structure/sign/directions/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "direction_cryo"


/////////////////////////////////////////////////////
// Hangar Signs
/////////////////////////////////////////////////////
/obj/structure/sign/hangar
	abstract_type = /obj/structure/sign/hangar
	name          = "hangar sign"
	desc          = "A sign indicating which hangar the observer is near."
	icon          = 'icons/obj/signs/hangars.dmi'

/obj/structure/sign/hangar/one
	name = "\improper Hangar One"
	icon_state = "hangar-1"

/obj/structure/sign/hangar/two
	name = "\improper Hangar Two"
	icon_state = "hangar-2"

/obj/structure/sign/hangar/three
	name = "\improper Hangar Three"
	icon_state = "hangar-3"

/////////////////////////////////////////////////////
// Deck Signs
/////////////////////////////////////////////////////

///A sign for indicating what level is the current level vertically
/obj/structure/sign/deck
	abstract_type = /obj/structure/sign/deck
	name          = "current level sign"
	desc          = "A sign indicating on what level the observer is currently on."
	icon          = 'icons/obj/signs/slim_decks.dmi'

/////////////////////////////////////////////////////
// Deck Signs Definition
/////////////////////////////////////////////////////

/obj/structure/sign/deck/bridge
	name       = "\improper Bridge Deck"
	icon_state = "deck-b"

/obj/structure/sign/deck/first
	name       = "\improper First Deck"
	icon_state = "deck-1"

/obj/structure/sign/deck/second
	name       = "\improper Second Deck"
	icon_state = "deck-2"

/obj/structure/sign/deck/third
	name       = "\improper Third Deck"
	icon_state = "deck-3"

/obj/structure/sign/deck/fourth
	name       = "\improper Fourth Deck"
	icon_state = "deck-4"

/obj/structure/sign/deck/fifth
	name       = "\improper Fifth Deck"
	icon_state = "deck-5"