// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:logger/logger.dart';
//
// class GoogleSignInHelper {
//   static final GoogleSignInHelper _instance = GoogleSignInHelper._internal();
//   factory GoogleSignInHelper() => _instance;
//   GoogleSignInHelper._internal();
//
//   final Logger _logger = Logger();
//
//   late final GoogleSignIn _googleSignIn;
//
//   void initialize({String? clientId}) {
//     _googleSignIn = GoogleSignIn(
//       scopes: [
//         'email',
//         'profile',
//       ],
//       // Optional: Add for web support
//       clientId: clientId,
//     );
//   }
//
//   /// Sign in with Google
//   Future<GoogleSignInAccount?> signIn() async {
//     try {
//       final GoogleSignInAccount? account = await _googleSignIn.signIn();
//
//       if (account != null) {
//         _logger.i('Google Sign-In successful: ${account.email}');
//         return account;
//       } else {
//         _logger.w('Google Sign-In cancelled by user');
//         return null;
//       }
//     } catch (error) {
//       _logger.e('Error during Google Sign-In: $error');
//       return null;
//     }
//   }
//
//   /// Get ID Token for backend authentication
//   Future<String?> getIdToken() async {
//     try {
//       final GoogleSignInAccount? account = _googleSignIn.currentUser;
//       if (account == null) {
//         _logger.w('No current Google user');
//         return null;
//       }
//
//       final GoogleSignInAuthentication auth = await account.authentication;
//       return auth.idToken;
//     } catch (error) {
//       _logger.e('Error getting ID token: $error');
//       return null;
//     }
//   }
//
//   /// Sign out
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       _logger.i('Google Sign-Out successful');
//     } catch (error) {
//       _logger.e('Error during Google Sign-Out: $error');
//     }
//   }
//
//   /// Disconnect (revoke access)
//   Future<void> disconnect() async {
//     try {
//       await _googleSignIn.disconnect();
//       _logger.i('Google account disconnected');
//     } catch (error) {
//       _logger.e('Error disconnecting Google account: $error');
//     }
//   }
//
//   /// Check if user is currently signed in
//   bool get isSignedIn => _googleSignIn.currentUser != null;
//
//   /// Get current user
//   GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
// }