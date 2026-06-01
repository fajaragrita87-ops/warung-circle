import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warung_circle/utils/warung_state.dart';

class FirebaseService {
  static bool useRealFirebase = false;

  // Local Mock Databases
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'email': 'superadmin@warung.com',
      'name': 'Teh Erni Super',
      'contact': '08111111111',
      'role': 'superadmin',
      'kopiBalance': 999.0,
      'isBanned': false,
    },
    // === AKUN DEV / TESTING SUPERADMIN ===
    // Login: admin@warung.com / password: admin123
    {
      'email': 'admin@warung.com',
      'name': 'Admin Warung',
      'contact': '08000000000',
      'role': 'superadmin',
      'kopiBalance': 999.0,
      'isBanned': false,
    },
  ];
  static final Set<String> _mockBannedUsers = {};

  // Stream Controllers for Mock Mode
  static final StreamController<List<Map<String, dynamic>>> _postsStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  static final Map<String, StreamController<List<Map<String, dynamic>>>> _commentsControllers = {};

  Future<void> initialize() async {
    try {
      // Try to initialize Firebase
      await Firebase.initializeApp();
      useRealFirebase = true;
      debugPrint("🔥 Firebase Initialized Successfully! Running in REAL Backend mode.");
    } catch (e) {
      useRealFirebase = false;
      debugPrint("⚠️ Firebase Initialize failed: $e. Running in MOCK Local Database mode.");
      _updatePostsStream();
    }
  }

  // Update stream for mock posts
  static void _updatePostsStream() {
    _postsStreamController.add(List<Map<String, dynamic>>.from(WS.dynamicPosts));
  }

  static void _updateCommentsStream(String postId, List<Map<String, dynamic>> comments) {
    if (!_commentsControllers.containsKey(postId)) {
      _commentsControllers[postId] = StreamController<List<Map<String, dynamic>>>.broadcast();
    }
    _commentsControllers[postId]!.add(List<Map<String, dynamic>>.from(comments));
  }

  // === AUTHENTICATION SYSTEM ===

  Future<void> signUpWithEmail(String email, String password, String name, String contact) async {
    String role = (email.trim() == 'superadmin@warung.com' || email.trim().contains('superadmin')) ? 'superadmin' : 'user';

    if (useRealFirebase) {
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email.trim(),
        'name': name.trim(),
        'contact': contact.trim(),
        'role': role,
        'kopiBalance': 15.0,
        'respectPoints': 75.0,
        'redFlags': 10.0,
        'isBanned': false,
      });

      await WS.login(name.trim(), contact.trim(), role: role);
      WS.kopiBalance = 15.0;
      WS.respectPoints = 75.0;
      WS.redFlags = 10.0;
    } else {
      // Mock Sign Up
      if (_mockUsers.any((u) => u['email'] == email.trim())) {
        throw Exception("Email sudah terdaftar!");
      }

      _mockUsers.add({
        'email': email.trim(),
        'name': name.trim(),
        'contact': contact.trim(),
        'role': role,
        'kopiBalance': 15.0,
        'respectPoints': 75.0,
        'redFlags': 10.0,
        'isBanned': false,
      });

      await WS.login(name.trim(), contact.trim(), role: role);
      WS.kopiBalance = 15.0;
      WS.respectPoints = 75.0;
      WS.redFlags = 10.0;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (useRealFirebase) {
      UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      var doc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
      if (doc.exists) {
        var data = doc.data()!;
        if (data['isBanned'] == true) {
          throw Exception("Akun Anda telah di-ban oleh Superadmin!");
        }
        await WS.login(data['name'] ?? '', data['contact'] ?? '', role: data['role'] ?? 'user');
        WS.kopiBalance = (data['kopiBalance'] as num?)?.toDouble() ?? 15.0;
        WS.respectPoints = (data['respectPoints'] as num?)?.toDouble() ?? 75.0;
        WS.redFlags = (data['redFlags'] as num?)?.toDouble() ?? 10.0;
      } else {
        String role = (email.trim() == 'superadmin@warung.com' || email.trim().contains('superadmin')) ? 'superadmin' : 'user';
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email.trim(),
          'name': email.split('@')[0],
          'contact': '08123456789',
          'role': role,
          'kopiBalance': 15.0,
          'respectPoints': 75.0,
          'redFlags': 10.0,
          'isBanned': false,
        });
        await WS.login(email.split('@')[0], '08123456789', role: role);
      }
    } else {
      // Mock Sign In
      var matched = _mockUsers.where((u) => u['email'] == email.trim());
      if (matched.isEmpty) {
        throw Exception("Email tidak terdaftar! Silakan daftar terlebih dahulu.");
      }
      var user = matched.first;
      if (user['isBanned'] == true || _mockBannedUsers.contains(user['email']) || _mockBannedUsers.contains(user['contact'])) {
        throw Exception("Akun Anda telah di-ban oleh Superadmin!");
      }

      await WS.login(user['name'], user['contact'], role: user['role']);
      WS.kopiBalance = (user['kopiBalance'] as num).toDouble();
      WS.respectPoints = (user['respectPoints'] as num?)?.toDouble() ?? 75.0;
      WS.redFlags = (user['redFlags'] as num?)?.toDouble() ?? 10.0;
    }
  }

  Future<void> logout() async {
    if (useRealFirebase) {
      await FirebaseAuth.instance.signOut();
    }
    await WS.logout();
  }

  // === POST SYSTEM ===

  Future<void> createPost(String text, {dynamic imageData, String? imageUrl, String? location, bool isVsMode = false}) async {
    if (await isUserBanned(WS.userContact) || await isUserBanned(WS.userName)) {
      throw Exception("Anda di-ban dan tidak diizinkan memposting!");
    }

    if (useRealFirebase) {
      String? uploadedUrl = imageUrl;
      if (imageData != null && imageData is Uint8List) {
        String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';
        var ref = FirebaseStorage.instance.ref().child(fileName);
        var uploadTask = await ref.putData(imageData);
        uploadedUrl = await uploadTask.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'author': WS.userName,
        'character': 'Warga',
        'time': 'Baru saja',
        'timestamp': FieldValue.serverTimestamp(),
        'text': text,
        'imageUrl': uploadedUrl,
        'location': location,
        'likes': 0,
        'commentsCount': 0,
        'isVsMode': isVsMode,
        'vsVotes': isVsMode ? {'A': 0, 'B': 0} : null,
        'votedUsers': isVsMode ? {} : null,
      });
    } else {
      // Mock Post
      final newPost = {
        'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
        'author': WS.userName,
        'character': 'Warga',
        'time': 'Baru saja',
        'text': text,
        'imageUrl': imageUrl,
        'imageData': imageData,
        'location': location,
        'likes': 0,
        'commentsCount': 0,
        'isVsMode': isVsMode,
        'vsVotes': isVsMode ? {'A': 0, 'B': 0} : null,
        'votedUsers': isVsMode ? <String, String>{} : null,
        'comments': <Map<String, dynamic>>[],
      };
      WS.dynamicPosts.insert(0, newPost);
      _updatePostsStream();
    }
  }

  Stream<List<Map<String, dynamic>>> streamPosts() {
    if (useRealFirebase) {
      return FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } else {
      // Mock Stream
      _updatePostsStream();
      return _postsStreamController.stream;
    }
  }

  Future<void> likePost(String postId) async {
    if (useRealFirebase) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1)
      });
    } else {
      for (var post in WS.dynamicPosts) {
        if (post['id'] == postId || post['text'] == postId) {
          post['likes'] = (post['likes'] ?? 0) + 1;
          break;
        }
      }
      _updatePostsStream();
    }
  }

  Future<void> deletePost(String postId) async {
    if (useRealFirebase) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } else {
      WS.dynamicPosts.removeWhere((p) => p['id'] == postId || p['text'] == postId);
      _updatePostsStream();
    }
  }

  // === COMMENT SYSTEM ===

  Stream<List<Map<String, dynamic>>> streamComments(String postId) {
    if (useRealFirebase) {
      return FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } else {
      // Mock comments stream
      var matched = WS.dynamicPosts.where((p) => p['id'] == postId || p['text'] == postId);
      List<Map<String, dynamic>> comments = [];
      if (matched.isNotEmpty) {
        comments = List<Map<String, dynamic>>.from(matched.first['comments'] ?? []);
      }
      // Delay slightly to allow listener to subscribe
      Timer(const Duration(milliseconds: 50), () => _updateCommentsStream(postId, comments));
      return _commentsControllers.putIfAbsent(postId, () => StreamController<List<Map<String, dynamic>>>.broadcast()).stream;
    }
  }

  Future<void> addComment(String postId, String text) async {
    if (await isUserBanned(WS.userContact) || await isUserBanned(WS.userName)) {
      throw Exception("Anda di-ban dan tidak diizinkan berkomentar!");
    }

    if (useRealFirebase) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
        'author': WS.userName,
        'text': text,
        'time': 'Baru saja',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1)
      });
    } else {
      for (var post in WS.dynamicPosts) {
        if (post['id'] == postId || post['text'] == postId) {
          List<Map<String, dynamic>> comments = List<Map<String, dynamic>>.from(post['comments'] ?? []);
          comments.add({
            'author': WS.userName,
            'text': text,
            'time': 'Baru saja',
          });
          post['comments'] = comments;
          post['commentsCount'] = comments.length;
          _updateCommentsStream(postId, comments);
          break;
        }
      }
      _updatePostsStream();
    }
  }

  // === ADMIN & MODERATION SYSTEM ===

  Future<void> addKopi(String contactOrEmail, double amount) async {
    if (useRealFirebase) {
      var query = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: contactOrEmail.trim()).get();
      if (query.docs.isEmpty) {
        query = await FirebaseFirestore.instance.collection('users').where('contact', isEqualTo: contactOrEmail.trim()).get();
      }
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'kopiBalance': FieldValue.increment(amount)
        });
      } else {
        throw Exception("User dengan kontak/email tersebut tidak ditemukan!");
      }
    } else {
      bool found = false;
      for (var u in _mockUsers) {
        if (u['email'] == contactOrEmail.trim() || u['contact'] == contactOrEmail.trim()) {
          u['kopiBalance'] = ((u['kopiBalance'] as num?)?.toDouble() ?? 0.0) + amount;
          found = true;
          break;
        }
      }
      if (WS.userContact == contactOrEmail.trim() || WS.userName == contactOrEmail.trim()) {
        WS.kopiBalance += amount;
        found = true;
      }
      if (!found) {
        throw Exception("User dengan kontak/email tersebut tidak ditemukan!");
      }
    }
  }

  Future<void> banUser(String contactOrEmail) async {
    if (useRealFirebase) {
      var query = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: contactOrEmail.trim()).get();
      if (query.docs.isEmpty) {
        query = await FirebaseFirestore.instance.collection('users').where('contact', isEqualTo: contactOrEmail.trim()).get();
      }
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'isBanned': true
        });
      } else {
        throw Exception("User dengan kontak/email tersebut tidak ditemukan!");
      }
    } else {
      _mockBannedUsers.add(contactOrEmail.trim());
      for (var u in _mockUsers) {
        if (u['email'] == contactOrEmail.trim() || u['contact'] == contactOrEmail.trim()) {
          u['isBanned'] = true;
          break;
        }
      }
    }
  }

  Future<bool> isUserBanned(String contactOrEmail) async {
    if (useRealFirebase) {
      var query = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: contactOrEmail.trim()).get();
      if (query.docs.isEmpty) {
        query = await FirebaseFirestore.instance.collection('users').where('contact', isEqualTo: contactOrEmail.trim()).get();
      }
      if (query.docs.isNotEmpty) {
        return query.docs.first.data()['isBanned'] == true;
      }
      return false;
    } else {
      return _mockBannedUsers.contains(contactOrEmail.trim());
    }
  }
}
