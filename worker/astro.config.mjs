import { defineConfig } from "astro/config";
import cloudflare from "@astrojs/cloudflare";

export default defineConfig({
  imageService: "compile",
  vite: {
    cacheDir: ".astro/vite",
    resolve: {
      alias: {
        "@": "/src",
      },
    },
  },
  build: {
    concurrency: 4,
  },
  server: {
    port: 4321,
    host: "0.0.0.0",
    allowedHosts: true,
  },
  devToolbar: {
    enabled: false,
  },
  adapter: cloudflare(),
});
