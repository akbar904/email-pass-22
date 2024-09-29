
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:simple_cubit_app/main.dart';

void main() {
	group('Main App Initialization', () {
		testWidgets('App shows LoginScreen initially', (WidgetTester tester) async {
			await tester.pumpWidget(MyApp());
			expect(find.byType(LoginScreen), findsOneWidget);
		});
	});

	group('AuthCubit', () {
		blocTest<AuthCubit, AuthState>(
			'initial state is AuthInitial',
			build: () => AuthCubit(),
			verify: (cubit) => expect(cubit.state, AuthInitial()),
		);

		blocTest<AuthCubit, AuthState>(
			'emits [AuthLoading, AuthSuccess] when login is successful',
			build: () => AuthCubit(),
			act: (cubit) => cubit.login('test@example.com', 'password'),
			expect: () => [AuthLoading(), AuthSuccess(User(email: 'test@example.com'))],
		);

		blocTest<AuthCubit, AuthState>(
			'emits [AuthLoading, AuthFailure] when login fails',
			build: () => AuthCubit(),
			act: (cubit) => cubit.login('wrong@example.com', 'wrongpassword'),
			expect: () => [AuthLoading(), AuthFailure('Invalid email or password')],
		);

		blocTest<AuthCubit, AuthState>(
			'emits [AuthInitial] when logout is called',
			build: () => AuthCubit()..emit(AuthSuccess(User(email: 'test@example.com'))),
			act: (cubit) => cubit.logout(),
			expect: () => [AuthInitial()],
		);
	});

	group('LoginScreen Widget', () {
		testWidgets('contains email and password fields and a login button', (WidgetTester tester) async {
			await tester.pumpWidget(MaterialApp(home: LoginScreen()));
			expect(find.byType(TextField), findsNWidgets(2));
			expect(find.byType(ElevatedButton), findsOneWidget);
		});

		testWidgets('shows error message on login failure', (WidgetTester tester) async {
			final authCubit = MockAuthCubit();
			when(() => authCubit.state).thenReturn(AuthFailure('Invalid email or password'));

			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>(
						create: (_) => authCubit,
						child: LoginScreen(),
					),
				),
			);

			expect(find.text('Invalid email or password'), findsOneWidget);
		});
	});

	group('HomeScreen Widget', () {
		testWidgets('contains a logout button', (WidgetTester tester) async {
			await tester.pumpWidget(MaterialApp(home: HomeScreen()));
			expect(find.byType(ElevatedButton), findsOneWidget);
		});
	});
}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}
