GLOBAL_PROTECTED(admins, /list, list())   // all clients whom are admins

var/global/list/clients =          list() // all clients
var/global/list/ckey_directory =   list() // all ckeys with associated client

var/global/list/player_list =      list() // List of all mobs **with clients attached**. Excludes /mob/new_player
var/global/list/human_mob_list =   list() // List of all human mobs and sub-types, including clientless
var/global/list/silicon_mob_list = list() // List of all silicon mobs, including clientless
var/global/list/living_mob_list_ = list() // List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list_ =   list() // List of all dead mobs, including clientless. Excludes /mob/new_player
var/global/list/ghost_mob_list =   list() // List of all ghosts, including clientless. Excludes /mob/new_player
