import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:rflutter_alert/rflutter_alert.dart';


class ResnetScreen extends StatefulWidget {
  static String routeName = 'ResnetScreen';

  @override
  _ResnetScreenState createState() => _ResnetScreenState();
}

class _ResnetScreenState extends State<ResnetScreen> {

  @override
  void initState() {
    super.initState();
  }

  File? _image;

  final url = Uri.parse("https://resnet-service-dannaluisa.cloud.okteto.net/v1/models/resnet:predict");
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  Future getImage(ImageSource source) async {
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image == null ) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);


      File file = File(image.path);
      List<int> fileInByte = file.readAsBytesSync();
      String fileInBase64 = base64Encode(fileInByte);
      uploadImage(fileInBase64);

      setState(() {
        this._image = imagePermanent;


      });
    }on PlatformException catch (e){
      print("Falló al obtener recursos de las imagenes: $e");
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/${name}');


    return File(imagePath).copy(image.path);
  }




  Future<void> uploadImage(base64) async {

    showDialog(
        context:  this.context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        }
    );

    try {

      final prediction_instance = {
        "instances" : [
          {
            "b64": "$base64"
          }
        ]
      };

      final res = await http.post(url, headers: headers, body: jsonEncode(prediction_instance));
      //print(jsonEncode(prediction_instance));



      if (res.statusCode == 200) {
        Navigator.pop(this.context);
        final json_prediction = jsonDecode(res.body);

        String clases_prediction = json_prediction['predictions'][0]['classes'].toString();

        final value = await rootBundle.loadString('assets/datos/imagenet_class_index.json');
        var datos = json.decode(value);
        var class_result_prediction = datos[clases_prediction.toString()][1];
        var result_prediction = datos[clases_prediction.toString()];


        Alert(
          context: this.context,
          type: AlertType.success,
          title: "¡Predicción Realizada!",
          desc: "ID:$clases_prediction\nResultado: $class_result_prediction",
          buttons: [
            DialogButton(
              child: Text(
                "Confirmar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(this.context),
              color: Colors.purple,
              width: 120,
            )
          ],
        ).show();

      }else{
        Navigator.pop(this.context);
        Alert(
          context: this.context,
          type: AlertType.error,
          title: "Error",
          desc: "Ocurrió un error al mandar la imagen",
          buttons: [
            DialogButton(
              child: Text(
                "Confirmar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(this.context),
              color: Colors.purple,
              width: 120,
            )
          ],
        ).show();

      }

    } catch (e) {
      Navigator.pop(this.context);
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Color(0xFF911EDE),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            // FAB 1
            SpeedDialChild(
                child: Icon(Icons.camera_alt_rounded, color: Colors.white),
                backgroundColor: Color(0xFFB754F5),
                onTap: () {
                  getImage(ImageSource.camera);
                },
                label: 'Camara',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFFB754F5)),
            // FAB 2
            SpeedDialChild(
                child: Icon(Icons.folder, color: Colors.white),
                backgroundColor: Color(0xFFC475F5),
                onTap: () {
                  setState(() {
                    getImage(ImageSource.gallery);
                  });
                },
                label: 'Galeria',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFFC475F5))
          ],
        ),
        body: Column(
          children: [

            Container(
              width: 100.w,
              height: 15.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resnet',
                          style: Theme.of(context).textTheme.subtitle1),
                      Text('Mande una imagen para predecir',
                          style: Theme.of(context).textTheme.subtitle2),
                      sizedBox,
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,

                  borderRadius: kTopBorderRadius,
                ),
                child:
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 50,),

                        SizedBox(height: 60,),
                        _image != null ? Image.file(_image!, width: 300, height: 400, fit: BoxFit.cover,) :
                        Image.asset('assets/images/gallery_icon.jpg'),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
