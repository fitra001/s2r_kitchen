import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/Admin/kelola_user/ubah_user/ubah_user.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tambah_user/tambah_user.dart';

class KelolaUser extends StatefulWidget {
  const KelolaUser({ Key? key }) : super(key: key);

  @override
  State<KelolaUser> createState() => _KelolaUserState();
}

class _KelolaUserState extends State<KelolaUser> {
  bool loading = true;
  List<User>? user;
  TextEditingController _searchController = TextEditingController();
  List userRole = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _getRole();
    _getUser();

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _searchList(_searchController.text);
      } else {
        _getUser();
      }
    });
  }

  _getRole()async{
    final getRole = await ApiService().getUserRole();
    setState(() {
      userRole = getRole['data'];
    });
  }

  String userRoleView(roleid) {
    final filtermap = userRole.where((i) {
      return i['id_role'] == roleid;
    }).toList();
    return filtermap[0]['role'];
  }

  _getUser() async{
    final getuser = await ApiService().getAllUser();
    setState(() {
      user = getuser;
      loading = false;
    });
  }

  _searchList(String text) async {
    final getSearch = await ApiService().getUserSearch(text);
    if (mounted) {
      setState(() {
        user = getSearch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            child: TextFormField(
              controller: _searchController,
              style: const TextStyle(fontFamily: 'sans serif'),
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(CupertinoIcons.search, color: Color(0x99FFC107)),
                hintText: 'Pencarian User',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
              ),
            )
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () { Navigator.pop(context); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        backgroundColor: Colors.white,
      ),
      body: (loading) ? const Center(child: CircularProgressIndicator(),) : userView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, 
            MaterialPageRoute(builder: (_) => const TambahUser())
          );
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );

  }

  Widget userView(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: user!.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UbahUser(
                            user: user?[index],
                          )));
            },
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (user![index].foto == null)
                      ? Image.asset(
                          'assets/images/bgsplash.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          ApiService.imageProfilUrl + user![index].foto!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            user![index].nama!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            user![index].no_telp!,
                              style: const TextStyle(
                                  fontSize: 18,)),
                          Text(
                            user![index].email!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text( userRoleView(user![index].role_id!),
                              style: const TextStyle(
                                  fontFamily: 'Satisfy',
                                  fontSize: 18,
                                  color: Color(0x99FFC107))),
                                  
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}