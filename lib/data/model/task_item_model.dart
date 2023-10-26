class TaskItemModel {
  final String nameTask;
  final String linkAvtCreator;
  final String linkAvtReciver;
  final String date;
  final int status;
  TaskItemModel(
      {required this.nameTask,
      required this.linkAvtCreator,
      required this.linkAvtReciver,
      required this.date,
      required this.status});
}
