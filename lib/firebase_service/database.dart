import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{

  Future<Stream<QuerySnapshot>> getUserDetails() async
  {
    return FirebaseFirestore.instance.collection("Users").where("role", isEqualTo: "Patient").snapshots();
  }

  Future<Stream<QuerySnapshot>> getDoctorDetails() async{
    return FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: "Doctor")
        .snapshots();
  }

  String? getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? uid;

    if (user != null) {
      uid = user.uid;
      print("Current user UID: $uid");
    } else {
      print("No user is currently signed in.");
    }
    return uid;
  }

  Future<String?> getDoctorProfilePic() async
  {
    String? uid = getCurrentUserUid();
    if(uid!=null)
      {
        DocumentSnapshot userSnapShot = await FirebaseFirestore.instance.collection("Users").doc(uid).get();
        return userSnapShot['image'];
      }


  }



  Future<String?> getUserRole() async{
    String? uid =  getCurrentUserUid();
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).get();

      if (userSnapshot.exists) {
        String? role = userSnapshot['role'];
        return role;
      }
    }
    return null; // User not found or role not defined
  }

  Future<bool> isUserPatient(User currentUser) async
  {
    String? UserRole = await getUserRole();

    if(UserRole=="Patient")
      {
        print("patient");
        return true;
      }
    else
      {
        print("doctor");
        return false;
      }
  }

}