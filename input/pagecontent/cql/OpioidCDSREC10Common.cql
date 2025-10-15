library OpioidCDSREC10Common version '2022.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include OpioidCDSCommon version '2022.1.0' called Common
include OpioidCDSRoutines version '2022.1.0' called Routines
include OpioidCDSCommonConfig version '2022.1.0' called Config

context Patient

// Constants

define "UDS Lookback Period":
  Interval[Today() - 12 months - 1 days, Today()]

define "Rx Lookback Period":
  Interval[Today() - 12 months - 31 days, Today()]

define "Amphetamine Simple Identifier": 'Amphetamine'
define "Barbiturate Simple Identifier": 'Barbiturate'
define "Benzodiazepine Simple Identifier": 'Benzodiazepine'
define "Buprenorphine Simple Identifier": 'Buprenorphine'
define "Cannabinoid Simple Identifier": 'Cannabinoid'
define "Cocaine Simple Identifier": 'Cocaine'
define "Fentanyl Simple Identifier": 'Fentanyl'
define "Heroin Simple Identifier": 'Heroin (6-AM)'
define "Methadone Simple Identifier": 'Methadone'
define "Opiate Simple Identifier": 'Opiate'
define "Oxycodone Simple Identifier": 'Oxycodone'
define "PCP Simple Identifier": 'Phencyclidine (PCP)'

/*
@description: Determines whether an opioid review is appropriate for the patient and whether they had a UDS performed in the past year
*/
define "Inclusion Criteria For UDS Recommendation":
  Routines."Is Opioid Review Useful?"
    and not exists (
      if Config."Use Alternative UDS Lookback Period"
        then "All Opioid or Non-opioid UDS in Alternative Lookback Period"
      else "All Opioid or Non-opioid UDS in Lookback Period"
    )

define "Inclusion Criteria For Unexpected Results":
  Routines."Is Opioid Review Useful?"
  and AnyTrue(
    "Remove Substances Without Positive or Negative Results" Details
      return (exists Details.unexpectedPosDetails) or (exists Details.unexpectedNegDetails)
  )

define "Exclusion Criteria":
  Common."End of Life Assessment"

define "All Opioid or Non-opioid UDS in Alternative Lookback Period":
  (
    [Observation: Common."All Drug Urine Screening"] Lab
      where date from Lab.effective in day of Config."Alternative UDS Lookback Period"
        and not (
          Lab.status in { 'unknown', 'entered-in-error', 'cancelled' }
        )
  ) X sort by date from effective desc

define "All Opioid or Non-opioid UDS in Lookback Period":
  (
    [Observation: Common."All Drug Urine Screening"] Lab
      where date from Lab.effective in day of "UDS Lookback Period"
        and not (
          Lab.status in { 'unknown', 'entered-in-error', 'cancelled' }
        )
  ) X sort by date from effective desc

// Amphetamines
define "Amphetamine Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Amphetamine Urine Tests"

define "Positive Amphetamine Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Amphetamine Screenings In Lookback Period", true)

define "Negative Amphetamine Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Amphetamine Screenings In Lookback Period", true)

define "Amphetamine Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
      where Rx.medication in Common."Amphetamine Medications"

// Barbiturates
define "Barbiturate Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Barbiturate Urine Tests"

define "Positive Barbiturate Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Barbiturate Screenings In Lookback Period", true)

define "Negative Barbiturate Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Barbiturate Screenings In Lookback Period", true)

define "Barbiturate Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
      where Rx.medication in Common."Barbiturate Medications"

// Benzodiazepines
define "Benzodiazepine Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Benzodiazepine Urine Tests"

define "Positive Benzodiazepine Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Benzodiazepine Screenings In Lookback Period", true)

define "Negative Benzodiazepine Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Benzodiazepine Screenings In Lookback Period", true)

define "Benzodiazepine Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where Rx.medication in Common."Benzodiazepine medications"

// Buprenorphine
define "Buprenorphine Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Buprenorphine Urine Tests"

define "Positive Buprenorphine Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Buprenorphine Screenings In Lookback Period", true)

