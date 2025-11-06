import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Copies Helper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppListPage(),
    );
  }
}

class AppListPage extends StatefulWidget {
  const AppListPage({super.key});
  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  List<Application>? _apps;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  Future<void> _fetchInstalledApps() async {
    setState(() => _loading = true);
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: false,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    setState(() {
      _apps = apps;
      _loading = false;
    });
  }

  Widget _buildAppTile(Application app) {
    return ListTile(
      title: Text(app.appName),
      subtitle: Text(app.packageName),
      trailing: IconButton(
        icon: const Icon(Icons.open_in_new),
        onPressed: () {
          DeviceApps.openApp(app.packageName);
        },
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AppCopiesPage(app: app)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة التطبيقات المثبتة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchInstalledApps,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _apps == null || _apps!.isEmpty
              ? const Center(child: Text('لا توجد تطبيقات مستخدم مثبتة.'))
              : ListView.builder(
                  itemCount: _apps!.length,
                  itemBuilder: (context, i) => _buildAppTile(_apps![i]),
                ),
    );
  }
}

class AppCopiesPage extends StatelessWidget {
  final Application app;
  const AppCopiesPage({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نسخ ${app.appName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('اختر أي من الأزرار لفتح التطبيق كـ "نسخة"'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  final copyNumber = index + 1;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('$copyNumber')),
                      title: Text('نسخة $copyNumber - ${app.appName}'),
                      subtitle: Text('اضغط لفتح التطبيق'),
                      onTap: () {
                        // هنا نفتح التطبيق مباشرةً — لا ننسخه فعليًا.
                        DeviceApps.openApp(app.packageName);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم فتح ${app.appName} (نسخة $copyNumber)')),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // مكان لتخصيص الاسم أو ملاحظة للنسخة — يمكنك توسيع الوظيفة لاحقًا.
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('تعديل اسم النسخة'),
                              content: const Text('ميزة التخصيص قيد التطوير.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
