#define NETWORK_MAC  uniqueness_repository.Generate(/datum/uniqueness_generator/hex)
									// Network allowed actions
#define NETWORK_SOFTWAREDOWNLOAD 	1 	// Downloads of software
#define NETWORK_COMMUNICATION 		2	// Communication (messaging)
#define NETWORK_SYSTEMCONTROL 		4	// Control of various systems, RCon, air alarm control, etc.
#define NETWORK_ALL_FEATURES		(NETWORK_SOFTWAREDOWNLOAD|NETWORK_COMMUNICATION|NETWORK_SYSTEMCONTROL)

// Transfer speeds, used when downloading/uploading a file/program.
#define NETWORK_SPEED_BASE  1/NETWORK_BASE_BROADCAST_STRENGTH	// GQ/s transfer speed, multiplied by signal power
#define NETWORK_SPEED_DISK 	10		// GQ/s transfer speed when the device is transferring between hard drives

// Network mainframe roles
#define MF_ROLE_FILESERVER  	"FILE SERVER"
#define MF_ROLE_EMAIL_SERVER  	"EMAIL SERVER"
#define MF_ROLE_LOG_SERVER  	"LOG SERVER"
#define MF_ROLE_CREW_RECORDS    "RECORDS SERVER"
#define MF_ROLE_SOFTWARE    	"SOFTWARE REPOSITORY"

// Program bitflags
#define PROGRAM_CONSOLE    BITFLAG(0)
#define PROGRAM_LAPTOP     BITFLAG(1)
#define PROGRAM_TABLET     BITFLAG(2)
#define PROGRAM_TELESCREEN BITFLAG(3)
#define PROGRAM_PDA        BITFLAG(4)
#define PROGRAM_ALL        (PROGRAM_CONSOLE|PROGRAM_LAPTOP|PROGRAM_TABLET|PROGRAM_TELESCREEN|PROGRAM_PDA)

#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

#define PROG_MISC  		"Miscellaneous"
#define PROG_ENG  		"Engineering"
#define PROG_OFFICE  	"Office Work"
#define PROG_COMMAND  	"Command"
#define PROG_SUPPLY  	"Supply and Shuttles"
#define PROG_ADMIN  	"Network Administration"
#define PROG_UTIL 		"Utility"
#define PROG_SEC 		"Security"
#define PROG_MONITOR	"Monitoring"

#define NETWORK_CONNECTION_WIRELESS			1
#define NETWORK_CONNECTION_STRONG_WIRELESS	2
#define NETWORK_BASE_BROADCAST_STRENGTH		25
#define NETWORK_WIRED_CONNECTION_STRENGTH	75

// Caps for network logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NETWORK_LOGS 100
#define MIN_NETWORK_LOGS 10