define "Negative Buprenorphine Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Buprenorphine Screenings In Lookback Period", true)

define "Buprenorphine Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where Rx.medication in Common."Buprenorphine Medications"

// Cannabinoids
define "Cannabinoid Screenings In Lookback Period":
  if Config."Cannabinoid Urine Screening Check Enabled"
    then (
      "All Opioid or Non-opioid UDS in Lookback Period" Lab
        where Lab.code in Common."Cannabinoid Urine Tests"
    ) else null

define "Positive Cannabinoid Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Cannabinoid Screenings In Lookback Period", Config."Cannabinoid Urine Screening Check Enabled")

define "Negative Cannabinoid Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Cannabinoid Screenings In Lookback Period", Config."Cannabinoid Urine Screening Check Enabled")

// Cocaine
define "Cocaine Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Cocaine Urine Tests"

define "Positive Cocaine Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Cocaine Screenings In Lookback Period", true)

define "Negative Cocaine Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Cocaine Screenings In Lookback Period", true)

// Fentanyl
define "Fentanyl Screenings In Lookback Period":
  if Config."Opiate Urine Screening Check Enabled"
  then (
    "All Opioid or Non-opioid UDS in Lookback Period" AllLabs
      where AllLabs.code in Common."Fentanyl Urine Tests"
  ) else null

define "Positive Fentanyl Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Fentanyl Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Negative Fentanyl Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Fentanyl Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Fentanyl Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where Rx.medication in Common."Fentanyl Medications"

// Heroin
define "Heroin Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Heroin Urine Tests"

define "Positive Heroin Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Heroin Screenings In Lookback Period", true)

define "Negative Heroin Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Heroin Screenings In Lookback Period", true)

// Methadone
define "Methadone Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" Lab
    where Lab.code in Common."Methadone Urine Tests"

define "Positive Methadone Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Methadone Screenings In Lookback Period", true)

define "Negative Methadone Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Methadone Screenings In Lookback Period", true)

define "Methadone Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where Rx.medication in Common."Methadone Medications"

// Opiates
define "Opiate Screenings In Lookback Period":
  if Config."Opiate Urine Screening Check Enabled"
    then (
      "All Opioid or Non-opioid UDS in Lookback Period" Lab
        where Lab.code in Common."General Opiate Urine Tests"
    ) else null

define "Positive Opiate Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Opiate Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Negative Opiate Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Opiate Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Opiate Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where (
      if Config."Use Default Opiate Medications ValueSet"
        then Rx.medication in Common."Opiate Medications"
      else Rx.medication in Config."Opiate Medications"
    )

// Oxycodone
define "Oxycodone Screenings In Lookback Period":
  if Config."Opiate Urine Screening Check Enabled"
    then (
      "All Opioid or Non-opioid UDS in Lookback Period" Lab
        where Lab.code in Common."Oxycodone Urine Tests"
    ) else null

define "Positive Oxycodone Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("Oxycodone Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Negative Oxycodone Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("Oxycodone Screenings In Lookback Period", Config."Opiate Urine Screening Check Enabled")

define "Oxycodone Rx In Lookback Period":
  "Normalize Rx In Lookback Period" Rx
    where Rx.medication in Common."Oxycodone Medications"

// PCP
define "PCP Screenings In Lookback Period":
  "All Opioid or Non-opioid UDS in Lookback Period" AllLabs
    where AllLabs.code in Common."PCP Urine Tests"

define "Positive PCP Screenings In Lookback Period":
  GetPositiveLabsInLookbackPeriod("PCP Screenings In Lookback Period", true)

define "Negative PCP Screenings In Lookback Period":
  GetNegativeLabsInLookbackPeriod("PCP Screenings In Lookback Period", true)

// Helpers  

define "All Lab Dates in Lookback Period":
  (
    "All Opioid or Non-opioid UDS in Lookback Period" Lab
      return date from Lab.effective
  ) X sort desc

define "Normalize Rx In Lookback Period":
  Common."Get MedicationRequest Medication as Code"(
    [MedicationRequest: category in Common."Community"] Rx
      where Rx.status in { 'active', 'completed', 'stopped' }
        and Rx.intent = 'order'
        and Common."Get Administration Date"(Rx) in day of "Rx Lookback Period"
  )

