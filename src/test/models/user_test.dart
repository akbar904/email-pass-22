
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_package_name/models/user.dart';

void main() {
	group('User Model Tests', () {
		test('User model should be instantiated with correct email', () {
			final email = 'test@example.com';
			final user = User(email: email);

			expect(user.email, email);
		});

		test('User model should serialize to JSON correctly', () {
			final email = 'test@example.com';
			final user = User(email: email);

			final expectedJson = {'email': email};
			expect(user.toJson(), expectedJson);
		});

		test('User model should deserialize from JSON correctly', () {
			final json = {'email': 'test@example.com'};
			final user = User.fromJson(json);

			expect(user.email, json['email']);
		});
	});
}

class User {
	final String email;

	User({required this.email});

	factory User.fromJson(Map<String, dynamic> json) {
		return User(email: json['email']);
	}

	Map<String, dynamic> toJson() {
		return {'email': email};
	}
}
