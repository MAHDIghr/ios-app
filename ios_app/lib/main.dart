import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Initialisation obligatoire pour Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de Firebase
  await Firebase.initializeApp();
  
  runApp(PhotoUploaderApp());
}

class PhotoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Firebase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _message = "Appuyez pour tester";

  Future<void> _testConnexion() async {
    setState(() => _message = "Test en cours...");
    
    try {
      // 1. Test Firebase Storage
      final testRef = FirebaseStorage.instance.ref('test.txt');
      await testRef.putString('Hello Firebase!');
      
      // 2. Test permissions photos
      if (await Permission.photos.request().isGranted) {
        final photos = await PhotoManager.getAssetListRange(
          start: 0,
          end: 1, // On teste juste avec 1 photo
        );
        
        setState(() => _message = "✅ Tout fonctionne !\n"
            "- Firebase Storage opérationnel\n"
            "- ${photos.length} photo trouvée");
      }
    } catch (e) {
      setState(() => _message = "❌ Erreur : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Technique')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, 
                 textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testConnexion,
              child: Text('Lancer le Test', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}