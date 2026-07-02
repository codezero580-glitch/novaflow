import 'package:flutter/material.dart';
import 'package:project_novaflow/data/auth/login_helper.dart';
import 'package:project_novaflow/data/auth/auth_provider.dart';
import 'package:project_novaflow/features/tasks/add_task_category.dart';
import 'package:project_novaflow/routes/bottom_nav.dart';
import 'package:project_novaflow/state/task_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLogin = true; //

  // controllers
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _konfirmasiPassword = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _konfirmasiPassword.dispose();

    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'assets/images/logo_hitam.png'
                                : 'assets/images/logo_putih.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _username,
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        decoration: _inputDecoration("Username", Icons.person),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _password,
                        focusNode: _passwordFocus,
                        textInputAction: isLogin
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onSubmitted: (_) {
                          if (isLogin) {
                            _passwordFocus.unfocus();
                          } else {
                            FocusScope.of(
                              context,
                            ).requestFocus(_confirmPasswordFocus);
                          }
                        },
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration("Password", Icons.lock)
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                      ),

                      if (!isLogin) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: _konfirmasiPassword,
                          focusNode: _confirmPasswordFocus,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            _confirmPasswordFocus.unfocus();
                          },
                          obscureText: _obscureConfirmPassword,

                          decoration:
                              _inputDecoration(
                                "Confirm Password",
                                Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          LoginHelper db = LoginHelper();
                          if (isLogin) {
                            // logika untuk login
                            LoginStatus loginStatus = await db.checkLogin(
                              _username.text,
                              _password.text,
                            );
                            if (loginStatus == LoginStatus.success) {
                              final auth = context.read<AuthProvider>();
                              final taskProvider = context.read<TaskProvider>();

                              final username = _username.text.trim();

                              auth.login(username);

                              try {
                                await taskProvider.loadCategories();

                                if (taskProvider.categories.isEmpty) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddTaskCategory(
                                        isFirstSetup: true,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BottomNav(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error while checking categories: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            } else {
                              String message;

                              switch (loginStatus) {
                                case LoginStatus.userNotFound:
                                  message = 'Account not found';
                                  break;

                                case LoginStatus.wrongPassword:
                                  message = 'Incorrect password';
                                  break;

                                default:
                                  message = 'Login failed';
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    message,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            // logika untuk register
                            if (_password.text == _konfirmasiPassword.text &&
                                _username.text.isNotEmpty) {
                              await db.register(_username.text, _password.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registration successful! You can now log in.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.greenAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setState(() {
                                isLogin = true;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registration failed! Please ensure your username and password meet the requirements.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          fixedSize: Size(120, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isLogin ? 'Login' : 'Register',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; // toggle antara login dan register
                  });
                },
                child: Text(
                  isLogin
                      ? 'Don\'t have an account? Register'
                      : 'Already have an account? Login',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
