import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const KHITNoticeApp());
}

class KHITNoticeApp extends StatelessWidget {
  const KHITNoticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KHIT Notice Board',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

// =====================================================
// LOGIN PAGE
// =====================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(isAdmin: true)),
      );
    } else if (username == 'student' && password == 'student123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(isAdmin: false)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.school, size: 50, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'KHIT Notice Board',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Login to continue',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: login,
                      icon: const Icon(Icons.login),
                      label: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 10),

                  const Text(
                    'Demo Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Admin: admin / admin123',
                    style: TextStyle(color: Colors.indigo),
                  ),

                  const Text(
                    'Student: student / student123',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  final bool isAdmin;

  const HomePage({super.key, required this.isAdmin});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Exams',
    'Events',
    'Placements',
    'General',
  ];

  List<Map<String, dynamic>> notices = [
    {
      'title': 'Mid Semester Examination',
      'category': 'Exams',
      'date': '2026-11-01',
      'description':
          'Mid semester examinations will begin soon. Students should prepare according to the timetable.',
    },
    {
      'title': 'Technical Fest 2026',
      'category': 'Events',
      'date': '2026-11-02',
      'description':
          'Our college is organizing a technical fest. Interested students can register.',
    },
    {
      'title': 'Campus Placement Drive',
      'category': 'Placements',
      'date': '2026-11-03',
      'description':
          'A campus placement drive will be conducted. Eligible students should register.',
    },
    {
      'title': 'College Holiday Announcement',
      'category': 'General',
      'date': '2026-11-04',
      'description':
          'Please check the official college announcement for holiday information.',
    },
    {
      'title': 'Internal Examination Timetable',
      'category': 'Exams',
      'date': '2026-11-05',
      'description':
          'The internal examination timetable will be announced by the examination department.',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadNotices();
  }

  Future<void> loadNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotices = prefs.getString('notices');

    if (savedNotices != null) {
      final List<dynamic> decoded = jsonDecode(savedNotices);

      if (!mounted) return;

      setState(() {
        notices = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });
    } else {
      await saveNotices();
    }
  }

  Future<void> saveNotices() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('notices', jsonEncode(notices));
  }

  List<Map<String, dynamic>> get filteredNotices {
    return notices.where((notice) {
      final matchesCategory =
          selectedCategory == 'All' || notice['category'] == selectedCategory;

      final matchesSearch =
          notice['title'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          notice['category'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          );

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Color categoryColor(String category) {
    switch (category) {
      case 'Exams':
        return Colors.orange;
      case 'Events':
        return Colors.purple;
      case 'Placements':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Exams':
        return Icons.menu_book;
      case 'Events':
        return Icons.event;
      case 'Placements':
        return Icons.work;
      default:
        return Icons.campaign;
    }
  }

  Future<void> openAddNoticePage() async {
    final newNotice = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddNoticePage()),
    );

    if (newNotice != null) {
      setState(() {
        notices.insert(0, newNotice);
        selectedCategory = 'All';
        searchQuery = '';
      });

      await saveNotices();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice added successfully!')),
      );
    }
  }

  Future<void> openEditNoticePage(int index) async {
    final updatedNotice = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoticePage(
          existingNotice: Map<String, dynamic>.from(notices[index]),
        ),
      ),
    );

    if (updatedNotice != null) {
      setState(() {
        notices[index] = updatedNotice;
      });

      await saveNotices();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice updated successfully!')),
      );
    }
  }

  Future<void> deleteNotice(int index) async {
    final noticeTitle = notices[index]['title'];

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Notice?'),
          content: Text('Are you sure you want to delete "$noticeTitle"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        notices.removeAt(index);
      });

      await saveNotices();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice deleted successfully!')),
      );
    }
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void openDetailsPage(Map<String, dynamic> notice, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoticeDetailsPage(
          notice: notice,
          isAdmin: widget.isAdmin,
          onEdit: () {
            Navigator.pop(context);
            openEditNoticePage(index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'KHIT Notice Board',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isAdmin
                      ? 'Welcome Admin! 👨‍💼'
                      : 'Welcome Student! 👨‍🎓',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stay updated with the latest college announcements.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notices...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: selectedCategory == category
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredNotices.isEmpty
                ? const Center(
                    child: Text(
                      'No notices found!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredNotices.length,
                    itemBuilder: (context, index) {
                      final notice = filteredNotices[index];

                      final originalIndex = notices.indexOf(notice);

                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),

                          leading: CircleAvatar(
                            backgroundColor: categoryColor(
                              notice['category'],
                            ).withOpacity(0.15),
                            child: Icon(
                              categoryIcon(notice['category']),
                              color: categoryColor(notice['category']),
                            ),
                          ),

                          title: Text(
                            notice['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${notice['category']} • ${notice['date']}',
                            ),
                          ),

                          trailing: widget.isAdmin
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        openEditNoticePage(originalIndex);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        deleteNotice(originalIndex);
                                      },
                                    ),
                                  ],
                                )
                              : const Icon(Icons.arrow_forward_ios, size: 18),

                          onTap: () {
                            openDetailsPage(notice, originalIndex);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: openAddNoticePage,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add Notice'),
            )
          : null,
    );
  }
}

