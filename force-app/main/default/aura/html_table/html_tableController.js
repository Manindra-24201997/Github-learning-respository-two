// ContactListController.js
({
    searchContacts: function(component, event, helper) {
        var searchKeyword = component.get("v.searchKeyword");
        // Call the server-side controller method to retrieve contacts based on the search keyword
        var action = component.get("c.getContacts");
        action.setParams({ searchKeyword: searchKeyword });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            } else {
                console.error("Error fetching contacts");
            }
        });

        $A.enqueueAction(action);
    }
})