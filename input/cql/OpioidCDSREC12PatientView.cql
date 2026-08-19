library OpioidCDSREC12PatientView version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config

/*
**
**  Recommendation #12
**    Clinicians should offer or arrange treatment with evidence-based medications to treat patients 
**    with opioid use disorder. Detoxification on its own, without medications for opioid use disorder, 
**    is not recommended for opioid use disorder because of increased risks for resuming drug use, 
**    overdose, and overdose death (recommendation category: A; evidence type: 1).
**
**  When
**    Patient is 18 years or older
**    Patient has a diagnosis of opioid use disorder in the past 90 days
**    No active order for buprenorphine or methadone medication
**  Then
**    Offer evidence-based medications to treat patients with opioid use disorder:
**      Document - Will order medication to treat opioid use disorder
**      Refer - Will refer patient to SUD specialist
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: PlanDefinition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-12-patient-view

context Patient

define "Opioid Use Disorder Lookback Period":
  Interval[Today() - 90 days, Today()]

define "Not Receiving Evidence-Based Treatment for Opioid Use Disorder":
  Config."Evidence Based Treatment Criteria For Opioid Use Disorder"
    and not (
        if Config."Can the implementing EHR support queries for past medications by date range?" then
          exists (
            [MedicationRequest: Common."Buprenorphine and methadone medications"] MR
              where MR.status in { 'active', 'completed' }
                and date from MR.authoredOn during day of "Opioid Use Disorder Lookback Period"
          )
        else
            true
    /* update 2022 removes "behavioral therapy condition"
      or exists (
        [Procedure: Common."Substance misuse behavioral counseling"] P
          where P.status ~ 'completed'
            and (
              case
                when P.performed is FHIR.dateTime then
                  Interval[FHIRHelpers.ToDateTime(P.performed as FHIR.dateTime), FHIRHelpers.ToDateTime(P.performed as FHIR.dateTime)]
                when P.performed is FHIR.Period then
                  FHIRHelpers.ToInterval(P.performed as FHIR.Period)
                else
                  null as Interval<DateTime>
                end
            ) during day of "Opioid Use Disorder Lookback Period"
      )*/
    )

define "Presence of Diagnosis of Opioid Use Disorder":
  exists (
    Common."US Core-Categorized Conditions" C
      where C.code in Common."Opioid misuse disorders"
        and C.clinicalStatus in Common."Active Condition"
        and date from C.recordedDate during day of "Opioid Use Disorder Lookback Period"
    )

define "Positive Result from Opioid Use Disorder Evaluation Tool":
  true

define "Inclusion Criteria":
  Common."Patient 18 or Older?"
    and "Not Receiving Evidence-Based Treatment for Opioid Use Disorder"
    and "Presence of Diagnosis of Opioid Use Disorder"
    and "Positive Result from Opioid Use Disorder Evaluation Tool"

define "Exclusion Criteria":
  false

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
