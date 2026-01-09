class AppStrings {
  // Generic
  static const title = "SleepSync";
  static const changeTheme = "Cambiando tu tema...";
  static const buttonConfirm = "Confirmar";

  // Form Fields
  static const emailLabel = "Correo electrónico";
  static const passwordLabel = "Contraseña";

  // Error Messages (Públicos)
  static const errorEmptyFields = "Por favor, completa todos los campos para continuar.";
  static const errorInvalidEmail = "El formato del correo electrónico no es válido.";
  static const invalidCredential = "Las credenciales proporcionadas no son válidas.";
  static const errorShortPassword = "La contraseña debe tener al menos 6 caracteres.";
  static const errorUserNotFound = "No encontramos una cuenta activa.";
  static const errorWrongPassword = "La contraseña es incorrecta.";
  static const errorEmailNotVerified = "Por favor, verifica tu correo electrónico antes de iniciar sesión.";
  static const errorEmailAlreadyInUse = "El correo electrónico ya está en uso. Intenta con otro.";
  static const errorNetwork = "Error de red. Por favor, verifica tu conexión e intenta de nuevo.";
  static const errorCancelled = "El proceso fue cancelado por el usuario.";
  static const errorGeneral = "Ocurrió un error inesperado. Intenta de nuevo.";

  // Login Screen
  static const String loginWelcome = 'Bienvenido de vuelta';
  static const String registerTitle = 'Crea tu cuenta';
  static const String nameHint = '¿Cómo quieres que te llamemos?';
  static const String googleContinue = 'Continuar con Google';
  static const String googleRegister = 'Registrarse con Google';
  static const String noAccount = '¿No tienes cuenta? ';
  static const String alreadyHaveAccount = '¿Ya tienes cuenta? ';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String resetPasswordSent = '¡Correo de restablecimiento enviado! Revisa tu bandeja de entrada.';
  static const String registerAction = 'Regístrate';
  static const String loginAction = 'Entra';
  static const String verificationSent = '¡Cuenta creada! Revisa tu email para verificar.';
  static const String verificationTitle = 'Verifica tu correo';
  static const String verificationMessage = 'Te hemos enviado un enlace de confirmación. Por favor, revisa tu bandeja de entrada (o spam) para activar tu cuenta.';
  static const String backToLogin = 'Volver al Login';
  static const String confirmTitle = '¿Cerrar sesión?';
  static const String confirmMessage = 'Tendrás que volver a ingresar para ver tus datos de sueño.';
  static const String confirmAction = 'Cerrar sesión';

  // Dashboard unlink
  static const unlinkedSubtitle = 'Sincroniza tu descanso y cuida de quien más quieres.';
  static const yourLinkCode = 'TU CÓDIGO DE VÍNCULACIÓN';
  static const copy = 'Copiar';
  static const share = 'Enviar';
  static const step1 = 'Comparte este código con tu pareja.';
  static const step2 = 'Tu pareja lo ingresa en su aplicación.';
  static const step3 = '¡Empiecen a sincronizar su sueño!';
  static const haveCodeAction = 'Vincular código';
  static const copiedCode = '¡Código copiado al portapapeles!';
  static const shareCodeMessage = '¡Hola! Vincúlate conmigo en Sleep Sync para sincronizar nuestro descanso. Mi código es: ';
  static const creatingCode = 'Creando código...';
  static const linkPartnerTitle = 'Vincular código';
  static const linkPartnerSubtitle = "Ingresa el código que aparece en el dispositivo de tu pareja para comenzar.";
  static const enterLinkCodeHint = 'Ingresa el código de vínculación';
  static const linkAction = 'Vincular';
  static const noLinkend = "Sin vinculación";
  static const linkProcess = "Vinculando con tu pareja...";
  static const linkSuccess = "Pareja vinculada";
  static const errorInvalidLinkCode = 'El código ingresado no existe. Verifica y vuelve a intentarlo.';
  static const errorLinkedWithSelf = 'No puedes vincularte con tu propio código.';
  static const errorPartnerAlreadyLinked = 'Esta persona ya está vinculada con alguien más.';

  // Dashboard link
  static const linkedTitle = 'Tu descanso hoy';
  static const linkRecordTitle = "¡Registra tu sueño!";
  static const linkRecordButton = "Registrar";
  static const linkPartnerRecordTitle = "sigue soñando?";
  static const linkPartnerRecordMessage = "Recuerdale registrar su sueño";
  static const linkPartnerRecorsend = "🐝 ¡Zumbido enviado a";
  static const streakTitle = "Tu racha";
  static const days = "días";
  static const sleepDiff = "Diferencia sueño";
  
  // Tabs
  static const tabToday = 'Hoy';
  static const tabHistory = 'Historial';
  static const tabProfile = 'Perfil';

  // Profile Screen
  static const averageSleep = 'Promedio';
  static const profileAverageSleep = 'Promedio';
  static const togetherAverageSleep = 'Nuestro promedio';
  static const profileSleepGoal = 'Meta de Sueño';
  static const profileEditGoal = 'Editar Meta';
  static const profileConfiguration = 'Configuración';
  static const profileConfigurationInfo = "Editar mis preferencias";
  static const profileEditProfile = 'Editar Perfil';
  static const profileTheme = "Modo Oscuro";
  static const profilePush = 'Notificaciones';
  static const profileLogout = 'Cerrar Sesión';
  static const profileSliderUnlink = 'Desliza para desvincular';
  static const profileSliderPlaceholder = 'Desvincular';
  static const profileChangingTheme = "Sincronizando tu modo...";
  static const profileGoalTitle = "Meta diaria";
  // Edit profile
  static const editProfileSubtitle = "¿Cómo quieres que te llamemos?";
  static const nameTextield = "Ingresa tu nombre";
  static const editProfileButton = "Editar";
  static const nameUpdated = "Nombre actualizado";
  // Unlink
  static const unlinkedSuccess = "Vinculación eliminada con éxito";
  static const unlinkProcess = "Desvinculando pareja...";
  // Push
  static const pushOn = "Notificaciones activas";
  static const pushOff = "Notificaciones inactivas";
  // Average
  static const hours = " horas";
  static const sleepGoalTitle = "Meta de sueño diaria";
  static const sleepGoalChanged = "Tiempo de sueño guardado";

  // Linking
  static const registerSleepTitle = "¿Cuánto dormiste anoche?";
  static const registerSleepSuccess = "Registro guardado";

  static String sleepMessage(int quality) {
    switch (quality) {
      case 5: return "¡Increíble! Meta cumplida.";
      case 4: return "Muy buen descanso.";
      case 3: return "Podría ser mejor, intenta dormir más hoy.";
      default: return "Necesitas recuperar horas de sueño.";
    }
  }
}