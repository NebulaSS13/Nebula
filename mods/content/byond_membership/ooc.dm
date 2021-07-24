/decl/communication_channel/ooc/get_emblem(client/C)
	if(!C)
		return

	if(C.get_byond_membership() && C.get_preference_value(/datum/client_preference/byond_membership/emblem) == PREF_SHOW)
		return "[html_icon('mods/content/byond_membership/member_content.dmi')] "
