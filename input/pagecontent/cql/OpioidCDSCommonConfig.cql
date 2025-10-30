library OpioidCDSCommonConfig version '2022.1.0'

// Override the default value set - ensure the identifier is the same
valueset "Opiate Medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opiate-medications'

// Opioid Review Useful
define "Age Less than 18 Years Is Enabled":
  true

// Opioid Review Useful
define "End-Stage Disease Criteria Enabled":
  true

// Sickle Cell
define "Sickle Cell Check Enabled":
  true

define "Sickle Cell Assumed Active":
  true

// Active Cancer Treatment
define "Active Cancer Treatment Encounters Condition Is Enabled":
  true

// Opioid Naive
define "Opioid Naive Prescription Condition Is Enabled":
  true

// Opioid Naive
define "Opioid Naive Report Condition Is Enabled":
  true

// Opioid Naive
define "Opioid Naive Dispense Condition Is Enabled":
  true

// OpioidCDSCommon
define "Hospice Findings Exclusion Enabled":
  false

// Subroutine 2 - Past Medications
define "Can the implementing EHR support queries for past medications by date range?":
  true

// Recommendation 2
define "Opioid Treatment Plan Verification Enabled":
  true

// Recommendation 3
define "Opioid Harms & Risks Discussion in Past 90 Days Criteria Enabled":
  true

// Recommendation 6
define "Order is to Treat Acute Pain Enabled":
  true

// Recommendation 8
define "Evidence of Naloxone Enabled":
  true

// Recommendation 9
define "PDMP Data Not Reviewed in Past 90 Days Criteria Enabled":
  true

// Recommendation 10
define "Opiate Urine Screening Check Enabled":
  true

define "Cannabinoid Urine Screening Check Enabled":
  false

define "Use Alternative UDS Lookback Period":
  false

define "Alternative UDS Lookback Period":
  Interval[Today() - 6 months - 1 days, Today()]

define "Unexpected Positive Lookback Duration":
  61 days

define "Unexpected Positive Lookback Duration String":
  '60 days'

define "Use Default Opiate Medications ValueSet":
  false

// Recommendation 12
define "Evidence Based Treatment Criteria For Opioid Use Disorder":
  true
