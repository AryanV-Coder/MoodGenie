import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/main.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {

  final box = Hive.box('moodBox');
  late List<dynamic> moodHistory;

  @override
  void initState() {
    super.initState();
    moodHistory = box.get('moodHistory',defaultValue: []);
  }

  void save_mood_history(String moodSummary){
    final now = DateTime.now();
    final formattedTime = DateFormat("MMMM d, y  h:mm a").format(now);

    if (!box.containsKey('id')){
      print("HI");
      box.put('id',0);
    }

    final oldId = box.get('id');
    setState(() {
      print(oldId);
      print(currentId);
      if (oldId == currentId) {
        int index = moodHistory.length - 1;
        moodHistory[index] = {"timestamp": formattedTime, "mood": moodSummary};
      } else {
        moodHistory.add({"timestamp": formattedTime, "mood": moodSummary});
        box.put('id',currentId);
      }
      box.put('moodHistory', moodHistory);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 17, 77).withOpacity(0.95), // dark blue vibe
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Mood History",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: moodHistory.length,
                  itemBuilder: (context, index) {
                    final item = moodHistory[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timestamp part
                          SizedBox(
                            width: 110,
                            child: Text(
                              item["timestamp"]!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Mood summary part
                          Expanded(
                            child: Text(
                              item["mood"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   late VideoPlayerController _videoController;

//   final List<Map<String, String>> _history = [
//     {
//       "time": "June 9, 2025 - 10:30 AM",
//       "mood": "😊 Feeling joyful after a refreshing walk!"
//     },
//     {
//       "time": "June 8, 2025 - 8:15 PM",
//       "mood": "😔 A bit down, it was a tiring day."
//     },
//     {
//       "time": "June 7, 2025 - 5:45 PM",
//       "mood": "😌 Calm and relaxed after meditation."
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.asset('assets/cloudy_animation.mp4')
//       ..initialize().then((_) {
//         _videoController.setLooping(true);
//         _videoController.setVolume(0);
//         _videoController.setPlaybackSpeed(0.75);
//         _videoController.play();
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           /// Background Video
//           if (_videoController.value.isInitialized)
//             SizedBox.expand(
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: _videoController.value.size.width,
//                   height: _videoController.value.size.height,
//                   child: VideoPlayer(_videoController),
//                 ),
//               ),
//             ),

//           /// Semi-transparent overlay for better readability
//           Container(
//             color: Colors.black.withOpacity(0.4),
//           ),

//           /// Foreground content
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "🧠 Mood History",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _history.length,
//                       itemBuilder: (context, index) {
//                         final entry = _history[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 16),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.85),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 entry["time"]!,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 entry["mood"]!,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
