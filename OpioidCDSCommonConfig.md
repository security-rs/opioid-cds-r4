# OpioidCDS Common Configuration Options

This document describes the configuration options available in [`input/cql/OpioidCDSCommonConfig.cql`](input/cql/OpioidCDSCommonConfig.cql). Each option is a CQL `define` that can be set to `true` or `false` (or, for date ranges, an `Interval`) to control the behavior of the Opioid CDS logic.

Library version: **2022.1.0**

| Option | Default | Description |
|---|---|---|
| Age Less than 18 Years Is Enabled | `true` | Enables the check that excludes patients under 18. Used in CDC 2022 General Inclusion Criteria subroutine. |
| End-Stage Disease Criteria Enabled | `true` | Enables the exclusion criteria for patients with end-stage disease. Used in CDC 2022 General Inclusion Criteria subroutine. |
| Sickle Cell Check Enabled | `true` | Enables the sickle cell disease check. Used in Sickle Cell subroutine. |
| Sickle Cell Assumed Active | `true` | When enabled, a sickle cell condition is assumed to be active without requiring an explicit active status. Used in Sickle Cell subroutine. |
| Active Cancer Treatment Encounters Condition Is Enabled | `true` | Enables the check for active cancer treatment encounters. Used in Active Cancer Treatment subroutine. |
| Opioid Naive Prescription Condition Is Enabled | `true` | Enables the opioid-naive check based on prescription data. Used in Opioid Naive subroutine. |
| Opioid Naive Report Condition Is Enabled | `true` | Enables the opioid-naive check based on medication report data. Used in Opioid Naive subroutine. |
| Opioid Naive Dispense Condition Is Enabled | `true` | Enables the opioid-naive check based on dispense data. Used in Opioid Naive subroutine. |
| Hospice Findings Exclusion Enabled | `false` | Enables the exclusion of patients with hospice findings. |
| Can the implementing EHR support queries for past medications by date range? | `true` | Indicates whether the implementing EHR can query past medications by date range. |
| Opioid Treatment Plan Verification Enabled | `true` | Enables verification that an opioid treatment plan exists. Used in Recommendation 2. |
| Opioid Harms & Risks Discussion in Past 90 Days Criteria Enabled | `true` | Enables the check for a documented opioid harms and risks discussion within the past 90 days. Used in Recommendation 3. |
| Order is to Treat Acute Pain Enabled | `true` | Enables the check for whether an opioid order is intended to treat acute pain. Used in Recommendation 6. |
| Evidence of Naloxone Enabled | `true` | Enables the check for evidence of a naloxone prescription. Used in Recommendation 8. |
| PDMP Data Not Reviewed in Past 90 Days Criteria Enabled | `true` | Enables the check for whether Prescription Drug Monitoring Program (PDMP) data has been reviewed in the past 90 days. Used in Recommendation 9. |
| Opiate Urine Screening Check Enabled | `true` | Enables the urine drug screening check for opiates. Used in Recommendation 10. |
| Cannabinoid Urine Screening Check Enabled | `false` | Enables the urine drug screening check for cannabinoids. Used in Recommendation 10. |
| Recommendation 10 UDS Lookback Period | `Today() - 12 months - 1 day` to `Today()` | The date interval used to look back for urine drug screening results. Used in Recommendation 10. |
| Recommendation 10 Rx Lookback Period | `Today() - 12 months - 31 days` to `Today()` | The date interval used to look back for prescription (Rx) data. Used in Recommendation 10. |
| Evidence Based Treatment Criteria For Opioid Use Disorder | `true` | Enables the check for evidence-based treatment criteria for opioid use disorder. Used in Recommendation 12. |
