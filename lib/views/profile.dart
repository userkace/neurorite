import 'package:flutter/material.dart';
import 'package:neurorite/models/firestore.dart';
import 'package:neurorite/views/options.dart';
import 'package:neurorite/theme/app_theme.dart';

class ProfileItem {
  final String assetLink;
  final int number;

  ProfileItem({required this.assetLink, required this.number});
}

class Profile extends StatelessWidget {
  final List<ProfileItem> profileItems;

  const Profile({
    super.key,
    required this.profileItems,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: profileItems.length,
      itemBuilder: (context, index) {
        final profileItem = profileItems[index];
        return InkWell(
          splashColor: AppTheme.primary, // Change splash color to red
          borderRadius: BorderRadius.circular(16.0), // Make splash rounded with a 10.0 radius
          onTap: () async => {
            // Firestore document ID is the user's UID
            await firestoreService.updateProfile(
              profileItem.number,
            ),
            Navigator.pop(context),
            Navigator.pop(context),
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Options(),
            ))
          },
          child: Stack(
            // Use Stack to overlay number on image
            children: [
              Image.asset(
                profileItem.assetLink,
                fit: BoxFit.cover,
              ),
            ],
          ),
        );
      },
    );
  }
}
