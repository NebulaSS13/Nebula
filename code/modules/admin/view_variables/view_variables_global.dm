/proc/readglobal(which)
	. = global.vars[which]
		
/proc/writeglobal(which, newval)
	global.vars[which] = newval

/proc/getallglobals()
	. = list()
	for(var/some_global in global.vars)
		. += some_global

/var/decl/global_vars/global_vars_

/decl/global_vars/get_view_variables_header()
	return "<b>Global Variables</b>"

/decl/global_vars/get_view_variables_options()
	return "" // Ensuring changes to the base proc never affect us

/decl/global_vars/get_variables()
	. = getallglobals() - VV_hidden()
	if(!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		. -= VV_secluded()

/decl/global_vars/get_variable_value(varname)
	return readglobal(varname)

/decl/global_vars/set_variable_value(varname, value)
	writeglobal(varname, value)

/decl/global_vars/make_view_variables_variable_entry(varname, value)
	return "(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>) "

/decl/global_vars/VV_locked()
	return vars

/decl/global_vars/VV_hidden()
	return list(
		"admins",
		"log_directory",
		"world_qdel_log",
		"world_href_log",
		"forumsqladdress",
		"forumsqldb",
		"forumsqllogin",
		"forumsqlpass",
		"forumsqlport",
		"sqladdress",
		"sqldb",
		"sqllogin",
		"sqlpass",
		"sqlport",
		"comms_password",
		"ban_comms_password",
		"login_export_addr"
	)

/client/proc/debug_global_variables()
	set category = "Debug"
	set name = "View Global Variables"

	if(!global_vars_)
		global_vars_ = new()
	debug_variables(global_vars_)
