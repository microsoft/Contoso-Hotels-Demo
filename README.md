Copyright (c) Microsoft Corporation.  
Licensed under the MIT license.

---
page_type: Contoso Hotels
languages: 
- ARM templates
- JavaScript
- .Net
products:
description: "Contoso Hotels: Provide hotel service with Azure dedicated resources hosting." 
urlFragment: "update-this-to-unique-url-stub"

---

# Contoso Hotels 

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

This solution deployes resources for the Contoso Hotels project.

## Contents

| File/folder                                 | Description                                |
|---------------------------------------------|--------------------------------------------|
| `applications\ClassicAppLoad`               | A application to simulate load.            |
| `ClassicAppLoad\SmartHotel.Registration.Wcf`| Contoso Hotels backend application.        |
| `ClassicAppLoad\SmartHotel.Registration.Web`| Contoso Hotels frontend application.       |
| `artifacts`                                 | ARM templates.                             |
| `scripts`                                   | Helper PowerShell scripts                  |
| `.gitignore`                                | Define what to ignore at commit time.      |
| `contoso-hotels.yml`                        | Main pipeline.                             |
| `contoso-hotels.variables.yml`              | Environment specific variables.            |
| `contoso-hotels-environment.variables.yml`  | Pipeline variables.                        |
| `README.md`                                 | This README file.                          |
| `CHANGELOG.md`                              | List of changes.                           |
| `CODE_OF_CONDUCT.md`                        | Microsoft open source code of conduct.     |
| `CONTRIBUTING.md`                           | Guidelines for contributing.               |
| `SECURITY.md`                               | Security notice.                           |
| `SUPPORT.md`                                | Support notice.                            |
| `README.md`                                 | This README file.                          |
| `LICENSE`                                   | The license.                               |

## Prerequisites

* Azure subscription
* You should be an owner of the subscription
* Azure DevOps project
* Permissions to create repositories, import and run pipelines

## Setup

1.	Clone the repository to your Azure DevOps project
1.	Create a service connection
1.	Ensure that the Owner role is assigned to the service connection's service principal
1.	If you don't have a key vault, create one
1.  Create adminUsername and adminPassword secrets to use as credentials for the VMs and SQL Databases
1.  Generate ssh private and public keys pair and add ssh public to the key vault as sshPrivateKey and sshPublicKey secrets
1.  Create a service principal. Add service principal's application ID, object ID and secret to the key vault as CHDiskEncryptionClientId, CHDiskEncryptionObjectId and CHDiskEncryptionClientSecret secrets

    Use Get-AzADServicePrincipal to get ObjectId

        (Get-AzADServicePrincipal -DisplayName '<Service Principal Name>').Id
1.  Generate an SSL certificate for Azure Application Gateway and add it to the key vault as CertAppGatewayWF certificate. (For details, visit https://docs.microsoft.com/en-us/azure/application-gateway/self-signed-certificates)
1.  Create a Key Vault access policy to allow the service connection's service principal to read secrets
1.  Update the environment variables file with correponding values
1.  Import the contoso-hotels.yml pipeline to your Azure DevOps project

## Runnning the sample

1.  Run the pipeline

## Post-Deployment Tasks

1.  Create Run As accounts

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.