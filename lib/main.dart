import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('DropZone', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      ),
      backgroundColor: Color(0xFFE6E6FA), // لون أرجواني فاتح مشابه للخلفية
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onScaleStart: (details) {
                _baseScale = _scale;
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = _baseScale * details.scale.clamp(0.8, 2.0);
                });
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildWindow('Login', Icons.person, [
                      TextField(decoration: InputDecoration(labelText: 'Username')),
                      TextField(decoration: InputDecoration(labelText: 'Password')),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {}, child: Text('Login')),
                    ]),
                    _buildWindow('Sign Up', Icons.person_add, [
                      TextField(decoration: InputDecoration(labelText: 'Email')),
                      TextField(decoration: InputDecoration(labelText: 'Password')),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
                    ]),
                    _buildWindow('Map', Icons.map, [
                      Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text('Map View')),
                      ),
                    ]),
                    _buildWindow('Choose Food', Icons.fastfood, [
                      Text('Choose your food', style: TextStyle(fontSize: 18)),
                      Image.asset('assets/food_icon.png', height: 50), // أضف صورة إذا كانت متوفرة
                      ElevatedButton(onPressed: () {}, child: Text('Get Started')),
                    ]),
                    _buildWindow('List 1', Icons.list, [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) => ListTile(
                          leading: Icon(Icons.restaurant),
                          title: Text('Restaurant ${index + 1}'),
                          subtitle: Text('4.5 ★'),
                        ),
                      ),
                    ]),
                    _buildWindow('List 2', Icons.list, [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) => ListTile(
                          leading: Icon(Icons.restaurant),
                          title: Text('Restaurant ${index + 4}'),
                          subtitle: Text('4.5 ★'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Sign up', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Log In', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindow(String title, IconData icon, List<Widget> content) {
    return Transform.scale(
      scale: _scale,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Container(
            width: 200,
            height: 300,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.purple),
                SizedBox(height: 10),
                Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ...content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
