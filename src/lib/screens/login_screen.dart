
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Login'),
			),
			body: BlocListener<AuthCubit, AuthState>(
				listener: (context, state) {
					if (state is AuthFailure) {
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text(state.message)),
						);
					} else if (state is AuthSuccess) {
						Navigator.pushReplacementNamed(context, '/home');
					}
				},
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							BlocBuilder<AuthCubit, AuthState>(
								builder: (context, state) {
									if (state is AuthLoading) {
										return CircularProgressIndicator();
									} else {
										return Column(
											children: [
												TextField(
													key: Key('emailField'),
													decoration: InputDecoration(labelText: 'Email'),
													onChanged: (value) {
														context.read<AuthCubit>().emailChanged(value);
													},
												),
												TextField(
													key: Key('passwordField'),
													decoration: InputDecoration(labelText: 'Password'),
													obscureText: true,
													onChanged: (value) {
														context.read<AuthCubit>().passwordChanged(value);
													},
												),
												SizedBox(height: 20),
												ElevatedButton(
													key: Key('loginButton'),
													onPressed: () {
														context.read<AuthCubit>().login();
													},
													child: Text('Login'),
												),
											],
										);
									}
								},
							),
						],
					),
				),
			),
		);
	}
}
