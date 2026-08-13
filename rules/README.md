# Scanner Rule Contract

`prodcheck.sh` is deliberately lightweight. It finds high-signal evidence and routes deeper review; it does not prove that an app is secure.

Each emitted check has:

- a stable `id` such as `deps.js-lockfile`;
- a status: `action`, `later`, `good`, or `note`;
- a plain-language message;
- evidence explaining what matched;
- a minimum stage encoded by the scanner when absence can become an action.

Text output translates these statuses for beginners:

| Machine status | Beginner label | Meaning |
| --- | --- | --- |
| `action` | FIX NOW | Expected at the selected stage |
| `later` | SAVE FOR LATER | Valuable at a later stage; avoid premature complexity |
| `good` | GOOD | Supporting evidence found, not a security guarantee |
| `note` | NOTE | Conditional feature or review routing information |

The default exit code is zero even when actions exist. `--strict` or `--fail-on action` returns status 3 when an action exists. JSON output is available with `--format json`.

Behavior is specified by `tests/prodcheck_test.sh`. New automated checks must include a fixture proving stage behavior, expected evidence, and exit behavior where applicable.
