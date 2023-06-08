import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hovedopgave_app/view/teams/post_dashboard.dart';
import '../../repository/post_repository.dart';
import '../../repository/team_repository.dart';
import 'add_post.dart';

class TeamDashboard extends StatefulWidget {
  final String teamID;
  final PostRepository postRepository;
  final TeamRepository teamRepository;

  const TeamDashboard(this.teamID,
      {required this.postRepository, required this.teamRepository});

  @override
  _TeamDashboardState createState() => _TeamDashboardState();
}

class _TeamDashboardState extends State<TeamDashboard> {
  bool _showMembers = false;

  void _toggleMembers() {
    setState(() {
      _showMembers = !_showMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hold info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: _toggleMembers,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.postRepository.getPostForCurrentTeam(widget.teamID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!.docs;
            if (posts.isNotEmpty) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index].data();
                  final creatorId = post['creator'];
                  final teamId = post['teamId'];
                  final postId = posts[index].id;
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(creatorId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final creatorData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final creatorName = creatorData['name'] as String;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDashboard(
                                  teamID: widget.teamID,
                                  postID: postId,
                                  postTitle: post['title'] ?? '',
                                  postContent: post['content'] ?? '',
                                  creatorName: creatorName,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(post['title'] ?? ''),
                            subtitle: Text(post['content'] ?? ''),
                            trailing: Text(creatorName),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Ingen opslag endnu. Tryk på + for at lave et.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(widget.teamID),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomSheet: _showMembers ? _buildMembersSheet(context) : null,
    );
  }

  Widget _buildMembersSheet(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.teamRepository.getMembersOfTeam(widget.teamID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final memberIds = snapshot.data!;
          return Container(
            height:
                MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Medlemmer'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _toggleMembers,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: memberIds.length,
                    itemBuilder: (context, index) {
                      final memberId = memberIds[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(memberId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final memberData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final memberName = memberData['name'] as String;
                            return ListTile(
                              title: Text(memberName),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
