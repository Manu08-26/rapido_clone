import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'notifications.dart';
import 'login_screen.dart';
import 'promo_code_details_screen.dart';
import 'location_screen.dart';
import 'rental_ride_screen.dart';
import 'services_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';
import 'map_location_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppTheme _appTheme = AppTheme();

  @override
  void initState() {
    super.initState();
    _appTheme.addListener(_onThemeChanged);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _appTheme.removeListener(_onThemeChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  PageController _pageController = PageController(viewportFraction: 0.8);
  PageController _servicesPageController = PageController();
  double currentPage = 0.0;
  int currentServicePage = 0;
  String selectedService = "Ride"; // Track selected service

  final List<String> images = [
    "assets/bike.png",
    "assets/car.png",
    "assets/bike.png",
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: _appTheme.textDirection,
      child: Scaffold(
        backgroundColor: _appTheme.backgroundColor,

        /// APP BAR
        appBar: AppBar(
          backgroundColor: _appTheme.cardColor,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          _appTheme.rtlEnabled ? Icons.menu : Icons.menu,
          color: _appTheme.textColor,
        ),
        onPressed: () {
          // Handle menu tap
        },
      ),
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MapLocationScreen(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.currentLocation,
              style: TextStyle(
                fontSize: 12,
                color: _appTheme.textGrey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Hotel Grand Sitara, Banja...",
                    style: TextStyle(
                      fontSize: 16,
                      color: _appTheme.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: _appTheme.textColor,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
      titleSpacing: 0,

      /// TOP RIGHT ICONS
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: _appTheme.textColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _appTheme.brandRed,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      ),

      /// BODY
       body: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROMOTIONAL HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "Pocket-Friendly Rides, Always!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _appTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No surge fees, no hidden charges - just low prices every time!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: _appTheme.textGrey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Carousel indicator for header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == 0 ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: index == 0
                                    ? _appTheme.brandRed
                                    : _appTheme.iconBgColor,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// BANNER WITH TEXT OVERLAY
                  SizedBox(
                    height: 280,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        double scale = (index == currentPage.floor())
                            ? 1 - (currentPage - index) * 0.1
                            : 0.9;
                        return Transform.scale(
                          scale: scale,
                          child: Stack(
                            children: [
                              bannerCard(images[index]),
                              // Text overlay
                              Positioned(
                                left: 20,
                                top: 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "IT'S TIME",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: _appTheme.textGrey, // Grey color
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "TO TRAVEL",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: _appTheme.textColor, // Black color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Banner carousel indicator
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: (currentPage.floor() == index) ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: (currentPage.floor() == index)
                              ? _appTheme.brandRed
                              : _appTheme.iconBgColor,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),
        Column(
          children: [
            Row(
              children: [
                /// PREVIOUS BUTTON
              

                if (currentServicePage > 0) const SizedBox(width: 8),

                /// PAGE VIEW
                Expanded(
                  child: SizedBox(
          height: 100,
          child: PageView(
            controller: _servicesPageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentServicePage = index;
              });
            },
            children: [
              /// PAGE 1 → NEXT at END
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  serviceItem(context, localizations, Icons.location_on, localizations.ride, "Ride", () {
                    setState(() {
                      selectedService = "Ride";
                    });
                  }),
                  serviceItem(context, localizations, Icons.directions_car, localizations.intercity, "Intercity", () {
                    setState(() {
                      selectedService = "Intercity";
                    });
                  }),
                  serviceItem(context, localizations, Icons.timer, localizations.package, "Package", () {
                    setState(() {
                      selectedService = "Package";
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationScreen(),
                      ),
                    );
                  }),
                  serviceItem(context, localizations, Icons.calendar_month, localizations.schedule, "Schedule", () {
                    setState(() {
                      selectedService = "Schedule";
                    });
                  }),

                  /// NEXT BUTTON
                  GestureDetector(
                    onTap: () {
                      _servicesPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: _arrowButton(Icons.arrow_forward_ios),
                  ),
                ],
              ),

              /// PAGE 2 → PREVIOUS at START
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// PREVIOUS BUTTON
                  GestureDetector(
                    onTap: () {
                      _servicesPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: _arrowButton(Icons.arrow_back_ios),
                  ),

                  serviceItem(context, localizations, Icons.directions_car, localizations.intercity, "Intercity", () {
                    setState(() {
                      selectedService = "Intercity";
                    });
                  }),
                  serviceItem(context, localizations, Icons.timer, localizations.package, "Package", () {
                    setState(() {
                      selectedService = "Package";
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LocationScreen(),
                      ),
                    );
                  }),
                  serviceItem(context, localizations, Icons.calendar_month, localizations.schedule, "Schedule", () {
                    setState(() {
                      selectedService = "Schedule";
                    });
                  }),
                  serviceItem(context, localizations, Icons.drive_eta, localizations.rental, "Rental", () {
                    setState(() {
                      selectedService = "Rental";
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RentalRideScreen(),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),

        ),

        /// NEXT BUTTON
      
      ],
    ),

    /// DOT INDICATORS
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentServicePage == index
                      ? _appTheme.brandRed
                      : _appTheme.iconBgColor,
                ),
              );
            }),
          ),
        ],
      ),

       

          const SizedBox(height: 24),

          /// CONTENT BASED ON SELECTED SERVICE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show search bar for Ride and Intercity
                      if (selectedService == "Ride" || selectedService == "Intercity") ...[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LocationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: _appTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _appTheme.dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: _appTheme.textGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  localizations.whereNext,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _appTheme.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Recent Location Card
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LocationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _appTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _appTheme.dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _appTheme.iconBgColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.history,
                                    color: _appTheme.textColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Khaja Mansion Convention Cente...",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _appTheme.textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Road Number 1, Owaisi Pura, Ba...",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _appTheme.textGrey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Show promotional banner for Package and Rental
                      if (selectedService == "Package" ) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_appTheme.brandRed, _appTheme.brandRed.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "GET MORE WITH THE",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "RIGHT PACKAGE!",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Book Now",
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
                              const SizedBox(width: 16),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.local_shipping,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
      if ( selectedService == "Rental") ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_appTheme.brandRed, _appTheme.brandRed.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "FIND YOUR PERFECT",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "RENTAL TODAY!",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Book Now",
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
                              const SizedBox(width: 16),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.local_shipping,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],

                      Text(
                        localizations.trendingOffers,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _appTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _offerCard(
                        context,
                        title: "Flat 10% OFF",
                        subtitle: "Valid on your next ride",
                        code: "RIDE10",
                      ),
                      _offerCard(
                        context,
                        title: "Flat 15% OFF",
                        subtitle: "Valid till 05 Mar 2026",
                        code: "SAVE15",
                      ),
                      _offerCard(
                        context,
                        title: "Flat 25% OFF",
                        subtitle: "Valid till 15 Mar 2026",
                        code: "SAVE25",
                      ),
                      _offerCard(
                        context,
                        title: "Flat 15% OFF",
                        subtitle: "Valid till 08 Mar 2026",
                        code: "SAVE625",
                      ),

                      const SizedBox(height: 40),

                      /// FOOTER
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "#GoTaxido",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _appTheme.iconBgColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Made with ❤️ by Pixelstrap",
                              style: TextStyle(color: _appTheme.textGrey),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ),
            ),
            /// BOTTOM NAV
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              backgroundColor: _appTheme.cardColor,
              selectedItemColor: _appTheme.brandRed,
              unselectedItemColor: _appTheme.textGrey,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ServicesScreen(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                }
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined), label: localizations.home),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.grid_view_outlined), label: localizations.services),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.history), label: localizations.history),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings_outlined), label: localizations.setting),
              ],
            ),
          ),
          );
        }
        Widget serviceItem(BuildContext context, AppLocalizations localizations, IconData icon, String title, String serviceKey, VoidCallback? onTap) {
          final bool isSelected = selectedService == serviceKey;
          
          return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _appTheme.iconBgColor,
                  child: Icon(icon, color: _appTheme.brandRed),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? _appTheme.brandRed : _appTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Underline indicator for selected service
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isSelected ? _appTheme.brandRed : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        }

      Widget _arrowButton(IconData icon) {
        final AppTheme _appTheme = AppTheme();
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _appTheme.iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _appTheme.textColor),
        );
      }

Widget bannerCard(String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
 /// OFFER CARD
Widget _offerCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String code,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PromoCodeDetailsScreen(
            code: code,
            title: title,
            subtitle: subtitle,
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _appTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _appTheme.textColor, // Black text
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _appTheme.textGrey, // Grey text
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Copied to clipboard"),
                      duration: const Duration(seconds: 2),
                      backgroundColor: _appTheme.brandRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.copy,
                  color: _appTheme.brandRed, // Red branding color
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _appTheme.brandRed.withOpacity(0.1), // Light red background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _appTheme.brandRed.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _appTheme.brandRed, // Red branding color
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

/// TOP ICON
class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIcon({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
