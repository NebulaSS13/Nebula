/datum/track
	var/title
	var/track

/datum/track/New(_title, _track)
	title = _title
	track = _track

/datum/track/proc/GetTrack()
	if(ispath(track, /decl/music_track))
		var/decl/music_track/music_track = GET_DECL(track)
		return music_track.song
	return track // Allows admins to continue their adminbus simply by overriding the track var
