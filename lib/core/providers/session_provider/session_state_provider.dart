import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum SessionStatus { authenticated, unauthenticated, loading }

class SessionState {
  final SessionStatus status;
  final String? token;

  const SessionState({required this.status, this.token});

  SessionState copyWith({SessionStatus? status, String? token}) {
    return SessionState(
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    Future.microtask(() => checkSession());
    return const SessionState(status: SessionStatus.loading);
  }

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      state = state.copyWith(status: SessionStatus.authenticated, token: token);
    } else {
      state = state.copyWith(status: SessionStatus.unauthenticated);
    }
  }

  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    state = state.copyWith(status: SessionStatus.authenticated, token: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = state.copyWith(status: SessionStatus.unauthenticated, token: null);
  }
}

final sessionStateProvider = NotifierProvider<SessionNotifier, SessionState>(
  () {
    return SessionNotifier();
  },
);
