import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';
import '../widgets/lottie_globe.dart';
import '../widgets/privacy_promise_card.dart';
import '../widgets/verification_rate_bar.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShieldNet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_outlined),
            tooltip: 'Language',
            onPressed: () {
              // Language picker wired up later.
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: HeroSection(
            eyebrow: 'Anonymous · Encrypted · Free',
            headline: 'Report cyber harassment.\nStay protected.',
            subtitle:
                'ShieldNet gives anyone affected by cyber harassment a '
                'safe way forward. Report an incident anonymously, with '
                'no account required. Upload evidence through encrypted, '
                'verified channels. Track your case anytime using a '
                'private token. No names, no exposure, no judgment. '
                'Your privacy is never compromised, by design.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VerificationRateBar(),
                const SizedBox(height: 32),
                const Center(child: LottieGlobe()),
                const SizedBox(height: 32),
                const PrivacyPromiseCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}