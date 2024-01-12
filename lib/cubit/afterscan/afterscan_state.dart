part of 'afterscan_cubit.dart';

@immutable
abstract class AfterscanState {}

class AfterscanIntial extends AfterscanState {}

class AfterscanLoading extends AfterscanState {}

class AfterscanSuccess extends AfterscanState {
  final String? contentPath;
  AfterscanSuccess(this.contentPath);
}

class AfterscanFailed extends AfterscanState {
  final String? msg;

  AfterscanFailed(
    this.msg,
  );
}
