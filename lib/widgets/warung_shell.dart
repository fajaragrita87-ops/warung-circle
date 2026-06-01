import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/bottom_nav_bar.dart';

// ============================================================
// WARUNG SHELL v2 — Cleaner layout, single FAB bottom-right
// 4-tab navigation: Posko | Pasar | Obrolan | Profil
// ============================================================
class WarungShell extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;
  final bool showFab;
  final List<Widget>? actions;
  final bool showAppBar;
  final VoidCallback? onFabPressed;

  const WarungShell({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.showFab = true,
    this.actions,
    this.showAppBar = true,
    this.onFabPressed,
  });

  // 4-tab route mapping
  void _onTabSelected(BuildContext context, int index) {
    if (index == currentIndex) return;
    const mapping = [
      Routes.home,
      Routes.lapak,
      Routes.chat,
      Routes.dapurErni,
    ];
    Navigator.pushReplacementNamed(context, mapping[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Soft peach canvas for desktop/web view
      color: const Color(0xFFFFEDE9),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: WC.bg,
            extendBody: true,

            // ===  APP BAR ===
            appBar: showAppBar
                ? AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    scrolledUnderElevation: 0.5,
                    shadowColor: Colors.black.withOpacity(0.06),
                    surfaceTintColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: WC.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: WC.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('☕', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Warung Circle',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: WC.textDark,
                              ),
                            ),
                            Text(
                              title,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: WC.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: actions ??
                        [
                          IconButton(
                            icon: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: WC.bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: WC.border),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 19,
                                color: WC.textMid,
                              ),
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 6),
                        ],
                  )
                : null,

            body: body,

            // === SINGLE CLEAN FAB — bottom right ===
            floatingActionButton: showFab
                ? FloatingActionButton(
                    onPressed: onFabPressed ?? () {},
                    backgroundColor: WC.primary,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [WC.primary, WC.primaryMid],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: WC.primary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

            // === BOTTOM NAV BAR ===
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentIndex,
              onTabSelected: (index) => _onTabSelected(context, index),
            ),
          ),
        ),
      ),
    );
  }
}
