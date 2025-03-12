import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jjcentre/screen/pay_membership_fee.dart';
import '../Api/data_store.dart';
import '../controller/login_controller.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  @override
  _AddFamilyMembersState createState() => _AddFamilyMembersState();
}

class _AddFamilyMembersState extends State<AddFamilyMemberScreen> {
  LoginController loginController = Get.find();
  List<Map<String, dynamic>> familyMembers = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();

    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {
    // Here you'd fetch the family members from the server
    // Simulating a fetch with hardcoded data
    List<Map<String, dynamic>> fetchedData = await loginController.fetchFamilyMembers();

    setState(() {
      familyMembers = fetchedData;
      for (int i = 0; i < familyMembers.length; i++) {
        focusNodes.add(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    // Dispose all the focus nodes when the widget is disposed
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _addNewMember() {
    setState(() {
      FocusNode newFocusNode = FocusNode();
      focusNodes.add(newFocusNode);
      familyMembers.add({
        'name': '',
        'gender': 'Male',
        'age': '',
        'relationship': 'Self',
        'profession': '',
      });
      // Request focus on the new member's name field
      newFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff1E20FF),
        elevation: 0,
        title: Center(
          child: Text(
            "Add Family Member".tr,
            style: TextStyle(
              fontFamily: "Gilroy Bold", // Replace with `FontFamily.gilroyBold` if defined
              fontSize: 17,
              color: Colors.white, // Replace with `WhiteColor` if it's defined elsewhere
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: focusNodes[index],
                            initialValue: familyMembers[index]['name'],
                            decoration:
                            InputDecoration(labelText: 'Name of the Family Member'),
                            onChanged: (value) {
                              setState(() {
                                familyMembers[index]['name'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: familyMembers[index]['gender'],
                            decoration: InputDecoration(labelText: 'Gender'),
                            items: ['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                familyMembers[index]['gender'] = value!;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: familyMembers[index]['age'],
                            decoration: InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                familyMembers[index]['age'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: familyMembers[index]['relationship'],
                            decoration:
                            InputDecoration(labelText: 'Relationship with the Member'),
                            items: [
                              'Self',
                              'Spouse',
                              'Son',
                              'Daughter',
                              'Father',
                              'Mother',
                              'GrandParent',
                              'GrandChild',
                              'Uncle',
                              'Aunt','Nephew','Niece','Cousin','Daughter-in-law','Father-in-law','Mother-in-law','Other'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                familyMembers[index]['relationship'] = value!;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: familyMembers[index]['profession'],
                            decoration: InputDecoration(labelText: 'Profession'),
                            onChanged: (value) {
                              setState(() {
                                familyMembers[index]['profession'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Remove this member from the list
                                  setState(() {
                                    familyMembers.removeAt(index);
                                    focusNodes[index].dispose();
                                    focusNodes.removeAt(index);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addNewMember,
              child: Text('Add Family Member'),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusts spacing between buttons
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Submit the data
                    print(familyMembers);
                    loginController.addMemberApiData(familyMembers);
                  },
                  child: Text('Update Member'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next screen

                    Get.to(PayMembershipFeeScreen());
                  },
                  child: Text('Next'),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
