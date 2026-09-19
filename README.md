# Strand

One Aura closed-loop **application seed** — not a Unify denseness span.

[Aether](https://github.com/cybrid-systems/aether) already proved the O→D→M→V→R loop on Aura. Strand is the first project that *uses* that loop as a program:

```
workspace f
  → query f
  → swarm or LLM propose a body
  → mutate:rebind
  → agent:decide
       commit   → persist:save
       rollback → ast:restore / hot-strategy:heal!
       back-off → mutate:safe-yield and skip
  → print agent:loop-stats + mutation-log
```

Default target: evolve `f` from identity to `abs` against a fixed case table. Offline catalog + `std/swarm` is the default proposer. Live LLM is opt-in (`LLM_API_KEY`).

## Success criteria (what this repo is for)

1. A bad body never stays — snapshot / heal restores `f`.
2. `agent:decide` of `back-off` / `escalate` stops mutating instead of spinning.
3. A fitness improvement is durable via `persist:save`.
4. End of run prints `agent:loop-stats` and `mutate:summary`.

These four are assumptions to measure, not guarantees. Host residuals that still matter: Aura `#3905` (orch Fiber vs AgentHandle) if you later add long-lived spawn; this seed stays single-threaded.

## Run

Needs a built Aura host (same convention as Aether):

```bash
# default: ../aura-grok/build/aura  and  ../aura-grok/lib
./scripts/run.sh

AURA_BIN=/path/to/aura AURA_LIB=/path/to/aura/lib ./scripts/run.sh
```

Optional live propose:

```bash
export LLM_API_KEY=...
export LLM_BASE_URL=https://api.deepseek.com/v1   # or MiniMax
export LLM_MODEL=deepseek-chat
STRAND_PROPOSE=llm ./scripts/run.sh
```

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
