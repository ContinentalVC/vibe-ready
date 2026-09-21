# Payment Readiness Checklist

Use this for Stripe, Paddle, Lemon Squeezy, in-app purchases, invoices, credits, subscriptions, QR payments, digital wallets, or any money movement.

## Launch Blockers

- [ ] Payment attempts use idempotency keys.
- [ ] The idempotency key is stored before calling the processor.
- [ ] Duplicate submissions return the stored result and do not double-charge.
- [ ] Webhook signatures are verified.
- [ ] Webhook events are deduplicated by provider event ID.
- [ ] Duplicate webhook deliveries return a success status so the provider stops retrying, and events older than a defined replay window are rejected.
- [ ] Webhook endpoints use a non-guessable path and, where the provider publishes ranges, restrict source IPs as a layer on top of signature verification.
- [ ] Payment state is not based only on one synchronous API response.
- [ ] Refunds, disputes, failed payments, and asynchronous updates are handled.

## Ledger And Audit Trail

- [ ] Payment lifecycle is modeled as events.
- [ ] Initiated, authorized, captured, refunded, disputed, failed, and canceled states are represented where applicable.
- [ ] Current payment status can be derived from the event timeline.
- [ ] Audit trail can explain what happened for support and finance.
- [ ] Manual admin changes are logged.

## Access And Entitlements

- [ ] Paid access is granted only after verified payment/subscription state.
- [ ] Entitlements update on cancellation, refund, dispute, failed renewal, and plan change.
- [ ] Users cannot change plan, price, quantity, or customer IDs from the client.
- [ ] Coupons, trials, credits, and upgrades are tested.

## Payment Ecosystem Awareness

- [ ] The payment flow correctly handles the roles of cardholder, merchant, payment gateway, payment processor, acquiring bank, card network (e.g., Visa, Mastercard), and issuing bank. Each entity's responsibilities and fees (merchant discount fee, interchange fee, network assessments) are understood.
- [ ] Idempotency is enforced beyond payments: order submissions prevent duplicate orders, user registrations prevent duplicate accounts, password resets produce a single reset action, and queue-message reprocessing has no side effects.
- [ ] QR-code or digital wallet payment flows (e.g., scan-to-pay) validate the payment amount, mark the payment as paid atomically to prevent double-payment, and notify both consumer and merchant of the payment outcome.

## Chargebacks And Disputes

- [ ] A refund policy is published and linked before the customer pays. Processors weigh its absence against the merchant when deciding disputes.
- [ ] Dispute and chargeback rates are monitored against the processor's thresholds, with an alert while there is still time to act rather than after account standing is affected.
- [ ] The evidence needed to contest a dispute is assembled in advance: transaction record, delivery or usage proof, and customer communication history.
- [ ] The consequences of a processor freezing or terminating the account are understood, including what happens to in-flight payouts.

## Testing

- [ ] Test mode covers success, failure, retry, duplicate webhook, refund, dispute, cancellation, and renewal.
- [ ] Every offered payment method is tested end to end, including wallets and alternate rails, not only the primary card path.
- [ ] The post-payment confirmation step is tested per method. A charge that succeeds while confirmation fails to render is the state in which customers pay twice.
- [ ] Webhook endpoint is tested with real provider test tools.
- [ ] Production keys are separated from test keys.
