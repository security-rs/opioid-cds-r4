const {
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY,
  FENTANYL_MED_CODE,
  FENTANYL_MED_DISPLAY,
  FENTANYL_UDS_CODE,
  FENTANYL_UDS_DISPLAY
} = require("../helpers/clinical-codes");

const {
  getDateMinusYears,
  dateTimeMinus30Days,
  getDateTimeMinusDays,
  getDateTimePlusDays,
  yesterdayDateTime
} = require("../helpers/date-helpers");

const {
  createPatient,
  createMedication,
  createMedicationRequestWithRef,
  createMedicationRequestWithoutRef,
  createCondition,
  createEncounter,
  createObservation
} = require("../helpers/fhir-resource-helpers");

const rec10OrderSignUdsMedReqWithRefId = "opioid-10-order-sign-medreq-with-ref";
const rec10OrderSignUdsMedReqWithoutRefId =
  "opioid-10-order-sign-medreq-without-ref";
const rec10OrderSignPatientLessThan18Id =
  "opioid-10-order-sign-patient-less-than-18";
const rec10OrderSignActiveCancerEncountersId =
  "opioid-10-order-sign-active-cancer-encounters";
const rec10OrderSignActiveCancerProblemListId =
  "opioid-10-order-sign-active-cancer-problem-list";
const rec10OrderSignSickleCellProblemListId =
  "opioid-10-order-sign-sickle-cell-problem-list";
const rec10OrderSignTerminalConditionProblemListId =
  "opioid-10-order-sign-terminal-problem-list";
const rec10OrderSignExpectedNegativeFentanylId =
  "opioid-10-order-sign-expected-negative-fentanyl";
const rec10OrderSignExpectedPositiveFentanylId =
  "opioid-10-order-sign-expected-positive-fentanyl";
const rec10OrderSignUnexpectedNegativeFentanylId =
  "opioid-10-order-sign-unexpected-negative-fentanyl";
const rec10OrderSignUnexpectedPositiveFentanylId =
  "opioid-10-order-sign-unexpected-positive-fentanyl";

const rec10OrderSignOxycodoneMedReqWithoutRefPatient = createPatient(
  rec10OrderSignUdsMedReqWithoutRefId,
  "Jane",
  "Doe",
  "female",
  getDateMinusYears(28)
);

const rec10OrderSignOxycodoneMedReqWithoutRefTriggeringMedReq =
  createMedicationRequestWithoutRef({
    id: `${rec10OrderSignUdsMedReqWithoutRefId}-trigger`,
    subjectId: rec10OrderSignUdsMedReqWithoutRefId,
    code: OXYCODONE_MED_CODE,
    display: OXYCODONE_MED_DISPLAY
  });

const rec10OrderSignPatientLessThan18Patient = createPatient(
  rec10OrderSignPatientLessThan18Id,
  "John",
  "Doe",
  "male",
  getDateMinusYears(17)
);

const rec10OrderSignPatientLessThan18TriggeringMedReq =
  createMedicationRequestWithoutRef({
    id: `${rec10OrderSignPatientLessThan18Id}-trigger`,
    subjectId: rec10OrderSignPatientLessThan18Id,
    rxNormCode: OXYCODONE_MED_CODE,
    display: OXYCODONE_MED_DISPLAY
  });

const rec10OrderSignActiveCancerEncountersPatient = createPatient(
  rec10OrderSignActiveCancerEncountersId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(45)
);

const rec10OrderSignOxycodoneMedReqWithRefPatient = createPatient(
  rec10OrderSignUdsMedReqWithRefId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(25)
);

const rec10OrderSignOxycodoneMedReqWithRefMedication = createMedication(
  `${rec10OrderSignUdsMedReqWithRefId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignOxycodoneMedReqWithRefTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignUdsMedReqWithRefId}-trigger`,
    subjectId: rec10OrderSignUdsMedReqWithRefId,
    medRefId: `${rec10OrderSignUdsMedReqWithRefId}-med-oxycodone`
  });

