## v1.2.0 (2026-08-05)

Upgrade to azurerm provider ~> 5.0 (target: v5.0.1). Format follows [Keep a Changelog](https://keepachangelog.com/).

### Added

* `providers.tf` (renamed from `main.tf`) pinning `required_version = ">= 1.9"` and `azurerm ~> 5.0` via `required_providers`.
* `.tflint.hcl` with `call_module_type = "local"` and the `tflint-ruleset-azurerm` plugin.
* `.gitattributes` enforcing LF line endings.
* `tests/diagnostic_policy_set.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` — `terraform test` coverage (mock_provider) for default values, `policy_name_postfix`, `management_group_id` scoping, and the new name override; 6 runs, 0 failures.
* `variable "policy_set_definition_name"` (optional) — lets an existing deployment whose Policy Set Definition name diverges from the generated formula pin the real name without destroy/recreate.
* `.github/workflows/terraform-ci.yml` — fmt/init/validate/test/tflint on every push and PR (no Azure credentials required; mock_provider intercepts all API calls).
* `.github/workflows/documentation.yml` — regenerates `README.md` via `terraform-docs` (using the existing `.terraform-docs.yml` config) and pushes it back to the PR branch on every PR to `master`.
* `.github/workflows/release.yml` — creates a GitHub release on merge to `master`, tagged from the version in `CHANGELOG.md`'s topmost `## vX.Y.Z` heading (idempotent: no-ops if that version's release already exists), using the merged PR's title/body as release notes.

### Fixed

* **Breaking provider schema change**: `azurerm_policy_set_definition` no longer accepts `management_group_id` — removed from the provider schema between azurerm v4.30.0 and v4.36.0 (confirmed absent in v5.0.0+). The module still set this argument on that resource, which fails `terraform plan`/`apply` under azurerm >= 4.36. Removed the argument from that resource only; `azurerm_policy_definition.management_group_id` and the `policy_definition_id` computed per-policy still honor `var.management_group_id` exactly as before, and the Policy Set Definition's own naming behavior (`Deploy-Diagnostic-Initiative` at MG scope vs. the env/userDefinedString formula at subscription scope) is unchanged.
* Both `object` and `policy_set_definition` outputs now set `sensitive = true` (they expose the full resource object).

### Removed

* `.devcontainer/` (devcontainer.json, docker-compose.yml) — unused dev container definition.
* `test/` (law.tf, locals.tf, main.tf, policy.tf, resourcegroup.tf) and `.github/workflows/test.yml` — this folder's real Azure deploy/destroy CI is superseded by a live upgrade-probe harness in a separate Terragrunt landing zone repo (`L2_test_diagnostic_policy_set`, following the `terraform-module-upgrade-probe` pattern), keeping no subscription credentials or real resource deploys inside this module repo. Mock-based coverage for every code path now lives in `tests/*.tftest.hcl` instead.

### Changed

* `required_version` raised from `>= 0.13` to `>= 1.9`.
* `azurerm` provider constraint tightened from unbounded `>= 2.34.0` to `~> 5.0`. Callers still pinned to azurerm 2.x/3.x/4.x must upgrade their provider before consuming this module version.

### Notes / known blockers

* This module predates the ESLZ `ESLZ/<resource>.tf` + tfvars-map convention (`for_each` over a map input) used by newer CAF modules — every sibling `module` invocation across this org's repos calls this module directly as a singleton, not through an `ESLZ/` wrapper. No `ESLZ/` directory was added; usage examples now live only in `README.md` and the external probe harness (see "Removed" above).
* `variable "log_analytics_workspace"` remains declared but unused by any resource in this module (`tflint-ignore: terraform_unused_declarations`, documented inline) — by design since v0.1.8, which deliberately moved policy assignment (where this value is actually consumed) outside the module. Kept required for backward compatibility with existing callers.
* `release.yml` and `documentation.yml` were adapted from the standard ESLZ artifact templates: since this module has no `ESLZ/<resource>.tf` file to source a release tag from, `release.yml` reads the version from `CHANGELOG.md`'s topmost heading instead; since `README.md` has no `<!-- BEGIN_TF_DOCS -->` markers, `documentation.yml` uses terraform-docs' `output-method: replace` (whole-file) instead of `inject`.

## v0.1.0 (July 2020)

FEATURES: 
* **new feature:**  Initial release

IMPROVEMENTS:

BUGS:

## v0.1.3 (July 2020)

FEATURES: 
* **new feature:**  Move code to json and implement for_each

IMPROVEMENTS:

BUGS:

## v0.1.5 (July 2020)

FEATURES: 
* **new feature:**  Add deploy variable support

IMPROVEMENTS:

BUGS:

## v0.1.7 (July 2020)

FEATURES: 
* **new feature:**  Move policies to single json file and iterate using for loop to create each individual policy fron the file.

IMPROVEMENTS:

BUGS:

## v0.1.8 (July 2020)

FEATURES: 
* **new feature:**  Moving the policy assignment part out of the module to make it more generic and allow for the assignment to take place outside as a seperate resource.
* **new features:** Adding support for management group instead of subscription level policies and policyset definitions.

IMPROVEMENTS:

BUGS:

## v0.1.9 (July 2020)

FEATURES: 

IMPROVEMENTS:

BUGS:

* Fix issue with Activity Log policy not properly detecting non compliant subscription

## v0.2.0 (July 2020)

FEATURES: 

* Add support for policy name postfix

IMPROVEMENTS:

BUGS:

* Fix deprecation warning for azurerm_policy_set_definition

## v1.0.0 (Aug 2020)

FEATURES: 

* Make code terraform 0.13 compatible

IMPROVEMENTS:

BUGS:

## v1.0.1 (Oct 2020)

FEATURES: 

IMPROVEMENTS:

BUGS:

* Update RecoveryVault policy definition to resolv an error

## v1.1.0 (Jun 2021)

FEATURES: 

IMPROVEMENTS:

BUGS:

* Update `azurerm_policy_definition` to fix deprecation warning regarding the parameters value used in past releases
