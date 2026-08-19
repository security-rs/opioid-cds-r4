library OpioidCDSREC10PatientView version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSREC10Common version '2022.1.0' called Rec10Common
include OpioidCDSCommonConfig version '2022.1.0' called Config
include OpioidCDSRoutines version '2022.1.0' called Routines

code "Urine Drug Screening": '310627008' from Common.SNOMED display 'Urine drug screening (procedure)'

/*
**  Recommendation #10
**    When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits 
**    and risks of toxicology testing to assess for prescribed medications as well as other prescribed 
**    and nonprescribed controlled substances (recommendation category: B; evidence type: 4).
**
**  When
**    Provider is prescribing an opioid analgesic with ambulatory misuse potential in the outpatient setting
**    There exists an opioid analgesic with ambulatory misuse potential in the outpatient setting:
**    CDC 2022 guideline general inclusion criteria met for this patient:
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
**    There exists an opioid analgesic with ambulatory misuse potential in the outpatient setting
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

// META: Plan Definition: http://fhir.org/guides/cdc/opioid-cds/PlanDefinition/opioid-cds-10-patient-view

context Patient

define "Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions":
  Common."Active Ambulatory Opioid Rx" AmbulatoryOpioidPrescription
    where Routines."Is Subacute or Chronic Pain Prescription?"(AmbulatoryOpioidPrescription)

define "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential":
  exists ("Chronic Pain Opioid Analgesic with Ambulatory Misuse Potential Prescriptions")

define "Is Perform Drug Screen Recommendation Applicable?":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Rec10Common."Inclusion Criteria For UDS Recommendation"
    and not Rec10Common."Exclusion Criteria"

define "Applicable Because of Unexpected Results":
  "Patient Is Being Prescribed Opioid Analgesic with Ambulatory Misuse Potential"
    and Rec10Common."Inclusion Criteria For Unexpected Results"
    and not Rec10Common."Exclusion Criteria"

define "Detail":
  Rec10Common."Get HTML Details"

// Service Request - Urine Screening
// Detected Issue - Opioids found in urine screening
// Detected Issue - Illicit drugs found in urine screening

define "Urine Drug Screening Request":
    ServiceRequest {
      //identifier:,
      instantiatesCanonical: { FHIR.canonical { value: 'http://fhir.org/guides/cdc/activitydefinition/urine-screening-request' } },
      status: FHIR.ServiceRequestStatus { value: 'draft' },
      intent: FHIR.ServiceRequestIntent { value: 'proposal' },
      priority: FHIR.ServiceRequestPriority { value: 'routine' },
      code: FHIR.CodeableConcept { coding: { ToCoding("Urine Drug Screening") } },
      subject: FHIR.Reference { reference: FHIR.string { value: 'Patient/' + Patient.id } },
      occurrence: FHIR.Period { start: FHIR.dateTime { value: Today() }, end: FHIR.dateTime { value: Today() + 7 days } },
      authoredOn: FHIR.dateTime { value: Now() }
      // doesn't really work, need a relatedArtifact here...
      //reasonCode: { FHIR.CodeableConcept { text: FHIR.string { value: 'https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm#Recommendation10' } } }
    }

define function ToCoding(code System.Code):
  FHIR.Coding {
    code: FHIR.code { value: code.code },
    system: FHIR.uri { value: code.system },
    version: FHIR.string { value: code.version },
    display: FHIR.string { value: code.display }
  }

