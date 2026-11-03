#!/bin/sh
# Builds the standalone iPhone web app (pwa/index.html) from the main app file.
cd "$(dirname "$0")"
{
cat <<'HEAD'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="Word Partners">
<meta name="theme-color" content="#f8f1de" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#211e19" media="(prefers-color-scheme: dark)">
<link rel="manifest" href="manifest.webmanifest">
<link rel="apple-touch-icon" href="icon-180.png">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px system-ui,-apple-system,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style>
HEAD
cat app.html
cat <<'TAIL'
<script>
if ("serviceWorker" in navigator) addEventListener("load", () => {
  navigator.serviceWorker.register("sw.js", { updateViaCache: "none" }).then(reg => {
    document.addEventListener("visibilitychange", () => { if (document.visibilityState === "visible") reg.update().catch(() => {}); });
  }).catch(() => {});
  // When a new version takes over, reload once so it shows right away (not during a lesson).
  let reloaded = false;
  navigator.serviceWorker.addEventListener("controllerchange", () => { if (!reloaded && !document.body.classList.contains("task-mode")) { reloaded = true; location.reload(); } });
});
</script>
</html>
TAIL
} > index.html
