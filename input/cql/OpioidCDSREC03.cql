library OpioidCDSREC03 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**  Recommendation #3
**    When starting opioid therapy for acute, subacute, or chronic pain, clinicians should 
**    prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) 
**    opioids (recommendation category: A; evidence type: 4).
**
**  When
**    Provider is prescribing an extended release opioid analgesic with ambulatory misuse potential in the outpatient setting
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
**    When Initiating Opioid Therapy, Utilize Immediate Release Opioids:
**      Document - Will prescribe immediate release opioid
**      Snooze - Benefits outweigh risks, snooze 3 months
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-03

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Chronic Pain Extended Release Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )
      and AmbulatoryOpioidPrescription.medication in Common."Extended release opioid with ambulatory misuse potential"

define "Patient Is Being Prescribed Extended Release Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Chronic Pain Extended Release Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Extended Release Opioid Analgesic with Ambulatory Misuse Potential"
      and Routines."CDC 2022 Guideline General Inclusion Criteria"
      and Routines."Is Opioid Naive?"

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
