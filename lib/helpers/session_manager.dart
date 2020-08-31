import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';

import 'constants.dart';

class SessionManagerTourist {
  Future<bool> isLogginTourist() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    return prefs.getBool(sessionLogin) ?? false;
  }

  Future<String> getToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    return "Bearer " + prefs.getString(sessionToken) ?? null;
  }

  Future<String> getUsers() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(sessionUser) ?? null;
  }

  setLoginTourist(UsuariosModel usuarios) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    prefs.setBool(sessionLogin, true);
    prefs.setString(sessionToken, usuarios.access_token);
    prefs.setString(sessionUser, usuarios.email);
  }

  Future<bool> clearPrefTourist() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    /// elimina los datos de la aplicacion
    prefs.remove(sessionLogin);
    prefs.remove(sessionUser);
    prefs.remove(sessionToken);

    /// elimina todos los datos de la aplicacion
    prefs.clear();

    return true;
  }
}
