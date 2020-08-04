/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"
	
/proc/icon2html(thing, target, icon_state, dir, frame = 1, moving = FALSE, realsize = FALSE, class = null)
	if (!thing)
		return

	var/key
	var/icon/I = thing
	if (!target)
		return
	if (target == world)
		target = GLOB.clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
		if (!targets.len)
			return
	if (!isicon(I))
		if (isfile(thing)) //special snowflake
			var/name = "[generate_asset_name(thing)].png"
			register_asset(name, thing)
			for (var/thing2 in targets)
				send_asset(thing2, key, FALSE)
			return "<img class='icon icon-misc [class]' src=\"[url_encode(name)]\">"
		var/atom/A = thing
		if (isnull(dir))
			dir = A.dir
		if (isnull(icon_state))
			icon_state = A.icon_state
		I = A.icon
		if(istype(thing, /mob/living/carbon/human)) // Shitty workaround for a BYOND issue.
			var/icon/temp = I
			I = icon()
			I.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	I = icon(I, icon_state, dir, frame, moving)

	key = "[generate_asset_name(I)].png"
	register_asset(key, I)
	for (var/thing2 in targets)
		send_asset(thing2, key, FALSE)

	if(realsize)
		return "<img class='icon icon-[icon_state] [class]' style='width:[I.Width()]px;height:[I.Height()]px;min-height:[I.Height()]px' src=\"[url_encode(key)]\">"
	return "<img class='icon icon-[icon_state] [class]' src=\"[url_encode(key)]\">"


/proc/to_world(message)
	for(var/client/C in GLOB.clients)
		to_chat(C, message)

/atom
	var/last_chat_message
	var/last_chat_message_count = 0

/client/New()
	..()
	src << output( \
{"
[script]
<script type='text/javascript'>

	function replace(msg, count) {
		var replacing = document.getElementById('chatOutput').innerHTML;
		var replacingIndex = replacing.lastIndexOf('<BR>');
		if(replacingIndex >= 0)
		{
			msg += ' <sup><span class=\\'notice\\'><i>x ' + count + '</i></span></sup>';
			document.getElementById('chatOutput').innerHTML = replacing.substring(0, replacingIndex);
		}
		append(msg)
	}

	function append(msg)
	{
		document.getElementById('chatOutput').innerHTML += '<br>' + msg;
		var scrollingElement = (document.scrollingElement || document.body);
		scrollingElement.scrollTop = scrollingElement.scrollHeight;
	}

	</script>

	<div id='chatOutput'></div>
	"}, "outputwindow.output");

/proc/to_chat(var/atom/target, var/message)
	if(!message)
		return
	if(istype(target, /client))
		var/client/C = target
		target = C.mob
	if(istype(target))
		var/func = "append"
		if(isnull(target.last_chat_message) || message != target.last_chat_message)
			target.last_chat_message_count = 0
		else
			func = "replace"
		target.last_chat_message_count++
		target << output(list2params(list(message, target.last_chat_message_count)), "outputwindow.output:[func]")
		target.last_chat_message = message
