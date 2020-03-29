
// Generic ones

/decl/artifact_appearance
	var/name = "alien artifact"
/decl/artifact_appearance/proc/apply_to(obj/structure/artifact/A)
	A.SetName(name)
	adjust_desc(A)
	adjust_icon(A)
	A.update_icon()
/decl/artifact_appearance/proc/adjust_desc(obj/structure/artifact/A)
/decl/artifact_appearance/proc/adjust_icon(obj/structure/artifact/A)
	var/icon_num = rand(0, 6)
	A.base_icon = "ano[icon_num]"

// Thing with vents?

/decl/artifact_appearance/vents
	name = "alien artifact"
/decl/artifact_appearance/vents/adjust_desc(obj/structure/artifact/A)
	A.desc = "A large alien device, there appear to be some kind of vents in the side."
/decl/artifact_appearance/vents/adjust_icon(obj/structure/artifact/A)
	A.base_icon = "ano10"

// Computer

/decl/artifact_appearance/computer
	name = "alien computer"
/decl/artifact_appearance/computer/adjust_desc(obj/structure/artifact/A)
	A.desc = "It is covered in strange markings."
/decl/artifact_appearance/computer/adjust_icon(obj/structure/artifact/A)
	A.base_icon = "ano9"
	
// Sealed pod

/decl/artifact_appearance/pod
	name = "sealed alien pod"
/decl/artifact_appearance/pod/adjust_icon(obj/structure/artifact/A)
	A.base_icon = "ano11"

// Crystals
/decl/artifact_appearance/crystal
	name = "large crystal"
/decl/artifact_appearance/crystal/adjust_desc(obj/structure/artifact/A)
	A.desc = pick(
		"It shines faintly as it catches the light.",
		"It appears to have a faint inner glow.",
		"It seems to draw you inward as you look it at.",
		"Something twinkles faintly as you look at it.",
		"It's mesmerizing to behold.")
/decl/artifact_appearance/crystal/adjust_icon(obj/structure/artifact/A)
	A.base_icon = "ano[pick(7,8)]"