
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/login_screen.dart';
import 'cubits/auth_cubit.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return BlocProvider(
			create: (context) => AuthCubit(),
			child: MaterialApp(
				title: 'Simple Cubit App',
				theme: ThemeData(
					primarySwatch: Colors.blue,
				),
				home: LoginScreen(),
			),
		);
	}
}

class AuthState {}

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
		emit(AuthLoading());
		await Future.delayed(Duration(seconds: 1)); // Simulate network delay
		if (email == 'test@example.com' && password == 'password') {
			emit(AuthSuccess(User(email: email)));
		} else {
			emit(AuthFailure('Invalid email or password'));
		}
	}

	void logout() {
		emit(AuthInitial());
	}
}

class User {
	final String email;
	User({required this.email});
}
