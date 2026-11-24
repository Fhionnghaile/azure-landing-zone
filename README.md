# Azure secure landing zone

<!-- at-a-glance -->
> **An enterprise-scale Azure landing zone: secure-by-default foundations before the first workload lands.**  
> **Result:** 5 IaC files; validate/build clean.  
> **Reproduce:** `az bicep build -f bicep/main.bicep`  
> ![CI](https://github.com/fhionnghaile/azure-landing-zone/actions/workflows/ci.yml/badge.svg)
>
> **What this is worth:** Gets governance, networking and identity right on day zero, so every team builds on a safe floor instead of hardening later.


A mini **hub/spoke** landing zone with **policy-as-code**, **Defender for Cloud**, and a **Microsoft
Sentinel** analytics pack — all **Bicep**.

## What it stands up
- **Network** (`modules/network.bicep`): hub + spoke VNets, peered; spoke workload subnet with
  outbound access off by default.
- **Policy** (`modules/policy.bicep`): subscription assignments — **require the `owner` tag**, **deny
  public network access on storage** (built-in definitions).
- **Defender** (`modules/defender.bicep`): Defender for Cloud **Standard** on VMs / Storage / Key
  Vaults / Containers.
- **Sentinel** (`modules/sentinel.bicep`): Log Analytics workspace + Sentinel onboarding + two
  **scheduled analytics rules** whose KQL lives in [`sentinel/hunting/`](sentinel/hunting):
  **impossible travel** and **self-granted privileged role**.

## Deploy
```bash
az deployment sub create -l eastus -f bicep/main.bicep
```

## Validate
CI runs `az bicep build` (compiles every module to ARM) and `az deployment sub what-if`. KQL rules are
loaded into the analytics-rule resources via `loadTextContent`, so they version with the infra.

## License
MIT.

## Key decisions

- Landing-zone pattern: management groups, policy and network topology as code, not click-ops.
- Secure defaults (logging on, deny-by-default network) so opting out is deliberate.
- Modular, so an org adopts the pieces it needs.

## Scope & limits

- A reference topology; a real tenant tailors policy sets and connectivity.

