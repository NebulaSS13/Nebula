#define NETWORK_MAC  uniqueness_repository.Generate(/datum/uniqueness_generator/hex)
									// Network allowed actions
#define NETWORK_SOFTWAREDOWNLOAD 	1 	// Downloads of software
#define NETWORK_COMMUNICATION 		2	// Communication (messaging)
#define NETWORK_SYSTEMCONTROL 		4	// Control of various systems, RCon, air alarm control, etc.
#define NETWORK_ALL_FEATURES		(NETWORK_SOFTWAREDOWNLOAD|NETWORK_COMMUNICATION|NETWORK_SYSTEMCONTROL)

// Transfer speeds, used when downloading/uploading a file/program.
#define NETWORK_SPEED_LOWSIGNAL 0.5	// GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NETWORK_SPEED_HIGHSIGNAL 1	// GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NETWORK_SPEED_ETHERNET 2		// GQ/s transfer speed when the device is using wired connection
#define NETWORK_SPEED_DISK 	10		// GQ/s transfer speed when the device is transferring between hard drives

// Network mainframe roles
#define MF_ROLE_FILESERVER  	"FILE SERVER"
#define MF_ROLE_EMAIL_SERVER  	"EMAIL SERVER"
#define MF_ROLE_LOG_SERVER  	"LOG SERVER"
#define MF_ROLE_CREW_RECORDS    "RECORDS SERVER"
#define MF_ROLE_SOFTWARE    	"SOFTWARE REPOSITORY"
#define MF_ROLE_DESIGN			"DESIGN REPOSITORY"
#define MF_ROLE_CLONING			"CLONING REPOSITORY"

// Program bitflags
#define PROGRAM_ALL 		0x1F
#define PROGRAM_CONSOLE 	0x1
#define PROGRAM_LAPTOP 		0x2
#define PROGRAM_TABLET 		0x4
#define PROGRAM_TELESCREEN 	0x8
#define PROGRAM_PDA 		0x10

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
#define NETWORK_CONNECTION_WIRED			3
#define NETWORK_BASE_BROADCAST_STRENGTH		25

// Caps for network logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NETWORK_LOGS 100
#define MIN_NETWORK_LOGS 10