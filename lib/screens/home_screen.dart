import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _fallbackName = "User";

  // Remembers the registered name for the lifetime of the app (in memory),
  // so it's still available on Home even after logging out and back in,
  // when Login navigates here without passing a name.
  static String? _savedName;

  String? _userName;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _userName = _resolveInitialUserName(context);
      _initialized = true;
    }
  }

  String _resolveInitialUserName(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String? argName;
    if (args is String && args.trim().isNotEmpty) {
      argName = args;
    } else if (args is Map &&
        args['name'] is String &&
        (args['name'] as String).trim().isNotEmpty) {
      argName = args['name'] as String;
    }

    if (argName != null) {
      _savedName = argName;
      return argName;
    }

    // No arguments this time (e.g. arrived here after logging back in) —
    // fall back to whatever name was registered earlier.
    if (_savedName != null && _savedName!.trim().isNotEmpty) {
      return _savedName!;
    }

    return _fallbackName;
  }

  String _initials(String userName) {
    final parts = userName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return "";
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Future<void> _openEditProfile() async {
    final currentName = _userName ?? _fallbackName;
    final nameParts = currentName.trim().split(RegExp(r'\s+'));
    final currentFirstName = nameParts.isNotEmpty ? nameParts.first : "";
    final currentLastName = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    final updatedName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EditProfileSheet(
        initialFirstName: currentFirstName,
        initialLastName: currentLastName,
      ),
    );

    if (updatedName != null && updatedName.trim().isNotEmpty) {
      final trimmedName = updatedName.trim();
      _savedName = trimmedName;
      setState(() => _userName = trimmedName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userName = _userName ?? _fallbackName;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildWelcomeHeader(userName, textTheme),
              const SizedBox(height: 32),
              Text("Quick Actions", style: textTheme.titleMedium),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 28),
              Text("Recent Activity", style: textTheme.titleMedium),
              const SizedBox(height: 12),
              _buildActivityItem(
                context,
                icon: Icons.person_outline,
                title: "Profile updated",
                subtitle: "2 hours ago",
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                context,
                icon: Icons.settings_outlined,
                title: "Settings saved",
                subtitle: "Yesterday",
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                context,
                icon: Icons.show_chart,
                title: "New activity synced",
                subtitle: "3 days ago",
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
                child: const Text("Logout"),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String userName, TextTheme textTheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.surface,
          child: Text(
            _initials(userName),
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome,", style: textTheme.bodyMedium),
            Text(userName, style: textTheme.headlineMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.person_outline,
            label: "Profile",
            onTap: _openEditProfile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.settings_outlined,
            label: "Settings",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(icon: Icons.show_chart, label: "Activity"),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.surface,
              child: Icon(icon, color: AppTheme.textDark, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.surface,
                child: Icon(icon, color: AppTheme.textDark, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet used to edit the user's first and last name.
/// Pops with the combined full name (String) when saved, or null when
/// dismissed without saving.
class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.initialFirstName,
    required this.initialLastName,
  });

  final String initialFirstName;
  final String initialLastName;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    final fullName =
        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}"
            .trim();
    Navigator.of(context).pop(fullName);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("Edit Profile", style: textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text("First Name", style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? "Required" : null,
              decoration: const InputDecoration(hintText: "First name"),
            ),
            const SizedBox(height: 16),
            Text("Last Name", style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? "Required" : null,
              decoration: const InputDecoration(hintText: "Last name"),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _handleSave, child: const Text("Save")),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
