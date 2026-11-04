// Offline support. The app page always comes from the network first, so updates show up at once;
// the saved copy is used only when there is no internet.
const CACHE = "word-partners-v15";
const FILES = ["./", "index.html", "manifest.webmanifest", "icon-180.png", "icon-192.png", "icon-512.png"];
self.addEventListener("install", e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES.map(f => new Request(f, { cache: "reload" }))))); self.skipWaiting(); });
self.addEventListener("activate", e => { e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k))))); self.clients.claim(); });
self.addEventListener("fetch", e => {
  if (e.request.method !== "GET") return;
  const url = new URL(e.request.url);
  if (url.origin !== location.origin) return;
  const page = e.request.mode === "navigate" || url.pathname.endsWith("/") || url.pathname.endsWith(".html");
  e.respondWith(caches.open(CACHE).then(async c => {
    const net = fetch(page ? new Request(e.request, { cache: "no-store" }) : e.request).then(r => { if (r.ok) c.put(e.request, r.clone()); return r; });
    if (page) return net.catch(async () => (await c.match(e.request)) || c.match("index.html"));
    const hit = await c.match(e.request);
    return hit || net;
  }));
});
