/datum/unit_test/jukebox_track_validate
	name = "MUSIC TRACK: Validate Jukebox Tracks"

/datum/unit_test/jukebox_track_validate/start_test()
	var/list/bad_boxes = list()
	for(var/obj/machinery/media/jukebox/jukebox in SSmachines.machinery)
		for(var/entry in jukebox.tracks)
			var/datum/track/track = entry
			if(!track.title || !ispath(track.track, /decl/music_track))
				bad_boxes += jukebox
				log_bad("Invalid jukebox track: [log_info_line(jukebox)]")
				break

	if(bad_boxes.len)
		fail("Found [bad_boxes.len] invalid jukebox(es)")
	else
		pass("All jukeboxes had valid tracks.")

	return 1
