// lib/presentation/screens/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/presentation/widgets/feed_dropdown_menu.dart';
import 'package:instagram_clone/presentation/widgets/post_widget.dart';
import 'package:instagram_clone/presentation/widgets/profile_avatar.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/stories_tray.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 1500) {
      context.read<FeedBloc>().add(LoadMorePosts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: state.isLoadingInitial
                ? _buildShimmer()
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // SCROLLABLE APPBAR
                      SliverAppBar(
                        backgroundColor: Colors.black,
                        elevation: 0.5,
                        pinned: false, // Set to false to make it scroll away
                        centerTitle: true,
                        leading: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                          onPressed: () {},
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Instagram',
                              style: TextStyle(
                                fontFamily: 'Billabong',
                                fontSize: 38,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: FaIcon(
                                FontAwesomeIcons.angleDown,
                                color: Colors.white,
                                size: 14,
                              ),
                              onPressed: ()=> FeedDropdownMenu.show(context),
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.heart, color: Colors.white),
                            onPressed: () {},
                          )
                        ],
                      ),
                      // FEED CONTENT
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 0) return const StoriesTray();
                            if (index == state.posts.length + 1) {
                              return state.isFetchingMore
                                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: CircularProgressIndicator(color: Colors.grey)))
                                  : const SizedBox.shrink();
                            }
                            return PostWidget(post: state.posts[index - 1]);
                          },
                          childCount: state.posts.length + 2,
                        ),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
              const BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: ''),
              const BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 28), label: ''),
              const BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined, size: 28), label: ''),
              BottomNavigationBarItem(
                icon: state.currentUser != null
                    ? ProfileAvatar(
                        userImageUrl: state.currentUser!.profileImageUrl,
                        radius: 12,
                      )
                    : const Icon(Icons.person_outline, size: 28, color: Colors.white54),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmer() => ListView.builder(
    itemCount: 3, 
    itemBuilder: (_, i) => Column(
      children: [
        if (i == 0) const StoriesTray(),
        Shimmer.fromColors(
          baseColor: Colors.grey[900]!, 
          highlightColor: Colors.grey[800]!,
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(),
                title: Container(height: 10, width: 100, color: Colors.white),
              ),
              Container(height: 400, color: Colors.black),
              const SizedBox(height: 50),
            ]
          ),
        ),
      ],
    )
  );
}