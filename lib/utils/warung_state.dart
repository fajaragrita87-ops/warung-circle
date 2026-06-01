import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// WARUNG CENTRAL STATE MANAGER (Thread-safe Unified Store)
// ============================================================
class WS {
  // === USER SESSION ===
  static bool _isLoggedIn = false;
  static bool get isLoggedIn => _isLoggedIn;
  static set isLoggedIn(bool val) => _isLoggedIn = val;

  static String _userName = '';
  static String get userName => _userName;
  static set userName(String val) => _userName = val;

  static String _userContact = '';
  static String get userContact => _userContact;
  static set userContact(String val) => _userContact = val;

  static String _userAvatar = '';
  static String get userAvatar => _userAvatar;
  static set userAvatar(String val) {
    _userAvatar = val;
    persistStats();
  }

  static String _userRole = 'user';
  static String get userRole => _userRole;
  static set userRole(String val) {
    _userRole = val;
    persistStats();
  }

  // === WALLET & STATS ===
  static double _kopiBalance = 15.0;
  static double get kopiBalance => _kopiBalance;
  static set kopiBalance(double val) {
    _kopiBalance = val;
    persistStats();
  }

  static double _kopiDebt = 0.0;
  static double get kopiDebt => _kopiDebt;
  static set kopiDebt(double val) {
    _kopiDebt = val;
    persistStats();
  }

  static double _respectPoints = 75.0;
  static double get respectPoints => _respectPoints;
  static set respectPoints(double val) {
    _respectPoints = val;
    persistStats();
  }

  static double _redFlags = 10.0;
  static double get redFlags => _redFlags;
  static set redFlags(double val) {
    _redFlags = val;
    persistStats();
  }

  // === GACHA INVENTORY ===
  static List<String> _gachaInventory = [];
  static List<String> get gachaInventory => _gachaInventory;
  static set gachaInventory(List<String> val) {
    _gachaInventory = val;
    persistStats();
  }

  // === LELANG WAKTU (Time Auctions) ===
  static List<Map<String, dynamic>> activeBids = [
    {
      'id': 'bid_1',
      'title': 'Jasa Ajarin Coding Flutter',
      'seller': 'Dika Pratama',
      'currentBid': 12.0,
      'timeLeft': 120, // seconds
      'status': 'Pending',
    },
    {
      'id': 'bid_2',
      'title': 'Les Privat Figma 1 Jam',
      'seller': 'Budi Santoso',
      'currentBid': 8.0,
      'timeLeft': 80,
      'status': 'Accepted',
    }
  ];

  // === STATIC INITIAL POSTS FEED ===
  static List<Map<String, dynamic>> dynamicPosts = [];

  // === INITIALIZE MEMORY & STORAGE STATE ===
  static Future<void> init(List<Map<String, dynamic>> initialPosts) async {
    if (dynamicPosts.isEmpty) {
      dynamicPosts = List<Map<String, dynamic>>.from(initialPosts);
    }
    await loadSession();
  }

  static Future<void> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _userName = prefs.getString('userName') ?? '';
      _userContact = prefs.getString('userContact') ?? '';
      _userRole = prefs.getString('userRole') ?? 'user';
      _userAvatar = prefs.getString('userAvatar') ?? '';
      _kopiBalance = prefs.getDouble('kopiBalance') ?? 15.0;
      _kopiDebt = prefs.getDouble('kopiDebt') ?? 0.0;
      _respectPoints = prefs.getDouble('respectPoints') ?? 75.0;
      _redFlags = prefs.getDouble('redFlags') ?? 10.0;
      _gachaInventory = prefs.getStringList('gachaInventory') ?? [];
    } catch (e) {
      debugPrint('Error loading persistent session: $e');
    }
  }

  // === HELPER METHODS ===
  static Future<void> login(String name, String contact, {String role = 'user'}) async {
    isLoggedIn = true;
    userName = name;
    userContact = contact;
    _userRole = role;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', name);
      await prefs.setString('userContact', contact);
      await prefs.setString('userRole', role);
      await prefs.setString('userAvatar', '');
      await prefs.setDouble('kopiBalance', kopiBalance);
    } catch (e) {
      debugPrint('Error saving login session: $e');
    }
  }

  static Future<void> persistStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('kopiBalance', kopiBalance);
      await prefs.setDouble('kopiDebt', kopiDebt);
      await prefs.setDouble('respectPoints', respectPoints);
      await prefs.setDouble('redFlags', redFlags);
      await prefs.setString('userRole', userRole);
      await prefs.setString('userAvatar', userAvatar);
      await prefs.setStringList('gachaInventory', gachaInventory);
    } catch (e) {
      debugPrint('Error persisting stats: $e');
    }
  }

  static Future<void> logout() async {
    isLoggedIn = false;
    userName = '';
    userContact = '';
    kopiBalance = 15.0;
    kopiDebt = 0.0;
    respectPoints = 75.0;
    redFlags = 10.0;
    _userRole = 'user';
    _userAvatar = '';
    gachaInventory.clear();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing login session: $e');
    }
  }
}
