// Merchant price modifiers affect how much a merchant will buy or sell all items for.
// They are held inside of a merchant's `[supply|demand]_price_modifiers` list, with the path used as a key.
// As they are decls held inside of a list, different merchants can have their prices change in a modular way.

/decl/merchant_price_modifier
	abstract_type = /decl/merchant_price_modifier
	var/name = null
	var/should_be_displayed = FALSE

/**
	Called when the merchant is calculating the price for something being bought or sold, depending on which list the decl was placed inside of.

	Subtypes should perform some sort of calculation, and then return the answer, which will either become the final price for something,
	or be used as the next `value` for another price modifier further down the list.

	- `value`: The price of whatever item the merchant is evaluating. This is not necessarily the base price,
	as preceding `merchant_price_modifier`s will probably have already altered it.
	- `input`: A value which exists as the value in the key-value pair alongside the decl's typepath in the merchant's
	price modifier lists. This is typically just a number, but a list could be used for multiple values.
	- `mob/user`: Reference to the user who is buying from, or selling to, the merchant.
	- `datum/merchant/merchant`: Reference to the merchant that's currently being interacted with by `user`.
	- Return: The new value, generally derived from the inputted `value`.
*/
/decl/merchant_price_modifier/proc/calculate(value, input, mob/user, datum/merchant/merchant)
	return value // Default implementation doesn't modify the price.

/decl/merchant_price_modifier/proc/print_amount(input, mob/user, datum/merchant/merchant)
	return "[round(calculate(100, input, user, merchant), 0.1) - 100]%"


/// Adds the input to the value as a flat amount unconditionally.
/decl/merchant_price_modifier/flat
	name = "Flat"

/decl/merchant_price_modifier/flat/calculate(value, input, mob/user, datum/merchant/merchant)
	return value + input

/decl/merchant_price_modifier/flat/print_amount(input, mob/user, datum/merchant/merchant)
	return "[input >= 0 ? "+" : "-"][input]"


/// Multiplies the value by the inputted input unconditionally. A common use for this is to be the base markup for a merchant. E.g. `/decl/merchant_price_modifier/percentage = 1.2` makes the merchant charge 20% extra.
/decl/merchant_price_modifier/percentage
	name = "Percentage"

/decl/merchant_price_modifier/percentage/calculate(value, input, mob/user, datum/merchant/merchant)
	return value * input


/decl/merchant_price_modifier/percentage/tax
	name = "Tax"
	should_be_displayed = TRUE

/// Multiplies the value by the input, scaled linearly based on the merchant's current disposition, capping out at `/datum/merchant::MAX_DISPOSITION_THRESHOLD`.
/// Negative disposition will scale in the opposite direction.
/decl/merchant_price_modifier/disposition
	name = "Disposition"

/decl/merchant_price_modifier/disposition/calculate(value, input, mob/user, datum/merchant/merchant)
	var/weight = merchant.get_disposition(user) / (merchant.MAX_DISPOSITION_THRESHOLD)
	weight = clamp(weight, -1.0, 1.0)
	return Interpolate(value, value * input, weight)


/// Modifies the price based on the relative skill levels between the user and merchant, with the aim of having parity with the old system if the same inputs are used.
/decl/merchant_price_modifier/legacy_skill_disparity
	abstract_type = /decl/merchant_price_modifier/legacy_skill_disparity
	name = "Skill"

/decl/merchant_price_modifier/legacy_skill_disparity/proc/skill_curve(disparity)
	// A negative value means the user has the skill advantage, while a positive value means the merchant has the skill advantage.
	if(disparity >= 0)
		// The equation equals `1+x^2`, resulting in: 1, 2, 5, 10, 17
		return 1 + (disparity) ** 2

	// The equation equals `0.8^-x`, resulting in: 0.8, 0.64, 0.51, 0.4
	var/const/BASE_DISCOUNT_PER_LEVEL = 0.8
	return BASE_DISCOUNT_PER_LEVEL ** -(disparity)


/// Modifies the price of items the merchant sells based on relative skills while maintaining the same prices as the old system.
/decl/merchant_price_modifier/legacy_skill_disparity/supply

/decl/merchant_price_modifier/legacy_skill_disparity/supply/calculate(value, input, mob/user, datum/merchant/merchant)
	ASSERT(input > 0)

	var/skill_level_disparity = merchant.skill_level - user.get_skill_value(SKILL_FINANCE)
	var/skill_curve_factor = skill_curve(skill_level_disparity)

	// This differs from the legacy equation, as the old one had the merchant's markup embedded inside it.
	// The new equation will still result in the same outcome, provided `input` matches what the old margin variable was previously.
	value = (value * (skill_curve_factor * input - skill_curve_factor + 1)) / input

	return value


/// Modifies the price of items the merchant buys based on relative skills while using the same equations as the old system.
/decl/merchant_price_modifier/legacy_skill_disparity/demand

/decl/merchant_price_modifier/legacy_skill_disparity/demand/calculate(value, input, mob/user, datum/merchant/merchant)
	ASSERT(input > 0)

	var/skill_level_disparity = merchant.skill_level - user.get_skill_value(SKILL_FINANCE)
	var/skill_curve_factor = skill_curve(skill_level_disparity)

	value *= max(1 - (input - 1) * skill_curve_factor, 0.1)
	return value
