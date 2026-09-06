/obj/item/music_player
	abstract_type = /obj/item/music_player
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 7
	w_class = ITEM_SIZE_HUGE //forbid putting something that emits loud sounds forever into a backpack

	var/playing = 0
	var/track_num = 1
	var/music_volume = 20
	var/max_volume = 40
	var/datum/sound_token/sound_token
	var/list/datum/track/tracks
	var/sound_id
	var/player_name = "Music Player"
	var/interact_sound
	var/music_frequency = 1

/obj/item/music_player/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(playing)
		icon_state = "[icon_state]_on"

/obj/item/music_player/proc/stop()
	playing = 0
	update_icon()
	QDEL_NULL(sound_token)

/obj/item/music_player/proc/start()
	QDEL_NULL(sound_token)
	var/datum/track/T = tracks[track_num]
	sound_token = play_looping_sound(src, sound_id, T.GetTrack(), volume = music_volume, frequency = music_frequency, range = 7, falloff = 4, prefer_mute = TRUE, preference = /datum/client_preference/play_game_music, streaming = TRUE)
	playing = 1
	update_icon()

/obj/item/music_player/attack_self(var/mob/user)
	interact(user)

/obj/item/music_player/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"
	tracks = setup_music_tracks(tracks)

/obj/item/music_player/Destroy()
	stop()
	. = ..()

/obj/item/music_player/interact(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/dat = list()
	var/datum/track/T = tracks[track_num]
	if(istype(T) && T.title)
		dat += "<h3>[T.title]</h3><br>"
	dat += "<A href='byond://?src=\ref[src];tracknum=1;'>NEXT</a>"
	dat += "<A href='byond://?src=\ref[src];tracknum=-1;'>PREV</a>"
	dat += "<A href='byond://?src=\ref[src];start=1;'>PLAY</a>"
	dat += "<A href='byond://?src=\ref[src];stop=1;'>STOP</a>"
	dat += "<A href='byond://?src=\ref[src];voldown=1;'>VOL -</a>"
	dat += "<A href='byond://?src=\ref[src];volup=1;'>VOL +</a>"
	var/datum/browser/popup = new(user, "music_player_[name]", "[player_name]", 350, 150)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/item/music_player/DefaultTopicState()
	return global.physical_topic_state

/obj/item/music_player/CouldUseTopic(var/mob/user)
	..()
	if(interact_sound)
		playsound(src, interact_sound, 40)

/obj/item/music_player/OnTopic(var/user, var/list/href_list)
	if(href_list["tracknum"])
		var/diff = text2num(href_list["tracknum"])
		track_num += diff
		if(track_num > tracks.len)
			track_num = 1
		else if (track_num < 1)
			track_num = tracks.len
		if(playing)
			start()
		interact(user)
		return TOPIC_REFRESH
	if(href_list["stop"])
		stop()
		return TOPIC_HANDLED
	if(href_list["start"])
		start()
		return TOPIC_HANDLED
	if(href_list["volup"])
		change_volume(music_volume + 10)
		return TOPIC_HANDLED
	if(href_list["voldown"])
		change_volume(music_volume - 10)
		return TOPIC_HANDLED

/obj/item/music_player/proc/change_volume(var/new_volume)
	music_volume = clamp(new_volume, 0, max_volume)
	if(sound_token)
		sound_token.SetVolume(music_volume)
