public class MyScheduledClass1 implements Schedulable {
  public void execute(SchedulableContext sc) {
        // The actual logic you want to run on a schedule
        System.debug('Scheduled Job is running now!');
    }
}