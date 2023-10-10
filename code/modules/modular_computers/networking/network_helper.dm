/proc/parse_network_uri(var/uri)
	var/found = findtext(uri, ".")
	if(!found)
		return
	return list("network_tag" = copytext(uri, 1, found), "network_id" = copytext(uri, found + 1))
