#define NETWORK_MAC  uniqueness_repository.Generate(/datum/uniqueness_generator/hex)
										// Network allowed actions
#define NET_FEATURE_SOFTWAREDOWNLOAD	BITFLAG(0)	// Downloads of software.
#define NET_FEATURE_COMMUNICATION		BITFLAG(1)	// Communication (messaging), e-mail.
#define NET_FEATURE_SYSTEMCONTROL		BITFLAG(2)	// Control of various systems, RCon, air alarm control, etc.
#define NET_FEATURE_SECURITY			BITFLAG(3)	// Access to security cameras, crew tracking etc.
#define NET_FEATURE_ACCESS				BITFLAG(4)	// Checking access by group membership, not modifying account access.
#define NET_FEATURE_RECORDS 			BITFLAG(5)	// Modifying accounts, viewing crew records etc.
#define NET_FEATURE_FILESYSTEM			BITFLAG(6)	// Accessing mainframe filesystems.
#define NET_FEATURE_DECK				BITFLAG(7)	// Control of docking beacons, supply, deck control.

#define NET_ALL_FEATURES		(NET_FEATURE_SOFTWAREDOWNLOAD|NET_FEATURE_COMMUNICATION|NET_FEATURE_SYSTEMCONTROL|NET_FEATURE_SECURITY|NET_FEATURE_ACCESS|NET_FEATURE_RECORDS|NET_FEATURE_FILESYSTEM|NET_FEATURE_DECK)

// Transfer speeds, used when downloading/uploading a file/program.
#define NETWORK_SPEED_BASE  1/NETWORK_BASE_BROADCAST_STRENGTH	// GQ/s transfer speed, multiplied by signal power
#define NETWORK_SPEED_DISK 	10		// GQ/s transfer speed when the device is transferring between hard drives

// Network mainframe roles
#define MF_ROLE_FILESERVER  	"FILE SERVER"
#define MF_ROLE_LOG_SERVER  	"LOG SERVER"
#define MF_ROLE_CREW_RECORDS    "RECORDS SERVER"
#define MF_ROLE_SOFTWARE    	"SOFTWARE REPOSITORY"
#define MF_ROLE_ACCOUNT_SERVER  "ACCOUNT SERVER"

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
#define PROGRAM_STATE_BROWSER 3

#define PROG_MISC  		"Miscellaneous"
#define PROG_ENG  		"Engineering"
#define PROG_OFFICE  	"Office Work"
#define PROG_COMMAND  	"Command"
#define PROG_SUPPLY  	"Supply and Shuttles"
#define PROG_ADMIN  	"Network Administration"
#define PROG_UTIL 		"Utility"
#define PROG_SEC 		"Security"
#define PROG_MONITOR	"Monitoring"

#define RECEIVER_WIRELESS					 1
#define RECEIVER_STRONG_WIRELESS			 2
#define RECEIVER_BROADCASTER				 3

#define NETWORK_BASE_BROADCAST_STRENGTH 		25
#define NETWORK_INTERNET_CONNECTION_STRENGTH	25
#define NETWORK_WIRED_CONNECTION_STRENGTH		100

// Caps for network logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NETWORK_LOGS 100
#define MIN_NETWORK_LOGS 10

// Default directories referenced by the OS or programs.
#define OS_PROGRAMS_DIR  "programs"
#define OS_RECORDS_DIR   "records"
#define OS_ACCOUNTS_DIR  "accounts"
#define OS_DOCUMENTS_DIR "documents"
#define OS_LOGS_DIR      "logs"

// Return codes for file storage.
#define OS_FILE_SUCCESS     1
#define OS_HARDDRIVE_ERROR  0
#define OS_FILE_NOT_FOUND  -1
#define OS_DIR_NOT_FOUND   -2
#define OS_FILE_EXISTS     -3
#define OS_FILE_NO_READ    -4
#define OS_FILE_NO_WRITE   -5
#define OS_HARDDRIVE_SPACE -6
#define OS_NETWORK_ERROR   -7
#define OS_BAD_NAME        -8
#define OS_BAD_TYPE        -9 // File type is unsupported on this hardware.