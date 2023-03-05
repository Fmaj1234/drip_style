import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drip_style/common/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:drip_style/common/utils/colors.dart';
import 'package:drip_style/models/user_model.dart';
import 'package:drip_style/common/providers/user_provider.dart';
import 'package:drip_style/features/home/screens/comments_screen.dart';
import 'package:drip_style/common/utils/utils.dart';
import 'package:drip_style/common/utils/colors.dart';
import 'package:drip_style/features/home/widgets/like_animation.dart';
import 'package:drip_style/features/auth/screens/signup_screen.dart';
import 'package:drip_style/features/profile/screens/general_profile_screen.dart';
import 'package:drip_style/common/widgets/follow_button.dart';
import 'package:drip_style/features/home/widgets/video_player_item.dart';
import 'package:drip_style/common/utils/global_variable.dart';
import 'package:drip_style/features/home/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:drip_style/features/home/widgets/circle_animation.dart';
import 'package:drip_style/common/widgets/transparent_button.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool isPlaying = false;

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userData['uid'].toString())
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(userData['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  checkValuePage(String postId) async {}

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;

    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              PageView.builder(
                itemCount: snapshot.data!.docs.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  final data = snapshot.data!.docs[index].data();
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        onDoubleTap: () {
                          FireStoreMethods().likePostAnimate(
                            data['postId'].toString(),
                            user.uid,
                            data['likes'],
                          );
                          setState(() {
                            isLikeAnimating = true;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 1,
                              width: double.infinity,
                              child: VideoPlayerItem(
                                videoUrl: data['postUrl'].toString(),
                                isPlayingState: isPlaying,
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isLikeAnimating ? 1 : 0,
                              child: LikeAnimation(
                                isAnimating: isLikeAnimating,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 100,
                                ),
                                duration: const Duration(
                                  milliseconds: 400,
                                ),
                                onEnd: () {
                                  setState(() {
                                    isLikeAnimating = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ElevatedButton(
                                        //     child: Text("check value",
                                        //         style: TextStyle(fontSize: 8)),
                                        //     style: ButtonStyle(
                                        //         foregroundColor:
                                        //             MaterialStateProperty.all<Color>(
                                        //                 Colors.white),
                                        //         backgroundColor:
                                        //             MaterialStateProperty.all<Color>(
                                        //                 Colors.grey),
                                        //         shape: MaterialStateProperty.all<
                                        //                 RoundedRectangleBorder>(
                                        //             RoundedRectangleBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(6.0),
                                        //                 side: BorderSide(
                                        //                     color: Colors.red)))),
                                        //     onPressed: () => null),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    GeneralProfileScreen(
                                                  uid: data['uid'].toString(),
                                                ),
                                              )),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: NetworkImage(
                                                  data['profImage'].toString(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    GeneralProfileScreen(
                                                  uid: data['uid'].toString(),
                                                ),
                                              )),
                                              child: Text(
                                                data['username'].toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            // TextButton(
                                            //     child: Text("follow",
                                            //         style: TextStyle(fontSize: 12)),
                                            //     style: ButtonStyle(
                                            //         tapTargetSize:
                                            //             MaterialTapTargetSize.shrinkWrap,
                                            //         padding:
                                            //             MaterialStateProperty.all<EdgeInsets>(
                                            //                 const EdgeInsets.all(-3)),
                                            //         foregroundColor:
                                            //             MaterialStateProperty.all<Color>(
                                            //                 Colors.white),
                                            //         shape: MaterialStateProperty.all<
                                            //                 RoundedRectangleBorder>(
                                            //             RoundedRectangleBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(6.0),
                                            //                 side:
                                            //                     BorderSide(color: Colors.white)))),
                                            //     onPressed: () => null),

                                            isFollowing
                                                ? TextButton(
                                                    onPressed: () async {
                                                      await FireStoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                      );

                                                      setState(() {
                                                        isFollowing = true;
                                                        followers++;
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize:
                                                            Size(90, 30),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                        side: const BorderSide(
                                                            width: 0.5,
                                                            color:
                                                                Colors.white),
                                                        alignment:
                                                            Alignment.center),
                                                    child: const Text("follow",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        )),
                                                  )
                                                : TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ))),

                                            // ElevatedButton(
                                            //     child: Text("follow".toUpperCase(),
                                            //         style: TextStyle(fontSize: 12)),
                                            //     style: ButtonStyle(
                                            //         foregroundColor:
                                            //             MaterialStateProperty.all<Color>(
                                            //                 Colors.white),
                                            //         backgroundColor:
                                            //             MaterialStateProperty.all<Color>(
                                            //                 Colors.red),
                                            //         shape: MaterialStateProperty.all<
                                            //                 RoundedRectangleBorder>(
                                            //             RoundedRectangleBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(
                                            //                         6.0),
                                            //                 side: BorderSide(color: Colors.red)))),
                                            //     onPressed: () => null),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          data['description'].toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Row(
                                        //   children: [
                                        //     const Icon(
                                        //       Icons.music_note,
                                        //       size: 12,
                                        //       color: Colors.white,
                                        //     ),
                                        //     Text(
                                        //       widget.snap['songName'].toString(),
                                        //       style: const TextStyle(
                                        //         fontSize: 12,
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.w200,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        const SizedBox(height: 2),
                                        TransparentButton(
                                          text: 'Check Value',
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.5),
                                          textColor: Colors.white,
                                          function: () async {
                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SignupScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50.0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // buildProfile(
                                      //   widget.snap['profImage'].toString(),
                                      // ),
                                      Column(
                                        children: [
                                          LikeAnimation(
                                            isAnimating: data['likes']
                                                .contains(user.uid),
                                            smallLike: true,
                                            child: IconButton(
                                              icon: data['likes']
                                                      .contains(user.uid)
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      size: 30,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.favorite,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                              onPressed: () =>
                                                  FireStoreMethods().likePost(
                                                data['postId'].toString(),
                                                user.uid,
                                                data['likes'],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data['likes'].length.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentsScreen(
                                                  postId:
                                                      data['postId'].toString(),
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.chat_bubble_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data['commentCount'].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.reply_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data['shareCount'].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.more_horiz,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      CircleAnimation(
                                        child: buildMusicAlbum(
                                          data['thumbnail'].toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  );

                  // return PostCard(
                  //   snap: snapshot.data!.docs[index].data(),
                  // );
                },
              ),
              SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_rounded,
                          color: primaryColor,
                        ),
                        onPressed: () {},
                      ),
                      const Text(
                        "Drip Vibes",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.group_rounded,
                          color: primaryColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
