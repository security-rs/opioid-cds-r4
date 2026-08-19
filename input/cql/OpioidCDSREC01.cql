library OpioidCDSREC01 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #1
**    Nonopioid therapies are at least as effective as opioids for many common types of acute pain. 
**    Clinicians should maximize use of nonpharmacologic and nonopioid pharmacologic therapies as 
**    appropriate for the specific condition and patient and only consider opioid therapy for acute 
**    pain if benefits are anticipated to outweigh risks to the patient. Before prescribing opioid 
**    therapy for acute pain, clinicians should discuss with patients the realistic benefits and 
**    known risks of opioid therapy (recommendation category: B; evidence type: 3).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting
**    Prescription is for treating acute pain.
**    CDC 2022 guideline general inclusion criteria met for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    Patient is opioid naive:
**      No indication of opioid use in the past 90 days from a prescription, self report (for future implementation), or a dispensing event (for future implementation)
**  Then
**    Consider Nonopioid Treatment Options for Acute Pain:
**      Document - Record reason for opioid therapy
**      Snooze - Attempt alternative therapy, snooze 3 months
**      Order - Select alternative therapies from order set
**      Snooze - N/A see comment, snooze 3 months
**      Remove - Will remove triggering medication order
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-01

parameter ContextPrescriptions List<FHIR.MedicationRequest>

context Patient

define "Acute Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Acute Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Acute Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and Routines."Is Opioid Naive?"

define "Exclusion Criteria":
  false

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
