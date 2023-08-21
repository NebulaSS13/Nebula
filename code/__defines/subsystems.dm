#define INITIALIZATION_INSSATOMS      0	//New should not call Initialize
#define INITIALIZATION_INSSATOMS_LATE 1	//New should not call Initialize; after the first pass is complete (handled differently)
#define INITIALIZATION_INNEW_MAPLOAD  2	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR  3	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(atom_flags & ATOM_FLAG_INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define SS_INIT_INPUT            22
#define SS_INIT_EARLY            21
#define SS_INIT_WEBHOOKS         20
#define SS_INIT_MODPACKS         19
#define SS_INIT_SECRETS          18
#define SS_INIT_GARBAGE          17
#define SS_INIT_MATERIALS        16
#define SS_INIT_PLANTS           15
#define SS_INIT_LORE             14
#define SS_INIT_MISC             13
#define SS_INIT_SKYBOX           12
#define SS_INIT_MAPPING          11
#define SS_INIT_JOBS             10
#define SS_INIT_CIRCUIT          9
#define SS_INIT_GRAPH            8
#define SS_INIT_OPEN_SPACE       7
#define SS_INIT_ATOMS            6
#define SS_INIT_PRE_CHAR_SETUP   5
#define SS_INIT_CHAR_SETUP       4
#define SS_INIT_MACHINES         3
#define SS_INIT_ICON_UPDATE      2
#define SS_INIT_OVERLAY          1
#define SS_INIT_DEFAULT          0
#define SS_INIT_AIR             -1
#define SS_INIT_VIS_CONTENTS    -2
#define SS_INIT_MISC_LATE       -3
#define SS_INIT_MISC_CODEX      -4
#define SS_INIT_ALARM           -5
#define SS_INIT_SHUTTLE         -6
#define SS_INIT_GOALS           -7
#define SS_INIT_LIGHTING        -8
#define SS_INIT_WEATHER         -9
#define SS_INIT_ZCOPY           -10
#define SS_INIT_HOLOMAP         -11
#define SS_INIT_XENOARCH        -12
#define SS_INIT_TICKER          -20
#define SS_INIT_UNIT_TESTS      -100

// SS runlevels
#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8
/// default runlevels for most subsystems
#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
/// all valid runlevels - subsystems with this will run all the time after their MC init stage.
#define RUNLEVELS_ALL (RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
