//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/proc/open_external_page_wrap(url, title)
	if(!url)
		to_chat(src, SPAN_WARNING("The [title] page URL is not set in the server configuration."))
	else if(alert("This will open the [title] page in your browser. Are you sure?",,"Yes","No") == "Yes")
		send_link(src, url)

/client/verb/open_wiki()
	set name = "Wiki"
	set desc = "Visit the wiki."
	set category = "OOC"

	open_external_page_wrap(config.wikiurl, "wiki")

/client/verb/open_codebase()
	set name = "Source Code"
	set desc = "Visit the codebase repository."
	set category = "OOC"

	open_external_page_wrap(config.githuburl, "codebase")

/client/verb/open_report_bug()
	set name = "Bug Report"
	set desc = "Visit the codebase repository to report an issue or bug."
	set category = "OOC"

	open_external_page_wrap(config.issuereporturl, "codebase")

/client/verb/open_community()
	set name = "Community"
	set desc = "Visit the community page."
	set category = "OOC"

	open_external_page_wrap(config.forumurl, "community")

#define RULES_FILE "config/rules.html"
/client/verb/open_rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set category = "OOC"
	show_browser(src, file(RULES_FILE), "window=rules;size=480x320")
#undef RULES_FILE
