const superagent = require("superagent");

superagent.parse["text/json"] = superagent.parse["application/json"];

const {
  OXYCODONE_MED_CODE,
  OXYCODONE_MED_DISPLAY,
  FENTANYL_MED_CODE,
  FENTANYL_MED_DISPLAY,
  FENTANYL_UDS_CODE,
  FENTANYL_UDS_DISPLAY
} = require("./fixtures/clinical-codes");

const {
  createPatient,
  createMedication,
  createMedicationRequestWithRef,
  createMedicationRequestWithoutRef,
  createCondition,
  createEncounter,
  createObservation
} = require("./helpers/fhir-resource-helpers");

const {
  getDateMinusYears,
  dateTimeMinus30Days,
  getDateTimeMinusDays,
  getDateTimePlusDays,
  yesterdayDateTime
} = require("./helpers/date-helpers");

jest.setTimeout(10 * 1000);

const FHIR_SERVER = process.env.FHIR_SERVER || "http://localhost:8080/fhir";
const CDS_SERVICE =
  process.env.CDS_SERVICE || "http://localhost:8080/cds-services";
const ORDER_SIGN = "opioidcds-10-order-sign";

beforeAll(() => {});

afterAll(() => {});

it("UDS_MED_WITH_REF", async () => {
  const rec10OrderSignUdsMedReqWithRefId =
    "opioid-10-order-sign-medreq-with-ref";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignUdsMedReqWithRefId}-trigger`,
              subjectId: rec10OrderSignUdsMedReqWithRefId,
              medRefId: `${rec10OrderSignUdsMedReqWithRefId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignUdsMedReqWithRefId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignUdsMedReqWithRefId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(25)
      )
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  expect(response.body.cards).toBeDefined();
});

it("UDS_MED_WITHOUT_REF", async () => {
  const rec10OrderSignUdsMedReqWithoutRefId =
    "opioid-10-order-sign-medreq-without-ref";
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
            resource: createMedicationRequestWithoutRef({
              id: `${rec10OrderSignUdsMedReqWithoutRefId}-trigger`,
              subjectId: rec10OrderSignUdsMedReqWithoutRefId,
              code: OXYCODONE_MED_CODE,
              display: OXYCODONE_MED_DISPLAY
            })
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignUdsMedReqWithoutRefId,
        "Jane",
        "Doe",
        "female",
        getDateMinusYears(28)
      )
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  expect(response.body.cards).toBeDefined();
});

it("EXCL_PATIENT_LESS_THAN_18", async () => {
  const rec10OrderSignPatientLessThan18Id =
    "opioid-10-order-sign-patient-less-than-18";
  const request = {
    hookInstance: rec10OrderSignPatientLessThan18Id,
    fhirServer: "{{FHIR_SERVER}}",
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
            resource: createMedicationRequestWithoutRef({
              id: `${rec10OrderSignPatientLessThan18Id}-trigger`,
              subjectId: rec10OrderSignPatientLessThan18Id,
              rxNormCode: OXYCODONE_MED_CODE,
              display: OXYCODONE_MED_DISPLAY
            })
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignPatientLessThan18Id,
        "John",
        "Doe",
        "male",
        getDateMinusYears(17)
      )
    }
  };

  const response = await superagent
    .post(`${CDS_SERVICE}/${ORDER_SIGN}`)
    .send(request)
    .set("Accept", "json");

  expect(response.status).toBe(200);
  expect(response.body.cards).toBeDefined();
});

