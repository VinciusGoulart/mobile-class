import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user);
        _isAuthenticated = true;
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUserData(credential.user);
      _isAuthenticated = true;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _error = 'Erro inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 🔐 Cria o usuário no Firebase Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // 🔥 Salva os dados adicionais no Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': user.name,
        'phone': user.phone,
        'email': user.email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 🚚 Carrega os dados para o estado atual
      _currentUser = UserModel(
        id: credential.user!.uid,
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: '', // Nunca armazena senha localmente
        role: 'user',
      );

      _isAuthenticated = true;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _error = 'Erro inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _error = 'Erro inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> updateProfile({
  required String name,
  required String phone,
  String? currentPassword,
  String? newPassword,
}) async {
  if (_currentUser == null) return false;

  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final userId = _currentUser!.id;

    if (currentPassword != null &&
        currentPassword.isNotEmpty &&
        newPassword != null &&
        newPassword.isNotEmpty) {
      final user = _auth.currentUser!;

      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPassword);
    }

    await _firestore.collection('users').doc(userId).update({
      'name': name,
      'phone': phone,
    });

    _currentUser = UserModel(
      id: _currentUser!.id,
      name: name,
      email: _currentUser!.email,
      phone: phone,
      password: '', // senha nunca é armazenada localmente
      role: _currentUser!.role,
    );

    notifyListeners();
    return true;
  } on FirebaseAuthException catch (e) {
    _error = _handleFirebaseAuthError(e);
    return false;
  } catch (e) {
    _error = 'Erro inesperado: $e';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  Future<void> _loadUserData(User? firebaseUser) async {
    if (firebaseUser == null) return;

    final doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      _currentUser = UserModel(
        id: firebaseUser.uid,
        name: data['name'] ?? '',
        email: data['email'] ?? firebaseUser.email ?? '',
        phone: data['phone'] ?? '',
        password: '', // Nunca armazenar senha localmente
        role: data['role'] ?? 'user',
      );
    }
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Conta desativada.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente mais tarde.';
      default:
        return e.message ?? 'Erro desconhecido.';
    }
  }
}
