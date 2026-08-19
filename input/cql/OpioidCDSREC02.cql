library OpioidCDSREC02 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #2
**    Nonopioid therapies are preferred for subacute and chronic pain. Clinicians should maximize 
**    use of nonpharmacologic and nonopioid pharmacologic therapies as appropriate for the specific 
**    condition and patient and only consider initiating opioid therapy if expected benefits for 
**    pain and function are anticipated to outweigh risks to the patient. Before starting opioid 
**    therapy for subacute or chronic pain, clinicians should discuss with patients the realistic 
**    benefits and known risks of opioid therapy, should work with patients to establish treatment 
**    goals for pain and function, and should consider how opioid therapy will be discontinued if 
**    benefits do not outweigh risks (recommendation category: A; evidence type: 2).
**
**  When
**    Provider is prescribing an opioid with ambulatory misuse potential in the outpatient setting
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
**    Patient is opioid naive:
**      No indication of opioid use in the past 90 days from a prescription, self report (for future implementation), or a dispensing event (for future implementation)
**    Pain management procedure in past 90 days is not present and
**    Pain treatment plan created, edited, or reviewed by the prescribing physician in past 90 days is not present
**  Then
**    Maximize Nonopioid Therapies as Appropriate:
**      Document - Collaborated with patient to identify treatment goals
**      Snooze - Attempting alternate therapy, snooze 3 months
**      Order - Select alternative therapies from order select
**      Snooze - N/A see comment, snooze 3 months
**      Remove - Will remove triggering medication order
**
*/

// META: PlanDefinition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-02

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Treatment Plan Lookback Period":
  Interval[Today() - 90 days, Today()]

define "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "No Opioid Treatment Plan Created, was Edited or Reviewed in Past 90 Days?":
  Config."Opioid Treatment Plan Verification Enabled"
    and not (
      exists ( "Opioid Treatment Plan Creation or Update in Past 90 Days" )
        or "Had Opioid Treatment Plan Reviewed in Past 90 Days"
    )

define "Opioid Treatment Plan Creation or Update in Past 90 Days":
  [CarePlan: category in Common."Pain treatment plan"] PainTreatmentPlan
    where PainTreatmentPlan.status in { 'active', 'completed' }
      and (
        FHIRHelpers.ToDateTime( PainTreatmentPlan.created ) during day of "Treatment Plan Lookback Period"
          or PainTreatmentPlan.meta.lastUpdated during day of "Treatment Plan Lookback Period"
      )
      and exists(
        "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions".recorder Recorder
          where Recorder ~ PainTreatmentPlan.author
      )

define "Had Opioid Treatment Plan Reviewed in Past 90 Days":
  exists (
    [Procedure: Common."Pain management procedure"] PainManagementProcedure
      where PainManagementProcedure.performed during day of "Treatment Plan Lookback Period"
        and exists (
          PainManagementProcedure.performer Performer
            with "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" ChronicPainScript
            such that Performer.actor ~ ChronicPainScript.recorder
        )
  )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and Routines."Is Opioid Naive?"
    and "No Opioid Treatment Plan Created, was Edited or Reviewed in Past 90 Days?"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