it("EXCL_ACTIVE_CANCER_ENCOUNTERS", async () => {
  const rec10OrderSignActiveCancerEncountersId =
    "opioid-10-order-sign-active-cancer-encounters";

  const enc1 = createEncounter(
    `${rec10OrderSignActiveCancerEncountersId}-1`,
    rec10OrderSignActiveCancerEncountersId,
    "finished",
    dateTimeMinus30Days(),
    dateTimeMinus30Days()
  );

  const cond1 = createCondition(
    `${rec10OrderSignActiveCancerEncountersId}-1`,
    rec10OrderSignActiveCancerEncountersId,
    "C15",
    "Malignant neoplasm of esophagus",
    "encounter-diagnosis",
    "Encounter Diagnosis"
  );
  cond1.encounter = { reference: `Encounter/${enc1.id}` };

  const enc2 = createEncounter(
    `${rec10OrderSignActiveCancerEncountersId}-2`,
    rec10OrderSignActiveCancerEncountersId,
    "finished",
    dateTimeMinus30Days(),
    dateTimeMinus30Days()
  );
  const cond2 = createCondition(
    `${rec10OrderSignActiveCancerEncountersId}-2`,
    rec10OrderSignActiveCancerEncountersId,
    "C15",
    "Malignant neoplasm of esophagus",
    "encounter-diagnosis",
    "Encounter Diagnosis"
  );
  cond2.encounter = { reference: `Encounter/${enc2.id}` };

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignActiveCancerEncountersId}-trigger`,
              subjectId: rec10OrderSignActiveCancerEncountersId,
              medRefId: `${rec10OrderSignActiveCancerEncountersId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignActiveCancerEncountersId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignActiveCancerEncountersId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(45)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: cond1,
            search: {
              mode: "match"
            }
          },
          {
            resource: cond2,
            search: {
              mode: "match"
            }
          }
        ]
      },
      item3: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: enc1,
            search: {
              mode: "match"
            }
          },
          {
            resource: enc2,
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("EXCL_ACTIVE_CANCER_PROBLEM_LIST", async () => {
  const rec10OrderSignActiveCancerProblemListId =
    "opioid-10-order-sign-active-cancer-problem-list";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignActiveCancerProblemListId}-trigger`,
              subjectId: rec10OrderSignActiveCancerProblemListId,
              medRefId: `${rec10OrderSignActiveCancerProblemListId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignActiveCancerProblemListId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignActiveCancerProblemListId,
        "Jane",
        "Doe",
        "female",
        getDateMinusYears(19)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createCondition(
              rec10OrderSignActiveCancerProblemListId,
              rec10OrderSignActiveCancerProblemListId,
              "C15",
              "Malignant neoplasm of esophagus",
              "problem-list-item",
              "Problem List Item",
              "active"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("EXCL_SICKLE_CELL_PROBLEM_LIST", async () => {
  const rec10OrderSignSickleCellProblemListId =
    "opioid-10-order-sign-sickle-cell-problem-list";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignSickleCellProblemListId}-trigger`,
              subjectId: rec10OrderSignSickleCellProblemListId,
              medRefId: `${rec10OrderSignSickleCellProblemListId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignSickleCellProblemListId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignSickleCellProblemListId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(18)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createCondition(
              rec10OrderSignSickleCellProblemListId,
              rec10OrderSignSickleCellProblemListId,
              "D57.04",
              "Hb-SS disease with dactylitis",
              "problem-list-item",
              "Problem List Item",
              "active"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("EXCL_TERMINAL_CONDITION_PROBLEM_LIST", async () => {
  const rec10OrderSignTerminalConditionProblemListId =
    "opioid-10-order-sign-terminal-problem-list";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignTerminalConditionProblemListId}-trigger`,
              subjectId: rec10OrderSignTerminalConditionProblemListId,
              medRefId: `${rec10OrderSignTerminalConditionProblemListId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignTerminalConditionProblemListId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignTerminalConditionProblemListId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(65)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createCondition(
              rec10OrderSignTerminalConditionProblemListId,
              rec10OrderSignTerminalConditionProblemListId,
              "K72.0",
              "Acute and subacute hepatic failure",
              "problem-list-item",
              "Problem List Item",
              "active"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("EXPECTED_NEGATIVE_FENTANYL", async () => {
  const rec10OrderSignExpectedNegativeFentanylId =
    "opioid-10-order-sign-expected-negative-fentanyl";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignExpectedNegativeFentanylId}-trigger`,
              subjectId: rec10OrderSignExpectedNegativeFentanylId,
              medRefId: `${rec10OrderSignExpectedNegativeFentanylId}-med-oxycodone`
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignExpectedNegativeFentanylId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignExpectedNegativeFentanylId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(21)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createObservation(
              rec10OrderSignExpectedNegativeFentanylId,
              rec10OrderSignExpectedNegativeFentanylId,
              "59673-4",
              "fentaNYL [Presence] in Urine by Screen method",
              yesterdayDateTime(),
              "Negative"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("EXPECTED_POSITIVE_FENTANYL", async () => {
  const rec10OrderSignExpectedPositiveFentanylId =
    "opioid-10-order-sign-expected-positive-fentanyl";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignExpectedPositiveFentanylId}-trigger`,
              subjectId: rec10OrderSignExpectedPositiveFentanylId,
              medRefId: `${rec10OrderSignExpectedPositiveFentanylId}-med-oxycodone`,
              status: "active"
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignExpectedPositiveFentanylId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignExpectedPositiveFentanylId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(25)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignExpectedPositiveFentanylId}-fentanyl`,
              subjectId: rec10OrderSignExpectedPositiveFentanylId,
              medRefId: `${rec10OrderSignExpectedPositiveFentanylId}-med-fentanyl`,
              status: "active",
              startDate: getDateTimeMinusDays(20),
              endDate: getDateTimePlusDays(10)
            }),
            search: {
              mode: "match"
            }
          }
        ]
      },
      item3: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createMedication(
              `${rec10OrderSignExpectedPositiveFentanylId}-med-fentanyl`,
              FENTANYL_MED_CODE,
              FENTANYL_MED_DISPLAY
            ),
            search: {
              mode: "match"
            }
          }
        ]
      },
      item4: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createObservation(
              `${rec10OrderSignExpectedPositiveFentanylId}-uds-fentanyl`,
              rec10OrderSignExpectedPositiveFentanylId,
              FENTANYL_UDS_CODE,
              FENTANYL_UDS_DISPLAY,
              getDateTimeMinusDays(2),
              "Positive"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("UNEXPECTED_NEGATIVE_FENTANYL", async () => {
  const rec10OrderSignUnexpectedNegativeFentanylId =
    "opioid-10-order-sign-unexpected-negative-fentanyl";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignUnexpectedNegativeFentanylId}-trigger`,
              subjectId: rec10OrderSignUnexpectedNegativeFentanylId,
              medRefId: `${rec10OrderSignUnexpectedNegativeFentanylId}-med-oxycodone`,
              status: "active"
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignUnexpectedNegativeFentanylId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignUnexpectedNegativeFentanylId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(35)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignUnexpectedNegativeFentanylId}-fentanyl`,
              subjectId: rec10OrderSignUnexpectedNegativeFentanylId,
              medRefId: `${rec10OrderSignUnexpectedNegativeFentanylId}-med-fentanyl`,
              status: "active",
              startDate: getDateTimeMinusDays(20),
              endDate: getDateTimePlusDays(10)
            }),
            search: {
              mode: "match"
            }
          }
        ]
      },
      item3: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createMedication(
              `${rec10OrderSignUnexpectedNegativeFentanylId}-med-fentanyl`,
              FENTANYL_MED_CODE,
              FENTANYL_MED_DISPLAY
            ),
            search: {
              mode: "match"
            }
          }
        ]
      },
      item4: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createObservation(
              `${rec10OrderSignUnexpectedNegativeFentanylId}-uds-fentanyl`,
              rec10OrderSignUnexpectedNegativeFentanylId,
              FENTANYL_UDS_CODE,
              FENTANYL_UDS_DISPLAY,
              getDateTimeMinusDays(2),
              "Negative"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});

it("UNEXPECTED_POSITIVE_FENTANYL", async () => {
  const rec10OrderSignUnexpectedPositiveFentanylId =
    "opioid-10-order-sign-unexpected-positive-fentanyl";

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
            resource: createMedicationRequestWithRef({
              id: `${rec10OrderSignUnexpectedPositiveFentanylId}-trigger`,
              subjectId: rec10OrderSignUnexpectedPositiveFentanylId,
              medRefId: `${rec10OrderSignUnexpectedPositiveFentanylId}-med-oxycodone`,
              status: "active"
            })
          },
          {
            resource: createMedication(
              `${rec10OrderSignUnexpectedPositiveFentanylId}-med-oxycodone`,
              OXYCODONE_MED_CODE,
              OXYCODONE_MED_DISPLAY
            )
          }
        ]
      }
    },
    prefetch: {
      item1: createPatient(
        rec10OrderSignUnexpectedPositiveFentanylId,
        "John",
        "Doe",
        "male",
        getDateMinusYears(25)
      ),
      item2: {
        resourceType: "Bundle",
        type: "searchset",
        entry: [
          {
            resource: createObservation(
              `${rec10OrderSignUnexpectedPositiveFentanylId}-uds-fentanyl`,
              rec10OrderSignUnexpectedPositiveFentanylId,
              "59673-4",
              "fentaNYL [Presence] in Urine by Screen method",
              yesterdayDateTime(),
              "Positive"
            ),
            search: {
              mode: "match"
            }
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
  expect(response.body.cards).toBeDefined();
});
