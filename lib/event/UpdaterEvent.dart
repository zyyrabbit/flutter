enum Status {
  Start,
  Running,
  Done
}

class UpdaterEvent {
  final Status status;
  final int progress;
  UpdaterEvent(this.status, this.progress);
}