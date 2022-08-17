import 'package:s2r_kitchen/library/my_shared_pref.dart';
import 'package:s2r_kitchen/models/kategori_model.dart';
import 'package:s2r_kitchen/models/menu_model.dart';
import 'package:s2r_kitchen/models/user_model.dart';
import 'package:s2r_kitchen/page/HomeUser/category/category.dart';
import 'package:s2r_kitchen/page/HomeUser/detail_item/detail_item.dart';
import 'package:s2r_kitchen/page/HomeUser/list_item/list_item.dart';
import 'package:s2r_kitchen/page/HomeUser/cart_item/cart_item.dart';
import 'package:s2r_kitchen/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:s2r_kitchen/helpers/currency_format.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  bool isLoadingSearch = false;
  late ApiService apiService;
  User? user;
  final _searchController = TextEditingController();
  List? _searchingList = [];
  int jumlahKeranjang = 0;
  List<Kategori>? listKategori = [];
  bool loadingKategori = true;
  List<Menu>? listMenuTerlaris = [];
  bool loadingMenuTerlaris = true;
  List<Menu>? listAllMenu = [];
  bool loadingAllMenu = true;
  
  @override
  void initState() {
    super.initState();
    
    user = User();
    apiService = ApiService();
    _searchController.addListener((){
      if (_searchController.text.isNotEmpty) {
        setState(() {
          isLoadingSearch= true;
        });
        _searchList(_searchController.text);
      }else{
        setState(() {
          isLoadingSearch = false;
          isSearching = false;
        });
      }
    });
    _getData();
  }

  _getData(){
    _login();
    _getKategori();
    _getMenuTerlaris();
    _getAllMenu();
  }

  _login() async{
    final getUser = await MySharedPref().getModel();
    if (getUser != null) {
      final getJumlahKeranjang = await apiService.getJumlahKeranjang(getUser.id_user.toString());
      if (mounted) {
        setState(() {
          jumlahKeranjang = int.parse(getJumlahKeranjang['data']['jumlah'] ?? "0");
          user = getUser;
        });
      }
    }
  }

  _getKategori() async {
    final kategori = await apiService.getAllKategori();
    if (mounted) {
      setState(() {
        listKategori = kategori;
        loadingKategori = false;
      });
    }
  }

  _getMenuTerlaris() async {
    final menuTerlaris = await apiService.getMenuTerlaris();
    final getMenuTerlaris = menuTerlaris ?? [];
    if (mounted) {
      setState(() {
        listMenuTerlaris = getMenuTerlaris;
        loadingMenuTerlaris = false;
      });
    }
  }

  _getAllMenu() async {
    final allMenu = await apiService.getAllMenu();
    if (mounted) {
      setState(() {
        listAllMenu = allMenu;
        loadingAllMenu = false;
      });
    }
  }

  _searchList(String text) async {
    final getSearch = await apiService.getMenuByNama(text);
    if (mounted) {
      setState(() {
        _searchingList = getSearch;
        isLoadingSearch = false;
        isSearching = true;
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
                hintText: 'Pencarian',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x99FFC107)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            )),
        actions: [
          Stack(
            children: [
              IconButton(
                color: Colors.black,
                icon: const Icon(CupertinoIcons.cart),
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartItem())),
              ),
              if(jumlahKeranjang > 0) Positioned(
                top: 2.0,
                right: 4.0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.red
                  ),
                  height: 10,
                  width: 10,
                )
              )
            ]
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          _getData();
        },
        child: SingleChildScrollView(
          child: isSearching ? SearchItem(menuSearch: _searchingList,) :Column(children: [
            (user!.nama == null) ? const SizedBox() : HeadHome(user: user!),
            const SizedBox(
              height: 20,
            ),
            (loadingKategori) ? const SizedBox() :ListCategory(kategori: listKategori,apiService: apiService,),
            const SizedBox(
              height: 20,
            ),
            (loadingMenuTerlaris)
              ? const SizedBox()
              : (listMenuTerlaris!.isEmpty) ? const SizedBox(height: 0,) : Menus(
                title: 'Menu Terlaris',
                menu: listMenuTerlaris,
                apiService: apiService,
              ),
  
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            (loadingAllMenu)
              ? const CircularProgressIndicator()
              : AllMenus(
                menu: listAllMenu,
                apiService: apiService,
              ),
            
          ]),
        ),
      ),
    );
  }
}

