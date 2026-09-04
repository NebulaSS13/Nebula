// Macro functions.
#define RAND_F(LOW, HIGH) (rand() * ((HIGH) - (LOW)) + (LOW))

// Float-aware floor and ceiling since round() will round upwards when given a second arg.
#define NONUNIT_FLOOR(x, y)    (floor((x) / (y)) * (y))
#define NONUNIT_CEILING(x, y) (ceil((x) / (y)) * (y))

// Special two-step rounding for reagents, to avoid floating point errors.
#define CHEMS_QUANTIZE(x) NONUNIT_FLOOR(round(x, MINIMUM_CHEMICAL_VOLUME * 0.1), MINIMUM_CHEMICAL_VOLUME)

#define MULT_BY_RANDOM_COEF(VAR,LO,HI) VAR =  round((VAR * rand(LO * 100, HI * 100))/100, 0.1)

#define EULER 2.7182818285

#define MODULUS_FLOAT(X, Y) ( (X) - (Y) * round((X) / (Y)) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS_FLOAT((degrees), 360))

#define IS_POWER_OF_TWO(VAL) ((VAL & (VAL-1)) == 0)
#define ROUND_UP_TO_POWER_OF_TWO(VAL) (2 ** ceil(log(2,VAL)))

// turn(0, angle) returns a random dir. This macro will instead do nothing if dir is already 0.
#define SAFE_TURN(DIR, ANGLE) (DIR && turn(DIR, ANGLE))
