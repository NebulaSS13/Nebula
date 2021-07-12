var/global/end_credits_song
var/global/end_credits_title

/datum/admin_secret_item/fun_secret/change_credits_song
	name = "Change End Credits Song"
/datum/admin_secret_item/fun_secret/change_credits_title
	name = "Change End Credits Title"

/datum/admin_secret_item/fun_secret/change_credits_song/do_execute()
	var/list/sounds = subtypesof(/decl/music_track)	

	var/decl/music_track/selected = input("Select a music track for the credits.", "Server music list") as null|anything in sounds

	if(selected)
		var/decl/music_track/track = GET_DECL(selected)
		global.end_credits_song = track.song
	
	SSstatistics.add_field_details("admin_verb","CECS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admin_secret_item/fun_secret/change_credits_title/do_execute()
	global.end_credits_title = input(usr, "What title would you like for the end credits?") as null|text

	if(!global.end_credits_title)
		return

	SSstatistics.add_field_details("admin_verb","CECT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!