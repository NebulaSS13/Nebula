// Required interfaces (fill in with your codebase equivalent):
#define TGS_EXTERNAL_CONFIGURATION

/// Create a global variable named `Name` and set it to `Value`.
#define TGS_DEFINE_AND_SET_GLOBAL(Name, Value) var/global/##Name = ##Value

/// Read the value in the global variable `Name`.
#define TGS_READ_GLOBAL(Name) global.##Name

/// Set the value in the global variable `Name` to `Value`.
#define TGS_WRITE_GLOBAL(Name, Value) global.##Name = ##Value

/// Disallow ANYONE from reflecting a given `path`, security measure to prevent in-game use of DD -> TGS capabilities.
#define TGS_PROTECT_DATUM(Path) //GENERAL_PROTECT_DATUM(##Path)

/// Display an announcement `message` from the server to all players.
#define TGS_WORLD_ANNOUNCE(message) world << ##message

/// Notify current in-game administrators of a string `event`.
#define TGS_NOTIFY_ADMINS(event) world.log << "TGS Admin Message: [##event]"

/// Write an info `message` to a server log.
#define TGS_INFO_LOG(message) world.log << "TGS Info: [##message]"

/// Write an warning `message` to a server log.
#define TGS_WARNING_LOG(message) world.log << "TGS Warning: [##message]"

/// Write an error `message` to a server log.
#define TGS_ERROR_LOG(message) world.log << "TGS Error: [##message]"

/// Get the number of connected /clients.
#define TGS_CLIENT_COUNT GLOB.clients.len

/// Put this at the start of [/world/proc/Topic].
#define TGS_TOPIC var/tgs_topic_return = TgsTopic(args[1]); if(tgs_topic_return) return tgs_topic_return