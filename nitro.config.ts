import { defineConfig } from "nitro/config";

export default defineConfig({
  preset: "cloudflare_module",
  compatibilityDate: "2026-02-09",
  cloudflare: {
    deployConfig: true,
    nodeCompat: true,
  },
});