define "Remove Substances Without Positive or Negative Results":
  "Unexpected Details" Details
    where (Details.posDates is not null and Length(Details.posDates) != 0)
      or (Details.negDates is not null and Length(Details.negDates) != 0)

// Details Logic

define "Unexpected Details":
  {
    CreateDetailWithPossibleUnexpectedNegative(
      "Amphetamine Simple Identifier", "Positive Amphetamine Screenings In Lookback Period", 
      "Negative Amphetamine Screenings In Lookback Period", "Amphetamine Rx In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Barbiturate Simple Identifier", "Positive Barbiturate Screenings In Lookback Period", 
      "Negative Barbiturate Screenings In Lookback Period", "Barbiturate Rx In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Benzodiazepine Simple Identifier", "Positive Benzodiazepine Screenings In Lookback Period", 
      "Negative Benzodiazepine Screenings In Lookback Period", "Benzodiazepine Rx In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Buprenorphine Simple Identifier", "Positive Buprenorphine Screenings In Lookback Period", 
      "Negative Buprenorphine Screenings In Lookback Period", "Buprenorphine Rx In Lookback Period"
    ),
    CreateDetailWithoutPossibleUnexpectedNegative(
      "Cannabinoid Simple Identifier", "Positive Cannabinoid Screenings In Lookback Period", 
      "Negative Cannabinoid Screenings In Lookback Period"
    ),
    CreateDetailWithoutPossibleUnexpectedNegative(
      "Cocaine Simple Identifier", "Positive Cocaine Screenings In Lookback Period", 
      "Negative Cocaine Screenings In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Fentanyl Simple Identifier", "Positive Fentanyl Screenings In Lookback Period", 
      "Negative Fentanyl Screenings In Lookback Period", "Fentanyl Rx In Lookback Period"
    ),
    CreateDetailWithoutPossibleUnexpectedNegative(
      "Heroin Simple Identifier", "Positive Heroin Screenings In Lookback Period", 
      "Negative Heroin Screenings In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Methadone Simple Identifier", "Positive Methadone Screenings In Lookback Period", 
      "Negative Methadone Screenings In Lookback Period", "Methadone Rx In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Opiate Simple Identifier", "Positive Opiate Screenings In Lookback Period", 
      "Negative Opiate Screenings In Lookback Period", "Opiate Rx In Lookback Period"
    ),
    CreateDetailWithPossibleUnexpectedNegative(
      "Oxycodone Simple Identifier", "Positive Oxycodone Screenings In Lookback Period", 
      "Negative Oxycodone Screenings In Lookback Period", "Oxycodone Rx In Lookback Period"
    ),
    CreateDetailWithoutPossibleUnexpectedNegative(
      "PCP Simple Identifier", "Positive PCP Screenings In Lookback Period", 
      "Negative PCP Screenings In Lookback Period"
    )
  }

// HTML Generation

define "Get HTML Details":
  Common."Style Header" & "Unexpected Div Start" & "Details Table" & "Expected Result Footnote" & "Details More Info" & "Div End"

define "Unexpected Div Start":
  '<div class=\"alert-body\"><div><p>Patient may have <strong>unexpected urine toxicology test results<\/strong> in the past year.<\/p><\/div>'

define "Details Table": 
  "Table Start" & Combine("Table Headers") 
    & '<tbody>' & Combine("Generate Table Rows") & '</tbody>' 
    & '<tfoot>' & Combine("Generate Footer Rows") & '<\/tfoot>' 
  & "Table End"

define "Table Start":
  '<div><table class=\"details-table\"><caption class=\"details-caption\">Urine Toxicology Results<\/caption><tr><th class=\"details-table-header\">Substance<\/th>'

define "Table Headers":
  "All Lab Dates in Lookback Period" LabDate
    return '<th class=\"details-table-header\">' & ToString(LabDate) & '<\/th>'

