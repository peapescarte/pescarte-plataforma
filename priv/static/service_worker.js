self.addEventListener('install', function(e) {
  e.waitUntil(
    fetch('/cache_manifest.json')
      .then(function (response) {
        return response.json()
      })
      .then(function (cacheManifest) {
        const cacheName = 'cache:static:' + cacheManifest.version;
        const all = Object.values(cacheManifest.latest).filter(
          (fn) => fn.match(/^(images|css|js|fonts)/)
        );

        caches.open(cacheName).then(async function (cache) {
          await cache.addAll(all);
          self.skipWaiting();
        });
      })
  );
});

self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      if (response) {
        return response;
      }

      return fetch(event.request);
    })
  );
});
