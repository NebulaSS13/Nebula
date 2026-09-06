/obj/abstract/map_effect/interval/screen_shaker
	name = "screen shaker"
	icon_state = "screen_shaker"
	interval_lower_bound = 1 SECOND
	interval_upper_bound = 2 SECONDS

	/// How far the shaking effect extends to. By default it is one screen length.
	var/shake_radius = 7
	/// How long the shaking lasts.
	var/shake_duration = 2
	/// How much it shakes.
	var/shake_strength = 1

/obj/abstract/map_effect/interval/screen_shaker/trigger_map_effect()
	for(var/mob/player in player_list)
		if(player.z == z && get_dist(src, player) <= shake_radius)
			shake_camera(player, shake_duration, shake_strength)
