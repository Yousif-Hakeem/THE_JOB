import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  static FavouriteCubit get(context) => BlocProvider.of(context);

  Future<void> shareImageFromApi({
    required String imageUrl,
    required String text,
    required String subject,
  }) async {
    final response = await http.get(Uri.parse(imageUrl));

    final tempDir = await getTemporaryDirectory();

    const tempFileName = 'image.png';
    final tempFile = File('${tempDir.path}/$tempFileName');

    await tempFile.writeAsBytes(response.bodyBytes);

    // Share the temporary image file using Share.shareXFiles.
    await Share.shareXFiles([XFile(tempFile.path)],
        subject: subject, text: text);

    // Delete the temporary image file.
    await tempFile.delete();
  }
}
