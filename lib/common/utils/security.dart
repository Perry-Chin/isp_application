// Security - random string generator

import 'dart:math';

// Function to generate a random string of specified length
String getRandomString(int length){
  // Possible characters that can be used
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // Create a random number generator
  Random rnd = Random();
  // Generate a random string
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
