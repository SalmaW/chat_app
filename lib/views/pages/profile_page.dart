import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  final TextEditingController _currentUserPass = TextEditingController();
  bool isDeleting = false; // To track deletion process

  void deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // User can't dismiss dialog by tapping outside
      builder: (context) => AlertDialog(
        title: const Text("Enter Password to Delete Account"),
        content: TextField(
          controller: _currentUserPass,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
          autofocus: true,
          onSubmitted: (password) => deleteConfirmed(context, password),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => deleteConfirmed(context, _currentUserPass.text),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteConfirmed(BuildContext context, String password) async {
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your password")),
      );
      return;
    }

    setState(() {
      isDeleting = true; // Show loading spinner
    });

    try {
      await authService.deleteCurrentUser(widget.user.email!, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully.")),
      );
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pop(); // Navigate away after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      setState(() {
        isDeleting = false; // Reset loading state if there's an error
      });
      Navigator.of(context).pop(); // Close dialog on error
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 12),
                Text("${widget.user.email}"),
              ],
            ),
            const SizedBox(height: 25),
            isDeleting
                ? const CircularProgressIndicator() // Show loading indicator during deletion
                : ElevatedButton(
                    onPressed: () => deleteAccount(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
