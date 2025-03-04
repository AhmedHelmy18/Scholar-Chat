import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'No user found for that email.'));
      } else if (ex.code == 'wrong-password') {
        emit(
          LoginFailure(errMessage: 'Wrong password provided for that user.'),
        );
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Something went wrong'));
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'Password is too weak'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'Email is already in use'));
      } else {
        emit(
          RegisterFailure(errMessage: ex.message ?? 'Authentication failed'),
        );
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: 'Something went wrong'));
    }
  }
}
