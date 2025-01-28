import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/pages/chat_page.dart';
import 'package:messenger_app/services/auth/auth_service.dart';
import 'package:messenger_app/theme_notifier.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  void switchTheme(BuildContext context) {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          // style: TextStyle(color: Colors.brown.shade800),
        ),
        // backgroundColor: Colors.amber.shade200,
        actions: [
          IconButton(onPressed: () => switchTheme(context), icon: const Icon(Icons.nightlight_round)),
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase(); // Update search query
                });
              },
              decoration: InputDecoration(
                hintText: "Search for users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("An error occurred!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Filter users based on search query
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data()! as Map<String, dynamic>;
          final email = data['email'] as String;
          return email.toLowerCase().contains(_searchQuery);
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text("No users found."));
        }

        return ListView(
          children: filteredDocs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // -- USERS LIST AS CARDS --
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Card(
          elevation: 4, // Shadow for the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(
              data['email'],
              style: const TextStyle(
                // color: Colors.brown.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: const Text(
              "Tap to chat",
              style: TextStyle(
                // color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              Icons.chat_bubble_outline,
              // color: Colors.brown.shade800,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    recieverUserEmail: data['email'],
                    recieverUserID: data['uid'],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
