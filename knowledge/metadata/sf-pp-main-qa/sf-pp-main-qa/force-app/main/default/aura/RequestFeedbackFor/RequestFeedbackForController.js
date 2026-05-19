({
    doInit : function(component, event, helper) {
        helper.loadUsers(component);
        helper.getSettings(component);
        helper.getPicklistValues(component);
        helper.setOpportunityAndAccountNames(component);

    },
    openEvent :function (component, event) {
        component.set('v.opportunityId', event.getParam('opportunityId'));
        console.log('11111' + event.getParam('opportunityId'));
        component.find('selCont').set('v.opportunityId', event.getParam('opportunityId'));
    },
    // handleEvent : function(component, event, helper) {
    //     let selCont = component.find('selCont');
    //     component.set('v.submitDisabled', true);
    //     if  (selCont.get('v.OppContactsValue').concat(selCont.get('v.AccContactsValue')).length>0) {
    //         component.set('v.submitDisabled', false);
    //     }
    // },

    hideModalSuccessView :function (component, event, helper) {
        component.set('v.successView', false);
    },
    hideModalFailureView :function (component, event, helper) {
        component.set('v.failureView', false);

        let listContactForCompare=component.get('v.listContactForCompare');
        listContactForCompare.length=0;
        component.set('v.listContactForCompare',listContactForCompare);
    },
    hideModalBothView:function(component,event,handler){
        component.set('v.bothTypeView',false);

        let listContactForCompare=component.get('v.listContactForCompare');
        listContactForCompare.length=0;
        component.set('v.listContactForCompare',listContactForCompare);
    },
    inputEmailClick:function(component){
        document.getElementById('combobox').style.visibility = 'visible';
    },
    userChanged : function(component, event, helper) {
        // var value = event.getParam('value');
        document.getElementById('combobox').style.visibility = 'hidden';
        let id = event.target.id;
        let name = event.target.name;
        component.set('v.opportunityOwner', name);
        component.set('v.inputEmailWrite', id);
        component.get('v.usersOptions').forEach(function (element, index)  {
            if (element.name === name) {
                helper.changeUser(component, index);
            }
        });
    },
    ondragleave :function() {
        document.getElementById('combobox').style.visibility = 'hidden';
    },
    handleNewContactEvent :function(component, event, helper) {
        component.set('v.newContact', true);
        component.set('v.messageVisible', false);
    },
    // handleEditContactEvent : function(component, event, helper) {
    //     component.set('v.editVisible', true);
    //     component.set('v.messageVisible', false);
    //     let selCont = component.find('selCont');
    //     var contactToEdit = selCont.get('v.OppContactsValue').concat(selCont.get('v.AccContactsValue'))[0];
    //     helper.loadContact(component, contactToEdit);
    //
    // },
    handleEditContactEvent : function(component, event, helper) {
        component.set('v.editVisible', true);
        component.set('v.messageVisible', false);

        let selCont = component.find('selCont');
        let listForCompare=component.get('v.listContactForCompare');
        let arr=selCont.get('v.OppContactsValue').concat(selCont.get('v.AccContactsValue'));
        let curContact;

        console.log('<<<ONCHANGE>>>'+arr);
        if(listForCompare.length==0){
            listForCompare.push(arr[0]);
            helper.loadContact(component, arr[0]);
            component.set('v.listContactForCompare',listForCompare);

        }else if(listForCompare.length<arr.length){

            curContact=arr.filter(item=>{
                return listForCompare.indexOf(item)==-1;
            });
            listForCompare.push(curContact[0]);
            helper.loadContact(component, curContact[0]);
            component.set('v.listContactForCompare',listForCompare);

        }else if(listForCompare.length>arr.length && arr.length>=1)
            {
            curContact=listForCompare.filter(item=>{
               return arr.indexOf(item)==-1;
            });
            let index=listForCompare.findIndex((item)=>{
                return item==curContact;
            })
            listForCompare.splice(index,1);
            helper.loadContact(component,curContact[0]);
            component.set('v.listContactForCompare',listForCompare);
        }else{
            curContact=listForCompare[0];
            helper.loadContact(component,curContact);
            listForCompare.length=0;
            component.set('v.listContactForCompare',listForCompare);
        }


    },
    editContact : function(component, event, helper) {

    },
    saveContact : function(component, event, helper) {

        component.set('v.notLoading', false);
        helper.saveContact(component);
        
    },
    saveNewContact :function(component, event, helper) {
        component.set('v.notLoading', false);
        helper.saveNewContact(component);
    },
    cancelEditOrNew :function(component, event, helper) {
        component.set('v.editVisible', false);
        component.set('v.newContact', false);
        component.set('v.messageVisible', true);
    },
    submitContacts : function(component, event, helper) {
        var contactsList = component.find('selCont').get('v.OppContactsValue').concat(component.find('selCont').get('v.AccContactsValue'));
        if(contactsList.length!=0){
            helper.translateContatcIdsToNames(component, contactsList);
            console.log(JSON.parse(JSON.stringify(contactsList)));
            helper.submitContacts(component, contactsList);
        }else{
            component.set('v.messageVisible',true);
        }
    },
    onRequiredFieldsChange:function(component, event, helper){
        if ((component.find('lastname').get('v.value').length>0)&&(component.find('firstname').get('v.value').length>0)&&(component.find('email').get('v.value').length>0)) 
        component.set('v.addContactDisabled', false); else component.set('v.addContactDisabled', true);
    },
    doneClicked : function(component, event, helper) {
        component.set('v.successView', false);
        let endpoint=component.get('v.settings').API_Endpoint__c+'/sales-profiles/'+component.get('v.settings').Initiative_id__c+'/'+component.get('v.userId');
        window.open(endpoint);
        //window.open(component.get('v.settings').API_Endpoint_Profiles__c+component.get('v.settings').Initiative_id__c +'/' + component.get('v.userId'));
        console.log('<<<API_Endpoint__c final url >>>');
        console.log(endpoint);
        let closerReq=component.getEvent('handleCloseReqFeedback');
        closerReq.fire();
    },
    failBothViewClick:function (component,event,helper) {
        component.set('v.bothTypeView',false);
    },
    doneBothViewClick:function (component,event,helper) {
        component.set('v.bothTypeView',false);
        let endpoint=component.get('v.settings').API_Endpoint__c+'/sales-profiles/'+component.get('v.settings').Initiative_id__c+'/'+component.get('v.userId');
        window.open(endpoint);
        console.log('<<<API_Endpoint__c final url >>>');
        console.log(endpoint);
        let closerReq=component.getEvent('handleCloseReqFeedback');
        closerReq.fire();
    },
    inputEmailWrite: function(component, event) {
        let inputEmailWrite = event.target.closest('a');
        component.set('v.inputEmailWrite',inputEmailWrite.id);
    }
    
})