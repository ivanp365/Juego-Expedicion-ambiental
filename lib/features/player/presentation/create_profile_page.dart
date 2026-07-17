import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  int selectedAvatar = 0;

  final List<String> avatars = ["🦊", "🐼", "🦉", "🐸", "🐢", "🦜"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Bienvenido a Expedición Ambiental",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del explorador",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Selecciona un avatar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: List.generate(avatars.length, (index) {
                final selected = selectedAvatar == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: selected ? 38 : 34,
                    backgroundColor: selected
                        ? Colors.green
                        : Colors.grey.shade300,
                    child: Text(
                      avatars[index],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/base');
                },
                child: const Text(
                  "Comenzar aventura",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
