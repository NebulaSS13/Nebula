#define isWrench(A)      (A && A.iswrench())
#define isWelder(A)      (A && A.iswelder())
#define isCoil(A)        (A && A.iscoil())
#define isWirecutter(A)  (A && A.iswirecutter())
#define isScrewdriver(A) (A && A.isscrewdriver())
#define isMultitool(A)   (A && A.ismultitool())
#define isCrowbar(A)     (A && A.iscrowbar())
#define isHatchet(A)     (A && A.ishatchet())

/atom/proc/iswrench()
	return FALSE

/atom/proc/iswelder()
	return FALSE

/atom/proc/iscoil()
	return FALSE

/atom/proc/iswirecutter()
	return FALSE

/atom/proc/isscrewdriver()
	return FALSE

/atom/proc/ismultitool()
	return FALSE

/atom/proc/iscrowbar()
	return FALSE

/atom/proc/ishatchet()
	return FALSE

/obj/item/stack/cable_coil/iscoil()
	return TRUE

/obj/item/multitool/ismultitool()
	return TRUE

/obj/item/iswrench()
	return current_tool_type == TOOL_FLAG_WRENCH

/obj/item/iswelder()
	return current_tool_type == TOOL_FLAG_WELDER

/obj/item/iswirecutter()
	return current_tool_type == TOOL_FLAG_WIRECUTTER

/obj/item/isscrewdriver()
	return current_tool_type == TOOL_FLAG_SCREWDRIVER

/obj/item/iscrowbar()
	return current_tool_type == TOOL_FLAG_CROWBAR

/obj/item/ishatchet()
	return current_tool_type == TOOL_FLAG_HATCHET
