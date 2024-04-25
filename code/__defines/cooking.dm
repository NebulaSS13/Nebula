#define COOKING_HEAT_ANY      0
#define COOKING_HEAT_DIRECT   1
#define COOKING_HEAT_INDIRECT 2

#define FOOD_RAW             -1
#define FOOD_PREPARED         0
#define FOOD_COOKED           1

#define SOUP_PLAIN      0
#define SOUP_VEGETARIAN BITFLAG(0)
#define SOUP_CARNIVORE  BITFLAG(1)
#define SOUP_DAIRY      BITFLAG(2)

#define TASTE_IS_DATA (!istext(taste) || taste == "soup_flags" || taste == "soup_ingredients" || taste == "mask_name" || taste == "mask_color")
