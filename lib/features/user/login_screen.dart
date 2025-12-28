import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppTheme _appTheme = AppTheme();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  String _selectedUserType = 'Captain'; // 'Rider' or 'Captain'
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _appTheme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _appTheme.removeListener(_onThemeChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  void _handleLogin() {
    // Navigate to home screen when Login button is clicked
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: _appTheme.textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), // Dark background
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// APP HEADER
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bolt,
                        color: _appTheme.brandRed,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.appName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Fast & Safe Rides",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                /// WELCOME SECTION
                Center(
                  child: Column(
                    children: [
                      // Red abstract icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _appTheme.brandRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.bar_chart,
                          color: _appTheme.brandRed,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to book your next ride",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// USER TYPE SELECTION
                Row(
                  children: [
                    Expanded(
                      child: _userTypeCard(
                        icon: Icons.person_outline,
                        title: "Rider",
                        subtitle: "Book a ride",
                        isSelected: _selectedUserType == 'Rider',
                        onTap: () {
                          setState(() {
                            _selectedUserType = 'Rider';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _userTypeCard(
                        icon: Icons.directions_car,
                        title: "Captain",
                        subtitle: "Start earning",
                        isSelected: _selectedUserType == 'Captain',
                        onTap: () {
                          setState(() {
                            _selectedUserType = 'Captain';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// EMAIL INPUT
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _emailFocusNode.hasFocus
                          ? _appTheme.brandRed
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email address",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// PASSWORD INPUT
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _passwordFocusNode.hasFocus
                          ? _appTheme.brandRed
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade400,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 14,
                        color: _appTheme.brandRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _appTheme.brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login as $_selectedUserType",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// DIVIDER WITH TEXT
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade700,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "or continue with",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade700,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// SOCIAL LOGIN BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("G", () {}), // Google
                    const SizedBox(width: 16),
                    _socialButton("A", () {}), // Apple
                    const SizedBox(width: 16),
                    _socialButton("F", () {}), // Facebook
                  ],
                ),

                const SizedBox(height: 32),

                /// SIGN UP PROMPT
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle sign up
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Sign up free",
                          style: TextStyle(
                            fontSize: 14,
                            color: _appTheme.brandRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? _appTheme.brandRed
                : Colors.grey.shade800,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _appTheme.brandRed.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? _appTheme.brandRed : Colors.white,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
