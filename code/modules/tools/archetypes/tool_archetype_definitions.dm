/decl/tool_archetype/cable_coil
	name         = "cable coil"
	tool_message = "rewiring"

/decl/tool_archetype/wirecutters
	name         = "wirecutters"
	article      = FALSE
	tool_sound   = 'sound/items/Wirecutter.ogg'
	codex_key    = TOOL_CODEX_WIRECUTTERS
	tool_message = "snipping"

/decl/tool_archetype/screwdriver
	name         = "screwdriver"
	tool_sound   = 'sound/items/Screwdriver.ogg'
	codex_key    = TOOL_CODEX_SCREWDRIVER

/decl/tool_archetype/multitool
	name         = "multitool"
	codex_key    = TOOL_CODEX_MULTITOOL
	tool_message = "reconfiguring"

/decl/tool_archetype/crowbar
	name         = "crowbar"
	codex_key    = TOOL_CODEX_CROWBAR
	tool_message = "levering"

/decl/tool_archetype/hatchet
	name         = "hatchet"
	tool_sound   = 'sound/items/axe_wood.ogg'
	tool_message = "chopping"

/decl/tool_archetype/wrench
	name         = "wrench"
	tool_sound   = 'sound/items/Ratchet.ogg'
	codex_key    = TOOL_CODEX_WRENCH

/decl/tool_archetype/shovel
	name         = "shovel"
	tool_sound   = 'sound/items/shovel_dirt.ogg'
	tool_message = "digging"

/decl/tool_archetype/pick
	name         = "pick"
	tool_sound   = 'sound/weapons/Genhit.ogg'
	tool_message = "excavating"

/decl/tool_archetype/hammer
	name         = "hammer"
	tool_sound   = 'sound/weapons/Genhit.ogg'
	tool_message = "striking"

/decl/tool_archetype/hoe
	name         = "hoe"
	tool_sound   = 'sound/items/shovel_dirt.ogg'
	tool_message = "tilling"

/decl/tool_archetype/stamp
	name         = "stamp"
	tool_message = "stamping"

/decl/tool_archetype/shears
	name         = "shears"
	tool_sound   = 'sound/weapons/bladeslice.ogg'
	tool_message = "shearing"

/decl/tool_archetype/knife
	name         = "knife"
	tool_sound   = 'sound/weapons/bladeslice.ogg'
	tool_message = "cutting"

/decl/tool_archetype/knife/get_default_quality(obj/item/tool)
	if(tool)
		if(tool.sharp && tool.edge)
			return TOOL_QUALITY_DEFAULT
		else if(tool.sharp || tool.edge)
			return TOOL_QUALITY_MEDIOCRE
	return ..()

/decl/tool_archetype/knife/get_default_speed(obj/item/tool)
	if(tool)
		if(tool.sharp && tool.edge)
			return TOOL_SPEED_DEFAULT
		else if(tool.sharp || tool.edge)
			return TOOL_SPEED_MEDIOCRE
	return ..()
