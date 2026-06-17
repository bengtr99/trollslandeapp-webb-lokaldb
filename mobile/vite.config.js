import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Mobile build. `base: './'` keeps asset URLs relative so the same build works
// both locally (preview) and when published under a sub-path (e.g. GitHub Pages).
// A separate port from the desktop app so both can run side by side.
export default defineConfig({
  plugins: [react()],
  base: './',
  server: {
    port: 5180,
    strictPort: true,
    host: true
  },
  preview: {
    port: 5180,
    strictPort: true,
    host: true
  }
});