const rec10OrderSignActiveCancerProblemListPatient = createPatient(
  rec10OrderSignActiveCancerProblemListId,
  "Jane",
  "Doe",
  "female",
  getDateMinusYears(19)
);

const rec10OrderSignActiveCancerProblemListTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignActiveCancerProblemListId}-trigger`,
    subjectId: rec10OrderSignActiveCancerProblemListId,
    medRefId: `${rec10OrderSignActiveCancerProblemListId}-med-oxycodone`
  });

const rec10OrderSignActiveCancerEncountersTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignActiveCancerEncountersId}-trigger`,
    subjectId: rec10OrderSignActiveCancerEncountersId,
    medRefId: `${rec10OrderSignActiveCancerEncountersId}-med-oxycodone`
  });

const rec10OrderSignActiveCancerEncountersMedication = createMedication(
  `${rec10OrderSignActiveCancerEncountersId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

// Encounters (2)
const rec10OrderSignActiveCancerEncountersFirstEncounter = createEncounter(
  `${rec10OrderSignActiveCancerEncountersId}-1`,
  rec10OrderSignActiveCancerEncountersId,
  "finished",
  dateTimeMinus30Days,
  dateTimeMinus30Days
);

const rec10OrderSignActiveCancerEncountersSecondEncounter = createEncounter(
  `${rec10OrderSignActiveCancerEncountersId}-2`,
  rec10OrderSignActiveCancerEncountersId,
  "finished",
  dateTimeMinus30Days,
  dateTimeMinus30Days
);

const rec10OrderSignActiveCancerEncountersFirstCondition = createCondition(
  `${rec10OrderSignActiveCancerEncountersId}-1`,
  rec10OrderSignActiveCancerEncountersId,
  "C15",
  "Malignant neoplasm of esophagus",
  "encounter-diagnosis",
  "Encounter Diagnosis"
);
rec10OrderSignActiveCancerEncountersFirstCondition.encounter = {
  reference: `Encounter/${rec10OrderSignActiveCancerEncountersFirstEncounter.id}`
};

const rec10OrderSignActiveCancerEncountersSecondCondition = createCondition(
  `${rec10OrderSignActiveCancerEncountersId}-2`,
  rec10OrderSignActiveCancerEncountersId,
  "C15",
  "Malignant neoplasm of esophagus",
  "encounter-diagnosis",
  "Encounter Diagnosis"
);
rec10OrderSignActiveCancerEncountersSecondCondition.encounter = {
  reference: `Encounter/${rec10OrderSignActiveCancerEncountersSecondEncounter.id}`
};

const rec10OrderSignActiveCancerProblemListMedication = createMedication(
  `${rec10OrderSignActiveCancerProblemListId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignActiveCancerProblemListCondition = createCondition(
  rec10OrderSignActiveCancerProblemListId,
  rec10OrderSignActiveCancerProblemListId,
  "C15",
  "Malignant neoplasm of esophagus",
  "problem-list-item",
  "Problem List Item",
  "active"
);

const rec10OrderSignSickleCellProblemListPatient = createPatient(
  rec10OrderSignSickleCellProblemListId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(18)
);

const rec10OrderSignSickleCellProblemListMedication = createMedication(
  `${rec10OrderSignSickleCellProblemListId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignSickleCellProblemListCondition = createCondition(
  rec10OrderSignSickleCellProblemListId,
  rec10OrderSignSickleCellProblemListId,
  "D57.04",
  "Hb-SS disease with dactylitis",
  "problem-list-item",
  "Problem List Item",
  "active"
);

const rec10OrderSignSickleCellProblemListTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignSickleCellProblemListId}-trigger`,
    subjectId: rec10OrderSignSickleCellProblemListId,
    medRefId: `${rec10OrderSignSickleCellProblemListId}-med-oxycodone`
  });

const rec10OrderSignTerminalConditionProblemListPatient = createPatient(
  rec10OrderSignTerminalConditionProblemListId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(65)
);

const rec10OrderSignTerminalConditionProblemListMedication = createMedication(
  `${rec10OrderSignTerminalConditionProblemListId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignTerminalConditionProblemListCondition = createCondition(
  rec10OrderSignTerminalConditionProblemListId,
  rec10OrderSignTerminalConditionProblemListId,
  "K72.0",
  "Acute and subacute hepatic failure",
  "problem-list-item",
  "Problem List Item",
  "active"
);

const rec10OrderSignTerminalConditionProblemListTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignTerminalConditionProblemListId}-trigger`,
    subjectId: rec10OrderSignTerminalConditionProblemListId,
    medRefId: `${rec10OrderSignTerminalConditionProblemListId}-med-oxycodone`
  });

