#define MCF_BLOCKER   BITFLAG(0)
#define MCF_HALL      BITFLAG(1)
#define MCF_ROOM      BITFLAG(2)
#define MCF_AQUEDUCT  BITFLAG(3)
#define MCF_HALL_BEND BITFLAG(4)
#define MCF_BRIDGE    BITFLAG(5)

#define TRANSLATE_MODMAP_COORD(X, Y, WIDTH) (((Y * WIDTH) + (X))+1)

var/global/list/_mcf_flags = list(
	(MCF_HALL),
	(MCF_ROOM),
	(MCF_AQUEDUCT),
	(MCF_HALL_BEND),
	(MCF_BRIDGE)
)
