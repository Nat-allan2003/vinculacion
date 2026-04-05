import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proto_segui/models/company.dart';
import 'package:proto_segui/models/vacancy.dart';
import 'package:proto_segui/network/ug/ug_models.dart';
import 'package:proto_segui/utils/colores.dart';

class NavItemData {
  final String label;
  final IconData icon;
  final Widget Function() builder;
  NavItemData({required this.label, required this.icon, required this.builder});
}

// --- CARDS ---
class VacancyCard extends StatelessWidget {
  final Vacancy vacancy;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const VacancyCard({
    super.key,
    required this.vacancy,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderC),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfTag(
                      text: vacancy.modality,
                      icon: Icons.laptop_mac_rounded,
                    ),
                    const SizedBox(width: 8),
                    ProfTag(
                      text: vacancy.postedDate,
                      icon: Icons.schedule_rounded,
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isFavorite ? Colors.amber : generalGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  vacancy.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: textDarkC,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vacancy.companyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryC,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: generalGray,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        vacancy.location,
                        style: const TextStyle(
                          color: textMutedC,
                          fontSize: 12.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ProfRatingPill(rating: vacancy.rating),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final Company company;
  final bool isFollowed;
  final VoidCallback onTap;
  final VoidCallback onFollowToggle;

  const CompanyCard({
    super.key,
    required this.company,
    required this.isFollowed,
    required this.onTap,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderC),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryC.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryC.withValues(alpha: .15)),
                  ),
                  child: Center(
                    child: Text(
                      company.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: primaryC,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: textDarkC,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${company.employeeCount} empleados • ${company.location}",
                        style: const TextStyle(
                          color: textMutedC,
                          fontSize: 12.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ProfTag(
                            text: company.industry,
                            icon: Icons.business_rounded,
                          ),
                          const SizedBox(width: 8),
                          ProfRatingPill(rating: company.rating),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: onFollowToggle,
                  style: FilledButton.styleFrom(
                    backgroundColor: isFollowed ? Colors.white : generalDark,
                    foregroundColor: isFollowed ? generalDark : Colors.white,
                    side: isFollowed
                        ? const BorderSide(color: borderC)
                        : BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(isFollowed ? "Siguiendo" : "Seguir"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- NAVBAR ---
class DynamicIslandNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<NavItemData> items;

  const DynamicIslandNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .90),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Colors.black.withValues(alpha: .85),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .14),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: primaryC.withValues(alpha: .14),
                  iconTheme: WidgetStateProperty.resolveWith(
                    (states) => IconThemeData(
                      color: states.contains(WidgetState.selected)
                          ? primaryC
                          : Colors.black.withValues(alpha: .70),
                      size: states.contains(WidgetState.selected) ? 26 : 24,
                    ),
                  ),
                  labelTextStyle: WidgetStateProperty.resolveWith(
                    (states) => TextStyle(
                      color: states.contains(WidgetState.selected)
                          ? primaryC
                          : Colors.black.withValues(alpha: .65),
                      fontWeight: states.contains(WidgetState.selected)
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ),
                child: NavigationBar(
                  height: 74,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onSelect,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  destinations: items
                      .map(
                        (e) => NavigationDestination(
                          icon: Icon(e.icon),
                          label: e.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassModuleMenu extends StatelessWidget {
  final List<UgMenuItem> menus;
  final int activeId;
  final IconData Function(String fa) iconResolver;
  final ValueChanged<UgMenuItem> onPick;

  const GlassModuleMenu({
    super.key,
    required this.menus,
    required this.activeId,
    required this.iconResolver,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 320,
          constraints: const BoxConstraints(maxHeight: 360),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withValues(alpha: .12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .14),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menus.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.black.withValues(alpha: .08),
              ),
              itemBuilder: (context, i) {
                final m = menus[i];
                final selected = m.moduloId == activeId;
                return InkWell(
                  onTap: () => onPick(m),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          iconResolver(m.icono),
                          size: 20,
                          color: selected ? Colors.black : textMutedC,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            m.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.w900
                                  : FontWeight.w800,
                              color: Colors.black.withValues(alpha: .88),
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// --- HELPERS MENORES ---
class ProfTag extends StatelessWidget {
  final String text;
  final IconData icon;
  const ProfTag({super.key, required this.text, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: borderC),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: generalGray),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: textMutedC,
          ),
        ),
      ],
    ),
  );
}

class ProfRatingPill extends StatelessWidget {
  final double rating;
  const ProfRatingPill({super.key, required this.rating});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.amber.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.amber.withValues(alpha: .22)),
    ),
    child: Row(
      children: [
        const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}

class ProfEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ProfEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 62, color: generalGray.withValues(alpha: .55)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: textMutedC, height: 1.35),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class ProfGhostChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const ProfGhostChip({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: borderC),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: generalGray),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: textMutedC,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: generalGray,
        ),
      ],
    ),
  );
}
