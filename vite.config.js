import { defineConfig } from 'vite'

export default defineConfig({
  root: './web',
  build: {
    outDir: '../dist',
    emptyOutDir: true
  },
  server: {
    port: 8080
  }
})
