# `test/live/` - live-test harness

A live, real-Azure-resource harness used by the `live-test` PR check (see
the [`live-test-actions`](https://github.com/canada-ca-terraform-modules/live-test-actions)
repo and this module's own `.github/workflows/live-test.yml`) to prove that
an open PR doesn't destroy or replace a resource a real consumer already
has running. It is **not** a substitute for either of the module's other
test surfaces:

- **`tests/*.tftest.hcl`** - mock-based unit tests (`terraform test`, no
  provider credentials, no live Azure resources). Run these first; they're
  fast and free.
- **`test/live/`** (this directory) - a single, real instance of the module
  applied against a disposable Azure sandbox subscription. Used by CI to
  diff the PR's plan against a live baseline, and can be run manually by a
  maintainer the same way.

## What's here

| File | Purpose |
|---|---|
| `main.tf` | Module block with `source = "../../"` (a relative path, not a pinned `?ref`), the `azurerm` provider config, and an empty `backend "local" {}` block (path supplied at `init` time - see below). |
| `variables.tf` | `env`, `pr_number` (defaults to `"manual"`), `log_analytics_workspace`, `management_group_id` (left `null` to exercise the default subscription scope), and `policy_name_postfix`. |
| `config/diagnostic_policy_set.tfvars` | A minimal fixture: subscription scope (`management_group_id` left unset), no Log Analytics linkage. |

No `test_dependencies.tf` here - `diagnostic_policy_set` creates only
subscription/management-group-scope Policy and PolicySet definitions, no
resource group or other parent resource is needed. Concurrent-PR isolation
is instead handled in `main.tf`, which folds `var.pr_number` into
`policy_name_postfix` so two open PRs never generate identically named
`azurerm_policy_definition` resources.

No Terragrunt anywhere under this directory - a single harness per repo has
no cross-harness DRY need.

## Running it manually

Requires your own `az login` session against the sandbox subscription (CI
uses OIDC instead).

```bash
cd test/live
terraform init
terraform plan  -var-file=config/diagnostic_policy_set.tfvars
terraform apply -var-file=config/diagnostic_policy_set.tfvars
```

Confirm only `module.diagnostic_policy_set` resources are planned/applied
(50 `azurerm_policy_definition` + 1 `azurerm_policy_set_definition`), then
tear it down:

```bash
terraform destroy -var-file=config/diagnostic_policy_set.tfvars
```

No `.tfstate` file is ever committed under `test/live/` - every run is
fully ephemeral, whether run by CI or by hand.

## Two-checkout state isolation (baseline vs. PR)

CI proves a PR isn't a breaking change by applying the target branch as a
live baseline, then plan/apply-ing the PR branch's checkout of this same
harness against that same live state - two on-disk checkouts of this repo,
one shared external state file, no state copying between them:

```bash
# Directory A: PR branch checkout, directory B: target branch checkout.
STATE=$RUNNER_TEMP/live-test-<pr-number>.tfstate

# 1. Baseline apply, from B.
cd B/test/live
terraform init -backend-config="path=$STATE"
terraform apply -var-file=config/diagnostic_policy_set.tfvars -var="pr_number=<pr-number>"

# 2. PR plan (and, in CI, apply), from A, against the same state file.
cd A/test/live
terraform init -backend-config="path=$STATE"
terraform plan -var-file=config/diagnostic_policy_set.tfvars -var="pr_number=<pr-number>"

# 3. Always tear down from A once the run finishes (`if: always()` in CI).
terraform destroy -var-file=config/diagnostic_policy_set.tfvars -var="pr_number=<pr-number>"
```

`pr_number` (`TF_VAR_pr_number` in CI, sourced from `github.event.number`)
is folded into every generated policy name via `policy_name_postfix`, so
two concurrently open PRs against this module - each pointed at their own
`live-test-<pr-number>.tfstate` - never collide on the same subscription's
policy definitions.
