/// Visual formatting for character info/comments.

var/global/_comment_mood_legend
/proc/get_comment_mood_legend()
	if(!global._comment_mood_legend)
		var/legend_width = 500
		var/legend_per_row = 5
		var/legend_cell_width = floor(legend_width/legend_per_row)
		global._comment_mood_legend = list("<table align = 'center' width = '[legend_width]px' style='padding: 3px'><tr><td colspan = [legend_per_row]><center><b>Legend</b></center></td></tr>")
		var/list/all_moods = decls_repository.get_decls_of_type(/decl/comment_mood)
		var/counter = 0
		for(var/mood_type in all_moods)
			if(counter == 0)
				global._comment_mood_legend += "<tr>"
			var/decl/comment_mood/mood = all_moods[mood_type]
			global._comment_mood_legend += "<td title = '[mood.name]' style=\"border: 1px solid [mood.fg_color];\" width = '[legend_cell_width]px' bgcolor = '[mood.bg_color]'><center><font size = 1 color = '[mood.fg_color]'>[mood.name]</font></center></td>"
			counter++
			if(counter == legend_per_row)
				counter = 0
				global._comment_mood_legend += "</tr>"
		if(counter != 0)
			global._comment_mood_legend += "</tr>"
		global._comment_mood_legend += "</table>"
		global._comment_mood_legend = jointext(global._comment_mood_legend, null)
	return global._comment_mood_legend

/// Formatting data for comments.
/decl/comment_mood
	abstract_type = /decl/comment_mood
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// Descriptive name used for mood selector.
	var/name
	/// Colour to format the foreground (text).
	var/fg_color = COLOR_BLACK
	/// Colour to format the background (fill).
	var/bg_color = COLOR_GRAY80

/decl/comment_mood/unknown
	name = "Unknown or no contact"
	uid = "comment_mood_unknown"

/decl/comment_mood/good_friend
	name = "Good friend"
	bg_color = COLOR_LIME
	uid = "comment_mood_good_friend"

/decl/comment_mood/friend_with_benefits
	name = "Friend with benefits"
	bg_color = "#ea9999"
	uid = "comment_mood_fwb"


/decl/comment_mood/crush_infatuation
	name = "Crush or infatuation"
	bg_color = COLOR_RED
	uid = "comment_mood_crush"

/decl/comment_mood/relationship
	name = "Committed relationship"
	bg_color = "#ff00ff"
	uid = "comment_mood_love"

/decl/comment_mood/old_flame
	name = "Old flame"
	fg_color = COLOR_WHITE
	bg_color = "#a61c00"
	uid = "comment_mood_old_flame"

/decl/comment_mood/complicated
	name = "It's complicated"
	fg_color = COLOR_WHITE
	bg_color = "#9900ff"
	uid = "comment_mood_complicated"

/decl/comment_mood/hatred
	name = "Hatred"
	fg_color = COLOR_WHITE
	bg_color = COLOR_BLACK
	uid = "comment_mood_hatred"

/decl/comment_mood/dislike
	name = "Disliked acquaintance"
	fg_color = COLOR_WHITE
	bg_color = "#274e13"
	uid = "comment_mood_disliked_acq"

/decl/comment_mood/concern
	name = "Concern or worry"
	bg_color = "#fff2cc"
	uid = "comment_mood_concern"

/decl/comment_mood/confusion
	name = "Confusion or bewilderment"
	bg_color = "#a64d79"
	uid = "comment_mood_confusion"

/decl/comment_mood/best_friend
	name = "Best friend"
	bg_color = COLOR_YELLOW
	uid = "comment_mood_best_friend"

/decl/comment_mood/vague_acquaintance
	name = "Vague acquaintance"
	bg_color = "#a4c2f4"
	uid = "comment_mood_vague_acq"

/decl/comment_mood/family
	name = "Family"
	bg_color = "#ff9900"
	uid = "comment_mood_family"

/decl/comment_mood/noted_dislike
	name = "Noted dislike"
	fg_color = COLOR_WHITE
	bg_color = "#783f04"
	uid = "comment_mood_noted_dislike"

/decl/comment_mood/fear
	name = "Fear"
	fg_color = COLOR_WHITE
	bg_color = "#0404e1"
	uid = "comment_mood_fear"

/decl/comment_mood/respect
	name = "Respect or idolization"
	bg_color = "#f9cb9c"
	uid = "comment_mood_respect"

/decl/comment_mood/rival
	name = "Rival"
	bg_color = COLOR_CYAN
	uid = "comment_mood_rival"

/decl/comment_mood/friendly_acquaintance
	name = "Friendly acquaintance"
	bg_color = "#57bb8a"
	uid = "comment_mood_friendly_acq"

/decl/comment_mood/pity
	name = "Pity"
	fg_color = COLOR_WHITE
	bg_color = "#073763"
	uid = "comment_mood_pity"
