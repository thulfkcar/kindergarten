import 'package:kid_garden_app/domain/Child.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : status = Status.LOADING;
  ApiResponse.empty() : status = Status.Empty;

  ApiResponse.non() : status = Status.NON;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.loadingNextPage() : status = Status.LOADING_NEXT_PAGE;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }

}

enum Status { LOADING, COMPLETED, ERROR, LOADING_NEXT_PAGE ,NON,Empty}
