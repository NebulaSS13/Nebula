// A set of constants used to determine which type of mute an admin wishes to apply.
// Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_IC << 1)
// Therefore there needs to be a gap between the flags for the automute flags.
#define MUTE_IC        BITFLAG(0)
#define MUTE_OOC       BITFLAG(1)
#define MUTE_PRAY      BITFLAG(2)
#define MUTE_ADMINHELP BITFLAG(3)
#define MUTE_DEADCHAT  BITFLAG(4)
#define MUTE_AOOC      BITFLAG(5)
#define MUTE_ALL       (MUTE_IC|MUTE_OOC|MUTE_PRAY|MUTE_ADMINHELP|MUTE_DEADCHAT|MUTE_AOOC)

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions.
#define R_BUILDMODE     BITFLAG(0)
#define R_ADMIN         BITFLAG(1)
#define R_BAN           BITFLAG(2)
#define R_FUN           BITFLAG(3)
#define R_SERVER        BITFLAG(4)
#define R_DEBUG         BITFLAG(5)
#define R_POSSESS       BITFLAG(6)
#define R_PERMISSIONS   BITFLAG(7)
#define R_STEALTH       BITFLAG(8)
#define R_REJUVENATE    BITFLAG(9)
#define R_VAREDIT       BITFLAG(10)
#define R_SOUNDS        BITFLAG(11)
#define R_SPAWN         BITFLAG(12)
#define R_MOD           BITFLAG(13)
#define R_HOST          BITFLAG(14)
#define R_INVESTIGATE   (R_ADMIN|R_MOD)
#define R_EVERYTHING    (~0)

#define R_MAXPERMISSION BITFLAG(14) // This holds the maximum value for a permission. It is used in iteration, so keep it updated.

#define ADDANTAG_PLAYER 1	// Any player may call the add antagonist vote.
#define ADDANTAG_ADMIN 2	// Any player with admin privilegies may call the add antagonist vote.
#define ADDANTAG_AUTO 4		// The add antagonist vote is available as an alternative for transfer vote.

#define TICKET_CLOSED 0   // Ticket has been resolved or declined
#define TICKET_OPEN     1 // Ticket has been created, but not responded to
#define TICKET_ASSIGNED 2 // An admin has assigned themself to the ticket and will respond

#define LAST_CKEY(M) (M.ckey || M.last_ckey)
#define LAST_KEY(M)  (M.key || M.last_ckey)