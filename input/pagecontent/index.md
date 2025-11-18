### Introduction

This implementation guide provides resources and discussion in support of applying the Centers
for Disease Control and Prevention (CDC) 2022 CDC Clinical Practice Guideline for Prescribing Opioids for Pain:

[2022 CDC Clinical Practice Guideline for Prescribing Opioids for Pain](https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm)

This implementation guide was developed based on work initially done as part of the
<a href="https://confluence.hl7.org/display/CQIWC/Clinical+Quality+Framework">Clinical Quality Framework (CQF)</a>
Initiative, a public-private partnership sponsored by the Centers for Medicare &amp; Medicaid Services (CMS) and
the U.S. Office of the National Coordinator for Health Information Technology (ONC) to identify, develop, and harmonize
standards for clinical decision support and electronic clinical quality measurement, as well as a joint effort by
the Centers for Disease Control and Prevention (CDC) and the Office of the National Coordinator for Health IT (ONC)
focused on improving processes for the development of standardized, shareable, computable decision support artifacts
using the 2022 CDC Clinical Practice Guideline as a model case.

Feedback and contributions are welcome and can be submitted using the New Issue link in the footer of every page. Discussions on the
use of this IG as well as other CQF projects take place regularly on the <a href="https://confluence.hl7.org/display/CDS/CPGonFHIR">CPG-on-FHIR calls</a>, a subworkgroup of the HL7 Clinical Decision Support Workgroup.

### Scope

This implementation guide includes support for the following guideline recommendations:
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

### Getting Started

For clinical informaticists interested in how the behavior for the artifacts was determined,
refer to the [Process Documentation](process-documentation.html).

### Trigger Overview

This implementation guide [assumes](process-documentation.html#technical-assumptions) that [CDS Hooks](http://cds-hooks.hl7.org/index.html) will serve as the technical framework for EHR integration. The table below outlines the supported triggering events for each guideline recommendation:

<div>{% include trigger_overview.svg %}</div>
 
### Morphine Milligram Equivalent (MME) Calculation Cautions

> **Caution**: All doses are in mg/day except for fentanyl, which is mcg/hr. 

> **Caution**: Equianalgesic dose conversions are only estimates and cannot account for individual variability in genetics and pharmacokinetics. 

> **Caution**: Do not use the calculated dose in MMEs to determine the doses to use when converting one opioid to another; when converting opioids, the new opioid is typically dosed at a substantially lower dose than the calculated MME dose to avoid overdose because of incomplete cross-tolerance and individual variability in opioid pharmacokinetics. Consult the FDA approved product labeling for specific guidance on medications.

> **Caution**: Use particular caution with methadone dose conversions because methadone has a long and variable half-life, and peak respiratory depressant effect occurs later and lasts longer than peak analgesic effect. 

> **Caution**: Use particular caution with transdermal fentanyl because it is dosed in mcg/hr instead of mg/day, and its absorption is affected by heat and other factors. 

> **Caution**: Buprenorphine products approved for the treatment of pain are not included in the table because of their partial µ-receptor agonist activity and resultant ceiling effects compared with full µ-receptor agonists. 

> **Caution**: These conversion factors should not be applied to dosage decisions related to the management of opioid use disorder.

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
| Tapentadol [^1]                  | 0.4 |
| Tramadol [^2]                    | 0.2 |
{: .grid }

[^1]: Tapentadol is a µ-receptor agonist and norepinephrine reuptake inhibitor. MMEs are based on degree of µ-receptor agonist activity; however, it is unknown whether tapentadol is associated with overdose in the same dose-dependent manner as observed with medications that are solely µ-receptor agonists.

[^2]: Tramadol is a µ-receptor agonist and norepinephrine and serotonin reuptake inhibitor. MMEs are based on degree of µ-receptor agonist activity; however, it is unknown whether tramadol is associated with overdose in the same dose-dependent manner as observed with medications that are solely µ-receptor agonists.

### Intellectual Property

{% include ip-statements.xhtml %}

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Dependencies

{% include dependency-table.xhtml %}

### Globals

{% include globals-table.xhtml %}