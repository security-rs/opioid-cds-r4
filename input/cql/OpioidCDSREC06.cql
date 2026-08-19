library OpioidCDSREC06 version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

/*
**
**  Recommendation #6
**    When opioids are needed for acute pain, clinicians should prescribe no greater quantity than 
**    needed for the expected duration of pain severe enough to require opioids 
**    (recommendation category: A; evidence type: 4).
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
**    Prescription is for more than 7 days
**  Then
**    When Treating Acute Pain, Prescribe No Greater Quantity Than Needed:
**      Document - Will adjust opioid order
**      Snooze - Benefits of opioid therapy duration outweigh risks, snooze 3 months
**      Snooze - N/A see comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-06

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Acute Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Acute Pain Prescription?"( AmbulatoryOpioidPrescription )
      and Routines."Acute Pain Prescription Greater Than 7 Days?"(AmbulatoryOpioidPrescription)

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential for Acute Pain":
  exists( "Acute Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Order is for Long-Acting Opioid":
  exists (
    "Acute Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" AmbulatoryOpioidPrescription
      where AmbulatoryOpioidPrescription.medication in Common."Extended release opioid with ambulatory misuse potential"
        or Common.GetDurationInDays( AmbulatoryOpioidPrescription.dispenseRequest.expectedSupplyDuration ) > 7 days
  )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential for Acute Pain"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and "Order is for Long-Acting Opioid"

define "Exclusion Criteria":
  false

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
