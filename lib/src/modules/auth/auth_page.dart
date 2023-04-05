import 'package:app/src/shared/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'widgets/button_auth.dart';
import 'widgets/text_field_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController? _emailController;
  TextEditingController? _pwController;

  StateMachineController? _controller;
  Artboard? _riveArtboard;
  SMIInput<bool>? _checkAnimation;
  SMIInput<bool>? _hiddenAnimation;
  SMIInput<bool>? _failAnimation;
  SMIInput<bool>? _successAnimation;

  bool isConected = true;

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _pwController = TextEditingController();

    rootBundle.load(Assets.assetsAnimationLogin).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        final controller =
            StateMachineController.fromArtboard(artboard, 'machine');
        if (controller != null) {
          artboard.addController(controller);
          _checkAnimation = controller.findInput('Check');
          _hiddenAnimation = controller.findInput('hands_up');
          _failAnimation = controller.findInput('fail');
          _successAnimation = controller.findInput('success');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final widthView = size.width > 512 ? 512.0 : size.width;

    return Scaffold(
      body: Container(
        color: theme.colorScheme.primaryContainer,
        child: Column(
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                width: size.width,
                height: 400,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onBackground,
                ),
                child: SizedBox(
                  width: size.width <= 512 ? 512.0 : size.width,
                  height: 300,
                  child: _animation(size.width),
                ),
              ),
            ),
            Text(
              'Seja bem-vindo',
              style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Acesse utilizando sua conta',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            MouseRegion(
              onEnter: (_) => _checkAnimation?.value = true,
              onExit: (_) => _checkAnimation?.value = false,
              child: SizedBox(
                width: widthView,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      TextFieldAuth(
                        controller: _emailController,
                        label: 'E-mail',
                        icon: Icons.alternate_email,
                        onTap: _onTapInput,
                        onChanged: _onChangeEmail,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldAuth(
                        controller: _pwController,
                        label: 'Senha',
                        icon: Icons.lock_outlined,
                        isObscureText: true,
                        onTap: () {
                          _onTapInput(isPw: true);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: widthView,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: widthView * 0.5,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateColor.resolveWith(
                                      (states) => theme.colorScheme.primary,
                                    ),
                                    value: isConected,
                                    onChanged: (bool? value) {
                                      _onTapInput();
                                      setState(() {
                                        isConected = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Manter conectado',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // FIXME add method for forgot
                                _onTapInput();
                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ButtonAuth(
                        width: double.infinity,
                        onPressed: () {
                          // FIXME add method for action login
                          _onTapInput();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Text(
                          'ACESSAR',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: theme.colorScheme.background,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: widthView,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Não possui cadastrado? ',
                              style: theme.textTheme.bodySmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                // FIXME add method for action sign-up
                                _onTapInput();
                              },
                              child: Text(
                                'Cadastra-se aqui',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapInput({bool isPw = false}) {
    if (isPw) {
      _failAnimation?.value = false;
      _hiddenAnimation?.value = true;
    } else if (_hiddenAnimation != null && _hiddenAnimation!.value) {
      _hiddenAnimation?.value = false;
    }
  }

  void _onChangeEmail(String email) {
    if (email.isNotEmpty) {
      final reg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      );
      final emailValid = reg.hasMatch(email);
      if (!emailValid) {
        _failAnimation?.value = true;
        return;
      }
    }
    _failAnimation?.value = false;
  }

  Widget _animation(double width) {
    return _riveArtboard == null
        ? const SizedBox()
        : Rive(
            fit: width > 512 ? BoxFit.fitHeight : BoxFit.fitWidth,
            artboard: _riveArtboard!,
          );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  bool reverse;

  /// flip the wave direction horizontal axis
  bool flip;

  CustomClipPath({this.reverse = false, this.flip = false});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (!reverse && !flip) {
      path.lineTo(0, size.height - 20);

      final firstControlPoint = Offset(size.width / 4, size.height);
      final firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy,
      );

      final secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      final secondEndPoint = Offset(size.width, size.height - 40);
      path
        ..quadraticBezierTo(
          secondControlPoint.dx,
          secondControlPoint.dy,
          secondEndPoint.dx,
          secondEndPoint.dy,
        )
        ..lineTo(
          size.width,
          size.height - 40,
        )
        ..lineTo(size.width, 0)
        ..close();
    } else if (!reverse && flip) {
      path.lineTo(0, size.height - 40);
      final firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      final firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy,
      );

      final secondCP = Offset(size.width / 1.25, size.height);
      final secondEP = Offset(size.width, size.height - 30);
      path
        ..quadraticBezierTo(
          secondCP.dx,
          secondCP.dy,
          secondEP.dx,
          secondEP.dy,
        )
        ..lineTo(
          size.width,
          size.height - 20,
        )
        ..lineTo(size.width, 0)
        ..close();
    } else if (reverse && flip) {
      path.lineTo(0, 20);
      final firstControlPoint = Offset(size.width / 3.25, 65);
      final firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy,
      );

      final secondCP = Offset(size.width / 1.25, 0);
      final secondEP = Offset(size.width, 30);
      path
        ..quadraticBezierTo(
          secondCP.dx,
          secondCP.dy,
          secondEP.dx,
          secondEP.dy,
        )
        ..lineTo(
          size.width,
          size.height,
        )
        ..lineTo(
          0,
          size.height,
        )
        ..close();
    } else {
      path.lineTo(0, 20);

      final firstControlPoint = Offset(size.width / 4, 0);
      final firstEndPoint = Offset(size.width / 2.25, 30);
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy,
      );

      final secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      final secondEndPoint = Offset(size.width, 40);
      path
        ..quadraticBezierTo(
          secondControlPoint.dx,
          secondControlPoint.dy,
          secondEndPoint.dx,
          secondEndPoint.dy,
        )
        ..lineTo(
          size.width,
          size.height,
        )
        ..lineTo(
          0,
          size.height,
        )
        ..close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
