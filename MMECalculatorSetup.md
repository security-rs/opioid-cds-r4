## MMECalculator setup instructions
The reference: 
    
    fhir.cdc."opioid-mme-r4".MMECalculator

is currently not working. As a temporary way to use the MMECalculator do the following. Once that reference is functioning, these changes will need to be backed out.   
[For reference](https://build.fhir.org/ig/cqframework/opioid-mme-r4/index.html)

### Changes:
In OpioidCDSRec08.cql and OpioidCDSRec08.cql comment out:

    include fhir.cdc."opioid-mme-r4".MMECalculator version '3.0.0' called MMECalculator
and

    include OpioidCDSCommonMME version '2.0.1' called CommonMME

Add 

    include MMECalculator version '3.0.0' called MMECalculator
Make sure all references to:

    TotalMME

ultimately end up pointing to:

    MMECalculator.TotalMME


Download the libraries AND cql from the following links and place them in the correct folders
(input/resources/library) and (input/pagecontent/cql):

[Conversion Factors](https://fhir.org/guides/cdc/opioid-mme-r4/Library-ConversionFactors.html)

[OMTKData](https://fhir.org/guides/cdc/opioid-mme-r4/Library-OMTKData.html)

[OMTKLogic](https://fhir.org/guides/cdc/opioid-mme-r4/Library-OMTKLogic.html)

[MMECalculator](https://fhir.org/guides/cdc/opioid-mme-r4/Library-MMECalculator.html)

run '_refresh.sh' and you should be good to go.