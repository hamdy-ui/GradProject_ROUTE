import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../movies/data/models/movie_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getUserProfile();

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> deleteAccount();

  Future<void> sendPasswordReset();

  Future<List<MovieModel>> getWishlist();

  Future<List<MovieModel>> getHistory();

  Future<bool> isMovieInWishlist(int movieId);

  Future<bool> toggleWishlist(MovieModel movie);

  Future<void> addToHistory(MovieModel movie);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  @override
  Future<UserModel?> getUserProfile() async {
    final uid = _currentUserId;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!, uid: uid);
    }

    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        name: user.displayName ?? 'Movie Fan',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        avatarIndex: 0,
      );
    }
    return null;
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final uid = _currentUserId;
    if (uid == null) throw Exception('User not logged in');

    await _auth.currentUser?.updateDisplayName(name.trim());

    await _firestore.collection('users').doc(uid).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'avatarIndex': avatarIndex,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final uid = user.uid;

    // Delete Firestore user document and subcollections
    try {
      final wishlistSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('wishlist')
          .get();
      for (final doc in wishlistSnapshot.docs) {
        await doc.reference.delete();
      }

      final historySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('history')
          .get();
      for (final doc in historySnapshot.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('users').doc(uid).delete();
    } catch (_) {}

    await user.delete();
  }

  @override
  Future<void> sendPasswordReset() async {
    final email = _auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw Exception('No email address associated with this account');
    }
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<List<MovieModel>> getWishlist() async {
    final uid = _currentUserId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MovieModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<MovieModel>> getHistory() async {
    final uid = _currentUserId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('watchedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MovieModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<bool> isMovieInWishlist(int movieId) async {
    final uid = _currentUserId;
    if (uid == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(movieId.toString())
        .get();

    return doc.exists;
  }

  @override
  Future<bool> toggleWishlist(MovieModel movie) async {
    final uid = _currentUserId;
    if (uid == null) throw Exception('Please login to manage your wishlist');

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(movie.id.toString());

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      return false; // Removed
    } else {
      final json = movie.toJson();
      json['addedAt'] = FieldValue.serverTimestamp();
      await docRef.set(json);
      return true; // Added
    }
  }

  @override
  Future<void> addToHistory(MovieModel movie) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .doc(movie.id.toString());

    final json = movie.toJson();
    json['watchedAt'] = FieldValue.serverTimestamp();
    await docRef.set(json);
  }
}
