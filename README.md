# Clinical Practice Guideline for Prescribing Opioids Implementation Guide (FHIR R4 (4.0.1))

This project is a joint effort by the Centers for Disease Control and Prevention (CDC) and the Office of the National Coordinator for Health IT (ONC) focused on improving processes for the development of standardized, shareable, computable decision support artifacts using the [2022 CDC Clinical Practice Guideline for Prescribing Opioids for Pain](https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm) as a model case.

The current draft of the implementation guide is available [here](http://build.fhir.org/ig/security-rs/opioid-cds-r4/). The draft is in the final stages of cleanup before publishing the initial 1.0 release.

The guide is published under a Creative Commons [license](LICENSE.md).

## Change Management and Roadmap

The guide currently includes artifacts to support all 12 recommendations contained in the 2022 CDC Clinical Practice Guideline. Next steps for this project include additional testing and piloting of the existing artifacts, as well as potential development of additional recommendations.

Feedback and issues can be submitted via the [issues](issues) page, and will be incorporated into subsequent releases as time and resources allow.

Contributions must follow the commit policy defined [here](/commit_policy.md)

## Repository and Build Information

This repository contains the source for the Clinical Practice Guideline for Prescribing Opioids Implementation Guide, and uses the [FHIR Implementation Guide publisher](http://wiki.hl7.org/index.php?title=IG_Publisher_Documentation) to produce a FHIR Implementation Guide.

Commits to this repository will automatically trigger a new build of the IG, which will then be published to the following location:

[http://build.fhir.org/ig/security-rs/opioid-cds-r4/](http://build.fhir.org/ig/security-rs/opioid-cds-r4/)

Debugging information is available here:

[http://build.fhir.org/ig/security-rs/opioid-cds-r4/debug.tgz](http://build.fhir.org/ig/security-rs/opioid-cds-r4/debug.tgz)

### Local Build

The HL7 IG Publisher is committed to this repository to make building as easy as possible. To build locally, clone the repository and issue the following command at the root:

    java -jar "org.hl7.fhir.publisher.jar" -ig ig.json

### Local Testing and the Date Roller
This project uses a Thunder Client test suite for local testing. The [Visual Studio Plugin for Thunder Client](https://www.thunderclient.com) enables simple execution of the test suite. Please note that there are two preconditions before running the tests (also see the [testing](https://github.com/security-rs/opioid-cds-r4/blob/master/commit_policy.md#testing) section of the commit policy for more information):
1. A [CQF-Ruler](https://github.com/cqframework/cqf-ruler) instance must be running and properly configured in the environment of the Thunder Client test suite (the default is localhost:8080). 
2. The test data must be periodically updated to maintain time-sensitive evaluation. The CQF tooling project offers a convenient solution for maintaining time-sensitive data, called the [date roller functionality](https://github.com/cqframework/cqf-tooling/tree/master/tooling/src/main/java/org/opencds/cqf/tooling/dateroller). Within this IG, one can execute the date roller by the [_refreshTestData.sh](https://github.com/security-rs/opioid-cds-r4/blob/master/_refreshTestData.sh) or the [_refreshTestData.bat](https://github.com/security-rs/opioid-cds-r4/blob/master/_refreshTestData.bat) script. All test data resources that require a frequent change in specified dates, contain an extension to indicate and configure the date roller functionality. One example of such an extension within this IG can be found [here](https://github.com/security-rs/opioid-cds-r4/blob/master/input/pagecontent/requests/OpioidCDSREC01/request-example-rec-01-in-outpatient-opioid.json#L16).

If a resource in a xml or json file has the [date roller extension](http://fhir.org/guides/cdc/opioid-cds/StructureDefinition/dataDateRoller) and if the current date is greater than the valueDuration set in that extension (i.e. 30 days) that resource will have its date, period, dateTimeType, etc. fields changed according to the relation of the date in that field to the dateLastUpdated value in the extension. This also applies to cds hook request test data. If the extension is not present, that resource is skipped. If the current date is not more than the duration from the lastUpdated date, that resource is skipped.

## Release and Branching

This repository will leverage a branching strategy to maintain multiple versions of the CDC opioid recommendations (currently 2016 and 2022) and their respective IG's. This will use semantic versioning on releases to make it clear which version of the recommendations the release is for.
 The format used will be major.minor.patch
- major represents the guideline version, and refers to the publication year (e.g. 2016)
- minor is for new features and capabilities, but not breaking changes, thus backwards compatible
- patches are bug fixes and technical corrections

Any release for 2022 version will be v2022.#.# and any that are 2016 will be v2016.#.#.

Note: that the "v" prefix is only used in the branch and tag names in git. The actual version will be "2016.#.#"


![branching](diagrams/Branching.svg)

### IG Publishing

You can view the latest development of the IG by going to the following locations:

#### v2016
[https://build.fhir.org/ig/security-rs/opioid-cds-r4/branches/v2016/](https://build.fhir.org/ig/cqframework/opioid-cds-r4/branches/v2016/)

#### v2022
[https://build.fhir.org/ig/security-rs/opioid-cds-r4/branches/master/](https://build.fhir.org/ig/cqframework/opioid-cds-r4/branches/master/)
