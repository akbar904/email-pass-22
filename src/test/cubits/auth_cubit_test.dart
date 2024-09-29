
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_cubit_app/cubits/auth_cubit.dart';
import 'package:simple_cubit_app/models/user.dart';

// Mock dependencies
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
	group('AuthCubit', () {
		late AuthCubit authCubit;

		setUp(() {
			authCubit = AuthCubit();
		});

		tearDown(() {
			authCubit.close();
		});

		test('initial state is AuthInitial', () {
			expect(authCubit.state, AuthInitial());
		});

		blocTest<AuthCubit, AuthState>(
			'emit [AuthLoading, AuthSuccess] when login is successful',
			build: () => authCubit,
			act: (cubit) => cubit.login('test@example.com', 'password123'),
			expect: () => [
				AuthLoading(),
				AuthSuccess(User(email: 'test@example.com')),
			],
		);

		blocTest<AuthCubit, AuthState>(
			'emit [AuthLoading, AuthFailure] when login fails',
			build: () => authCubit,
			act: (cubit) => cubit.login('wrong@example.com', 'wrongpassword'),
			expect: () => [
				AuthLoading(),
				AuthFailure('Login failed'),
			],
		);

		blocTest<AuthCubit, AuthState>(
			'emit [AuthInitial] when logout is called',
			build: () => authCubit,
			act: (cubit) => cubit.logout(),
			expect: () => [
				AuthInitial(),
			],
		);
	});
}
