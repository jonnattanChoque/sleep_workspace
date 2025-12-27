import 'dart:math';

class CodeGenerator {
  static String generateSyncCode(String initials) {
    final random = Random();
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const numbers = '23456789';

    String getRandom(String set) => set[random.nextInt(set.length)];
    final pattern = '${getRandom(letters)}${getRandom(numbers)}${getRandom(letters)}${getRandom(numbers)}';
    
    return 'SS${initials.toUpperCase()}-$pattern';
  }
}