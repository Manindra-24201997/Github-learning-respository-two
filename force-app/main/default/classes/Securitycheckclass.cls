public class Securitycheckclass {
    
    public static void method1(){
        List<Sample_Object_1__c> sobj1 = [SELECT Id,name,Cost__c FROM Sample_Object_1__c WITH SECURITY_ENFORCED];
        system.debug('sobj1 === '+sobj1.size()); 
    }
    
    /*public static void method2() {
    List<Sample_Object_1__c> sobj1 = [SELECT Id, Name, Cost__c FROM Sample_Object_1__c];
    System.debug('sobj1 === ' + sobj1.size());
    SObjectAccessDecision sad = Security.stripInaccessible(
        Security.AccessType.READABLE, 
        sobj1
    );
    for (Sample_Object_1__c sobrcd : (List<Sample_Object_1__c>)sad.getRecords()) {
        System.debug('Safe Name: ' + sobrcd.Name); 
        System.debug('Safe Cost: ' + sobrcd.Cost__c); // may be null if not accessible
    }
}*/

}