const rec10OrderSignExpectedNegativeFentanylPatient = createPatient(
  rec10OrderSignExpectedNegativeFentanylId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(21)
);

const rec10OrderSignExpectedNegativeFentanylMedication = createMedication(
  `${rec10OrderSignExpectedNegativeFentanylId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignExpectedNegativeFentanylUds = createObservation(
  rec10OrderSignExpectedNegativeFentanylId,
  rec10OrderSignExpectedNegativeFentanylId,
  "59673-4",
  "fentaNYL [Presence] in Urine by Screen method",
  yesterdayDateTime(),
  "Negative"
);

const rec10OrderSignExpectedNegativeFentanylTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignExpectedNegativeFentanylId}-trigger`,
    subjectId: rec10OrderSignExpectedNegativeFentanylId,
    medRefId: `${rec10OrderSignExpectedNegativeFentanylId}-med-oxycodone`
  });

const rec10OrderSignExpectedPositiveFentanylPatient = createPatient(
  rec10OrderSignExpectedPositiveFentanylId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(25)
);

const rec10OrderSignExpectedPositiveFentanylTriggeringMedRef = createMedication(
  `${rec10OrderSignExpectedPositiveFentanylId}-med-oxycodone`,
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY
);

const rec10OrderSignExpectedPositiveFentanylMedRef = createMedication(
  `${rec10OrderSignExpectedPositiveFentanylId}-med-fentanyl`,
  FENTANYL_MED_CODE,
  FENTANYL_MED_DISPLAY
);

const rec10OrderSignExpectedPositiveFentanylMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignExpectedPositiveFentanylId}-fentanyl`,
    subjectId: rec10OrderSignExpectedPositiveFentanylId,
    medRefId: `${rec10OrderSignExpectedPositiveFentanylId}-med-fentanyl`,
    status: "active",
    startDate: getDateTimeMinusDays(20),
    endDate: getDateTimePlusDays(10)
  });

const rec10OrderSignExpectedPositiveFentanylUds = createObservation(
  `${rec10OrderSignExpectedPositiveFentanylId}-uds-fentanyl`,
  rec10OrderSignExpectedPositiveFentanylId,
  FENTANYL_UDS_CODE,
  FENTANYL_UDS_DISPLAY,
  getDateTimeMinusDays(2),
  "Positive"
);

const rec10OrderSignExpectedPositiveFentanylTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignExpectedPositiveFentanylId}-trigger`,
    subjectId: rec10OrderSignExpectedPositiveFentanylId,
    medRefId: `${rec10OrderSignExpectedPositiveFentanylId}-med-oxycodone`,
    status: "active"
  });

const rec10OrderSignUnexpectedNegativeFentanylPatient = createPatient(
  rec10OrderSignUnexpectedNegativeFentanylId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(35)
);

const rec10OrderSignUnexpectedNegativeFentanylTriggeringMedRef =
  createMedication(
    `${rec10OrderSignUnexpectedNegativeFentanylId}-med-oxycodone`,
    OXYCODONE_MED_CODE,
    OXYCODONE_MED_DISPLAY
  );

