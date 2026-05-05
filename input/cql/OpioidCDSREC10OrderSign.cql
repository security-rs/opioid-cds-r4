library OpioidCDSREC10OrderSign version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines
include OpioidCDSREC10Common version '2022.1.0' called Rec10Common

/*
**  Recommendation #10
**    When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits 
**    and risks of toxicology testing to assess for prescribed medications as well as other prescribed 
**    and nonprescribed controlled substances (recommendation category: B; evidence type: 4).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting:
**    Prescription is for treating subacute and/or chronic pain.
**    Opioid review is useful for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    Nonopioid drug urine screening has not been performed in last 12 months or
**    Opioid drug urine screening has not been performed in last 12 months
**  Then
**    Consider the benefits and risks of conducting a urine toxicology screen:
**      Document - Order toxicology screen
**      Document risks outweigh benefits
**      Snooze - N/A see comment, snooze 3 months
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting:
**    Prescription is for treating subacute and/or chronic pain.
**    Opioid review is useful for this patient:
**      Patient is 18 or over
**      Patient does not have evidence of sickle cell disease
**      Patient does not have findings indicating limited life expectancy
**      Patient does not have orders for therapies indicating end of life care
**      Patient is not undergoing active cancer treatment:
**        Patient has had at least 2 office visits within the past 12 months with an oncology specialist present, or
**        Patient has had at least 2 office visits within the past 12 months with a CDC malignant cancer condition diagnosis
**      Patient does not have conditions likely terminal for opioid prescribing present
**    Nonopioid drug urine screening has been performed in last 12 months and
**    Opioid drug urine screening has been performed in last 12 months and
**    Positive result for synthetic opioid in the past year and not currently prescribed synthetic opioid or
**    Positive result for phencyclidine(PCP) in the past year or
**    Positive result for fentanyl in the past year and not currently prescribed fentanyl or
**    Positive result for cocaine in the past year or
**    Positive result for amphetamine in the past year and not currently prescribed amphetamine or
**    Positive result for tetrahydrocannabinol (THC) in the past year and not currently prescribed tetrahydrocannabinol (THC) or
**    Positive result for opiate in the past year and not currently prescribed natural opiate or
**    Positive result for alcohol in the past year or
**    Positive result for methadone in the past year and not currently prescribed methadone
**  Then
**    Patient may have unexpected toxicology test results:
**      Document - Will repeat urine drug screening more frequently
**      Document - Will assess patient for substance use disorder
**      Snooze - Patient's test results were expected, snooze for 3 months
**      Snooze - N/A snooze for 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds-r4/PlanDefinition/opioid-cds-10-order-sign

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Subacute or Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Subacute or Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Is Perform Drug Screen Recommendation Applicable?":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Rec10Common."Inclusion Criteria For UDS Recommendation"

define "Applicable Because of Unexpected Results":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and (
      if Config."Unexpected Results Latest UDS Only Enabled"
        then "Inclusion Criteria For Unexpected Results On Latest UDS"
      else Rec10Common."Inclusion Criteria For Unexpected Results"
    )

define "Latest UDS Date":
  First(Rec10Common."All Lab Dates in Lookback Period")

define "Inclusion Criteria For Unexpected Results On Latest UDS":
  Routines."Is Opioid Review Useful?"
    and exists (
      Rec10Common."Remove Substances Without Positive or Negative Results" Details
        where Details.unexpectedPosDetails.date contains "Latest UDS Date"
          or Details.unexpectedNegDetails.udsDate contains "Latest UDS Date"
    )

define "Detail":
  Rec10Common."Get HTML Details"