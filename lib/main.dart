import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // late ArCoreController arCoreController;

  void onArCoreViewCreated(ArCoreController controller) async{
    // arCoreController = controller;
    // arCoreController.onNodeTap = (name) => onTapHandler(name);
    // arCoreController.onPlaneTap = _handleOnPlaneTap;
     _addEarth(controller);
  }

  void _addEarth(ArCoreController controller) async{

    final moonMaterial = ArCoreMaterial(color: Colors.grey);

    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');

    final earthMaterial = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    final earth = ArCoreNode(
        shape: earthShape,
        children: [moon],
        position: vector.Vector3(0, 0, 0),
        );

    controller.addArCoreNode(earth);


  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  // void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) async {
  //   final hit = hits.first;

  //   final moonMaterial = ArCoreMaterial(color: Colors.grey);

  //   final moonShape = ArCoreSphere(
  //     materials: [moonMaterial],
  //     radius: 0.03,
  //   );

  //   final moon = ArCoreNode(
  //     shape: moonShape,
  //     position: vector.Vector3(0.2, 0, 0),
  //     rotation: vector.Vector4(0, 0, 0, 0),
  //   );

  //   final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');

  //   final earthMaterial = ArCoreMaterial(
  //       color: Color.fromARGB(120, 66, 134, 244),
  //       textureBytes: textureBytes.buffer.asUint8List());

  //   final earthShape = ArCoreSphere(
  //     materials: [earthMaterial],
  //     radius: 0.1,
  //   );

  //   final earth = ArCoreNode(
  //       shape: earthShape,
  //       children: [moon],
  //       position: hit.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
  //       rotation: hit.pose.rotation);

  //   controller.addArCoreNodeWithAnchor(earth);
  // }

  void _addCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return ArCoreView(
        enableTapRecognizer: true, onArCoreViewCreated: onArCoreViewCreated);
  }
}
