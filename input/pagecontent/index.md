### Introduction

This implementation guide (IG) provides resources and discussion in support of applying the [Centers
for Disease Control and Prevention (CDC) 2022 CDC Clinical Practice Guideline for Prescribing Opioids for Pain](https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm), including support for the following guideline recommendations:
* [Recommendation #1 - Nonpharmacologic and Nonopioid Pharmacologic Therapy Consideration](recommendation-01.html)
* [Recommendation #2 - Prioritize Nonopioid Pain Therapies](recommendation-02.html)
* [Recommendation #3 - Opioid Immediate Release Form When Starting Opioid Therapy](recommendation-03.html)
* [Recommendations #4 and #5 - Lowest Effective Dose](recommendation-04-05.html)
* [Recommendation #6 - Prescribe Lowest Effective Dose and Duration](recommendation-06.html)
* [Recommendation #7 - Opioid Therapy Risk Assessment](recommendation-07.html)
* [Recommendation #8 - Naloxone Consideration](recommendation-08.html)
* [Recommendation #9 - Consider Patient's History of Controlled Substance Prescriptions](recommendation-09.html)
* [Recommendation #10 - Urine Drug Testing](recommendation-10.html)
* [Recommendation #11 - Concurrent Use of Opioids and Benzodiazepines](recommendation-11.html)
* [Recommendation #12 - Evidence-based Treatment for Patients with Opioid Use Disorder](recommendation-12.html)  

For further details on how the behaviors for the artifacts were determined, refer to the [Process Documentation](process-documentation.html).

### Background

This implementation guide was developed based on work initially done as part of the
[Clinical Quality Framework (CQF)](https://confluence.hl7.org/display/CQIWC/Clinical+Quality+Framework) Initiative, a public-private partnership sponsored by the Centers for Medicare & Medicaid Services (CMS) and
the U.S. Assistant Secretary for Technology Policy/Office of the National Coordinator for Health Information Technology (ASTP/ONC), to identify, develop, and harmonize standards for clinical decision support and electronic clinical quality measurement, as well as a joint effort by the CDC and ASTP/ONC focused on improving processes for the development of standardized, shareable, computable decision support artifacts using the [2022 CDC Clinical Practice Guideline for Prescribing Opioids for Pain](https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm) as a model case.

### Feedback and Discussion
Discussions on the use of this IG happen at the [HL7 Clinical Decision Support (CDS) Workgroup](https://confluence.hl7.org/spaces/CDS/pages/40742688/WorkGroup+Home). Feedback and contributions are welcome and can be raised with the CDS Workgroup or submitted directly using the _New Issue_ link in the footer of every page.

### Related IGs

#### CPG IG
This implementation guide has followed and applied the [methodology laid out by the HL7 Clinical Practice Guideline (CPG) IG](https://www.hl7.org/fhir/uv/cpg/methodology.html). The CPG IG offers an abstract high-level methodology for translating clinical guidelines into electronic Clinical Decision Support (eCDS) artifacts based on the following steps:

-	*Select*: Select content and recommendations for implementation
-	*Represent*: Apply selected recommendations to the implementation approach
-	*Translate*: Formally express concepts, flow diagrams, and narrative content 
-	*Validate*: Build and run test cases to verify expected functionality

The following diagram depicts the relationship and (navigable) links between the artifacts in the CPG IG and their respective instantiations in this IG.

<div>{% include cpg-ig-diagram.svg %}</div>

#### Data Exchange Profiles IG
The [HL7 Data Exchange Profiles for 2022 CDC Clinical Practice Guideline for Prescribing Opioids](https://build.fhir.org/ig/HL7/cdc-opioid-cpg/) has been developed to define a set of conformance requirements for supporting the data queries used in this implementation guide. By conforming to these profiles (which are derived from US Core) EHRs can ensure they are prepared to support the integration with this IG.

### Trigger Overview

This implementation guide [assumes](process-documentation.html#technical-assumptions) that [CDS Hooks](http://cds-hooks.hl7.org/index.html) serves as the technical framework for EHR integration. The table below outlines the supported triggering events for each guideline recommendation:

<div>{% include trigger_overview.svg %}</div>
 
### Morphine Milligram Equivalent (MME) Calculation Cautions

1. All doses are in mg/day except for fentanyl, which is mcg/hr. 

2. Equianalgesic dose conversions are only estimates and cannot account for individual variability in genetics and pharmacokinetics. 

3. Do not use the calculated dose in MMEs to determine the doses to use when converting one opioid to another; when converting opioids, the new opioid is typically dosed at a substantially lower dose than the calculated MME dose to avoid overdose because of incomplete cross-tolerance and individual variability in opioid pharmacokinetics. Consult the FDA approved product labeling for specific guidance on medications.

4. Use particular caution with methadone dose conversions because methadone has a long and variable half-life, and peak respiratory depressant effect occurs later and lasts longer than peak analgesic effect. 

5. Use particular caution with transdermal fentanyl because it is dosed in mcg/hr instead of mg/day, and its absorption is affected by heat and other factors. 

6. Buprenorphine products approved for the treatment of pain are not included in the table because of their partial µ-receptor agonist activity and resultant ceiling effects compared with full µ-receptor agonists. 

7. These conversion factors should not be applied to dosage decisions related to the management of opioid use disorder.


#### Morphine milligram equivalent doses for commonly prescribed opioids for pain management table

| Opioid                           | Conversion Factor |
|----------------------------------|:-----------------:|
| Codeine                          | 0.15 |
| Fentanyl transdermal (in mcg/hr) | 2.4 |
| Hydrocodone                      | 1.0 |
| Hydromorphone                    | 5.0 |
| Methadone                        | 4.7 |
| Morphine                         | 1.0 |
| Oxycodone                        | 1.5 |
| Oxymorphone                      | 3.0 |
| Tapentadol *                     | 0.4 |
| Tramadol **                      | 0.2 |
{: .grid }

\* Tapentadol is a µ-receptor agonist and norepinephrine reuptake inhibitor. MMEs are based on degree of µ-receptor agonist activity; however, it is unknown whether tapentadol is associated with overdose in the same dose-dependent manner as observed with medications that are solely µ-receptor agonists.

** Tramadol is a µ-receptor agonist and norepinephrine and serotonin reuptake inhibitor. MMEs are based on degree of µ-receptor agonist activity; however, it is unknown whether tramadol is associated with overdose in the same dose-dependent manner as observed with medications that are solely µ-receptor agonists.

### Credits
**Project Team**
- Johnathan Coleman (Security Risk Solutions)
- Mohammad Jafari, PhD (Security Risk Solutions)
- Kensaku Kawamoto, MD, PhD, MHS (Independent)
- Robert McClure, MD (Independent)
- Amber Patel (Security Risk Solutions)
- Bryn Rhodes (Smile CDR)
- Chris Schuler (Smile CDR)
- Greg White (Security Risk Solutions)

**Government Leadership**
- Mera Choi (ASTP)
- Roua El Kalach, PharmD, BCPS (CDC)
- Alison Kemp, MPH (ASTP)
- Jan Losby, PhD (CDC)
- Anastasia Perchem (ASTP)
- Wes Sargent, EdD (CDC)
- Andrew Terranella, MD, MPH (CDC)
- Adam Wong, MPP (ASTP)


### Intellectual Property

{% include ip-statements.xhtml %}

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Dependencies

{% include dependency-table.xhtml %}

### Globals

{% include globals-table.xhtml %}