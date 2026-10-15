// Service worker de Firebase Cloud Messaging para la app web (ADR-0027).
// Muestra los avisos push con la pestaña cerrada o en segundo plano y abre la pantalla
// del aviso al tocarlo.
//
// La configuración pública de Firebase (por ambiente) la escribe el workflow deploy-web
// en firebase-config.js al compilar. Sin ese archivo (local) el push web queda apagado.
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-messaging-compat.js');
importScripts('firebase-config.js');

firebase.initializeApp(self.FIREBASE_CONFIG);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title ?? 'SISI';
  self.registration.showNotification(title, {
    body: payload.notification?.body ?? '',
    icon: 'icons/Icon-192.png',
    data: payload.data ?? {},
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const route = event.notification.data?.route ?? '/';
  // Solo rutas de la propia app.
  const target = route.startsWith('/') ? route : '/';
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clients) => {
      for (const client of clients) {
        if ('focus' in client) {
          client.navigate(target);
          return client.focus();
        }
      }
      return self.clients.openWindow(target);
    }),
  );
});
