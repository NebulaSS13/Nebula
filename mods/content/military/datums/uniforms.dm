/decl/hierarchy/mil_uniform
	name = "Master outfit hierarchy"
	hierarchy_type = /decl/hierarchy/mil_uniform
	var/list/branches = null
	var/departments = 0
	var/min_rank = 0

	var/pt_under = null
	var/pt_shoes = null

	var/utility_under = null
	var/utility_shoes = null
	var/utility_hat = null
	var/utility_extra = null

	var/service_under = null
	var/service_skirt = null
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_skirt = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

/decl/hierarchy/mil_uniform/arm
	name = "Master Armsmen outfit"
	hierarchy_type = /decl/hierarchy/mil_uniform/arm
	branches = list(/datum/mil_branch/fed_armsmen)

	utility_under = /obj/item/clothing/under/armsmen/utility
	utility_shoes = /obj/item/clothing/shoes/jackboots
	utility_hat = /obj/item/clothing/head/beret/purple
	utility_extra = list()