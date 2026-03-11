// Resolve the backend API base URL at runtime.
//
// For Docker users: BACKEND_URL is set in docker-compose and Next.js rewrites
// proxy /api/* calls server-side. In that case API_BASE can be empty.
//
// For local/zip users: the frontend and backend run on separate ports
// (3000 and 8000), so we auto-detect using the browser's hostname.
//
// Override order:
//   1. Build-time NEXT_PUBLIC_API_URL (for advanced users who rebuild the image)
//   2. Runtime auto-detect from window.location.hostname + port 8000

function resolveApiBase(): string {
  // Build-time override (works when image is rebuilt with the env var)
  if (process.env.NEXT_PUBLIC_API_URL) {
    return process.env.NEXT_PUBLIC_API_URL;
  }

  // Server-side rendering: fall back to localhost
  if (typeof window === "undefined") {
    return "http://localhost:8000";
  }

  // Client-side: use the same hostname the user is browsing on
  const proto = window.location.protocol;
  const host = window.location.hostname;
  return `${proto}//${host}:8000`;
}

export const API_BASE = resolveApiBase();
