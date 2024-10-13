import '../core/constants/app_constants.dart';
import '../core/handlers/api_result.dart';
import '../models/models.dart';
import '../models/response/gallery_upload_response.dart';

abstract class GalleryRepositoryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
      String file,
      UploadType uploadType,
      );

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
      List<String?> filePaths,
      UploadType uploadType,
      );
}
