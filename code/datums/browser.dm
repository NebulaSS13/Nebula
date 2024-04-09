/datum/browser
	var/mob/user
	var/title
	/// window_id is used as the window name for browse and onclose
	var/window_id
	var/width
	var/height
	var/atom/ref
	var/window_options = "focus=0;can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	/// this CSS sheet is common to all UIs
	var/common_stylesheet = 'html/browser/common.css'
	var/list/stylesheets = list()
	var/list/scripts = list()
	var/head_content = ""
	var/content = ""
	var/title_buttons = ""
	var/written_text = WRITTEN_SKIP

/datum/browser/written_physical
	written_text = WRITTEN_PHYSICAL

/datum/browser/written_digital
	written_text = WRITTEN_DIGITAL

/datum/browser/New(nuser, nwindow_id, ntitle, nwidth, nheight, atom/nref)

	user = nuser
	window_id = nwindow_id

	if(ntitle)
		set_title(ntitle)

	if(nwidth)
		width = nwidth

	if(nheight)
		height = nheight

	if(nref)
		ref = nref

	// If a client exists, but they have disabled fancy windowing, disable it!
	if(user?.client?.get_preference_value(/datum/client_preference/browser_style) == PREF_PLAIN)
		return

	if(common_stylesheet)
		add_stylesheet("common", common_stylesheet)

/datum/browser/proc/set_title(ntitle)
	title = sanitize(ntitle)

/datum/browser/proc/add_head_content(nhead_content)
	head_content = nhead_content

/datum/browser/proc/set_title_buttons(ntitle_buttons)
	title_buttons = ntitle_buttons

/datum/browser/proc/set_window_options(nwindow_options)
	window_options = nwindow_options

/datum/browser/proc/add_stylesheet(name, file)
	stylesheets[name] = file

/datum/browser/proc/add_script(name, file)
	scripts[name] = file

/datum/browser/proc/set_content(ncontent)
	content = ncontent

/datum/browser/proc/get_header()
	var/key
	var/filename
	for (key in stylesheets)
		filename = "[ckey(key)].css"
		send_rsc(user, stylesheets[key], filename)
		head_content += "<link rel='stylesheet' type='text/css' href='[filename]'>"

	for (key in scripts)
		filename = "[ckey(key)].js"
		send_rsc(user, scripts[key], filename)
		head_content += "<script type='text/javascript' src='[filename]'></script>"

	var/title_attributes = "class='uiTitle'"

	return {"<!DOCTYPE html>
<html>
	<meta charset=\"utf-8\">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		[head_content]
	</head>
	<body scroll=auto>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div [title_attributes]><tt>[title]</tt></div><div class='uiTitleButtons'>[title_buttons]</div></div>" : ""]
			<div class='uiContent'>
	"}

/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	. = {"
	[get_header()]
	[content]
	[get_footer()]
	"}
	if(written_text != WRITTEN_SKIP)
		. = user.handle_reading_literacy(user, ., digital = (written_text == WRITTEN_DIGITAL))

/datum/browser/proc/open(use_onclose = TRUE)
	var/window_size = ""
	if(width && height)
		window_size = "size=[width||0]x[height||0];"

	show_browser(user, get_content(), "window=[window_id];[window_size][window_options]")

	if(use_onclose)
		onclose(user, window_id, ref)

/datum/browser/proc/update(force_open, use_onclose = TRUE)
	if(force_open)
		open(use_onclose)
	else
		send_output(user, get_content(), "[window_id].browser")

/datum/browser/proc/close()
	close_browser(user, "window=[window_id]")

/**
 * Registers the on-close verb for a browse window (client/verb/.windowclose)
 * this will be called when the close-button of a window is pressed.

 * This is usually only needed for devices that regularly update the browse window,
 * e.g. canisters, timers, etc.
 *
 * windowid should be the specified window name
 * e.g. code is	: show_browser(user, text, "window=fred")
 * then use 	: onclose(user, "fred")
 *
 * Optionally, specify the "ref" parameter as the controlled atom (usually src)
 * to pass a "close=1" parameter to the atom's Topic() proc for special handling.
 * Otherwise, the user mob's machine var will be reset directly.
 */
/proc/onclose(mob/user, windowid, atom/ref)
	if(!user || !user.client)
		return

	var/param = ref ? "\ref[ref]" : "null"
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, post_onclose), windowid, param), 2)

/mob/proc/post_onclose(windowid, param)
	if(client)
		winset(src, windowid, "on-close=\".windowclose [param]\"")


/**
 * the on-close client verb
 *
 * called when a browser popup window is closed after registering with proc/onclose()
 * if a valid atom reference is supplied, call the atom's Topic() with "close=1"
 * otherwise, just reset the client mob's machine var.
 */
/client/verb/windowclose(atomref as text)
	set name = ".windowclose"
	set hidden = TRUE
	if (atomref != "null")
		atomref = locate(atomref)
		if (atomref)
			usr = src?.mob
			Topic("close=1", list("close" = "1"), atomref)
			return

	if (src?.mob)
		mob.unset_machine()
