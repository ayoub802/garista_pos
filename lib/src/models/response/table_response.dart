import '../data/table_data.dart';

class TableResponse {
  List<TableData>? data;

  TableResponse({this.data});

  // Updated to handle a plain list of TableData
  TableResponse.fromJson(List<dynamic> json) {
    data = List<TableData>.from(json.map((x) => TableData.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = List<dynamic>.from(this.data!.map((x) => x.toJson()));
    }
    return data;
  }
}
