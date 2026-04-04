public class Futureclass {
    // The Future method. Must be static, return void, and only accept primitives.
    @future
    public static void startAsynchronousProcess(String inputData) {
        
        System.debug('Future Method started. Input: ' + inputData);
        
        // 1. Create an instance of the Queueable class
        String queueableMessage = 'Data processed by Future method: ' + inputData;
        MyQueueableJob1 job = new MyQueueableJob1(queueableMessage);
        
        // 2. Enqueue the Queueable job
        // This is the critical step that links the two asynchronous processes.
        Id jobId = System.enqueueJob(job);
        
        System.debug('Queueable Job ID enqueued: ' + jobId);
        
        // REMINDER: You can only call System.enqueueJob() once from an
        // executing asynchronous method (like a @future method).
    }
    
    @future
    public static void attemptToSchedule() {
        // Attempting to schedule a job from a future method is NOT allowed
        
        // Assume 'MyScheduledClass1' implements Schedulable
        MyScheduledClass1 sch = new MyScheduledClass1();
        
        // This line will cause a runtime error (System.AsyncException)
        // because an asynchronous method cannot call System.schedule().
        String jobId = System.schedule('Scheduled Job from Future', '0 0 1 * * ?', sch); 
        
        // The error will prevent execution from proceeding.
    }
}