// Macro functions.
#define RAND_F(LOW, HIGH) (rand() * (HIGH - LOW) + LOW)
#define CEILING(x) (-round(-(x)))

// Float-aware floor and ceiling since round() will round upwards when given a second arg.
#define NONUNIT_FLOOR(x, y)    (round( (x) / (y)) * (y))
#define NONUNIT_CEILING(x, y) (-round(-(x) / (y)) * (y))

#define MULT_BY_RANDOM_COEF(VAR,LO,HI) VAR =  round((VAR * rand(LO * 100, HI * 100))/100, 0.1)

#define ROUND(x) (((x) >= 0) ? round((x)) : -round(-(x)))
#define FLOOR(x) (round(x))
#define EULER 2.7182818285

#define MODULUS_FLOAT(X, Y) ( (X) - (Y) * round((X) / (Y)) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS_FLOAT((degrees), 360))

#define IS_POWER_OF_TWO(VAL) ((VAL & (VAL-1)) == 0)
#define ROUND_UP_TO_POWER_OF_TWO(VAL) (2 ** CEILING(log(2,VAL)))