define "Generate Table Rows":
  "Remove Substances Without Positive or Negative Results" BOT
    let row: ToString(IndexOf("Remove Substances Without Positive or Negative Results", BOT) + 1)
    return '<tr>' + GetExpectedColumn(BOT.ingredient) + Combine(
      "All Lab Dates in Lookback Period" LabDate
        let col: ToString(IndexOf("All Lab Dates in Lookback Period", LabDate) + 2)
        return all (
          if BOT.unexpectedPosDetails.date contains LabDate
            then GetUnexpectedColumn('pos', row & ':' & col)
          else if BOT.unexpectedNegDetails.udsDate contains LabDate
            then GetUnexpectedColumn('neg', row & ':' & col)
          else if BOT.posDates contains LabDate
            then GetExpectedColumn('pos*')
          else if BOT.negDates contains LabDate
            then GetExpectedColumn('neg*')
          else GetExpectedColumn('n/a')
        )
    ) + '<\/tr>'

define "Generate Footer Rows":
  "Remove Substances Without Positive or Negative Results" BOT
      let row: ToString(IndexOf("Remove Substances Without Positive or Negative Results", BOT) + 1),
      colspan: Length("All Lab Dates in Lookback Period") + 1
      return Combine(
          "All Lab Dates in Lookback Period" LabDate
            let col: ToString(IndexOf("All Lab Dates in Lookback Period", LabDate) + 2)
            return all (
              if BOT.unexpectedPosDetails.date contains LabDate
                then Coalesce(
                  BOT.unexpectedPosDetails PosDetail
                    where PosDetail.date same day as LabDate
                      return '<tr>' & GetFooterColumn(colspan, row & ':' & col & ' - Possible unexpected substance found: ' & PosDetail.udsDetail) & '<\/tr>'
                )
              else if BOT.unexpectedNegDetails.udsDate contains LabDate
                then Coalesce(
                  BOT.unexpectedNegDetails NegDetail
                    where NegDetail.udsDate same day as LabDate
                      return '<tr>' & GetFooterColumn(colspan, row + ':' & col & ' - Possible unexpected negative result found: prescribed ' & NegDetail.rxDetail & ' on ' & ToString(NegDetail.rxDate)) & '<\/tr>'
                )
              else ''
            )
      )

define "Table End":
  '<\/table><\/div>'

define "Details More Info":
  '<div id=\"box\">\r\n  <p>Note on false positives and unexpected negative results...<\/p>\r\n  <input type=\"checkbox\" class=\"show-more\"> Show more\r\n  <div class=\"more\">\r\n  <p>An unexpectedly negative test may be due to time since last dose, diversion, intermittent use, aberrant drug use behavior, or other factors, including a false negative result. Clinicians should interpret this result in the context of the overall treatment plan.<\/p>\r\n\r\n  <p>Positive results may be a false positives or could represent occasional use or possible substance use disorder.<br\/><br\/>For a review regarding interpreting possible false positive urine toxicology results, see <a target=\"_blank\" href=\"https:\/\/pubmed.ncbi.nlm.nih.gov\/24986836\">http:\/\/pubmed.ncbi.nlm.nih.gov\/24986836<\/a>. It is unknown if the findings reported in this article can be extrapolated to other laboratory analyzers that were not used in the referenced studies.<br\/><br\/>For guidance regarding evaluating and addressing unexpected toxicology tests results, see <a target=\"_blank\" href=\"https:\/\/www.cdc.gov\/mmwr\/volumes\/71\/rr\/rr7103a1.htm#Recommendation10\">Recommendation 10 of the 22 CDC Clinical Practice Guideiline<\/a>.<\/p><\/div>\r\n<\/div>'

define "Expected Result Footnote":
  '<div>* - These are expected results based on an analysis of the patient\'s medication list 30 days prior to the corresponding lab results.<\/div>'

define "Div End": '<\/div>'

// Functions

define function GetUnexpectedColumn(Result String, Superscript String):
  '<td class=\"details-table-cell-unexpected\">' & Result & '<sup>' & Superscript & '<\/sup><\/td>'

