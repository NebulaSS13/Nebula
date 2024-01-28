#define HAS_ASPECT(holder, check_aspect) (ismob(holder) && ispath(check_aspect, /decl/aspect) && (GET_DECL(check_aspect) in holder.personal_aspects))

#define ADD_ASPECT(holder, add_aspect) \
	if(holder && add_aspect && !HAS_ASPECT(holder, add_aspect)) { \
		var/decl/aspect/A = GET_DECL(add_aspect); \
		LAZYDISTINCTADD(holder.personal_aspects, A); \
		holder.need_aspect_sort = TRUE; \
		A.apply(holder); \
	}

#define ASPECTS_PHYSICAL  BITFLAG(0)
#define ASPECTS_MENTAL    BITFLAG(1)

#define DEFINE_ROBOLIMB_MODEL_ASPECTS(MODEL_PATH, MODEL_ID, COST) \
/decl/aspect/prosthetic_limb/left_hand/##MODEL_ID {                                                        \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/left_hand;                                                       \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/left_arm/##MODEL_ID {                                                         \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/left_arm;                                                        \
	aspect_cost = COST;                                                                                    \
}                                                                                                          \
/decl/aspect/prosthetic_limb/right_hand/##MODEL_ID {                                                       \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/right_hand;                                                      \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/right_arm/##MODEL_ID {                                                        \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/right_arm;                                                       \
	aspect_cost = COST;                                                                                    \
}                                                                                                          \
/decl/aspect/prosthetic_limb/left_foot/##MODEL_ID {                                                        \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/left_foot;                                                       \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/left_leg/##MODEL_ID {                                                         \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/left_leg;                                                        \
	aspect_cost = COST;                                                                                    \
}                                                                                                          \
/decl/aspect/prosthetic_limb/right_foot/##MODEL_ID {                                                       \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/right_foot;                                                      \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/right_leg/##MODEL_ID {                                                        \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/right_leg;                                                       \
	aspect_cost = COST;                                                                                    \
}                                                                                                          \
/decl/aspect/prosthetic_limb/head/##MODEL_ID {                                                             \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/head;                                                            \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/chest/##MODEL_ID {                                                            \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/chest;                                                           \
	aspect_cost = COST * 0.5;                                                                              \
}                                                                                                          \
/decl/aspect/prosthetic_limb/groin/##MODEL_ID {                                                            \
	model = MODEL_PATH;                                                                                    \
	parent = /decl/aspect/prosthetic_limb/groin;                                                           \
	aspect_cost = COST * 0.5;                                                                              \
}
