/decl/music_track
	var/artist
	var/title
	var/album
	var/decl/license/license
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70
	abstract_type = /decl/music_track

/decl/music_track/Initialize()
	. = ..()
	license = GET_DECL(license)

/decl/music_track/validate()
	. = ..()
	if(!song)
		. += "Missing song"
	if(!title)
		. += "Missing title"
	if(istype(license, /decl/license))
		if(license.attribution_mandatory)
			if(!artist || cmptext(artist, "unknown"))
				. += "Invalid artist"
			if(!url || cmptext(url, "unknown"))
				. += "Invalid url"
	else
		. += "Invalid license"

/decl/music_track/proc/play_to(var/listener)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)

	to_chat(listener, "<span class='good'>License: <a href='[license.url]'>[license.name]</a></span>")
	sound_to(listener, sound(song, repeat = 1, wait = 0, volume = volume, channel = sound_channels.lobby_channel))

// No VV editing anything about music tracks
/decl/music_track/VV_static()
	return ..() + vars
