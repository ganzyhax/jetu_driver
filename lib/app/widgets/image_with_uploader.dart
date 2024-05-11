import 'dart:developer';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:uuid/uuid.dart';

class ImageCardWithUploader extends StatefulWidget {
  final Function(File?) selectedFile;
  String userImage;

  ImageCardWithUploader({
    Key? key,
    required this.userImage,
    required this.selectedFile,
  }) : super(key: key);

  @override
  State<ImageCardWithUploader> createState() => _ImageCardWithUploaderState();
}

class _ImageCardWithUploaderState extends State<ImageCardWithUploader> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(source: source, maxWidth: 1920);
      if (pickedImage == null) return;
      final String fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);
      setState(() {});
      widget.selectedFile.call(imageFile);
    } catch (err) {
      log('err: $err');
    }
  }

  showImageSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(16),
          right: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Выберите способ добавления фото",
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  title: const Text("Сфотографировать"),
                  trailing: const Icon(Icons.photo_camera_outlined),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  title: const Text("Загрузить из галереи"),
                  trailing: const Icon(Icons.photo_library_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pickPhotoArea(context),
        // photoType(
        //   isUploaded: imageFile != null,
        // ),
      ],
    );
  }

  Widget pickPhotoArea(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            onTap: () {
              showImageSelectionBottomSheet(context);
            },
            child: SizedBox(
              height: 56,
              width: 56,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: imageFile != null
                    ? Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: FileImage(imageFile!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      )
                    : (widget.userImage == 'null')
                        ? Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/jetu_logo.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )
                        : Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: NetworkImage(widget.userImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          ),
              ),
            ),
            // TextButton(
            //     onPressed: () => showImageSelectionBottomSheet(context),
            //     child: const Text('Загрузить фото'),
            //   ),
          ),
        ));
  }

  Widget photoType({
    bool isUploaded = false,
  }) {
    return isUploaded
        ? TextButton(
            onPressed: () {
              setState(
                () => imageFile = null,
              );
              widget.selectedFile.call(imageFile);
            },
            child: const Text(
              "🗑️ Удалить",
              style: TextStyle(
                color: AppColors.red,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

Future<void> uploadImage(File file, {String driverId = ''}) async {
  print(driverId);
  try {
    final auth = NhostAuthClient(
      url: "https://elmrnhqzybgkyhthobqy.auth.eu-central-1.nhost.run/v1",
    );

    final storage = NhostStorageClient(
      url: 'https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1',
      session: auth.userSession,
    );
    final res = await auth.signInEmailPassword(
      email: 'user-1@nhost.io',
      password: 'password-1',
    );

    final imageResponse = await storage.uploadBytes(
      fileName: '${Platform.operatingSystem}_${getUniqueValue()}',
      fileContents: await file.readAsBytes(),
      mimeType: 'image/jpeg',
      bucketId: 'driver_documents',
    );

    String imageLink =
        "https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1/files/${imageResponse.id}";

    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserImage()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "driverId": driverId,
        "avatar_url": imageLink,
      },
    );
    final client = await GraphQlService.init();
    final ress = await client.value.mutate(options);
    log(ress.data.toString());
    print("uploadPhone: ${ress.exception}");
  } catch (err) {
    print('image err: $err');
  }
}

String getUniqueValue() {
  var uuid = const Uuid();
  return uuid.v1();
}
