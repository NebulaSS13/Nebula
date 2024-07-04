
/**
 * Observer Pattern Implementation: Payroll Revoked
 *
 * Raised when: Someone's payroll is stolen at the Accounts terminal.
 *
 * Arguments that the called proc should expect:
 *     /datum/money_account: The account whose payroll was revoked.
 */
/decl/observ/revoke_payroll
	name = "Payroll Revoked"

/**
 * Observer Pattern Implementation: Account Status Changed
 *
 * Raised when: Someone's account is suspended or unsuspended at the Accounts terminal.
 *
 * Arguments that the called proc should expect:
 *     /datum/money_account: The account whose status was changed.
 */
/decl/observ/change_account_status
	name = "Account Status Changed"
