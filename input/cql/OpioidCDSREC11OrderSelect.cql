library OpioidCDSREC11OrderSelect version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #11
**    Clinicians should use particular caution when prescribing opioid pain medication and benzodiazepines concurrently 
**    and consider whether benefits outweigh risks of concurrent prescribing of opioids and other central nervous system 
**    depressants  (recommendation category: B; evidence type: 3).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting or
**    Provider is prescribing a benzodiazepine or other central nervous system depressant medication
**    CDC 2022 guideline general inclusion criteria met for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    Patient prescribed opioid analgesic with ambulatory misuse potential and benzodiazepine or other central nervous system depressant medication concurrently
**  Then
**    Use particular caution when prescribing opioid pain medication and benzodiazepines concurrently:
**      Document - Will modify prescription
**      Snooze - Benefits outweigh risks, snooze 3 months
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-11-order-select

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions )

define "Benzodiazepine or CNS Depressant Prescriptions":
  Common."Is Benzodiazepine or CNS Depressant?"( ContextPrescriptions )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Patient Is Being Prescribed Benzodiazepine or CNS Depressant":
  exists( "Benzodiazepine or CNS Depressant Prescriptions" )

define "Inclusion Criteria":
  (
    (
      "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
        and exists Common."Active Ambulatory Benzodiazepine or CNS Depressant Rx"
    )
      or (
        "Patient Is Being Prescribed Benzodiazepine or CNS Depressant"
          and exists Common."Active Ambulatory Opioid Rx"
      )
  )
    and Routines."CDC 2022 Guideline General Inclusion Criteria"

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
