/decl/hierarchy
	allow_abstract_init = TRUE
	abstract_type = /decl/hierarchy
	var/name = "Hierarchy"
	var/decl/hierarchy/parent
	var/list/decl/hierarchy/children

/decl/hierarchy/Initialize()
	children = list()
	for(var/subtype in subtypesof(type))
		var/decl/hierarchy/child = GET_DECL(subtype) // Might be a grandchild, which has already been handled.
		if(child.parent_type == type)
			insert_sorted(children, child, /proc/cmp_name_asc)
			child.parent = src
	. = ..()

/decl/hierarchy/proc/is_category()
	return INSTANCE_IS_ABSTRACT(src) && length(children)

/decl/hierarchy/proc/get_descendents()
	if(!children)
		return
	. = children.Copy()
	for(var/decl/hierarchy/child in children)
		if(child.children)
			. |= child.get_descendents()
