'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "47ff0ea7fbbffaf08664d0d38e5e03bc",
"assets/AssetManifest.bin.json": "3308625c73afc7442ee7fed6014b8e6d",
"assets/AssetManifest.json": "913ef4449ed71542588cdd7f095c55b1",
"assets/assets/dark/category_new.svg": "a2f3a7e8f7707e611a2ee5a26113bc7b",
"assets/assets/dark/slider_new.svg": "4d0e330d2530c59edf13f37e18b8087f",
"assets/assets/dark/story_new.svg": "af902c32f0439d5855c86065959990d4",
"assets/assets/images/add_icon.svg": "014f3475c9abb3e844402cd801bf203e",
"assets/assets/images/arrow_left.svg": "0723e2ecd27353c89f1652f59f812639",
"assets/assets/images/dashboard_category_icon.svg": "39dce3541d43248b0a418e42fac2fb17",
"assets/assets/images/dashboard_donation_icon.svg": "18fe6bf66121a167dc2ee85c66825a29",
"assets/assets/images/dashboard_featured_books_icon.svg": "ea8eae40599b9db41fc969761d9ca54c",
"assets/assets/images/dashboard_feedback_icon.svg": "419c1b4a90bf28d9d287f721cc765f4d",
"assets/assets/images/dashboard_homeslider_slider.svg": "e2d8338a6854bd73a011573122204113",
"assets/assets/images/dashboard_kegiatan_literasi_icon.svg": "9b8f2819c3bf2df9724833413c4284aa",
"assets/assets/images/dashboard_populer_books_icon.svg": "e624e945da000036e3cf77372039f6ed",
"assets/assets/images/dashboard_rating_icon.svg": "2f225f185445f2a423fb7604b2fcf2f2",
"assets/assets/images/dashboard_sekilas_info_icon.svg": "fcf41a0d896753cc7c213f29d51542b9",
"assets/assets/images/dashboard_stories_icon.svg": "d3e7cc8717eadf7e0284f28186b6bf6a",
"assets/assets/images/dashboard_tukar_milik_icon.svg": "22054074a288bb2b36b80dad6e9ad7f8",
"assets/assets/images/dashboard_tukar_pinjam_icon.svg": "eab8cd59b114aee6ad1ad806099f5ab1",
"assets/assets/images/dashboard_user_icon.svg": "ca4dc4da57c56191cd8c1d5c1e797ced",
"assets/assets/images/down.png": "586c26550f49cd22a7aa532574e6dc81",
"assets/assets/images/frame.png": "bb17763ad9ce3de4245e773efd23906d",
"assets/assets/images/hide.png": "e68fd803889384084270f7d71fea6e38",
"assets/assets/images/list.png": "6b2782ea009c7256dd0f5302abc6180f",
"assets/assets/images/more.png": "ff6bf2c9a2d5662b4cbf8d19452c059a",
"assets/assets/images/pdf.png": "6584c2a8506325708a0b8d127695a3cf",
"assets/assets/images/place.png": "2c8f4a3ceb2a2054adf46138eb7172cb",
"assets/assets/images/profile-placeholder.png": "0b55275319eb7866b84d315ee3389c95",
"assets/assets/images/profile.png": "5867df9af4a0107082fdd97a4f0cd43d",
"assets/assets/images/profile_dark.png": "891b4416dadd13554d7bd63a20b7dcff",
"assets/assets/images/shape_1.png": "73f2129c4f50eff37e6082b9792ee62e",
"assets/assets/images/shape_2.png": "e7036d171041bf85c5110930ec456740",
"assets/assets/images/shape_3.png": "b00510ad453ddf639bf094a8df59a759",
"assets/assets/images/trash.png": "eb9bd34fb521bf51f28f8ff25006c40e",
"assets/assets/images/view.png": "d58934fe7377dcd53e3e07dbfc05e71d",
"assets/assets/svg/book.svg": "01c42d85a1da3a2728d52fed63d27a82",
"assets/assets/svg/category_active.svg": "271b0fd861e19f8bc73c6627123a41ce",
"assets/assets/svg/category_new.svg": "9f3bac2b0ef8ad8afc760e9d254574e2",
"assets/assets/svg/close.svg": "56d3851dcc61219077b4fce5be64c0b0",
"assets/assets/svg/dark_mode.svg": "7efc9d840bbb9b815a3d50e5bb282f64",
"assets/assets/svg/down.svg": "5885c343d10fc7a835ffdbe63a89ab37",
"assets/assets/svg/edit.svg": "cf04289eabd82777ec5bf7c1ce6c81c4",
"assets/assets/svg/home.svg": "1b4e6f3015b5ad82bc233c74ea7ff95e",
"assets/assets/svg/home_active.svg": "65137bd4e4c361fea7be5773c4d65aa6",
"assets/assets/svg/icon_chat_fill.svg": "368c877e964a24b8f6a7f0342ce6a42d",
"assets/assets/svg/icon_chat_outline.svg": "5207338b4775c5061abf76f69346a45b",
"assets/assets/svg/icon_donation_fill.svg": "1608e1507fdbab6bd013cae4edc770e8",
"assets/assets/svg/icon_donation_outline.svg": "4677bbb7261510a4735f3d88a8b00848",
"assets/assets/svg/icon_feedback_fill.svg": "cc5d8adde852012f415f33d9ab94e942",
"assets/assets/svg/icon_feedback_outline.svg": "cf02dd483a6bf70eb8721417b42ecb6c",
"assets/assets/svg/icon_kegiatan_literasi_fill.svg": "5d027e5fefcf0ebf071aee5aeba0e5fb",
"assets/assets/svg/icon_kegiatan_literasi_outline.svg": "79921b70168455593015de326f50a8ce",
"assets/assets/svg/icon_rating_fill.svg": "c8f6dea107136f0a4e37fef6f93b3ca9",
"assets/assets/svg/icon_rating_outline.svg": "a8aea4e79652774a2febbf38867c3d79",
"assets/assets/svg/left.svg": "b13ee26821c9abb41305730d5d9a62fc",
"assets/assets/svg/light_mode.svg": "9cdc75ed9e09a50b271a9e6c04418eac",
"assets/assets/svg/menu.svg": "30a8356febadbc2403d4bfe50b88346b",
"assets/assets/svg/menu_1.svg": "f769912398d209018234245d32cebf64",
"assets/assets/svg/newspaper.svg": "e7dea4c80addbba3b4566e847a1f1ae4",
"assets/assets/svg/notification.svg": "0a88673bc463b74eee30587a39fb32d5",
"assets/assets/svg/notification_active.svg": "8a9083ed0fba1f040f6c1c2d2bc50383",
"assets/assets/svg/orange_star.svg": "56b21af43498b6fe78dc141accc2257b",
"assets/assets/svg/profile.svg": "3df238e726cc8f5b3170ebe2867e8590",
"assets/assets/svg/rating_empty_star.svg": "cd30b7687b8e29c208fb65156682a481",
"assets/assets/svg/right.svg": "e3ea4a361b71344a40ffefda5f205f13",
"assets/assets/svg/search.svg": "03d2b2d4c3dfd7c72014b58cce65655a",
"assets/assets/svg/sekilas_ilmu_fill.svg": "f0583675f26f6bf79f12be7ae1cfa8ec",
"assets/assets/svg/setting.svg": "8f5163a5945690a7bfa9f3d7abcfdd57",
"assets/assets/svg/setting_active.svg": "ebb5e92d493e961be70568ba8ae85bb7",
"assets/assets/svg/slider.svg": "1e6c008a6d8d7423fd69e6f32a536ddd",
"assets/assets/svg/slider_1.svg": "73c77da09baf98ccfc9acc5eb0046e17",
"assets/assets/svg/slider_active.svg": "c31ad652747a5f8da357449b9cfed18b",
"assets/assets/svg/slider_new.svg": "df70e34163111fac01861aab4aa5efd7",
"assets/assets/svg/star_half.svg": "0059f54714cb2bd6323d136051b6708a",
"assets/assets/svg/stories.svg": "514515501c646c0284d6b8c95d98b2ef",
"assets/assets/svg/stories_active.svg": "4160563e0290d5e26d7df6a0d63aa7f5",
"assets/assets/svg/story_new.svg": "59fed93fcb0bc8291941171bc78b1488",
"assets/assets/svg/trash.svg": "8afdf7c66b3761ee55a24044ff148df9",
"assets/assets/svg/user.svg": "fab8c03457844bb85d677226024093cd",
"assets/assets/svg/user_active.svg": "8f0fc98af1f5c2289dad1cd976e07c83",
"assets/FontManifest.json": "dfe381ee9d70aaf049523ef504dd9570",
"assets/fonts/CormorantGaramond-Bold.ttf": "d2f41939e8d24b563077bdc4a8137e91",
"assets/fonts/MaterialIcons-Regular.otf": "b5d3f0720e0f63d9462f7521ef3524f8",
"assets/fonts/PlusJakartaSans-Bold.ttf": "202ed785290892875b3c8b3d0584efc5",
"assets/fonts/PlusJakartaSans-Medium.ttf": "86c690cf3c5fa19ac4d644e3179d726e",
"assets/fonts/PlusJakartaSans-Regular.ttf": "1c53607464229476dd0241bcc71235f6",
"assets/NOTICES": "5f8b78580eb98ddb50ce390d21cda8d6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"firebase-messaging-sw.js": "b76f4ab3d0db6dc94608bc1c582f0aa5",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "196efd0eab44874620eb8fc5965c5423",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icon_simarku.png": "8f66b81c872fe9ac833852e403f13d16",
"index.html": "0462f7233ba55ce39d17f40f6b532f35",
"/": "0462f7233ba55ce39d17f40f6b532f35",
"main.dart.js": "a77cf7bf953545ab4a040e4a61d10aa2",
"manifest.json": "8ab570d085e70eb3780b596f09220efd",
"version.json": "c49fd0c0f764f6ce9c6b8f3aa00c016b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