const rec10OrderSignUnexpectedNegativeFentanylTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignUnexpectedNegativeFentanylId}-trigger`,
    subjectId: rec10OrderSignUnexpectedNegativeFentanylId,
    medRefId: `${rec10OrderSignUnexpectedNegativeFentanylId}-med-oxycodone`,
    status: "active"
  });

const rec10OrderSignUnexpectedNegativeFentanylMedRef = createMedication(
  `${rec10OrderSignUnexpectedNegativeFentanylId}-med-fentanyl`,
  FENTANYL_MED_CODE,
  FENTANYL_MED_DISPLAY
);

const rec10OrderSignUnexpectedNegativeFentanylMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignUnexpectedNegativeFentanylId}-fentanyl`,
    subjectId: rec10OrderSignUnexpectedNegativeFentanylId,
    medRefId: `${rec10OrderSignUnexpectedNegativeFentanylId}-med-fentanyl`,
    status: "active",
    startDate: getDateTimeMinusDays(20),
    endDate: getDateTimePlusDays(10)
  });

const rec10OrderSignUnexpectedNegativeFentanylUds = createObservation(
  `${rec10OrderSignUnexpectedNegativeFentanylId}-uds-fentanyl`,
  rec10OrderSignUnexpectedNegativeFentanylId,
  FENTANYL_UDS_CODE,
  FENTANYL_UDS_DISPLAY,
  getDateTimeMinusDays(2),
  "Negative"
);

const rec10OrderSignUnexpectedPositiveFentanylPatient = createPatient(
  rec10OrderSignUnexpectedPositiveFentanylId,
  "John",
  "Doe",
  "male",
  getDateMinusYears(25)
);

const rec10OrderSignUnexpectedPositiveFentanylTriggeringMedRef =
  createMedication(
    `${rec10OrderSignUnexpectedPositiveFentanylId}-med-oxycodone`,
    OXYCODONE_MED_CODE,
    OXYCODONE_MED_DISPLAY
  );

const rec10OrderSignUnexpectedPositiveFentanylTriggeringMedReq =
  createMedicationRequestWithRef({
    id: `${rec10OrderSignUnexpectedPositiveFentanylId}-trigger`,
    subjectId: rec10OrderSignUnexpectedPositiveFentanylId,
    medRefId: `${rec10OrderSignUnexpectedPositiveFentanylId}-med-oxycodone`,
    status: "active"
  });

const rec10OrderSignUnexpectedPositiveFentanylUds = createObservation(
  `${rec10OrderSignUnexpectedPositiveFentanylId}-uds-fentanyl`,
  rec10OrderSignUnexpectedPositiveFentanylId,
  "59673-4",
  "fentaNYL [Presence] in Urine by Screen method",
  yesterdayDateTime(),
  "Positive"
);

