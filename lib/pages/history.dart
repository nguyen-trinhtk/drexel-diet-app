import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code/themes/constants.dart';
import 'package:code/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/themes/widgets.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = Provider.of<UserProvider>(context).userId;

    if (uid == null) {
      return const Center(child: Text("Error: User not logged in."));
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('mealHistory')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: CustomText(content:"No meal history found :(", header:true, fontSize: 30));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            final rawList = data['entries'] ?? data['mealHistory'];

            if (rawList == null || rawList is! List) {
              return const Center(child: CustomText(content:"No meal history found :(", header:true, fontSize: 30));
            }

            if (rawList.isEmpty) {
              return const Center(child: CustomText(content:"No meal has been logged yet :'(", header:true, fontSize: 30));
            }

            final List<Map<String, dynamic>> entries = List<Map<String, dynamic>>.from(rawList);
            final sortedEntries = entries.reversed.toList();

            return ListView(
              children: sortedEntries.map((entry) {
                return ThemedHistoryCard(
                  date: entry['date'] ?? '',
                  time: entry['time'] ?? '',
                  meal: entry['name'] ?? '',
                  calories: entry['totalCalories'] ?? 0,
                  foodList: (entry['dishes'] as Map<String, dynamic>?)?.keys.toList() ?? [],
                  protein: entry['totalProtein'] ?? 0,
                  carbs: entry['totalCarbs'] ?? 0,
                  fat: entry['totalFat'] ?? 0,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
