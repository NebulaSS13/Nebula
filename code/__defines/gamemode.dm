//Used with the ticker to help choose the gamemode.
#define CHOOSE_GAMEMODE_SUCCESS     1 // A gamemode was successfully chosen.
#define CHOOSE_GAMEMODE_RETRY       2 // The gamemode could not be chosen; we will use the next most popular option voted in, or the default.
#define CHOOSE_GAMEMODE_REVOTE      3 // The gamemode could not be chosen; we need to have a revote.
#define CHOOSE_GAMEMODE_RESTART     4 // The gamemode could not be chosen; we will restart the server.
#define CHOOSE_GAMEMODE_SILENT_REDO 5 // The gamemode could not be chosen; we request to have the the proc rerun on the next tick.

//End game state, to manage round end.
#define END_GAME_NOT_OVER         1
#define END_GAME_MODE_FINISH_DONE 2
#define END_GAME_AWAITING_MAP     3
#define END_GAME_READY_TO_END     4
#define END_GAME_ENDING           5
#define END_GAME_AWAITING_TICKETS 6
#define END_GAME_DELAYED          7

#define BE_PAI   "BE_PAI"

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB    BITFLAG(0) // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB    BITFLAG(1) // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT BITFLAG(2) // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME     BITFLAG(3) // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE  BITFLAG(4) // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS      BITFLAG(5) // Shows up on roundstart report.
#define ANTAG_HAS_LEADER      BITFLAG(6) // Generates a leader antagonist.
#define ANTAG_HAS_NUKE        BITFLAG(7) // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN       BITFLAG(8) // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE         BITFLAG(9) // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE  BITFLAG(10) // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED BITFLAG(11) // If a game mode randomly selects antag types, antag types with this flag should be excluded.

#define DEFAULT_TELECRYSTAL_AMOUNT 130
#define IMPLANT_TELECRYSTAL_AMOUNT(x) (round(x * 0.49)) // If this cost is ever greater than half of DEFAULT_TELECRYSTAL_AMOUNT then it is possible to buy more TC than you spend

//Voting-related
#define VOTE_PROCESS_ABORT    1
#define VOTE_PROCESS_COMPLETE 2
#define VOTE_PROCESS_ONGOING  3

#define VOTE_STATUS_PREVOTE   1
#define VOTE_STATUS_ACTIVE    2
#define VOTE_STATUS_COMPLETE  3