#define SETUP_RANDOM_COLOR_GETTER(X, Y, Z, W)  \
/decl/bodytype/var/list/random_##Y = W;\
/decl/bodytype/proc/get_random_##X(){\
	if((Z && !(appearance_flags & Z)) || !random_##Y.len){\
		return;\
	}\
	var/decl/color_generator/CG = GET_DECL(pickweight(random_##Y));\
	return CG && CG.generate_random_colour();\
}

#define SETUP_RANDOM_COLOR_SETTER(X, Y)\
/mob/living/human/proc/randomize_##X(){\
	var/decl/bodytype/root_bodytype = get_bodytype();\
	if(!root_bodytype){\
		return;\
	}\
	var/colour = root_bodytype.get_random_##X();\
	if(colour){\
		Y(colour);\
	}\
}

SETUP_RANDOM_COLOR_GETTER(skin_color, skin_colors, HAS_SKIN_COLOR, list(
	/decl/color_generator/black,
	/decl/color_generator/grey,
	/decl/color_generator/brown,
	/decl/color_generator/chestnut,
	/decl/color_generator/blue,
	/decl/color_generator/blue_light,
	/decl/color_generator/green,
	/decl/color_generator/white))
SETUP_RANDOM_COLOR_SETTER(skin_color, set_skin_colour)

SETUP_RANDOM_COLOR_GETTER(eye_color, eye_colors, HAS_EYE_COLOR, list(
	/decl/color_generator/black,
	/decl/color_generator/grey,
	/decl/color_generator/brown,
	/decl/color_generator/chestnut,
	/decl/color_generator/blue,
	/decl/color_generator/blue_light,
	/decl/color_generator/green,
	/decl/color_generator/albino_eye))
SETUP_RANDOM_COLOR_SETTER(eye_color, set_eye_colour)

/decl/bodytype/proc/get_random_skin_tone()
	return random_skin_tone(src)

/mob/living/human/proc/randomize_skin_tone()
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype)
		return
	var/new_tone = root_bodytype.get_random_skin_tone()
	if(!isnull(new_tone))
		change_skin_tone(new_tone)

#undef SETUP_RANDOM_COLOR_GETTER
