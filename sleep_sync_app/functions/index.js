const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { setGlobalOptions } = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();

// Configuramos la región (opcional, por defecto es us-central1)
setGlobalOptions({ region: "us-central1" });

exports.onNudgeCreated = onDocumentCreated(
  "njudges/{nudgeId}",
  async (event) => {
    // En v2, los datos están en event.data
    const nudgeData = event.data.data();
    const receiverId = nudgeData.receiverId;
    const senderName = nudgeData.senderName;

    try {
      // 1. Buscamos el token del receptor
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(receiverId)
        .get();

      if (!userDoc.exists) {
        console.log("El usuario receptor no existe");
        return;
      }

      const fcmToken = userDoc.data().fcmToken;

      if (!fcmToken) {
        console.log("El usuario no tiene un token FCM registrado");
        return;
      }

      // 2. Construimos el mensaje
      const message = {
        notification: {
          title: "¡Zumbido! 🐝",
          body: `${senderName} quiere saber cómo dormiste hoy.`,
        },
        token: fcmToken,
      };

      // 3. Enviamos vía FCM
      const response = await admin.messaging().send(message);
      console.log("Notificación enviada con éxito:", response);
    } catch (error) {
      console.error("Error enviando notificación:", error);
    }
  },
);
