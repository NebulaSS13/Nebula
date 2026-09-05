#define AMBIENCE_QUEUE_TURF(T) \
	if(!T.ambience_queued) { \
		T.ambience_queued = TRUE; \
		SSambience.queued += T; \
	}

#define AMBIENCE_DEQUEUE_TURF(T) \
	if(T.ambience_queued) { \
		T.ambience_queued = FALSE; \
		SSambience.queued -= T; \
	}

#define AMBIENCE_HIGHSEC list(                       \
	'sound/ambience/highsec/highsec1.ogg',           \
	'sound/ambience/highsec/highsec2.ogg',           \
	'sound/ambience/highsec/highsec3.ogg',           \
	'sound/ambience/highsec/highsec4.ogg'            \
)
#define AMBIENCE_GENERIC list(                       \
	'sound/ambience/generic/generic1.ogg',           \
	'sound/ambience/generic/generic2.ogg',           \
	'sound/ambience/generic/generic3.ogg'            \
)
#define AMBIENCE_SUBSTATION list(                    \
	'sound/ambience/substation/substation1.ogg',     \
	'sound/ambience/substation/substation2.ogg'      \
)
#define AMBIENCE_ENGINEERING list(                   \
	'sound/ambience/engineering/engineering1.ogg',   \
	'sound/ambience/engineering/engineering2.ogg',   \
	'sound/ambience/engineering/engineering3.ogg'    \
)
#define AMBIENCE_ATMOS list(                         \
	'sound/ambience/engineering/engineering1.ogg',   \
	'sound/ambience/engineering/engineering2.ogg',   \
	'sound/ambience/engineering/engineering3.ogg',   \
	'sound/ambience/atmospherics/atmospherics1.ogg'  \
)
// The actual chapel room, and maybe some other places of worship.
#define AMBIENCE_CHAPEL list(                        \
	'sound/ambience/chapel/chapel1.ogg',             \
	'sound/ambience/chapel/chapel2.ogg',             \
	'sound/ambience/chapel/chapel3.ogg',             \
	'sound/ambience/chapel/chapel4.ogg'              \
	)
// Sounds suitable for being inside dark, tight corridors in the underbelly of the station.
#define AMBIENCE_MAINTENANCE list(                   \
	'sound/ambience/maintenance/maintenance1.ogg',   \
	'sound/ambience/maintenance/maintenance2.ogg',   \
	'sound/ambience/maintenance/maintenance3.ogg',   \
	'sound/ambience/maintenance/maintenance4.ogg',   \
	'sound/ambience/maintenance/maintenance5.ogg',   \
	'sound/ambience/maintenance/maintenance6.ogg',   \
	'sound/ambience/maintenance/maintenance7.ogg',   \
	'sound/ambience/maintenance/maintenance8.ogg',   \
	'sound/ambience/maintenance/maintenance9.ogg'    \
)
// Creepy AI/borg stuff.
#define AMBIENCE_AI list(                            \
	'sound/ambience/ai/ai1.ogg',                     \
	'sound/ambience/ai/ai2.ogg',                     \
	'sound/ambience/ai/ai3.ogg'                      \
)
// Ambience heard when aboveground on Sif and not in a Point of Interest.
#define AMBIENCE_SIF list(                           \
	'sound/ambience/sif/sif1.ogg'                    \
)
// Ruined structures found on the surface or in the caves.
#define AMBIENCE_RUINS list(                         \
	'sound/ambience/ruins/ruins1.ogg',               \
	'sound/ambience/ruins/ruins2.ogg',               \
	'sound/ambience/ruins/ruins3.ogg',               \
	'sound/ambience/ruins/ruins4.ogg',               \
	'sound/ambience/ruins/ruins5.ogg',               \
	'sound/ambience/ruins/ruins6.ogg'                \
)
// Similar to the above, but for more technology/signaling based ruins.
#define AMBIENCE_TECH_RUINS list(                    \
	'sound/ambience/tech_ruins/tech_ruins1.ogg',     \
	'sound/ambience/tech_ruins/tech_ruins2.ogg',     \
	'sound/ambience/tech_ruins/tech_ruins3.ogg'      \
)
#define AMBIENCE_FOREBODING list(                    \
	'sound/ambience/foreboding/foreboding1.ogg',     \
	'sound/ambience/foreboding/foreboding2.ogg',     \
	'sound/ambience/foreboding/foreboding3.ogg',     \
	'sound/ambience/foreboding/foreboding4.ogg',     \
	'sound/ambience/foreboding/foreboding5.ogg',     \
	'sound/ambience/maintenance/maintenance6.ogg'    \
	)
#define AMBIENCE_OTHERWORLDLY list(                  \
	'sound/ambience/otherworldly/otherworldly1.ogg', \
	'sound/ambience/otherworldly/otherworldly2.ogg', \
	'sound/ambience/otherworldly/otherworldly3.ogg'  \
)
#define AMBIENCE_SPACE list(                         \
	'sound/ambience/space/space_serithi.ogg',        \
	'sound/ambience/space/space1.ogg'                \
)
#define AMBIENCE_GHOSTLY list(                       \
	'sound/ambience/ghostly/ghostly1.ogg',           \
	'sound/ambience/ghostly/ghostly2.ogg'            \
)
#define AMBIENCE_UNHOLY list(                        \
	'sound/ambience/unholy/unholy1.ogg'              \
)
#define AMBIENCE_LAVA list(                          \
	'sound/ambience/lava/lava1.ogg'                  \
)