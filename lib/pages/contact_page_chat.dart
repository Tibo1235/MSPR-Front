import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '/utility/providerUser.dart';
import 'package:dio/dio.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<User> contacts = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${userProvider.user?.token}';

      final response = await dio.get('/users');

      if (response.statusCode == 200) {
        // Parse the response and update contacts
        setState(() {
          // Convert your response data to User objects
          // This is an example, adjust according to your API response
          contacts = (response.data as List)
              .map((user) => User.fromJson(user))
              .toList();
        });
      }
    } catch (error) {
      print('Error fetching contacts: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading contacts')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /*void startChat(User selectedUser) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${userProvider.user?.token}';

      final response = await dio.post('/chats', data: {
        //'recipient_id': selectedUser.id,
      });

      if (response.statusCode == 201) {
        // Navigate to chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => ChatScreen(chatId: response.data['chat_id']),
          ),
        );
      }
    } catch (error) {
      print('Error creating chat: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting chat')),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E9DE),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xB2E1BD98),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Contacts",
                    filled: true,
                    fillColor: Color(0xA68A9B6E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Implement search filtering
                    setState(() {
                      // Filter contacts based on search text
                    });
                  },
                ),
              ),
              /*Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xA68A9B6E),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFF8E9DE),
                          child: Text(
                            //contact.username[0].toUpperCase(),
                            style: TextStyle(
                              color: Color(0xA68A9B6E),
                            ),
                          ),
                        ),
                        title: Text(
                          //contact.username,
                          /*style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),*/
                        ),
                        subtitle: const Text(
                          contact.email,
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        /*trailing: IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                          ),
                          //onPressed: () => startChat(contact),
                        ),
                        onTap: () => startChat(contact),*/
                        ),
                        ),
                        );

                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}