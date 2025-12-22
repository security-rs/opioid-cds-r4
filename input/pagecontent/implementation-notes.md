This section presents key considerations and lessons learned derived from testing activities and pilot implementations of this implementation guide. It is intended to help implementers understand practical challenges and apply best practices identified through real-world use.

### Deploying Knowledge Artifacts
To deploy the knowledge artifacts, a bundle containing all the artifacts must be deployed to a server capable of consuming these artifacts and running CQL code. To generate a deployable bundle, the following steps are necessary. These scripts require `java` to be installed and available to the shell.

1. Clone a local copy of the IG:
```shell
git clone git@github.com:cqframework/opioid-cds-r4.git
```

2. Update the CQF tooling needed to compile and generate the bundle:
```shell
sh ./_updateCQFTooling.sh
```

3. Refresh the artifacts:
```shell
sh ./_refresh.sh
```
Note that equivalent windows scripts are also available. 

Once the above steps are completed successfully, the respective bundle for each recommendation will be generated in the following subdirectory:
```
./bundles/plandefinition/
```

### Configuration 
[TBD]

### Integration with EHR 
To enable alerts, the local EHR must be configured to invoke the appropriate CDS Hook in response to relevant clinical or administrative events and subsequently render the alerts or suggestion cards based on the response.

These configurations are EHR-specific and can be complex, therefore, setting up this integration typically requires consulting with the EHR product subject-matter experts and documentation.

### Service Performance 
A  seamless user experience crucially depends on the response time from the CDS service. This in turn depends on the response time by the EHR FHIR API for the queries invoked from the service to obtain the required patient data for. While minimal in comparison, the computation of the logic by the service (once the required data is collected) also contributes to the overall response time.

Many factors are consequential in the eventual service response time, for example: 
- the computation power of the machine running the CDS service, 
- the performance of the EHR FHIR API, 
- the API's support for search parameters to allow narrowing the volume of the returned data, 
- network infrastructure that determines transmission time, and
- the individual patient's history and the volume of their data.

For a successful implementation, appropriate engineering strategies must be applied to ensure the response time is within acceptable thresholds. These strategies highly depend on the specifics of the EHR implementation and deployment environment, but general attention to assigning sufficient computational and networking resources to the service and optimization of the respective FHIR queries can be named as examples of such strategies.

The EHR configurations often allow setting a timeout for the CDS Hooks calls to ensure that performance edge cases would not disrupt the clinical workflow and impact the clinicians' user experience.

#### Run-Ahead Execution
One of the strategies emerging from the pilot implementations is to employ a _run-ahead_ approach in configuring the service for some recommendations such as recommendation 10. 

The general idea behind this approach is to call the CDS service that depends on the `order-sign` event, ahead of time, and at the time of `order-select` so that the  processing can begin in anticipation of an imminent `order-sign` even. This strategy reduces perceived latency and improves responsiveness by running the service logic ahead of time and having the results cached and ready at the moment when it is needed as shown in the figure below.

<div>{% include run_ahead_execution.svg %}</div>

Using this approach requires careful implementation of caching and configuration of the integration with the EHR. It may also lead to deployment complexities, therefore, it should only be used in the case of response time challenges that cannot be addressed through other strategies.

### Customizing the Artifacts
Local policies at some clinical sites may require changes to the logic of the knowledge artifacts. While the logic has been designed to provide configurable parameters for common customization use cases, direct modification to the artifacts may still be needed in some cases, such as customizing alert text or suggestion cards content.

We recommend that sites track their custom artifacts by creating and maintaining a fork from the [main IG repository](https://github.com/cqframework/opioid-cds-r4). This approach enables each site to manage and evolve its customized artifacts  over time, while remaining tethered to the main IG code and having a seamless mechanism to incorporate future updates to the IG such as bug fixes and enhancements. 

