import 'package:flutter_note_app/domain/util/order_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'note_order.freezed.dart';

@freezed
sealed class NoteOrder with _$NoteOrder {
  const factory NoteOrder.title(OrderType orderType) = NoteOrderTitle;
  const factory NoteOrder.date(OrderType orderType) = NoteOrderDate;
  const factory NoteOrder.color(OrderType orderType) = NoteOrderColor;
}
