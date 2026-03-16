import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static const String _jwtSecret = 'your-super-secret-jwt-key-min-32-chars-long!!!';
  static const Duration _tokenExpiry = Duration(hours: 24);
  static const Duration _refreshExpiry = Duration(days: 7);

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }

  static String generateToken(String userId, String clinicId, String email, String role, {bool isRefresh = false,}) {
    final now = DateTime.now();
    final expiry = isRefresh ? now.add(_refreshExpiry) : now.add(_tokenExpiry);
    final jwt = JWT({'sub': userId, 'clinic_id': clinicId, 'email': email, 'role': role, 'iat': now.millisecondsSinceEpoch ~/ 1000, 'exp': expiry.millisecondsSinceEpoch ~/ 1000, 'type': isRefresh ? 'refresh' : 'access', 'jti': const Uuid().v4(),});
    return jwt.sign(SecretKey(_jwtSecret));
  }

  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecret));
      return jwt.payload as Map<String, dynamic>;
    } on JWTException catch (e) {
      return null;
    }
  }

  static String? getUserIdFromToken(String token) {
    final payload = verifyToken(token);
    return payload?['sub'] as String?;
  }

  static String? getClinicIdFromToken(String token) {
    final payload = verifyToken(token);
    return payload?['clinic_id'] as String?;
  }

  static String? getRoleFromToken(String token) {
    final payload = verifyToken(token);
    return payload?['role'] as String?;
  }

  static String? refreshAccessToken(String refreshToken) {
    final payload = verifyToken(refreshToken);
    if (payload == null || payload['type'] != 'refresh') {
      return null;
    }
    return generateToken(payload['sub'] as String, payload['clinic_id'] as String, payload['email'] as String, payload['role'] as String, isRefresh: false,);
  }
}