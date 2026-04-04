public with sharing class ExploreCustomAccountController {

    @AuraEnabled(cacheable=true)
    public static List<account> getAccounts(String searchText) {
        String searchString = '%' + searchText + '%';
        List<Account> acts = [SELECT Id, Name FROM Account WHERE name like: searchString];
        return acts;

    }
}