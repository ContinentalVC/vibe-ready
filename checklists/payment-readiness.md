# Payment Readiness Checklist

Use this for Stripe, Paddle, Lemon Squeezy, in-app purchases, invoices, credits, subscriptions, QR payments, digital wallets, or any money movement.

Processor behavior and response windows change. Verify implementation details against the current documentation for the processor in use; for example, Stripe documents its current [automatic retry and dunning behavior](https://docs.stripe.com/billing/revenue-recovery/smart-retries).

## Launch Blockers

- [ ] Payment attempts use idempotency keys.
- [ ] The idempotency key is stored before calling the processor.
- [ ] Duplicate submissions return the stored result and do not double-charge.
- [ ] Webhook signatures are verified.
- [ ] Webhook events are deduplicated by provider event ID.
- [ ] Payment state is not based only on one synchronous API response.
- [ ] Refunds, disputes, failed payments, and asynchronous updates are handled.
- [ ] Receipts and payment-status confirmations have an observable delivery path and an in-app or support fallback when email is delayed or rejected.

## Ledger And Audit Trail

- [ ] Payment lifecycle is modeled as events.
- [ ] Initiated, authorized, captured, refunded, disputed, failed, and canceled states are represented where applicable.
- [ ] Current payment status is consistent with the durable event/audit timeline and can be reconciled against the processor; the implementation may use an event-derived projection or an explicitly updated state model.
- [ ] Audit trail can explain what happened for support and finance.
- [ ] Manual admin changes are logged.

## Access And Entitlements

- [ ] Paid access is granted only after verified payment/subscription state.
- [ ] Entitlements update on cancellation, refund, dispute, failed renewal, and plan change.
- [ ] Users cannot change plan, price, quantity, or customer IDs from the client.
- [ ] Coupons, trials, credits, and upgrades are tested.

## Failed Payments And Subscription Recovery

- [ ] Failed recurring payments enter a documented recovery state rather than silently canceling access or remaining active forever.
- [ ] Retry behavior distinguishes recoverable failures from hard declines, has a bounded schedule, and is driven by verified processor events.
- [ ] Customers receive clear, non-deceptive failure notices with a secure path to update their payment method.
- [ ] Grace-period and entitlement behavior is explicit for `past_due`, `unpaid`, canceled, disputed, and recovered states.
- [ ] Recovery automation is monitored for stuck invoices, repeated failures, notification failures, and inconsistent subscription state.

## Refunds And Disputes

- [ ] A product-specific refund and cancellation policy is visible before purchase and matches the implemented flow.
- [ ] Dispute and chargeback alerts route to a named owner before processor response windows expire.
- [ ] A dispute-response workflow can assemble transaction history, customer communications, delivery or usage evidence, policy acceptance, and refund history without exposing unrelated customer data.
- [ ] Dispute rate, refund rate, and processor-account health are monitored using thresholds appropriate to the processor and business.
- [ ] Support can distinguish duplicate authorizations, duplicate captures, pending charges, and settled charges before responding to a customer.

## Payment Ecosystem Awareness

- [ ] The payment flow identifies the parties and state transitions that actually apply to its payment method and processor. Card-specific gateway, processor, acquiring-bank, network, and issuing-bank roles are reviewed only for card flows; marketplace, wallet, bank-transfer, app-store, and invoice flows use their own applicable model.
- [ ] Idempotency is enforced beyond payments: order submissions prevent duplicate orders, user registrations prevent duplicate accounts, password resets produce a single reset action, and queue-message reprocessing has no side effects.
- [ ] QR-code or digital wallet payment flows (e.g., scan-to-pay) validate the payment amount, mark the payment as paid atomically to prevent double-payment, and notify both consumer and merchant of the payment outcome.

## Testing

- [ ] Test mode covers success, failure, retry, duplicate webhook, refund, dispute, cancellation, and renewal.
- [ ] Critical checkout paths are tested across supported payment methods, mobile and desktop layouts, interrupted redirects, slow webhooks, and rapid repeat submissions.
- [ ] Webhook endpoint is tested with real provider test tools.
- [ ] Production keys are separated from test keys.
