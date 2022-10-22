

// This is for machines which bypass standard interactions entirely, usually because they are hidden subtypes or auxiliary entities.
// Use for actual machines is discouraged.

/decl/machine_construction/noninteractive
	visible_components = FALSE

/decl/machine_construction/noninteractive/terminal/mechanics_info()
	. += "Use a wirecutter to disconnect the terminal from the machine."