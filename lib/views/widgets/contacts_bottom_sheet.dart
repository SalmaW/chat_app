import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactListBottomSheet extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onContactSelected;

  const ContactListBottomSheet({
    super.key,
    required this.contacts,
    required this.onContactSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              contact.displayName,
            ),
            subtitle: contact.phones.isNotEmpty
                ? Text(contact.phones.first.number)
                : const Text("No phone number available"),
            onTap: () {
              Navigator.pop(context);
              onContactSelected(contact);
            },
          );
        },
      ),
    );
  }
}
