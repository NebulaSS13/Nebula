//Darkmode preference by Kmc2000 and in_phaze//

var/global/lightmode_style = url_encode(file2text('code/modules/client/lightmode.css'))
var/global/darkmode_style = url_encode(file2text('code/modules/client/darkmode.css'))

/**
	Force the light and dark theme css files to be reloaded. Mainly usefule for devs.
 */
/proc/ReloadThemeCss(client/C, quiet = FALSE)
	//Reload the files.
	//#NOTE: I'm not sure why we're caching those as globals on the server? Would make more sense to load them directly from client local file into the winset()
	global.lightmode_style = url_encode(file2text('code/modules/client/lightmode.css'))
	global.darkmode_style  = url_encode(file2text('code/modules/client/darkmode.css'))

	//Tell our client to set their output window style.
	var/pref_mode = C.get_preference_value(/datum/client_preference/chat_color_mode)
	var/style_string
	if(pref_mode == PREF_LIGHTMODE)
		style_string = global.lightmode_style
	else
		style_string = global.darkmode_style
	winset(C, "output", "style = [style_string]")
	if(!quiet)
		to_chat(C, "Reloaded client CSS stylesheet for current theme.")

/*
This lets you switch chat themes by using winset and CSS loading.
Things to note:
If you change ANYTHING in interface/skin.dmf you need to change it here:
Format:
winset(src, "window as appears in skin.dmf after elem", "var to change = currentvalue;var to change = desired value")
*/

/client/proc/deactivate_darkmode(clear_chat = TRUE) //There's no way round it. We're essentially changing the skin by hand. It's painful but it works, and is the way Lummox suggested.
	//Main windows
	winset(src, "infowindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = none")
	winset(src, "infowindow", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "rpane", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = none")
	winset(src, "rpane", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "info", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "info", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "outputwindow", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "outputwindow", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "rpanewindow", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "rpanewindow", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "mainwindow", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = none")
	winset(src, "split", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "status_bar", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "status_bar", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	//Buttons
	winset(src, "textb", "background-color = #494949;background-color = none")
	winset(src, "textb", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "infob", "background-color = #494949;background-color = none")
	winset(src, "infob", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "button_codex", "background-color = #494949;background-color = none")
	winset(src, "button_codex", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "rulesb", "background-color = #494949;background-color = none")
	winset(src, "rulesb", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "Lore", "background-color = #494949;background-color = none")
	winset(src, "Lore", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "wikib", "background-color = #494949;background-color = none")
	winset(src, "wikib", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "forumb", "background-color = #494949;background-color = none")
	winset(src, "forumb", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "changelog", "background-color = #494949;background-color = none")
	winset(src, "changelog", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "github", "background-color = #494949;background-color = none")
	winset(src, "github", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "BugReport", "background-color = #494949;background-color = none")
	winset(src, "BugReport", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	//Status and verb tabs
	winset(src, "output", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "output", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "output", "style=[global.lightmode_style]")
	winset(src, "info", "background-color = [COLOR_DARKMODE_DARKBACKGROUND];background-color = #FFFFFF")
	winset(src, "info", "tab-background-color = [COLOR_DARKMODE_BACKGROUND];tab-background-color = none")
	winset(src, "info", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "info", "tab-text-color = [COLOR_DARKMODE_TEXT];tab-text-color = #000000")
	winset(src, "info", "prefix-color = [COLOR_DARKMODE_TEXT];prefix-color = #000000")
	winset(src, "info", "suffix-color = [COLOR_DARKMODE_TEXT];suffix-color = #000000")
	//Say, OOC, me Buttons etc.
	winset(src, "saybutton", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "saybutton", "text-color = [COLOR_DARKMODE_TEXT];text-color = #000000")
	winset(src, "asset_cache_browser", "background-color = [COLOR_DARKMODE_BACKGROUND];background-color = none")
	winset(src, "asset_cache_browser", "text-color = [COLOR_DARKMODE_TEXT];text-color = none")

	if(clear_chat)
		to_output(src, null, "outputwindow.output")
		if(join_motd)
			to_chat(src, "<div class=\"motd\">[join_motd]</div>")
			to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")
		to_chat(src, "Light mode activated, chat cleared!")

/client/proc/activate_darkmode(clear_chat = TRUE) //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	winset(src, "infowindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "infowindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "rpane", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "rpane", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "info", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "browseroutput", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "browseroutput", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "outputwindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "outputwindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "rpanewindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "rpanewindow", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "mainwindow", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "split", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "status_bar", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "status_bar", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	//Buttons
	winset(src, "textb", "background-color = none;background-color = #494949")
	winset(src, "textb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "infob", "background-color = none;background-color = #494949")
	winset(src, "infob", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "button_codex", "background-color = none;background-color = #494949")
	winset(src, "button_codex", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "rulesb", "background-color = none;background-color = #494949")
	winset(src, "rulesb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "Lore", "background-color = none;background-color = #494949")
	winset(src, "Lore", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "wikib", "background-color = none;background-color = #494949")
	winset(src, "wikib", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "forumb", "background-color = none;background-color = #494949")
	winset(src, "forumb", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "changelog", "background-color = none;background-color = #494949")
	winset(src, "changelog", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "github", "background-color = none;background-color = #494949")
	winset(src, "github", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "BugReport", "background-color = none;background-color = #494949")
	winset(src, "BugReport", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	//Chat pane
	winset(src, "output", "background-color = none;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "output", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "output", "style=[global.darkmode_style]")
	//Status and verb tabs
	winset(src, "info", "background-color = #FFFFFF;background-color = [COLOR_DARKMODE_DARKBACKGROUND]")
	winset(src, "info", "tab-background-color = none;tab-background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "info", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "tab-text-color = #000000;tab-text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "prefix-color = #000000;prefix-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "info", "suffix-color = #000000;suffix-color = [COLOR_DARKMODE_TEXT]")
	//Say, OOC, me Buttons etc.
	winset(src, "saybutton", "background-color = none;background-color = #494949")
	winset(src, "saybutton", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")
	winset(src, "asset_cache_browser", "background-color = none;background-color = [COLOR_DARKMODE_BACKGROUND]")
	winset(src, "asset_cache_browser", "text-color = #000000;text-color = [COLOR_DARKMODE_TEXT]")

	if(clear_chat)
		to_output(src, null, "outputwindow.output")
		if(join_motd)
			to_chat(src, "<div class=\"motd\">[join_motd]</div>")
			to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")
		to_chat(src, "Dark mode activated, chat cleared!")
