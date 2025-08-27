import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../services/api_service.dart';
import '../screens/ResetPasswordScreen.dart';

class AccountRecoverScreen extends StatefulWidget {
  const AccountRecoverScreen({super.key});

  @override
  State<AccountRecoverScreen> createState() => _AccountRecoverScreenState();
}

class _AccountRecoverScreenState extends State<AccountRecoverScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _showCodeStep = false;
  bool _isLoading = false;
  String? _recoveryCode;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onNextPressed() async {
    if (!_showCodeStep) {
      if (_emailController.text.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });

        final response = await ApiService.sendRecoveryEmail(
          correoElectronico: _emailController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          _recoveryCode = response.data!['codigo'];
          setState(() {
            _showCodeStep = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Error enviando correo')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa tu correo electrónico')),
        );
      }
    } else {
        if (_codeController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ingresa el código de verificación')),
          );
          return;
        }

        if (_codeController.text == _recoveryCode) {
          // Código correcto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(correoElectronico: _emailController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Código incorrecto')),
          );
        }

        setState(() { _isLoading = true; });

        final response = await ApiService.verifyRecoveryCode(
          correoElectronico: _emailController.text,
          codigo: _codeController.text,
        );

        setState(() { _isLoading = false; });

        if (response.success) {
          // Código correcto, aquí puedes navegar a cambiar contraseña
          Navigator.pushNamed(context, '/reset-password', arguments: _emailController.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Código incorrecto')),
          );
        }
      }
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_showCodeStep) ...[
                const SizedBox(height: 20),
                Image.asset(
                  isDarkMode ? 'assets/logo_dark.png' : 'assets/logo.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.star_outline,
                      size: 40,
                      color: Color(0xFF41277A),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],

              if (!_showCodeStep) ...[
                Text(
                  'Recuperación de cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Recuperar',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF41277A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tu correo electrónico para recuperar tu cuenta',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person,
                          color: isDarkMode ? Colors.white : Colors.grey[600],
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Verificación',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _emailController.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Código de verificación',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF41277A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa el código de verificación enviado a tu correo electrónico',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!_showCodeStep) ...[
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Correo electrónico',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF41277A)),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          ),
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _codeController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Código de 6 dígitos',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF41277A)),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            counterText: '',
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onNextPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF41277A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [],
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : Text(
                            _showCodeStep ? 'Verificar' : 'Siguiente',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      if (_showCodeStep) ...[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            setState(() {
                              _showCodeStep = false;
                              _codeController.clear();
                            });
                          },
                          child: Text(
                            'Cambiar correo electrónico',
                            style: TextStyle(color: Color(0xFF7B7B8A)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.help_outline, color: Color(0xFFB0B0B8), size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}