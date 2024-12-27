import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:cypheron/models/UserModel.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';

class FireBaseService {

  static final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -------------------------- User Operations --------------------------

  // Google Sign-In
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Case when the user cancels the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if(user != null) {
        await createUser(user);
      }

      return user;
    } catch (e) {
      // Catch and log any errors during the process
      print("Error during Google Sign-In: $e");
      return null;
    }
  }


  /// Firebase sign-up process using email and password
  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if(user != null) {
        await createUser(user);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions here if needed
      throw e; // Re-throw the exception to handle it in the calling function
    } catch (e) {
      // Handle any other exceptions here
      throw Exception("An unexpected error occurred: $e");
    }
  }

  /// create document for the user 
  static Future<void> createUser(User user) async {

    try {
      // Check if the user's document already exists
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Document does not exist, save user details
        await _firestore.collection('users').doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "contactIds": [],
          "signUpDate": DateTime.now().toIso8601String(),
          "analyticsData": {
            "totalTimeSpent": 0,
            "lastActive": null,
            "sessions": []
          },
        });
      }
    } catch (e) {
      print("Error checking or saving user document: $e");
    }
  }

  /// Firebase sign-in process using email and password
  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      throw e; // Re-throw to handle it in the calling function
    } catch (e) {
      // Handle other exceptions
      throw Exception("An unexpected error occurred: $e");
    }
  }


  // -------------------------- Contact Operations --------------------------

  // Save a contact to Firebase with messages as a subcollection
  static Future<bool> saveContactToFirebase(String userId, ContactModel contact) async {
    try {
      // Step 1: Add the contact ID to the user's contactIds array
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'contactIds': FieldValue.arrayUnion([contact.id]),
      });

      // Step 2: Create or update the contact document
      final contactRef = userRef.collection('contacts').doc(contact.id);
      await contactRef.set({
        'id': contact.id,
        'name': contact.name,
        'phoneNumber': contact.phoneNumber,
      });

      // // Step 3: Save messages as a subcollection under the contact document
      // final messagesRef = contactRef.collection('messages');
      // for (var message in contact.messages) {
      //   await messagesRef.doc().set({
      //     'title': message.title,
      //     'body': message.body,
      //     'timestamp': message.timestamp.toIso8601String(),
      //   });
      // }

      return true; // Success
    } catch (e) {
      print("Error saving contact to Firebase: $e");
      return false; // Failure
    }
  }

  // Delete a contact from Firebase with messages as a subcollection
  static Future<bool> deleteContactFromFirebase(String userId, ContactModel contact) async {
    try {
      // Reference to the user's document
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Reference to the contact document
      final contactRef = userRef.collection('contacts').doc(contact.id);

      // Step 1: Delete the contact document
      await contactRef.delete();

      // Step 2: Remove the contact ID from the contactIds array
      await userRef.update({
        'contactIds': FieldValue.arrayRemove([contact.id]),
      });

      return true; // Deletion successful
    } catch (e) {
      print("Error deleting contact from Firebase: $e");
      return false; // Deletion failed
    }
  }


  // -------------------------- Message Operations --------------------------

  /// Adds a message to Firestore for a specific contact
  static Future<bool> addMessageToFirebase(String userId, String contactId, MessageModel message) async {
    try {
      // Reference to the messages subcollection under the contact
      final messageRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contactId)
          .collection('messages')
          .doc(message.id); // Generate a unique ID for the message

      // Save the message document
      await messageRef.set({
        'id': message.id,
        'title': message.title,
        'body': message.body,
        'timestamp': message.timestamp.toIso8601String(),
      });

      return true; // Success
    } catch (e) {
      print("Error saving message to Firebase: $e");
      return false; // Failure
    }
  }

  /// Deletes a message from Firestore for a specific contact
  static Future<bool> deleteMessageFromFirebase(String userId, String contactId, String messageId) async {
    try {
      // Reference to the specific message document
      final messageRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contactId)
          .collection('messages')
          .doc(messageId);

      await messageRef.delete(); // Delete the message document
      return true; // Deletion successful
    } catch (e) {
      print("Error deleting message from Firebase: $e");
      return false; // Deletion failed
    }
  }

}
