library OpioidCDSREC11PatientView version '2022.1.0'

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
**    There exists an active opioid analgesic with ambulatory misuse potential in the outpatient setting or
**    There exists an active benzodiazepine or other central nervous system depressant medication
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

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-11-patient-view

context Patient

define "Inclusion Criteria":
  (
    exists (Common."Active Ambulatory Benzodiazepine or CNS Depressant Rx")
      and exists (Common."Active Ambulatory Opioid Rx")
  ) and Routines."CDC 2022 Guideline General Inclusion Criteria"

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"

// Detected Issue - Avoid prescribing opioid pain medication and benzodiazepines concurrently

// define "Concurrent Benzodiazepine Prescription Issue":
//   DetectedIssue {
//     //identifier:,
//     status: FHIR.DetectedIssueStatus { value: 'preliminary' },
//     code: FHIR.CodeableConcept { text: FHIR.string { value: "Get Summary" } },
//     severity: FHIR.DetectedIssueSeverity { value: 'moderate' },
//     patient: FHIR.Reference { reference: FHIR.string { value: 'Patient/' + Patient.id } },
//     identified: FHIR.dateTime { value: Now() },
//     // TODO: Device representation...
//     // author:,
//     implicated:
//       (Common."Active Ambulatory Benzodiazepine Rx" union Common."Active Ambulatory Opioid Rx") M
//         return FHIR.Reference { reference: FHIR.string { value: 'MedicationRequest/' + M.id } },
//     detail: FHIR.string { value: "Get Detail" },
//     reference: FHIR.uri { value: 'http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioidcds-11-patient-view'}
//   }
