const {
  todayDateTime,
  nowNoTz,
  dateTimePlus30Days
} = require("./date-helpers");

const createPatient = (id, firstName, lastName, gender, birthDate) => ({
  resourceType: "Patient",
  id,
  active: true,
  name: [
    {
      use: "official",
      family: lastName,
      given: [firstName]
    },
    {
      use: "usual",
      family: lastName,
      given: [firstName]
    }
  ],
  gender: gender,
  birthDate: birthDate,
  deceasedBoolean: false
});

const createMedication = (id, rxNormCode, display) => ({
  resourceType: "Medication",
  id,
  code: {
    coding: [
      {
        system: "http://www.nlm.nih.gov/research/umls/rxnorm",
        code: rxNormCode,
        display
      }
    ]
  }
});

const createMedicationRequestWithRef = ({
  id,
  subjectId,
  medRefId,
  status = "draft",
  startDate = todayDateTime,
  endDate = dateTimePlus30Days
}) => ({
  resourceType: "MedicationRequest",
  id,
  status,
  intent: "order",
  category: [
    {
      coding: [
        {
          system:
            "http://terminology.hl7.org/CodeSystem/medicationrequest-category",
          code: "community",
          display: "Community"
        }
      ]
    }
  ],
  medicationReference: {
    reference: `Medication/${medRefId}`
  },
  subject: {
    reference: `Patient/${subjectId}`
  },
  encounter: {
    reference: `Encounter/${subjectId}`
  },
  authoredOn: startDate,
  requester: {
    reference: "Practitioner/default",
    type: "Practitioner"
  },
  recorder: {
    reference: "Practitioner/default",
    type: "Practitioner"
  },
  dosageInstruction: [
    {
      timing: {
        event: [startDate]
      }
    }
  ],
  dispenseRequest: {
    validityPeriod: {
      start: startDate,
      end: endDate
    },
    numberOfRepeatsAllowed: 0,
    quantity: {
      value: 60,
      unit: "tablet"
    },
    expectedSupplyDuration: {
      value: 30,
      unit: "Day",
      system: "http://unitsofmeasure.org",
      code: "d"
    }
  }
});

const createMedicationRequestWithoutRef = ({
  id,
  subjectId,
  code,
  display,
  status = "draft",
  startDate = todayDateTime,
  endDate = dateTimePlus30Days
}) => ({
  resourceType: "MedicationRequest",
  id: id,
  status: status,
  intent: "order",
  category: [
    {
      coding: [
        {
          system:
            "http://terminology.hl7.org/CodeSystem/medicationrequest-category",
          code: "community",
          display: "Community"
        }
      ]
    }
  ],
  medicationCodeableConcept: {
    coding: [
      {
        system: "http://www.nlm.nih.gov/research/umls/rxnorm",
        code,
        display
      }
    ]
  },
  subject: {
    reference: `Patient/${subjectId}`
  },
  encounter: {
    reference: `Encounter/${subjectId}`
  },
  requester: {
    reference: "Practitioner/default",
    type: "Practitioner"
  },
  recorder: {
    reference: "Practitioner/default",
    type: "Practitioner"
  },
  dosageInstruction: [
    {
      timing: {
        event: [startDate]
      }
    }
  ],
  dispenseRequest: {
    validityPeriod: {
      start: startDate,
      end: endDate
    },
    numberOfRepeatsAllowed: 0,
    quantity: {
      value: 60,
      unit: "tablet"
    },
    expectedSupplyDuration: {
      value: 30,
      unit: "Day",
      system: "http://unitsofmeasure.org",
      code: "d"
    }
  }
});

const createEncounter = (
  id,
  subjectId,
  status = "finished",
  startDate = nowNoTz,
  endDate = nowNoTz
) => ({
  resourceType: "Encounter",
  id: id,
  status: status,
  subject: {
    reference: `Patient/${subjectId}`
  },
  period: {
    start: startDate,
    end: endDate
  }
});

const createCondition = (
  id,
  subjectId,
  code,
  display,
  categoryCode,
  categoryDisplay,
  clinicalStatus
) => ({
  resourceType: "Condition",
  id,
  clinicalStatus: clinicalStatus
    ? {
        coding: [
          {
            system: "http://terminology.hl7.org/CodeSystem/condition-clinical",
            code: clinicalStatus
          }
        ]
      }
    : undefined,
  category: [
    {
      coding: [
        {
          system: "http://terminology.hl7.org/CodeSystem/condition-category",
          code: categoryCode,
          display: categoryDisplay
        }
      ]
    }
  ],
  code: {
    coding: [
      {
        system: "http://hl7.org/fhir/sid/icd-10-cm",
        code,
        display
      }
    ]
  },
  subject: {
    reference: `Patient/${subjectId}`
  }
});

const createObservation = (
  id,
  subjectId,
  code,
  display,
  effectiveDate,
  valueString
) => ({
  resourceType: "Observation",
  id: id,
  status: "final",
  category: [
    {
      coding: [
        {
          system: "http://terminology.hl7.org/CodeSystem/observation-category",
          code: "laboratory",
          display: "Laboratory"
        }
      ]
    }
  ],
  code: {
    coding: [
      {
        system: "http://loinc.org",
        code: code,
        display: display
      }
    ]
  },
  subject: {
    reference: `Patient/${subjectId}`
  },
  effectiveDateTime: effectiveDate,
  issued: effectiveDate,
  valueString: valueString
});

module.exports = {
  createPatient,
  createMedication,
  createMedicationRequestWithRef,
  createMedicationRequestWithoutRef,
  createEncounter,
  createCondition,
  createObservation
};