const rec10PatientBundle = {
  resourceType: "Bundle",
  type: "transaction",
  entry: [
    {
      resource: rec10OrderSignOxycodoneMedReqWithRefPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignUdsMedReqWithRefId}`
      }
    },
    {
      resource: rec10OrderSignOxycodoneMedReqWithRefMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignUdsMedReqWithRefId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignOxycodoneMedReqWithoutRefPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignUdsMedReqWithoutRefId}`
      }
    },
    {
      resource: rec10OrderSignPatientLessThan18Patient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignPatientLessThan18Id}`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignActiveCancerEncountersId}`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignActiveCancerEncountersId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersFirstCondition,
      request: {
        method: "PUT",
        url: `Condition/${rec10OrderSignActiveCancerEncountersId}-1`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersSecondCondition,
      request: {
        method: "PUT",
        url: `Condition/${rec10OrderSignActiveCancerEncountersId}-2`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersFirstEncounter,
      request: {
        method: "PUT",
        url: `Encounter/${rec10OrderSignActiveCancerEncountersId}-1`
      }
    },
    {
      resource: rec10OrderSignActiveCancerEncountersSecondEncounter,
      request: {
        method: "PUT",
        url: `Encounter/${rec10OrderSignActiveCancerEncountersId}-2`
      }
    },
    {
      resource: rec10OrderSignActiveCancerProblemListPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignActiveCancerProblemListId}`
      }
    },
    {
      resource: rec10OrderSignActiveCancerProblemListMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignActiveCancerProblemListId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignActiveCancerProblemListCondition,
      request: {
        method: "PUT",
        url: `Condition/${rec10OrderSignActiveCancerProblemListId}`
      }
    },
    {
      resource: rec10OrderSignSickleCellProblemListPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignSickleCellProblemListId}`
      }
    },
    {
      resource: rec10OrderSignSickleCellProblemListMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignSickleCellProblemListId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignSickleCellProblemListCondition,
      request: {
        method: "PUT",
        url: `Condition/${rec10OrderSignSickleCellProblemListId}`
      }
    },
    {
      resource: rec10OrderSignTerminalConditionProblemListPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignTerminalConditionProblemListId}`
      }
    },
    {
      resource: rec10OrderSignTerminalConditionProblemListMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignTerminalConditionProblemListId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignTerminalConditionProblemListCondition,
      request: {
        method: "PUT",
        url: `Condition/${rec10OrderSignTerminalConditionProblemListId}`
      }
    },
    {
      resource: rec10OrderSignExpectedNegativeFentanylPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignExpectedNegativeFentanylId}`
      }
    },
    {
      resource: rec10OrderSignExpectedNegativeFentanylMedication,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignExpectedNegativeFentanylId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignExpectedNegativeFentanylUds,
      request: {
        method: "PUT",
        url: `Observation/${rec10OrderSignExpectedNegativeFentanylId}`
      }
    },
    {
      resource: rec10OrderSignExpectedPositiveFentanylPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignExpectedPositiveFentanylId}`
      }
    },
    {
      resource: rec10OrderSignExpectedPositiveFentanylTriggeringMedRef,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignExpectedPositiveFentanylId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignExpectedPositiveFentanylMedRef,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignExpectedPositiveFentanylId}-med-fentanyl`
      }
    },
    {
      resource: rec10OrderSignExpectedPositiveFentanylMedReq,
      request: {
        method: "PUT",
        url: `MedicationRequest/${rec10OrderSignExpectedPositiveFentanylId}-fentanyl`
      }
    },
    {
      resource: rec10OrderSignExpectedPositiveFentanylUds,
      request: {
        method: "PUT",
        url: `Observation/${rec10OrderSignExpectedPositiveFentanylId}-uds-fentanyl`
      }
    },
    {
      resource: rec10OrderSignUnexpectedNegativeFentanylPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignUnexpectedNegativeFentanylId}`
      }
    },
    {
      resource: rec10OrderSignUnexpectedNegativeFentanylTriggeringMedRef,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignUnexpectedNegativeFentanylId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignUnexpectedNegativeFentanylMedRef,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignUnexpectedNegativeFentanylId}-med-fentanyl`
      }
    },
    {
      resource: rec10OrderSignUnexpectedNegativeFentanylMedReq,
      request: {
        method: "PUT",
        url: `MedicationRequest/${rec10OrderSignUnexpectedNegativeFentanylId}-fentanyl`
      }
    },
    {
      resource: rec10OrderSignUnexpectedNegativeFentanylUds,
      request: {
        method: "PUT",
        url: `Observation/${rec10OrderSignUnexpectedNegativeFentanylId}-uds-fentanyl`
      }
    },
    {
      resource: rec10OrderSignUnexpectedPositiveFentanylPatient,
      request: {
        method: "PUT",
        url: `Patient/${rec10OrderSignUnexpectedPositiveFentanylId}`
      }
    },
    {
      resource: rec10OrderSignUnexpectedPositiveFentanylTriggeringMedRef,
      request: {
        method: "PUT",
        url: `Medication/${rec10OrderSignUnexpectedPositiveFentanylId}-med-oxycodone`
      }
    },
    {
      resource: rec10OrderSignUnexpectedPositiveFentanylUds,
      request: {
        method: "PUT",
        url: `Observation/${rec10OrderSignUnexpectedPositiveFentanylId}-uds-fentanyl`
      }
    }
  ]
};

