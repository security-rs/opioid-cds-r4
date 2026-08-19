library OpioidCDSREC04And05 version '2022.1.0'

using FHIR version '4.0.1'

include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines
/*include fhir.cdc."opioid-mme-r4".MMECalculator version '3.0.0' called MMECalculator
 */
include MMECalculator version '3.0.0' called MMECalculator

/*
**
**  Recommendation #4
**    When opioids are initiated for opioid-naïve patients with acute, subacute, or chronic pain, 
**    clinicians should prescribe the lowest effective dosage. If opioids are continued for 
**    subacute or chronic pain, clinicians should use caution when prescribing opioids at any dosage, 
**    should carefully evaluate individual benefits and risks when considering increasing dosage, and 
**    should avoid increasing dosage above levels likely to yield diminishing returns in benefits 
**    relative to risks to patients (recommendation category: A; evidence type: 3)
**  Recommendation #5
**    For patients already receiving opioid therapy, clinicians should carefully weigh benefits and 
**    risks and exercise care when changing opioid dosage. If benefits outweigh risks of continued 
**    opioid therapy, clinicians should work closely with patients to optimize nonopioid therapies 
**    while continuing opioid therapy. If benefits do not outweigh risks of continued opioid therapy, 
**    clinicians should optimize other therapies and work closely with patients to gradually taper to 
**    lower dosages or, if warranted based on the individual circumstances of the patient, appropriately 
**    taper and discontinue opioids. Unless there are indications of a life-threatening issue such as 
**    warning signs of impending overdose (e.g., confusion, sedation, or slurred speech), opioid therapy 
**    should not be discontinued abruptly, and clinicians should not rapidly reduce opioid dosages from 
**    higher dosages (recommendation category: B; evidence type: 4).
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
**    Patient Morphine Milligram Equivalent (MME) greater than or equal to 50
**  Then
**    Calibrate to Lowest Opioid Dose Needed for Expected Results and Exercise Care When Changing Opioid Dosages:
**      Document - Will prescribe a lower dose
**      Document - Will calibrate a gradual change in dosage
**      Snooze - Benefits outweigh risks, snooze 3 months
**      Snooze - Short term benefits outweigh risks, snooze 1 month
**      Snooze - N/A add comment, snooze 3 months
**
*/

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-04-05

parameter ContextPrescriptions List<MedicationRequest>

context Patient

define "Taper Now": "Total MME".value >= 90

define "Consider Tapering": "Total MME".value < 90

define "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  ( Common."Is Opioid Analgesic with Ambulatory Misuse Potential?"( ContextPrescriptions ) ) AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists( "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions" )

define "Total MME":
  MMECalculator.TotalMME(
    (
      "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions"
        union Common."Active Ambulatory Opioid Rx"
    ) AmbulatoryOpioidPrescription
      where Routines."Is Subacute or Chronic Pain Prescription?"( AmbulatoryOpioidPrescription )
  )

define "Inclusion Criteria":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Routines."CDC 2022 Guideline General Inclusion Criteria"
    and "Total MME" >= 50 '{MME}/d'

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "Is Recommendation Applicable?":
  "Inclusion Criteria"
    and not "Exclusion Criteria"