class AllMenus extends StatelessWidget {
  const AllMenus({
    Key? key,
    required this.menu,
    required this.apiService
  }) : super(key: key);

  final List<Menu>? menu;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Semua Menu',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16,),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.4)
            ), 
            itemCount: menu?.length,
            itemBuilder: (_, index) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailItem(
                                idMenu: '${menu?[index].id_menu}',
                              )));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (menu![index].photo.isEmpty)
                    ? Image.asset(
                        'assets/images/bgsplash.png',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        ApiService.imageMenuUrl + '${menu?[index].photo}',
                        width: double.infinity,
                        height:120,
                        fit: BoxFit.fill,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: Text(menu![index].menu.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    )),
                    Text(
                      CurrencyFormat.convertToIdr(
                          int.parse(menu![index].harga), 0),
                      style: const TextStyle(
                          fontFamily: 'Satisfy',
                          fontSize: 18,
                          color: Color(0x99FFC107))),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  const ListCategory({Key? key, required this.kategori, required this.apiService}) : super(key: key);

  final List<Kategori>? kategori;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 18),
              ),
              InkWell(
                child:
                    const Text('Lihat Semua', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Category()));
                },
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            clipBehavior: Clip.none,
            itemCount: kategori?.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListItem(
                            title: '${kategori?[index].kategori}',
                            future: apiService.getMenuByIdKategori('${kategori?[index].id_kategori}')
                          )));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.network(
                          ApiService.imageKategoriUrl +'${kategori?[index].icon}',
                          height: 40,
                        ),
                        Text('${kategori?[index].kategori}', style: const TextStyle(fontSize: 12.0),)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Menus extends StatelessWidget {
  const Menus({
    Key? key,
    required this.title,
    required this.menu,
    required this.apiService
  }) : super(key: key);

  final String? title;
  final List<Menu>? menu;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(fontSize: 18),
              ),
              InkWell(
                child: const Text('Lihat Semua', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListItem(
                            title: title,
                            future: apiService.getMenuTerlaris(),
                          )));
                },
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: menu?.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                // height: 80,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailItem(
                              idMenu: '${menu?[index].id_menu}',
                            )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (menu![index].photo.isEmpty)
                        ? Image.asset(
                            'assets/images/bgsplash.png',
                            height: 120,
                            fit: BoxFit.cover,
                          ) :
                        Image.network(
                          ApiService.imageMenuUrl + '${menu?[index].photo}',
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal : 8.0),
                          child: Center(child: Text('${menu?[index].menu}',maxLines: 2, overflow: TextOverflow.ellipsis)),
                        )),
                        Text(CurrencyFormat.convertToIdr(int.parse(menu![index].harga), 0), style: const TextStyle(fontFamily: 'Satisfy', fontSize: 18, color: Color(0x99FFC107))),
                        const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HeadHome extends StatelessWidget {
  const HeadHome({
    Key? key,
    required this.user
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Selamat Datang, ${user.nama}',
                style: const TextStyle(fontSize: 18),
              ),
              const Text('Mau pesan apa hari ini?', style: TextStyle(fontSize: 18))
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/profile.png',
              height: 40,
              width: 40,
            ),
          )
        ],
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({ Key? key, required this.menuSearch }) : super(key: key);
  final List? menuSearch;

  @override
  Widget build(BuildContext context) {
    return menuSearch!.isEmpty ? const Center(child: Text('Tidak Ditemukan'))  : ListView.builder(
      shrinkWrap: true,
      itemCount: menuSearch?.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailItem(
                            idMenu: menuSearch?[index].id_menu.toString(),
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
                  (menuSearch![index].photo.isEmpty)
                    ? Image.asset(
                        'assets/images/bgsplash.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    :
                  Image.network(
                    ApiService.imageMenuUrl + menuSearch?[index].photo,
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
                            menuSearch?[index].menu,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:
                                const TextStyle( fontSize: 24),
                          ),
                          Text(
                              CurrencyFormat.convertToIdr(int.parse(menuSearch![index].harga), 0),
                              style: const TextStyle(
                                  fontFamily: 'Satisfy',
                                  fontSize: 24,
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
