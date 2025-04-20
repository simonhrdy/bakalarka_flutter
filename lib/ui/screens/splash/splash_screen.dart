import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/gen/assets.gen.dart';
import 'package:sportmatter/l10n/l10n.dart';

@RoutePage()
class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    Timer? timer;
    useEffect(() {
      animationController.repeat();

      // Fake timeout
      timer = Timer(const Duration(seconds: 2), () {
        context.router.replace(const LoginRoute());
      });

      return () {
        animationController.dispose();
        timer?.cancel();
      };
    }, []);

    return Scaffold(
      body: Container(
          width: context.mq.size.width,
          height: context.mq.size.height,
          decoration: BoxDecoration(
            gradient: context.theme.primaryGradient,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: animationController,
                child: Assets.icons.logoSplash.svg(width: 100, height: 100),
              ),
              const Gap(16),
              Text(
                context.l10n.title,
                style: context.textTheme.h1,
              ),
            ],
          )),
    );
  }
}
