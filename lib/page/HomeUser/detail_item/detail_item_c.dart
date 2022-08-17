import '../../../services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailItemC {
  addKeranjang({String? idUser, String? idMenu, String? qty}) async {
    final res = await ApiService()
        .addKeranjang(idMenu: idMenu, idUser: idUser, qty: qty);
    if (res['success'] == false) {
      Fluttertoast.showToast(
          msg: res[
              'message']); 
    } else {
      Fluttertoast.showToast(msg: res['message']);

    }
    
    return res['success'];
  }
}