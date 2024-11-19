import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  // Menyimpan username dan password ke SharedPreferences
  static Future<void> saveAccount(String username, String password) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('username', username);
    await sharedPref.setString('password', password); // Pertimbangkan enkripsi
  }

  // Mengambil username dari SharedPreferences
  static Future<String> getUsername() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('username') ?? 'Guest'; // Default jika tidak ada
  }

  // Melakukan login dengan memvalidasi username dan password
  static Future<bool> login(String username, String password) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? storedUsername = sharedPref.getString('username');
    String? storedPassword = sharedPref.getString('password');

    return username == storedUsername && password == storedPassword;
  }

  // Menghapus akun dari SharedPreferences
  static Future<void> clearAccount() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove('username');
    await sharedPref.remove('password');
  }
}