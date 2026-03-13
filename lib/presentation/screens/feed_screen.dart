import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/post_widget.dart';
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
    // Standard screen height roughly accounts for 1.5 posts. 
    // Triggering when maxScrollExtent - currentPixels is less than ~1500px triggers it ~2 posts early.
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Instagram', style: GoogleFonts.grandHotel(fontSize: 34, color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state.isLoadingInitial) return _buildShimmer();
          
          return RefreshIndicator(
            onRefresh: () async => context.read<FeedBloc>().add(LoadInitialFeed()),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length + 2, // 1 for stories, 1 for bottom loader
              itemBuilder: (ctx, i) {
                if (i == 0) return const StoriesTray();
                if (i == state.posts.length + 1) {
                  return state.isFetchingMore
                      ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: CircularProgressIndicator(color: Colors.grey)))
                      : const SizedBox.shrink();
                }
                return PostWidget(post: state.posts[i - 1]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 28), label: ''),
        ],
      ),
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