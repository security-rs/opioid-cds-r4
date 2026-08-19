library OpioidCDSREC09 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #9
**    When prescribing initial opioid therapy for acute, subacute, or chronic pain, and periodically 
**    during opioid therapy for chronic pain, clinicians should review the patient’s history of 
**    controlled substance prescriptions using state prescription drug monitoring program (PDMP) data 
**    to determine whether the patient is receiving opioid dosages or combinations that put the patient 
**    at high risk for overdose (recommendation category: B; evidence type: 4).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting
**    CDC 2022 guideline general inclusion criteria met for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    PDMP data has not been reviewed in the past 90 days or
**    PDMP review procedure has not been performed in the past 90 days
**  Then
**    Before Ordering Opioids, Review PDMP Data:
**      Access Data - Launch app to review PDMP data
**      Document - PDMP data reviewed, snooze 3 months
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-09

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Look Back 90 Days":
  Interval[Today() - 90 days, Today()]

define "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "PDMP Data Not Reviewed in Past 90 Days":
  Config."PDMP Data Not Reviewed in Past 90 Days Criteria Enabled"
    and not (
      exists (
        [Procedure: Common."PDMP review procedure"] P
          where P.status ~ 'completed'
            and P.performed during "Look Back 90 Days"
      )
      or exists (
        [Observation: Common."PDMP data reviewed finding"] O
          where O.status in { 'final', 'amended' }
            and (
              if O.effective is FHIR.Period
                then (O.effective as FHIR.Period) during day of "Look Back 90 Days"
                else if O.effective is FHIR.dateTime
                  then date from O.effective in day of "Look Back 90 Days"
                  else false
          )
      )
    )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and "PDMP Data Not Reviewed in Past 90 Days"

define "Exclusion Criteria":
  false

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
