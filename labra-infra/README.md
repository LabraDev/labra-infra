# labra-infra


## What Is Active In `env/dev`

- Phase 0 / Ver 0.1
  - Terraform layout + remote state bootstrap
  - VPC/subnets/routing baseline
  - SG + IAM baseline
- Phase 1 / Ver 0.2
  - IAM trust/policy sketch for build/deploy workers
  - region/tag contract propagation
- Phase 2 / Ver 0.3
  - app contract fields wired (`app_name`, `build_type`)
- Phase 3 / Ver 0.4
  - static deploy infra (`S3 + CloudFront + OAC`)
  - outputs we need for deploy flow (`bucket_name`, `distribution_id`, `site_url`)
- Phase 4 / Ver 1.0
  - static release retention defaults
  - CloudFront alarm scaffolding

## What Is Deliberately Not Wired Yet

- Phase 5+ runtime additions (rollback flow expansion, secrets wiring, queue
  workers, container runtime expansion, DB provisioning)
- Those module folders are kept as placeholders with comment-only `.tf` files
  so nobody has to read ahead right now.

We can add those back one phase at a time once Phase 4 is clean.

## Where Module Purpose Is Documented

- This README is the quick map for every module/folder.
- Active module purpose is also called out in comments inside each `.tf` file.
- Parked modules have comment-only `.tf` files so nobody has to parse future
  phase code right now.

## Module Map

- `modules/labels`: naming prefix + shared tag map used everywhere.
- `modules/state-bootstrap`: one-time S3 + Dynamo setup for Terraform state.
- `modules/network`: VPC, subnets, routing, NAT baseline.
- `modules/security`: SG baseline + IAM role baseline for build/deploy flows.
- `modules/static_runtime`: Phase 3/4 static deploy path (S3 + CloudFront + alarms/retention).
- `modules/app_runtime`: parked placeholder for Phase 10 container runtime.
- `modules/runtime_observability`: parked placeholder for Phase 7 runtime alarms/dashboard.
- `modules/secrets_contracts`: parked placeholder for Phase 6 secret-path wiring.
- `modules/worker_queue`: parked placeholder for Phase 8 queue/retry worker infra.

## Module File Notes

- For active modules (`labels`, `state-bootstrap`, `network`, `security`, `static_runtime`):
  - `main.tf`: actual resources/logic.
  - `variables.tf`: module inputs we pass from `env/dev/main.tf`.
  - `outputs.tf`: contract outputs other modules/backend/frontend consume.
- For parked modules (`app_runtime`, `runtime_observability`, `secrets_contracts`, `worker_queue`):
  - each `.tf` file has a one-line phase comment and stays intentionally empty.

## `env/dev` File Map

- `main.tf`: composes active modules for Phase 4.
- `variables.tf`: all env inputs with Phase 4 defaults.
- `terraform.tfvars`: current dev values to actually apply.
- `outputs.tf`: contract outputs backend/frontend consume.
- `backend.hcl.example`: template for remote backend init.

## Root File Map

- `modules/`: reusable Terraform modules
- `env/dev/`: active Phase 4 composition
- `versions.tf`: Terraform/provider version constraints.
- `providers.tf`: provider setup + default tags.
- `variables.tf`: shared root-level variables.
- `locals.tf`: shared root-level tags/prefix locals.
- `outputs.tf`: shared root-level outputs.
- `terraform.tfvars.example`: starter values for new env setups.

## Workflow

1. Bootstrap backend once:
   - set `bootstrap_state_backend = true` in `env/dev/terraform.tfvars`
   - run `terraform init` and `terraform apply` from `env/dev`
2. Move to remote backend:
   - copy `backend.hcl.example` to `backend.hcl`
   - run `terraform init -reconfigure -backend-config=backend.hcl`
3. Deploy active stack:
   - set `bootstrap_state_backend = false`
   - run `terraform plan` and `terraform apply`

## Notes

- Keep real secrets out of committed tfvars.
- Integration contract outputs live in `env/dev/outputs.tf`.
- If we change an output name or semantics, call it out in PR notes so frontend and backend wiring does not silently drift.
