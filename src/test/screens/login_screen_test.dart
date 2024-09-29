
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:simple_cubit_app/screens/login_screen.dart';
import 'package:simple_cubit_app/cubits/auth_cubit.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
	group('LoginScreen Widget Tests', () {
		testWidgets('should display email and password fields and login button', (WidgetTester tester) async {
			await tester.pumpWidget(MaterialApp(home: LoginScreen()));
			
			expect(find.byType(TextField), findsNWidgets(2));
			expect(find.byType(ElevatedButton), findsOneWidget);
			expect(find.text('Login'), findsOneWidget);
		});

		testWidgets('should show error message when login fails', (WidgetTester tester) async {
			final mockAuthCubit = MockAuthCubit();
			whenListen(
				mockAuthCubit,
				Stream.fromIterable([AuthFailure('Invalid credentials')]),
				initialState: AuthInitial()
			);
			
			await tester.pumpWidget(MaterialApp(
				home: BlocProvider<AuthCubit>(
					create: (_) => mockAuthCubit,
					child: LoginScreen(),
				),
			));
			
			await tester.pump();
			expect(find.text('Invalid credentials'), findsOneWidget);
		});

		testWidgets('should show loading indicator when logging in', (WidgetTester tester) async {
			final mockAuthCubit = MockAuthCubit();
			whenListen(
				mockAuthCubit,
				Stream.fromIterable([AuthLoading()]),
				initialState: AuthInitial()
			);

			await tester.pumpWidget(MaterialApp(
				home: BlocProvider<AuthCubit>(
					create: (_) => mockAuthCubit,
					child: LoginScreen(),
				),
			));
			
			await tester.pump();
			expect(find.byType(CircularProgressIndicator), findsOneWidget);
		});
	});
}
