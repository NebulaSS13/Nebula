#define TRAIT_LEVEL_EXISTS   0
#define TRAIT_LEVEL_MINOR    1
#define TRAIT_LEVEL_MODERATE 2
#define TRAIT_LEVEL_MAJOR    3

#define DEFINE_ROBOLIMB_MODEL_TRAITS(MODEL_PATH, MODEL_ID, COST, MODEL_STRING) \
/decl/trait/prosthetic_limb/left_hand/##MODEL_ID {       \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/left_hand;      \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_left_hand_" + MODEL_STRING;  \
}                                                        \
/decl/trait/prosthetic_limb/left_arm/##MODEL_ID {        \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/left_arm;       \
	trait_cost = COST;                                   \
	uid = "trait_prosthetic_left_arm_" + MODEL_STRING;   \
}                                                        \
/decl/trait/prosthetic_limb/right_hand/##MODEL_ID {      \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/right_hand;     \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_right_hand_" + MODEL_STRING; \
}                                                        \
/decl/trait/prosthetic_limb/right_arm/##MODEL_ID {       \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/right_arm;      \
	trait_cost = COST;                                   \
	uid = "trait_prosthetic_right_arm_" + MODEL_STRING;  \
}                                                        \
/decl/trait/prosthetic_limb/left_foot/##MODEL_ID {       \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/left_foot;      \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_left_foot_" + MODEL_STRING;  \
}                                                        \
/decl/trait/prosthetic_limb/left_leg/##MODEL_ID {        \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/left_leg;       \
	trait_cost = COST;                                   \
	uid = "trait_prosthetic_left_leg_" + MODEL_STRING;   \
}                                                        \
/decl/trait/prosthetic_limb/right_foot/##MODEL_ID {      \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/right_foot;     \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_right_foot_" + MODEL_STRING; \
}                                                        \
/decl/trait/prosthetic_limb/right_leg/##MODEL_ID {       \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/right_leg;      \
	trait_cost = COST;                                   \
	uid = "trait_prosthetic_right_leg_" + MODEL_STRING;  \
}                                                        \
/decl/trait/prosthetic_limb/head/##MODEL_ID {            \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/head;           \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_head_" + MODEL_STRING;       \
}                                                        \
/decl/trait/prosthetic_limb/chest/##MODEL_ID {           \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/chest;          \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_chest_" + MODEL_STRING;      \
}                                                        \
/decl/trait/prosthetic_limb/groin/##MODEL_ID {           \
	model = MODEL_PATH;                                  \
	parent = /decl/trait/prosthetic_limb/groin;          \
	trait_cost = COST * 0.5;                             \
	uid = "trait_prosthetic_groin_" + MODEL_STRING;      \
}
