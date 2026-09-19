# Strand

One Aura closed-loop **application seed** — not a Unify denseness span.

[Aether](https://github.com/cybrid-systems/aether) already proved the O→D→M→V→R loop on Aura. Strand is the first project that *uses* that loop as a program:

```
workspace f
  → query f
  → catalog / swarm / LLM propose a body
  → mutate:rebind
  → agent:decide
       commit   → persist:save
       rollback → ast:restore / hot-strategy:heal!
       back-off → mutate:safe-yield and skip
  → print agent:loop-stats + mutation-log
```

Default target: evolve `f` from identity to `abs` against a fixed case table. Default proposer is the offline catalog (round 3 injects poison `(lambda (x) 99)` to force a rollback). `STRAND_PROPOSE=swarm` searches that catalog with `std/swarm`. `STRAND_PROPOSE=llm` is the only path that calls `llm-ask`.

## Success criteria (what this repo is for)

1. A bad body never stays — snapshot / heal restores `f`.
2. `back-off` skips a mutate (first commit arms a yield round even if `agent:decide` stays `commit`).
3. A fitness improvement is durable via `persist:save`, then poison + `persist:load`.
4. `query :find` on live `f` returns a handle.
5. End of run prints `agent:loop-stats` and `mutate:summary`.

These four are assumptions to measure, not guarantees. Host residuals that still matter: Aura `#3905` (orch Fiber vs AgentHandle) if you later add long-lived spawn; this seed stays single-threaded.

## Run

Needs a built Aura host (same convention as Aether). `scripts/run.sh` looks for `../aura-grok`, then `../aura`. Sandbox is off by default (same as the Aether CLI demos); otherwise `mutate` is denied by the effect gate.

```bash
# default: ../aura-grok/build/aura  and  ../aura-grok/lib
./scripts/run.sh

AURA_BIN=/path/to/aura AURA_LIB=/path/to/aura/lib ./scripts/run.sh
```

Optional proposers:

```bash
STRAND_PROPOSE=swarm ./scripts/run.sh

export LLM_API_KEY=...
export LLM_BASE_URL=https://api.deepseek.com/v1   # or MiniMax
export LLM_MODEL=deepseek-chat
STRAND_PROPOSE=llm ./scripts/run.sh
```

PASS (printed at the end of `loop.aura`): at least 1 commit, 1 rollback, and live `f` fitness ≥ 3. Extra line records query / back-off / `persist:load` (those can residual without failing the base PASS). That is a host measurement, not a guarantee.

Soul file lands at `.strand/session.aura-soul` (gitignored).

## Layout

```
strand/
  loop.aura          # the whole program
  scripts/run.sh     # host Aura runner
  README.md
```

No extra span library. Compose Aura stdlib only: `std/agent`, `std/mutate`, `std/persist`, `std/swarm`, `std/hot-strategy`, `std/query`, `std/llm`.

## Not this repo

| Want | Where |
|------|--------|
| Denseness probes, escape accounting | [aether](https://github.com/cybrid-systems/aether) |
| Runtime / primitives | [aura](https://github.com/cybrid-systems/aura) |
| Multi-agent overnight harness | Aether examples 20–22 |

## License

Apache-2.0, same as Aura.
