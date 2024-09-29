
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
	final User user;
	AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
	final String error;
	AuthFailure(this.error);
}

class AuthCubit extends Cubit<AuthState> {
	AuthCubit() : super(AuthInitial());

	void login(String email, String password) async {
		try {
			emit(AuthLoading());
			// Simulate a delay for authentication
			await Future.delayed(Duration(seconds: 1));
			
			// For demonstration, we assume any email with "test" logs in successfully
			if (email == 'test@example.com' && password == 'password123') {
				emit(AuthSuccess(User(email: email)));
			} else {
				emit(AuthFailure('Login failed'));
			}
		} catch (e) {
			emit(AuthFailure('An error occurred'));
		}
	}

	void logout() {
		emit(AuthInitial());
	}
}
