
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:com.example.simple_cubit_app/screens/home_screen.dart';
import 'package:com.example.simple_cubit_app/cubits/auth_cubit.dart';

class MockAuthCubit extends MockCubit<void> implements AuthCubit {}

void main() {
	group('HomeScreen', () {
		late MockAuthCubit mockAuthCubit;

		setUp(() {
			mockAuthCubit = MockAuthCubit();
		});

		testWidgets('should display a logout button', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>.value(
						value: mockAuthCubit,
						child: HomeScreen(),
					),
				),
			);

			expect(find.byType(ElevatedButton), findsOneWidget);
			expect(find.text('Logout'), findsOneWidget);
		});

		testWidgets('should call logout when logout button is pressed', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<AuthCubit>.value(
						value: mockAuthCubit,
						child: HomeScreen(),
					),
				),
			);

			await tester.tap(find.byType(ElevatedButton));
			await tester.pump();

			verify(() => mockAuthCubit.logout()).called(1);
		});
	});
}
