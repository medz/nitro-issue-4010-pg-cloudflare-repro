# Repro for nitrojs/nitro#4010

Reproduces `pg` packaging behavior on `Nitro v3 + rolldown + cloudflare_module`.

## Setup

```bash
pnpm install
```

## Reproduce

```bash
pnpm run repro
```

## Expected

After Nitro build, Cloudflare worker runtime starts successfully.

## Actual

`pnpm run build` succeeds, but `pnpm run worker:check` fails at startup with:

```txt
Uncaught Error: Calling `require` for "events" in an environment that doesn't expose the `require` function.
```

This comes from the bundled `pg` CJS fallback chain (`require("events")`, `require("pg-native")`).

## Notes

- This repo intentionally imports `pg` in `server.ts` so Nitro/rolldown includes it in the worker bundle.
- `pnpm run deploy:dry-run` can still succeed, because this failure appears when worker runtime initializes.
