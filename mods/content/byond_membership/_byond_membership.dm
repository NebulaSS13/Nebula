/decl/modpack/byond_membership
	name = "BYOND Membership"
	var/icon/emblem = icon('mods/content/byond_membership/member_content.dmi', "emblem")

/decl/modpack/byond_membership/get_membership_perks()
	return "OOC emblem"

/decl/communication_channel/ooc/get_emblem(client/C)
	if(C && C.get_byond_membership() && C.get_preference_value(/datum/client_preference/byond_membership/emblem) == PREF_SHOW)
		var/decl/modpack/byond_membership/bm = GET_DECL(/decl/modpack/byond_membership)
		return "[html_icon(bm.emblem)] "

/datum/client_preference/byond_membership/emblem
	description = "BYOND Membership Emblem"
	key = "BYOND_MEMBERSHIP_EMBLEM"
	options = list(PREF_SHOW, PREF_HIDE)
