# Repro for nitrojs/nitro#4010

Reproduces `pg` packaging behavior on `Nitro v3 + rolldown + cloudflare_module`.

## Setup

```bash
pnpm install
```

## Reproduce

### 1. Nitro + Wrangler (fails)

```bash
pnpm run repro:nitro:fail
```

### 2. Direct Wrangler (succeeds)

```bash
pnpm run repro:wrangler:ok
```

This uses `wrangler.direct.json` to run `server.ts` directly (without Nitro bundling).

### Legacy command

```bash
pnpm run repro
```

## Expected

- Nitro path: worker should fail at runtime startup (current behavior in issue).
- Direct Wrangler path: worker starts and responds with HTTP 200.

## Actual

`pnpm run nitro:build` succeeds, but `pnpm run nitro:worker:check` fails at startup with:

```txt
Uncaught Error: Calling `require` for "events" in an environment that doesn't expose the `require` function.
```

This comes from the bundled `pg` CJS fallback chain (`require("events")`, `require("pg-native")`).

## Notes

- This repo intentionally imports `pg` in `server.ts` so Nitro/rolldown includes it in the worker bundle.
- `pnpm run wrangler:direct:dry-run` succeeds in the direct wrangler path.
