import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/features/auth/data/model/user_model.dart';

abstract interface class AuthRemoteDataSource{
  User? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  // whenever this implementation class is called, firebase auth instance is injected as a param. therefore we can use any other service instead
  // of firebase whenever we like without complicating the code much. this is dependency injection. so basically there are 2 reason-
  // 1. a dependency is not created between a class and firebase
  // 2. for testing
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  User? get currentUserSession => FirebaseAuth.instance.currentUser;

  @override
  Future<UserModel> loginWithEmailPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.reload();
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw ServerException("Failed to retrieve user after sign-in.");
      }

      final userData = {
        'id': user.uid,
        'email': user.email ?? '',
        'name': user.displayName ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      };

      final profilesRef = FirebaseFirestore.instance.collection('profiles');
      final docSnapshot = await profilesRef.doc(user.uid).get();
      if (!docSnapshot.exists) {
        await profilesRef.doc(user.uid).set(userData);
      } else {
        await profilesRef.doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return UserModel(id: user.uid, email: user.email?? '', name: user.displayName?? '');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'wrong-password') {
        throw ServerException("Incorrect password provided.");
      } else if (e.code == 'user-not-found') {
        throw ServerException("No user found for that email.");
      } else if (e.code == 'invalid-email') {
        throw ServerException("The email address is not valid.");
      }
      throw ServerException(e.message?? "Error: ${e.message}");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({required String name, required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update the user's display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw ServerException("Failed to retrieve user after sign-up.");
      }

      final userData = {
        'id': user.uid,
        'email': user.email ?? '',
        'name': user.displayName ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      };

      final profilesRef = FirebaseFirestore.instance.collection('profiles');
      final docSnapshot = await profilesRef.doc(user.uid).get();
      if (!docSnapshot.exists) {
        await profilesRef.doc(user.uid).set(userData);
      } else {
        await profilesRef.doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return UserModel(id: user.uid, email: user.email?? '', name: user.displayName?? name);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'weak-password') {
        throw ServerException("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw ServerException("An account already exists for this email.");
      } else if (e.code == 'invalid-email') {
        throw ServerException("The email address is not valid.");
      }
      throw ServerException(e.message?? "Error: ${e.message}");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(currentUserSession != null) {
        return UserModel(
          id: currentUserSession!.uid,
          email: currentUserSession!.email ?? '',
          name: currentUserSession!.displayName ?? '',
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}