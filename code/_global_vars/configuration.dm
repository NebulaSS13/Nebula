// Bomb cap!
var/global/max_explosion_range = 14
var/global/game_version        = "Nebula"
var/global/changelog_hash      = ""
var/global/join_motd = null

var/global/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/global/Debug2 = 0

var/global/gravity_is_on = 1

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/global/DBConnection/dbcon // General-purpose record database.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/global/fileaccess_timer = 0
var/global/custom_event_msg = null

 // Used for admin shenanigans.
var/global/random_players = FALSE
var/global/triai = FALSE
