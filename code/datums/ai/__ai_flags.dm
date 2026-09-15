#define AI_ACTIVITY_NORMAL           0
#define AI_ACTIVITY_MOVING_TO_TARGET 1
#define AI_ACTIVITY_BUILDING         2
#define AI_ACTIVITY_REPRODUCING      3
#define AI_ACTIVITY_ATTACKING        4
#define AI_ACTIVITY_MANEUVERING      5

#define AI_FLAGS_NONE            0
// Will scan for and attack targets.
#define AI_FLAG_AGGRESSIVE       BITFLAG(0)
// Will offer an 'alert' period before attacking fully.
#define AI_FLAG_ALERTS           BITFLAG(1)
// Will become tired and stop attacking after a period in attack stance
#define AI_FLAG_TIRES            BITFLAG(2)
// Will try to cloak and will remain at a distance until cloaked
#define AI_FLAG_AMBUSHER         BITFLAG(3)
// Will destroy obstacles and surrounding structures when hostile
#define AI_FLAG_DESTROYER        BITFLAG(4)
// Will attempt to keep a distance of 3 tiles while attacking from range.
#define AI_FLAG_CAUTIOUS         BITFLAG(5)
// Will attack their own faction.
#define AI_FLAG_ATTACKS_FACTION  BITFLAG(6)
// Will only attack mobs on their enemies list.
#define AI_FLAG_ATTACKS_ENEMIES  BITFLAG(7)
// Will attempt to escape when buckled.
#define AI_FLAG_ESCAPE_BUCKLES   BITFLAG(8)
// Will periodically wander when idle.
#define AI_FLAG_WANDERS          BITFLAG(9)
// Will stop wandering of pulled.
#define AI_FLAG_NO_PULLED_WANDER BITFLAG(10)
// Will flee when under a certain health threshold
#define AI_FLAG_COWARD           BITFLAG(11)
// Has a chance of lying down when idle.
#define AI_FLAG_RESTS            BITFLAG(12)
// Will become aggressive when hungry, and will eat dead prey.
#define AI_FLAG_HUNTER           BITFLAG(13)
// Will return to handler after a kill.
#define AI_FLAG_RETURNING        BITFLAG(14)
// Will follow after their closest friend when idle.
#define AI_FLAG_FRIENDLY         BITFLAG(15)
// Will listen for and respond to some commands.
#define AI_FLAG_COMMANDED        BITFLAG(16)
