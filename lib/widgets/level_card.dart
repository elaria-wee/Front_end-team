import 'package:flutter/material.dart';

/// Reusable level card for the kids English learning app.
/// Uniform 300x180 cards with background image, hover scale, and SnackBar on tap.
class LevelCard extends StatefulWidget {
  const LevelCard({
    super.key,
    required this.levelLetter,
    required this.title,
    required this.description,
    required this.icon,
    required this.themeColor,
    required this.backgroundImagePath,
    this.onTap,
  });

  final String levelLetter;
  final String title;
  final String description;
  final IconData icon;
  final Color themeColor;
  final String backgroundImagePath;
  final VoidCallback? onTap;

  /// Uniform card dimensions (responsive on small screens).
  static const double cardWidth = 300;
  static const double cardHeight = 180;
  static const double borderRadius = 16;
  static const double cardSpacing = 16;

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleHover(bool hovered) {
    if (_isHovered != hovered) {
      setState(() => _isHovered = hovered);
      if (hovered) {
        _scaleController.forward();
      } else {
        _scaleController.reverse();
      }
    }
  }

  void _handleTap() {
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _scaleController.reverse();
    });
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Level ${widget.levelLetter} Selected! Get ready for ${widget.title} adventures with Eli!',
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            left: 16,
            right: 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 400;
    final cardWidth = isSmallScreen ? size.width - 48 : LevelCard.cardWidth;
    final iconSize = isSmallScreen ? 36.0 : 42.0;
    final titleSize = isSmallScreen ? 15.0 : 17.0;
    final descSize = isSmallScreen ? 12.0 : 13.0;
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: cardWidth,
            height: LevelCard.cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(LevelCard.borderRadius),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: widget.themeColor.withOpacity(0.15),
                  blurRadius: _isHovered ? 16 : 8,
                  offset: Offset(0, _isHovered ? 5 : 3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(LevelCard.borderRadius),
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      widget.backgroundImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                widget.themeColor.withOpacity(0.4),
                                widget.themeColor.withOpacity(0.15),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Level ${widget.levelLetter}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Icon(
                          widget.icon,
                          size: iconSize,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: titleSize,
                            shadows: <Shadow>[
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: descSize,
                              height: 1.35,
                              shadows: <Shadow>[
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
