import 'package:firebase_auth/firebase_auth.dart';

class MyPageViewModel {
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  String getNickname() {
    return FirebaseAuth.instance.currentUser?.displayName ?? '이름 없음';
  }

  String getProfileImageUrl() {
    return FirebaseAuth.instance.currentUser?.photoURL ??
        'https://cdn.pixabay.com/photo/2023/06/03/17/11/giraffe-8038107_1280.jpg';
  }

  String getUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
