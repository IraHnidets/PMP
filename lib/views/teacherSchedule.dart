import 'package:flutter/material.dart';

class Teacherschedule extends StatelessWidget {
  const Teacherschedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Розклад занять для викладачів',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(4.0, 4.0),
                      blurRadius: 10.0,
                      color: Color(0x80526FAA),
                    )
                  ],
                ),
              ),
            ),
            const Center(
              child: Text(
                'Для перегляду результатів введіть у поле "Розклад" значення ПІБ повністю',
                textAlign: TextAlign.center, // Додано TextAlign.center
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),


            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF526FAA)),
                hintText: 'Розклад...',
                filled: true,
                fillColor: Color(0xFFD1E7FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}