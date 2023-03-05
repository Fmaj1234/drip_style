import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:drip_style/models/video.dart';

class PostController extends GetxController {
  final Rx<List<Video>> _postList = Rx<List<Video>>([]);

  List<Video> get postList => _postList.value;

  @override
  void onInit() {
    super.onInit();
    _postList.bindStream(
        FirebaseFirestore.instance.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  
}
