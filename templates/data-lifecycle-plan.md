# Data Lifecycle Plan

This template is not legal advice. Have the completed retention and privacy-request rules reviewed for the jurisdictions, contracts, industries, and data types that apply.

## Scope And Owners

- Product or service:
- Data owner:
- Privacy/legal reviewer:
- Security owner:
- Support owner:
- Last reviewed:

## Data Inventory

| Data category | System / processor | Purpose | User or tenant key | Sensitivity | Retention basis | Retention period | End-of-life action | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Example: User uploads | Private object storage | Core product workflow | `tenant_id` + `user_id` | Customer confidential | Service contract |  | Delete objects and derived previews |  |

Include primary databases, object storage, sessions, logs, support tools, analytics, search indexes, caches, exports, backups, and subprocessors.

## Account-State Transitions

| Transition | Access effect | Session effect | Data effect | Notifications | Audit evidence |
| --- | --- | --- | --- | --- | --- |
| Active → deactivated |  |  |  |  |  |
| Deactivated → restored |  |  |  |  |  |
| Deactivated → deletion pending |  |  |  |  |  |
| Deletion pending → deleted / anonymized |  |  |  |  |  |
| Any state → legal hold |  |  |  |  |  |

## Relationship And Cascade Map

| Parent record | Related record or external copy | On deactivation | On deletion | Retention exception | Verification query or evidence |
| --- | --- | --- | --- | --- | --- |
| User |  |  |  |  |  |

## Privacy-Request Workflow

1. Authenticate the requester without collecting unnecessary new data.
2. Record request type, jurisdiction or contract basis, received date, applicable deadline, owner, and status.
3. Discover data across all systems and processors.
4. Review retention exceptions or legal holds with an authorized person.
5. Export, correct, restrict, anonymize, or delete as required.
6. Verify propagation and provide an accurate completion response.
7. Preserve minimal audit evidence without retaining erased content unnecessarily.

## Backup And Restoration Behavior

- Backup retention:
- Whether individual deletion from backups is technically supported:
- Compensating controls for immutable backups:
- How restored data is reprocessed against completed deletion requests:
- Restore test evidence:

## Tests

- [ ] Deactivation revokes sessions and access.
- [ ] Cascade behavior matches the table above.
- [ ] Cache, index, object-store, analytics, and processor copies are handled.
- [ ] Shared and legally retained records remain appropriately protected.
- [ ] Restoring a backup does not silently resurrect deleted access or data.
- [ ] Export and deletion evidence can be produced without exposing another user or tenant.
