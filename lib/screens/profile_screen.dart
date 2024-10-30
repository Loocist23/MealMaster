import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  User? user;
  bool isEditing = false;
  String name = '';
  String email = '';
  String username = '';
  bool verified = false;
  File? avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    user = await apiService.fetchUserProfile();
    setState(() {
      if (user != null) {
        name = user!.name;
        email = user!.email;
        username = user!.username;
        verified = user!.verified;
      }
    });
  }

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        avatarFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (user != null) {
      try {
        await apiService.updateUserProfile(
          userId: user!.id,
          name: name,
          avatarPath: avatarFile?.path,
        );
        setState(() {
          isEditing = false;
        });
        _fetchUserProfile(); // Rafraîchit les données du profil après la mise à jour
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour du profil : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: isEditing ? _pickAvatar : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarFile != null
                      ? FileImage(avatarFile!)
                      : user!.avatar != null
                      ? NetworkImage(user!.avatar!) as ImageProvider
                      : null,
                  child: avatarFile == null && user!.avatar == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              enabled: isEditing,
              controller: TextEditingController(text: name),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
              controller: TextEditingController(text: email),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              enabled: isEditing,
              controller: TextEditingController(text: username),
              onChanged: (value) => username = value,
            ),
            const SizedBox(height: 20),
            Text(
              'Account Created: ${user!.created}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Last Updated: ${user!.updated}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
