import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api_service.dart';
import '../group_model.dart';
import '../product_model.dart';
import 'product_details_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupSlug;
  final String userId;
  final String userName;

  const GroupDetailsScreen({
    super.key,
    required this.groupSlug,
    required this.userId,
    required this.userName,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  GroupModel? group;
  List<ProductModel> products = [];
  bool isLoading = true;

  bool isJoined = false;
  bool isJoining = false;

  @override
  void initState() {
    super.initState();
    loadGroupData();
  }

  Future<void> loadGroupData() async {
    try {
      final loadedGroup = await ApiService.fetchGroupBySlug(widget.groupSlug);
      final loadedProducts =
          await ApiService.fetchGroupProducts(widget.groupSlug);
      final joined = await ApiService.fetchJoinStatus(
        slug: widget.groupSlug,
        userId: widget.userId,
      );

      if (!mounted) return;

      setState(() {
        group = loadedGroup;
        products = loadedProducts;
        isJoined = joined;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("GROUP DETAILS ERROR: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _joinGroup() async {
    if (isJoined || isJoining) return;

    setState(() {
      isJoining = true;
    });

    try {
      await ApiService.joinGroup(
        slug: widget.groupSlug,
        userId: widget.userId,
      );

      if (!mounted) return;

      setState(() {
        isJoined = true;
        if (group != null) {
          group = GroupModel(
            id: group!.id,
            title: group!.title,
            slug: group!.slug,
            coverImage: group!.coverImage,
            profileImage: group!.profileImage,
            description: group!.description,
            categoryKey: group!.categoryKey,
            membersCount: group!.membersCount + 1,
            isActive: group!.isActive,
            groupType: group!.groupType,
          );
        }
      });

      _showPrettySnackBar(
        message: "Joined successfully",
        icon: Icons.check_rounded,
      );
    } catch (e) {
      _showPrettySnackBar(
        message: "Failed to join group",
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isJoining = false;
      });
    }
  }

  Future<void> _leaveGroup() async {
    if (!isJoined || isJoining) return;

    setState(() {
      isJoining = true;
    });

    try {
      await ApiService.leaveGroup(
        slug: widget.groupSlug,
        userId: widget.userId,
      );

      if (!mounted) return;

      setState(() {
        isJoined = false;
        if (group != null && group!.membersCount > 0) {
          group = GroupModel(
            id: group!.id,
            title: group!.title,
            slug: group!.slug,
            coverImage: group!.coverImage,
            profileImage: group!.profileImage,
            description: group!.description,
            categoryKey: group!.categoryKey,
            membersCount: group!.membersCount - 1,
            isActive: group!.isActive,
            groupType: group!.groupType,
          );
        }
      });

      _showPrettySnackBar(
        message: "Left group successfully",
        icon: Icons.logout_rounded,
      );
    } catch (e) {
      _showPrettySnackBar(
        message: "Failed to leave group",
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isJoining = false;
      });
    }
  }

  void _showPrettySnackBar({
    required String message,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF202124),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (group == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Group not found")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Group",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF202124),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          color: const Color(0xFFF5F5F5),
                          child: group!.coverImage.isNotEmpty
                              ? (group!.coverImage.startsWith("http")
                                  ? Image.network(
                                      group!.coverImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox(),
                                    )
                                  : Image.asset(
                                      group!.coverImage,
                                      fit: BoxFit.cover,
                                    ))
                              : const SizedBox(),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: isJoined ? _leaveGroup : _joinGroup,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isJoined
                                    ? const Color(0xFF202124)
                                    : const Color(0xFF5B2333),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isJoined
                                        ? Icons.logout_rounded
                                        : Icons.group_add_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isJoining
                                        ? (isJoined
                                            ? "Leaving..."
                                            : "Joining...")
                                        : (isJoined ? "Leave" : "Join"),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 51,
                                backgroundColor: const Color(0xFFEAEAEA),
                                backgroundImage: group!.profileImage.isNotEmpty
                                    ? (group!.profileImage.startsWith("http")
                                        ? NetworkImage(group!.profileImage)
                                        : AssetImage(group!.profileImage)
                                            as ImageProvider)
                                    : null,
                                child: group!.profileImage.isEmpty
                                    ? const Icon(Icons.image,
                                        size: 30, color: Colors.grey)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            group!.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF202124),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${group!.membersCount} members",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (group!.description.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              group!.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildProductsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "No products found",
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(
                  product: product,
                  userId: widget.userId,
                  userName: widget.userName,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: product.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported_outlined),
                        ),
                      )
                    : const Icon(Icons.image_not_supported_outlined),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF202124),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: const Color(0xFF444444),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${product.currency} ${product.price}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
