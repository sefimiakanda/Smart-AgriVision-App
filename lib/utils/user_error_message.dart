String userErrorMessage(Object error) {
  final message = error.toString().replaceFirst('Bad state: ', '');
  if (message.contains('permission') || message.contains('denied')) {
    return 'Permission refusée. Autorisez l’accès demandé dans les réglages du téléphone.';
  }
  if (message.contains('network') ||
      message.contains('SocketException') ||
      message.contains('timeout')) {
    return 'Connexion impossible. Vérifiez Internet puis réessayez.';
  }
  if (message.contains('Clé ') || message.contains('absente')) {
    return 'Ce service n’est pas configuré sur cette version de l’application.';
  }
  return message.contains(':')
      ? 'Une erreur est survenue. Réessayez.'
      : message;
}
