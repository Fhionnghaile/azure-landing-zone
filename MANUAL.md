# Azure secure landing zone — manual

*One page, eight blocks. Every figure here comes from this repository's own tests and README.*

## 1. Claim
Hub-and-spoke networking, policy-as-code, Defender for Cloud and two Sentinel analytics rules are all defined in Bicep and compile cleanly.

## 2. What it is
The secure foundations an Azure tenant needs before the first workload arrives: networking, guardrail policies, threat protection and detection rules, written as code instead of clicked together.

## 3. Demo
Capture to record: `az bicep build` compiling every module, and a `what-if` against a sandbox subscription.

## 4. Run it yourself
**Prerequisites:** Azure CLI with Bicep. A sandbox subscription for deploy or what-if.

```bash
az bicep build -f bicep/main.bicep
az deployment sub what-if -l eastus -f bicep/main.bicep
```

## 5. What you will see
Every module compiles to ARM. what-if lists the hub and spoke VNets, the policy assignments (require `owner` tag; deny public storage access), Defender plans and the Sentinel rules.

## 6. 30-second talking point
> Get governance, networking and detection right on day zero, and every team builds on a safe floor. The KQL rules are loaded into the infrastructure, so they are versioned with it.

## 7. Scope and limits
- A reference topology. A real tenant tailors policy sets and connectivity.

## 8. Links
[Repository](https://github.com/fhionnghaile/azure-landing-zone) · [Write-up](https://padraigfhionnghaile.com/work/azure-landing-zone/) · [README](README.md)
