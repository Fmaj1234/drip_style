import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:drip_style/features/post/screens/add_post_screen.dart';
import 'package:drip_style/features/home/screens/feed_screen.dart';
import 'package:drip_style/features/profile/screens/profile_screen.dart';
import 'package:drip_style/features/discover/screens/search_screen.dart';
import 'package:drip_style/features/notification/screens/notification_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

List pages = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