define function GetExpectedColumn(Content String):
  '<td class=\"details-table-cell\">' & Content & '<\/td>'

define function GetFooterColumn(colspan Integer, message String):
  '<td class=\"details-table-cell\"' & ' colspan=' & ToString(colspan) & '>' & message & '<\/td>'

define function CreateDetailWithPossibleUnexpectedNegative(TheSubstance String, ThePosLabs List<Observation>, TheNegLabs List<Observation>, TheMeds List<MedicationRequest>) returns Tuple{ingredient System.String,posDates List<System.Date>,negDates List<System.Date>,unexpectedPosDetails List<Tuple{date System.Date,udsDetail System.String}>,unexpectedNegDetails List<Tuple{udsDate System.Date,udsDetail System.String,rxDate System.DateTime,rxDetail System.String}>}:
  {
    ingredient: TheSubstance,
    posDates: (
      ThePosLabs PosLab
        return date from PosLab.effective
    ),
    negDates: (
      TheNegLabs NegLab
        return date from NegLab.effective
    ),
    unexpectedPosDetails: (
      ThePosLabs PosLab
        where not exists (
          TheMeds Rx
            where Common."Get Administration Date"(Rx)
              in day of Interval[
                date from PosLab.effective - 31 days,
                date from PosLab.effective - 1 days
              ]
        )
        return {
          date: date from PosLab.effective,
          udsDetail:
            if exists(PosLab.code.coding)
              then PosLab.code.coding[0].display
              else 'Unable to determine a detailed identifier'
        }
    ),
    unexpectedNegDetails: (
      from TheNegLabs NegLab,
        ( if exists(TheMeds) then TheMeds else { null as MedicationRequest } ) Rx
        let medDate: Common."Get Administration Date"(Rx)
          where medDate in day of Interval[date from NegLab.effective - 31 days, date from NegLab.effective - 1 days]
          return {
            udsDate: date from NegLab.effective,
            udsDetail: if exists (NegLab.code.coding) then NegLab.code.coding[0].display else 'Unable to determine a detailed identifier',
            rxDate: medDate,
            rxDetail: 
              if Rx.medication.text is not null then Rx.medication.text
              else if exists (Rx.medication.coding) and Rx.medication.coding[0].display is not null then Rx.medication.coding[0].display 
              else 'Unable to determine a detailed identifier'
          }
    )
  }

define function CreateDetailWithoutPossibleUnexpectedNegative(TheSubstance String, ThePosLabs List<Observation>, TheNegLabs List<Observation>) returns Tuple{ingredient System.String,posDates List<System.Date>,negDates List<System.Date>,unexpectedPosDetails List<Tuple{date System.Date,udsDetail System.String}>,unexpectedNegDetails List<Tuple{udsDate System.Date,udsDetail System.String,rxDate System.DateTime,rxDetail System.String}>}:
  {
    ingredient: TheSubstance,
    posDates: (
      ThePosLabs PosLab
        return date from PosLab.effective
    ),
    negDates: (
      TheNegLabs NegLab
        return date from NegLab.effective
    ),
    unexpectedPosDetails: (
      ThePosLabs PosLab
        return {
          date: date from PosLab.effective,
          udsDetail: if exists (PosLab.code.coding) then PosLab.code.coding[0].display else 'Unable to determine a detailed identifier'
        }
    ),
    unexpectedNegDetails: {
      null as Tuple{ udsDate System.Date, udsDetail System.String, rxDate System.DateTime, rxDetail System.String }
    }
  }

define function GetPositiveLabsInLookbackPeriod(Labs List<FHIR.Observation>, Enabled Boolean):
  if Enabled
    then Labs Lab
     where StartsWith(Lower(Lab.value as FHIR.string), 'pos')
  else {}

define function GetNegativeLabsInLookbackPeriod(Labs List<FHIR.Observation>, Enabled Boolean):
  if Enabled
    then Labs Lab
     where StartsWith(Lower(Lab.value as FHIR.string), 'neg')
  else {}