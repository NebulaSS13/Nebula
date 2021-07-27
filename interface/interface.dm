//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "Wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if(config.wikiurl)
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		send_link(src, config.wikiurl)
	else
		to_chat(src, SPAN_WARNING("The wiki URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub repository."
	set hidden = 1
	if(config.githuburl)
		if(alert("This will open GitHub in your browser. Are you sure?",,"Yes","No")=="No")
			return
		send_link(src, config.githuburl)
	else
		to_chat(src, SPAN_WARNING("The github URL is not set in the server configuration."))
	return

/client/verb/bugreport()
	set name = "Bug Report"
	set desc = "Visit the GitHub repository to report an issue or bug."
	set hidden = 1
	if(config.issuereporturl)
		if(alert("This will open GitHub in your browser. Are you sure?",,"Yes","No")=="No")
			return
		send_link(src, config.issuereporturl)
	else
		to_chat(src, SPAN_WARNING("The issue report URL is not set in the server configuration."))
	return

/client/verb/forum()
	set name = "Forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(config.forumurl)
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		send_link(src, config.forumurl)
	else
		to_chat(src, SPAN_WARNING("The forum URL is not set in the server configuration."))
	return

/client/verb/discord()
	set name = "Discord"
	set desc = "Visit the Discord server."
	set hidden = 1
	if(config.discordurl)
		if(alert("This will open the Discord invition link in your browser. Are you sure?",,"Yes","No")=="No")
			return
		send_link(src, config.discordurl)
	else
		to_chat(src, SPAN_WARNING("The Discord server URL is not set in the server configuration."))
	return

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	show_browser(src, file(RULES_FILE), "window=rules;size=480x320")
#undef RULES_FILE
