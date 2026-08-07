importScripts(
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js'
);

importScripts(
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js'
);

const firebaseConfig = {
  apiKey: "AIzaSyAevp89ZWEV-FijVDc5eFnAIWddNyHkhhE",
  authDomain: "nursing-school-system.firebaseapp.com",
  projectId: "nursing-school-system",
  storageBucket: "nursing-school-system.firebasestorage.app",
  messagingSenderId: "446249583331",
  appId: "1:446249583331:web:5fe419be6a3fcd86247bd6",
  measurementId: "G-8BMJTT1EPX"
}
firebase.initializeApp(firebaseConfig);
 const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
  console.log("Received background message: ", message);

  const notificationTitle = message.notification?.title || "إشعار جديد";
  const notificationOptions = {
    body: message.notification?.body || "",
    icon: "/favicon.png",
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
