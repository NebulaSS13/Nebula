// This proc is used to offset a mob overlay image (such as hats on nonhumans)
var/global/list/offset_image_cache = list()
/proc/offset_image(var/mob/owner, var/image/I, var/list/offsets)

	if(!istype(I))
		return
	if(!istype(owner))
		return I

	var/cache_key = "[I.icon]-[I.icon_state]-[json_encode(offsets)]-[owner.icon]"
	if(!global.offset_image_cache[cache_key])
		var/icon/final = icon(owner.icon, "template") // whoever uses this proc should also check the owner a template state in its image
		for(var/dir in offsets)
			var/list/facing_list = offsets[dir]
			var/icon/canvas = icon(owner.icon, "template")
			var/use_dir = text2num(dir)
			canvas.Blend(icon(I.icon, I.icon_state, dir = use_dir), ICON_OVERLAY, facing_list[1]+1, facing_list[2]+1)
			final.Insert(canvas, dir = use_dir)
		global.offset_image_cache[cache_key] = final

	I.icon = global.offset_image_cache[cache_key]
	I.icon_state = ""
	for(var/thing in I.overlays)
		I.overlays -= thing
		I.overlays += offset_image(owner, thing, offsets)

	return I