/world
/* This page contains info for the hub. To allow your server to be visible on the hub, update the entry in the config.
 * You can also toggle visibility from in-game with toggle-hub-visibility; be aware that it takes a few minutes for the hub go
 */
	hub = "Exadv1.spacestation13"
	name = "Space Station 13 - Nebula13"

/world/proc/update_hub_visibility()
	if(get_config_value(/decl/config/toggle/hub_visibility))
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"
