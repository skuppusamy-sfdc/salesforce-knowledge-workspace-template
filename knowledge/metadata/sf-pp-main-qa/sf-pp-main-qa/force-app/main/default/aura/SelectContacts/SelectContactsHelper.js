({
    loadContacts : function(component) {
        var filterValue = component.get('v.filterValue');
        var action = component.get('c.getAccountContacs');
        console.log(component.get('v.opportunityId'));
        action.setParam('oppId' , component.get('v.opportunityId'));
        action.setParam('filterValue' , filterValue);
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {                
                var users = response.getReturnValue();                
                var values = [];
                users.forEach(element => {
                    let value = {'label':element.Name, 'value':element.Id};
                    values.push(value);

                });
                component.set('v.accContacts', values);
               
           }

        });
        $A.enqueueAction(action);
        var newAction = component.get("c.getOppotrunityContacts");
        //newAction.setParam('oppId', component.get('v.opportunity').Id);
        newAction.setParam('oppId', component.get('v.opportunityId'));
        newAction.setParam('filterValue' , filterValue);
        newAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {                
                var users = response.getReturnValue();
                var values = [];
                console.log(users.length);
                users.forEach(element => {
                    let value = {'label':element.Name, 'value':element.Id};
                    values.push(value);

                });
                component.set('v.oppContacts', values);
                
            }

        });
        $A.enqueueAction(newAction);

    },
    changeContact:function (component) {
        component.getEvent('EditContact').fire();
    }

})