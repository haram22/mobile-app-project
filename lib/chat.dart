import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class chattingPage extends StatefulWidget {
//   const chattingPage({ Key? key }) : super(key: key);

//   @override
//   State<chattingPage> createState() => _chattingPageState();
// }

// class _chattingPageState extends State<chattingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back,color: Colors.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text('chat',style: TextStyle(color: Colors.black),)
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(children: [

//             ],),
//           ),
//           Divider(
//             thickness: 2,
//             height: 3,
//             color: Colors.black,
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 20),
//             child: Row(children: [
//             TextField(
//               style: TextStyle(fontSize: 25),
//               decoration:  InputDecoration(
//                 hintText: '메세지 입력',
//                 hintStyle: TextStyle(color: Colors.grey)
//               ),
//             ),
//             Icon(Icons.send,color: Colors.black,)
//           ],),
//           )
//         ],
//       ),
//     );
//   }
// }
String _name = 'Your Name';

class ChatMessage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
   ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(text))
    );
  }
}

class chattingPage extends StatefulWidget {
  const chattingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<chattingPage> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<chattingPage> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 20),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text('chatting',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration:
                    const InputDecoration.collapsed(hintText: '메세지를 입력해주세요'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                      icon: _isComposing ? Icon(Icons.send_outlined ) : Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}