// =====================================================
// ADD / EDIT NOTICE PAGE
// =====================================================

class AddNoticePage extends StatefulWidget {
  final Map<String, dynamic>? existingNotice;

  const AddNoticePage({super.key, this.existingNotice});

  @override
  State<AddNoticePage> createState() => _AddNoticePageState();
}

class _AddNoticePageState extends State<AddNoticePage> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final dateController = TextEditingController();

  String selectedCategory = 'General';

  final List<String> categories = ['Exams', 'Events', 'Placements', 'General'];

  bool get isEditing => widget.existingNotice != null;

  @override
  void initState() {
    super.initState();

    if (widget.existingNotice != null) {
      titleController.text = widget.existingNotice!['title'] ?? '';

      descriptionController.text = widget.existingNotice!['description'] ?? '';

      dateController.text = widget.existingNotice!['date'] ?? '';

      selectedCategory = widget.existingNotice!['category'] ?? 'General';
    } else {
      dateController.text = DateTime.now().toString().split(' ')[0];
    }
  }

  Future<void> selectDate() async {
    DateTime initialDate = DateTime.now();

    if (dateController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(dateController.text);
      } catch (_) {}
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void saveNotice() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final notice = {
      'title': titleController.text.trim(),
      'category': selectedCategory,
      'date': dateController.text.trim(),
      'description': descriptionController.text.trim(),
    };

    Navigator.pop(context, notice);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Notice' : 'Add Notice'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Notice Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter notice title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: dateController,
              readOnly: true,

              decoration: InputDecoration(
                hintText: 'Select date',

                prefixIcon: const Icon(Icons.calendar_today),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: selectDate,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onTap: selectDate,
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,

              maxLines: 6,

              decoration: InputDecoration(
                hintText: 'Enter notice description',

                alignLabelWithHint: true,

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 90),
                  child: Icon(Icons.description),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: saveNotice,

                icon: Icon(isEditing ? Icons.save : Icons.add),

                label: Text(
                  isEditing ? 'UPDATE NOTICE' : 'ADD NOTICE',

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// NOTICE DETAILS PAGE
// =====================================================

class NoticeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> notice;
  final bool isAdmin;
  final VoidCallback? onEdit;

  const NoticeDetailsPage({
    super.key,
    required this.notice,
    required this.isAdmin,
    this.onEdit,
  });

  Color categoryColor(String category) {
    switch (category) {
      case 'Exams':
        return Colors.orange;

      case 'Events':
        return Colors.purple;

      case 'Placements':
        return Colors.green;

      default:
        return Colors.blue;
    }
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Exams':
        return Icons.menu_book;

      case 'Events':
        return Icons.event;

      case 'Placements':
        return Icons.work;

      default:
        return Icons.campaign;
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = notice['category'].toString();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Notice Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        backgroundColor: Colors.indigo,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          elevation: 5,
          color: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(22),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // CATEGORY ICON
                Center(
                  child: CircleAvatar(
                    radius: 40,

                    backgroundColor: categoryColor(category).withOpacity(0.15),

                    child: Icon(
                      categoryIcon(category),
                      size: 45,
                      color: categoryColor(category),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE
                Center(
                  child: Text(
                    notice['title'].toString(),

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(),

                const SizedBox(height: 15),

                // CATEGORY
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.indigo),

                    const SizedBox(width: 10),

                    const Text(
                      'Category:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Chip(
                      label: Text(category),

                      backgroundColor: categoryColor(
                        category,
                      ).withOpacity(0.15),

                      labelStyle: TextStyle(
                        color: categoryColor(category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // DATE
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.indigo),

                    const SizedBox(width: 10),

                    const Text(
                      'Date:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      notice['date'].toString(),

                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // DESCRIPTION
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,

                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Text(
                    notice['description'].toString(),

                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ),

                const SizedBox(height: 30),

                // ADMIN EDIT BUTTON
                if (isAdmin && onEdit != null)
                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: onEdit,

                      icon: const Icon(Icons.edit),

                      label: const Text(
                        'EDIT NOTICE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