module.exports = {
  rec10OrderSignUdsMedReqWithRefId,
  rec10OrderSignUdsMedReqWithoutRefId,
  rec10OrderSignPatientLessThan18Id,
  rec10OrderSignActiveCancerEncountersId,
  rec10OrderSignActiveCancerProblemListId,
  rec10OrderSignSickleCellProblemListId,
  rec10OrderSignTerminalConditionProblemListId,
  rec10OrderSignExpectedNegativeFentanylId,
  rec10OrderSignExpectedPositiveFentanylId,
  rec10OrderSignUnexpectedNegativeFentanylId,
  rec10OrderSignUnexpectedPositiveFentanylId,
  //
  rec10OrderSignPatientLessThan18Patient,
  rec10OrderSignPatientLessThan18TriggeringMedReq,
  //
  rec10OrderSignOxycodoneMedReqWithoutRefPatient,
  rec10OrderSignOxycodoneMedReqWithoutRefTriggeringMedReq,
  //
  rec10OrderSignOxycodoneMedReqWithRefPatient,
  rec10OrderSignOxycodoneMedReqWithRefMedication,
  rec10OrderSignOxycodoneMedReqWithRefTriggeringMedReq,
  //
  rec10OrderSignActiveCancerProblemListPatient,
  rec10OrderSignActiveCancerProblemListTriggeringMedReq,
  //
  rec10OrderSignActiveCancerEncountersPatient,
  rec10OrderSignActiveCancerEncountersMedication,
  rec10OrderSignActiveCancerEncountersTriggeringMedReq,
  rec10OrderSignActiveCancerEncountersFirstEncounter,
  rec10OrderSignActiveCancerEncountersSecondEncounter,
  rec10OrderSignActiveCancerEncountersFirstCondition,
  rec10OrderSignActiveCancerEncountersSecondCondition,
  rec10OrderSignActiveCancerProblemListMedication,
  rec10OrderSignActiveCancerProblemListCondition,
  //
  rec10OrderSignSickleCellProblemListPatient,
  rec10OrderSignSickleCellProblemListMedication,
  rec10OrderSignSickleCellProblemListCondition,
  rec10OrderSignSickleCellProblemListTriggeringMedReq,
  //
  rec10OrderSignTerminalConditionProblemListPatient,
  rec10OrderSignTerminalConditionProblemListMedication,
  rec10OrderSignTerminalConditionProblemListCondition,
  rec10OrderSignTerminalConditionProblemListTriggeringMedReq,
  //
  rec10OrderSignExpectedNegativeFentanylPatient,
  rec10OrderSignExpectedNegativeFentanylMedication,
  rec10OrderSignExpectedNegativeFentanylUds,
  rec10OrderSignExpectedNegativeFentanylTriggeringMedReq,
  //
  rec10OrderSignExpectedPositiveFentanylPatient,
  rec10OrderSignExpectedPositiveFentanylTriggeringMedRef,
  rec10OrderSignExpectedPositiveFentanylTriggeringMedReq,
  rec10OrderSignExpectedPositiveFentanylMedRef,
  rec10OrderSignExpectedPositiveFentanylMedReq,
  rec10OrderSignExpectedPositiveFentanylUds,
  //
  rec10OrderSignUnexpectedNegativeFentanylPatient,
  rec10OrderSignUnexpectedNegativeFentanylTriggeringMedRef,
  rec10OrderSignUnexpectedNegativeFentanylTriggeringMedReq,
  rec10OrderSignUnexpectedNegativeFentanylMedRef,
  rec10OrderSignUnexpectedNegativeFentanylMedReq,
  rec10OrderSignUnexpectedNegativeFentanylUds,
  //
  rec10OrderSignUnexpectedPositiveFentanylPatient,
  rec10OrderSignUnexpectedPositiveFentanylTriggeringMedRef,
  rec10OrderSignUnexpectedPositiveFentanylTriggeringMedReq,
  rec10OrderSignUnexpectedPositiveFentanylUds,
  //
  rec10PatientBundle
};
