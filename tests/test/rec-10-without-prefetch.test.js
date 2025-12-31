const superagent = require("superagent");

superagent.parse["text/json"] = superagent.parse["application/json"];

const {
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
  rec10PatientBundle
} = require("./fixtures/patient-bundle");

jest.setTimeout(10 * 1000);

const FHIR_SERVER = process.env.FHIR_SERVER || "http://localhost:8080/fhir";
const CDS_SERVICE =
  process.env.CDS_SERVICE || "http://localhost:8080/cds-services";
const ORDER_SIGN = "opioidcds-10-order-sign";

beforeAll(async () => {
  const request = rec10PatientBundle;

  const response = await superagent
    .post(`${FHIR_SERVER}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
});

afterAll(() => {});

it("UDS_MED_WITH_REF", async () => {
  const request = {
    hookInstance: rec10OrderSignUdsMedReqWithRefId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignUdsMedReqWithRefId,
      encounterId: rec10OrderSignUdsMedReqWithRefId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignOxycodoneMedReqWithRefTriggeringMedReq
          },
          {
            resource: rec10OrderSignOxycodoneMedReqWithRefMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBeGreaterThan(0);
});

it("UDS_MED_WITHOUT_REF", async () => {
  const request = {
    hookInstance: rec10OrderSignUdsMedReqWithoutRefId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignUdsMedReqWithoutRefId,
      encounterId: rec10OrderSignUdsMedReqWithoutRefId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignOxycodoneMedReqWithoutRefTriggeringMedReq
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBeGreaterThan(0);
});

it("EXCL_PATIENT_LESS_THAN_18", async () => {
  const request = {
    hookInstance: rec10OrderSignPatientLessThan18Id,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignPatientLessThan18Id,
      encounterId: rec10OrderSignPatientLessThan18Id,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignPatientLessThan18TriggeringMedReq
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
});

it("EXCL_ACTIVE_CANCER_ENCOUNTERS", async () => {
  const request = {
    hookInstance: rec10OrderSignActiveCancerEncountersId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignActiveCancerEncountersId,
      encounterId: rec10OrderSignActiveCancerEncountersId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignActiveCancerEncountersTriggeringMedReq
          },
          {
            resource: rec10OrderSignActiveCancerEncountersMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
});

it("EXCL_ACTIVE_CANCER_PROBLEM_LIST", async () => {
  const request = {
    hookInstance: rec10OrderSignActiveCancerProblemListId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignActiveCancerProblemListId,
      encounterId: rec10OrderSignActiveCancerProblemListId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignActiveCancerProblemListTriggeringMedReq
          },
          {
            resource: rec10OrderSignActiveCancerProblemListMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
});

it("EXCL_SICKLE_CELL_PROBLEM_LIST", async () => {
  const request = {
    hookInstance: rec10OrderSignSickleCellProblemListId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignSickleCellProblemListId,
      encounterId: rec10OrderSignSickleCellProblemListId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignSickleCellProblemListTriggeringMedReq
          },
          {
            resource: rec10OrderSignSickleCellProblemListMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
});

it("EXCL_TERMINAL_CONDITION_PROBLEM_LIST", async () => {
  const request = {
    hookInstance: rec10OrderSignTerminalConditionProblemListId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignTerminalConditionProblemListId,
      encounterId: rec10OrderSignTerminalConditionProblemListId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignTerminalConditionProblemListTriggeringMedReq
          },
          {
            resource: rec10OrderSignTerminalConditionProblemListMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
});

it("EXPECTED_NEGATIVE_FENTANYL", async () => {
  const request = {
    hookInstance: rec10OrderSignExpectedNegativeFentanylId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignExpectedNegativeFentanylId,
      encounterId: rec10OrderSignExpectedNegativeFentanylId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignExpectedNegativeFentanylTriggeringMedReq
          },
          {
            resource: rec10OrderSignExpectedNegativeFentanylMedication
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBe(0);
});

it("EXPECTED_NEGATIVE_FENTANYL", async () => {
  const request = {
    hookInstance: rec10OrderSignExpectedPositiveFentanylId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignExpectedPositiveFentanylId,
      encounterId: rec10OrderSignExpectedPositiveFentanylId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignExpectedPositiveFentanylTriggeringMedReq
          },
          {
            resource: rec10OrderSignExpectedPositiveFentanylTriggeringMedRef
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBe(0);
});

it("UNEXPECTED_NEGATIVE_FENTANYL", async () => {
  const request = {
    hookInstance: rec10OrderSignUnexpectedNegativeFentanylId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignUnexpectedNegativeFentanylId,
      encounterId: rec10OrderSignUnexpectedNegativeFentanylId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignUnexpectedNegativeFentanylTriggeringMedReq
          },
          {
            resource: rec10OrderSignUnexpectedNegativeFentanylTriggeringMedRef
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBeGreaterThan(0);
});

it("UNEXPECTED_POSITIVE_FENTANYL", async () => {
  const request = {
    hookInstance: rec10OrderSignUnexpectedPositiveFentanylId,
    fhirServer: FHIR_SERVER,
    hook: "order-sign",
    context: {
      patientId: rec10OrderSignUnexpectedPositiveFentanylId,
      encounterId: rec10OrderSignUnexpectedPositiveFentanylId,
      userId: "PractitionerRole/default",
      draftOrders: {
        resourceType: "Bundle",
        type: "collection",
        entry: [
          {
            resource: rec10OrderSignUnexpectedPositiveFentanylTriggeringMedReq
          },
          {
            resource: rec10OrderSignUnexpectedPositiveFentanylTriggeringMedRef
          }
        ]
      }
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  const cards = response.body?.cards;
  expect(cards).toBeDefined();
  expect(cards.length).toBeGreaterThan(0);
});
