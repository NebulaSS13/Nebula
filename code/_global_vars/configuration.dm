// Bomb cap!
var/max_explosion_range = 14

var/href_logfile        = null
var/game_version        = "Nebula13"
var/changelog_hash      = ""
var/join_motd = null

var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/Debug2 = 0

var/gravity_is_on = 1

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon // General-purpose record database.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

 // Used for admin shenanigans.
var/random_players = FALSE
var/triai = FALSE
