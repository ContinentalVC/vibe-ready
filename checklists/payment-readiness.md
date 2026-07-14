# Payment Readiness Checklist

Use this for Stripe, Paddle, Lemon Squeezy, in-app purchases, invoices, credits, subscriptions, QR payments, digital wallets, or any money movement.

## Launch Blockers

- [ ] Payment attempts use idempotency keys.
- [ ] The idempotency key is stored before calling the processor.
- [ ] Duplicate submissions return the stored result and do not double-charge.
- [ ] Webhook signatures are verified.
- [ ] Webhook events are deduplicated by provider event ID.
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

## Testing

- [ ] Test mode covers success, failure, retry, duplicate webhook, refund, dispute, cancellation, and renewal.
- [ ] Webhook endpoint is tested with real provider test tools.
- [ ] Production keys are separated from test keys.
