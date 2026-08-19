library OpioidCDSREC07 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #7
**    Clinicians should evaluate benefits and risks with patients within 1-4 weeks of starting 
**    opioid therapy for subacute or chronic pain or of dosage escalation. Clinicians should 
**    regularly reevaluate benefits and risks of continued opioid therapy with patients 
**    (recommendation category: A; evidence type: 4).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting
**    Prescription is for treating subacute and/or chronic pain.
**    CDC 2022 guideline general inclusion criteria met for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    Opioid risk benefit assessment has not been performed in the past 90 days
**  Then
**    Regularly Evaluate the Benefits and Risks of Opioid Therapy:
**      Document - Conducted benefit and risk assessment
**      Snooze - Conducted assessment, snooze 3 months
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-07

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Risk Assessment Interval":
  Interval[Today() - 91 days, Today() - 1 day]

define "Previous 10 Days Interval":
  Interval[Today() - 10 days, Today()]

define "Encounter Interval":
  Interval[Today() - 12 months - 1 days, Today() - 1 day]

define "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Opioid Risk Assessment in Past 90 Days":
  [Procedure: Common."Opioid misuse assessment procedure"] riskAssessment
    where start of (riskAssessment.performed as FHIR.Period) in day of "Risk Assessment Interval"

define "Prescribed Opioids for 7 of Past 10 Days with an Encounter":
  Common."Days on Opioids during Period"( "Previous 10 Days Interval" ) >= 7
    and exists (
      [Encounter: Common."Office Visit"] AmbulatoryEncounter
        where AmbulatoryEncounter.period during "Encounter Interval"
    )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and not exists ( "Opioid Risk Assessment in Past 90 Days" )
    and (
      "Prescribed Opioids for 7 of Past 10 Days with an Encounter"
        or Common."Prescribed Opioids for 21 or more of 30 Days for each of the past 3 Months"
    )

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"

