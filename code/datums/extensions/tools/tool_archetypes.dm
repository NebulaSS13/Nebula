/decl/tool_archetype
	var/name = "tool"
	var/list/tool_sounds //list of sounds to be picked from when tool is used.
	var/tool_effectiveness //greater than 1 is better, less than is vastly slower since the tool interaction uses a divisor
	var/requires_fuel = FALSE //does this use fuel?

/decl/tool_archetype/proc/handle_before_interaction()
  return TRUE

/decl/tool_archetype/proc/handle_post_interaction()
  return TRUE

/decl/tool_archetype/wrench
	name = "wrench"

/decl/tool_archetype/screwdriver
	name = "screwdriver"

/decl/tool_archetype/crowbar
	name = "crowbar"

/decl/tool_archetype/wirecutter
	name = "wirecutter"

/decl/tool_archetype/weldingtool
	name = "welding tool"

/decl/tool_archetype/weldingtool/handle_before_interaction()
  return isLit() && hasFuel()

/decl/tool_archetype/weldingtool/handle_post_interaction()
  return isLit() && hasFuel()

/decl/tool_archetype/hatchet
	name = "hatchet"

/decl/tool_archetype/wrench/power
	name = "powered boltdriver"

/decl/tool_archetype/screwdriver/power
	name = "powered screwdriver"

/decl/tool_archetype/crowbar/power
	name = "pry tool"

/decl/tool_archetype/wirecutter/power
	name = "cutting tool"