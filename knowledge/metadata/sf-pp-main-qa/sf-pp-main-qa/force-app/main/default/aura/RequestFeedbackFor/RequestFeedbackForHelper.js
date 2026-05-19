({

    loadUsers: function (component) {
        let action = component.get('c.getUsers');
        let usersOptions = Array();
        let self = this;
        action.setParam('oppId', component.get('v.oppId'));
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let users = response.getReturnValue();
                users[2].Name = users[2].FirstName;
                component.set('v.users', users);
                let b=['YOU','Collector', 'Sales people'];
                let i = 0;

                users.forEach(element => {
                    let user = {
                        'label': element.Email,
                        'name': element.Name,
                        'value': element.Id,
                        'title': b[i],
                    };
                    usersOptions.push(user);
                    i++;
                });
                component.set('v.usersOptions', usersOptions);
                console.log(usersOptions);
                component.set('v.inputEmailWrite', usersOptions[0].label);
                component.set('v.opportunityOwner', usersOptions[0].name);
                let newAction = component.get('c.getOwnerId');
                newAction.setParam('oppid', component.get('v.oppId'));
                newAction.setCallback(this, function (response) {
                    if (response.getState() === 'SUCCESS') {
                        component.set('v.componentNotReady', false);
                        component.get('v.usersOptions').forEach(function (element, index) {
                            if (element.value == response.getReturnValue()) {
                                self.changeUser(component, index);
                            }
                        });
                    }
                });
                $A.enqueueAction(newAction);
            }
        });
        $A.enqueueAction(action);

    },
    getUserId: function (component) {
        console.log(component.get('v.settings'));
        let apiEndpoit = component.get('v.settings').API_Endpoint__c;
        const xhr = new XMLHttpRequest();
        xhr.open('GET', apiEndpoit + '/sfa/users/' + component.get('v.selectedUser').Email + '/email-delegate', true);
        console.log(apiEndpoit + '/sfa/users/' + component.get('v.selectedUser').Email + '/email-delegate');
        xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
        xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
        xhr.onreadystatechange = $A.getCallback(() => {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    console.log(xhr.response);
                    let user = JSON.parse(xhr.response).authorized;
                    console.log('<<USER_ID:'+JSON.parse(xhr.response).truvoice_user_id);
                    component.set('v.userId', JSON.parse(xhr.response).truvoice_user_id);
                }
            }
        });
        xhr.send();

    }
    ,
    loadContact: function (component, contactToEdit) {

        var action = component.get("c.getContact");
        action.setParam('id', contactToEdit);

        action.setCallback(this, response => {
            if (response.getState() === "SUCCESS") {
                let contact = response.getReturnValue();
                console.log('v.roleEEEEEEEEEEEEEEEEEEEEEEEE');
                console.log(contactToEdit);
                console.log(component.get('v.oppId'));

                let action = component.get('c.getContactRole');
                action.setParams({
                    'contactId': contactToEdit,
                    'oppId': component.get('v.oppId')
                });
                action.setCallback(this, response => {
                    console.log(response.getReturnValue());

                    if (response.getState() === "SUCCESS") {
                        component.set('v.role', response.getReturnValue());
                        component.set('v.Rl', component.get('v.role').Role);

                        console.log(response.getReturnValue());
                    }else {
                        console.log('FAIL');
                    }
                });
                $A.enqueueAction(action);
                component.set('v.editableContact', contact);
                component.find('firstname').set('v.value', contact.FirstName);
                component.find('lastname').set('v.value', contact.LastName);
                component.find('title').set('v.value', contact.Title);

                component.find('email').set('v.value', contact.Email);
                component.find('mobile').set('v.value', contact.MobilePhone);
                component.find('phone').set('v.value', contact.Phone);
                component.find('extension').set('v.value', contact.Phone_Extension__c);
                component.find('note').set('v.value', contact.pi__notes__c);//TODO : textarea size        
            }
        });
        $A.enqueueAction(action);
    },
    saveContact: function (component) {
        var action = component.get("c.updateContact");
        let contact = component.get('v.editableContact');

        console.log('1111111111111111' + component.get('v.role').OpportunityId);
        action.setParams({

            'lastName': component.find('lastname').get('v.value'),
            'firstName': component.find('firstname').get('v.value'),
            'id': contact.Id,
            'oppId': component.get('v.role').OpportunityId,
            'title': component.find('title').get('v.value'),
            'company_Rolec': component.get('v.Rl'),
            'email': component.find('email').get('v.value'),
            'mobilePhone': component.find('mobile').get('v.value'),
            'phone': component.find('phone').get('v.value'),
            'phone_Extensionc': component.find('extension').get('v.value'),
            'Pi_notesc': component.find('note').get('v.value'),
            'accountName': ''
        });
        action.setCallback(this, response => {
            if (response.getState() === "SUCCESS") {
                component.set('v.editVisible', false);
                component.set('v.newContact', false);
                component.set('v.messageVisible', true);
                component.set('v.notLoading', true);
                component.find('selCont').reload();
                const toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Saved!',
                    message: 'Contact saved succefully. '

                });
                toastEvent.fire();
            } else {
                const toastEvent = $A.get('e.force:showToast');

                component.set('v.editVisible', false);
                component.set('v.newContact', false);
                component.set('v.messageVisible', true);
                component.set('v.notLoading', true);
                component.find('selCont').reload();
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Somthing gone wrong.'

                });
                toastEvent.fire();

            }
        });
        $A.enqueueAction(action);

    },
    saveNewContact: function (component) {
        var action = component.get("c.insertContact");
        let contact = component.get('v.editableContact');
        action.setParams({

            'lastName': component.find('lastname').get('v.value'),
            'firstName': component.find('firstname').get('v.value'),
            'id': '',
            'oppId': component.get('v.oppId'),
            'title': component.find('title').get('v.value'),
            'company_Rolec': component.get('v.Rl'),
            'email': component.find('email').get('v.value'),
            'mobilePhone': component.find('mobile').get('v.value'),
            'phone': component.find('phone').get('v.value'),
            'phone_Extensionc': '',
            'isPrimary': component.get('v.radioValue'),
            'Pi_notesc': component.find('note').get('v.value'),
            'accountName': component.get('v.accLabelValue')
        });
        console.log('1111+' + component.get('v.oppId'));
        action.setCallback(this, response => {
            if (response.getState() === "SUCCESS") {
                component.set('v.editVisible', false);
                component.set('v.newContact', false);
                component.set('v.messageVisible', true);
                component.set('v.notLoading', true);
                component.find('selCont').reload();
                const toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Saved!',
                    message: 'Contact saved succefully. '

                });
                toastEvent.fire();
            } else {
                const toastEvent = $A.get('e.force:showToast');

                component.set('v.editVisible', false);
                component.set('v.newContact', false);
                component.set('v.messageVisible', true);
                component.set('v.notLoading', true);
                component.find('selCont').reload();
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Somthing gone wrong.'

                });
                toastEvent.fire();


            }
        });
        $A.enqueueAction(action);

    },
    getPicklistValues: function (component) {
        var action = component.get('c.getPickListValuesIntoList');
        action.setCallback(this, response => {
            if (response.getState() === "SUCCESS") {
                component.set('v.roles', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    },
    setOpportunityAndAccountNames: function (component) {

        var action = component.get('c.getOpportunityAndAccountNames');
        action.setParam('oppid', component.get('v.oppId'));
        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {
                component.set('v.oppLabelValue', response.getReturnValue()[0]);
                component.set('v.accLabelValue', response.getReturnValue()[1]);
            }
        });
        $A.enqueueAction(action);
    },

    getSettings: function (component) {
        var action = component.get('c.getSettings');
        let self = this;
        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {

                component.set('v.settings', response.getReturnValue());

            } else {
                const toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Cannot obtain TruSales App settings. ' + response.getError()[0].message,
                    type: 'error'
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    changeUser: function (component, value) {
        component.set('v.opportunityOwner', component.get('v.users')[value].Name);
        component.set('v.selectedUser', component.get('v.users')[value]);
        console.log(component.get('v.users')[value]);
        this.getUserId(component);
    },
    // submitContacts: function (component, contactsList) {
    //
    //     let apiEndpoit = component.get('v.settings').API_Endpoint__c;
    //     const xhr = new XMLHttpRequest();
    //     xhr.open('POST', apiEndpoit + '/rest/collectors/' + component.get('v.settings').Collector_id__c + '/contact/add', true);
    //     var action = component.get('c.getDataForContactSubmit');
    //     const userId = component.get('v.selectedUser').Id;
    //     const ctcList = contactsList.toString();
    //     action.setParams({
    //         oppId: component.get('v.oppId'),
    //         senderId: userId,
    //         contactList: ctcList
    //
    //     });
    //     action.setCallback(this, response => {
    //         if (response.getState() === 'SUCCESS') {
    //             console.log(response.getReturnValue());
    //             xhr.setRequestHeader('apikey', component.get('v.settings').TruVoice_API_Key__c);
    //             xhr.setRequestHeader('x-truvoice-client', component.get('v.settings').TruVoice_Client_ID__c);
    //             xhr.setRequestHeader('Content-Type', 'application/json');
    //             xhr.onreadystatechange = $A.getCallback(() => {
    //                 if (xhr.readyState == 4) {
    //                     console.log('<<<<<<FINISHED>>>>>>');
    //                     if (xhr.status == 200) {
    //                         component.set('v.successView', true);
    //                     } else {
    //                         console.log('<<<<<<<<<<<<<<<<<<<<<SERVER RESPONSE EROR>>>>>>>>>>>>>>>>>>>>>>>>');
    //                         console.log('status '+xhr.status);
    //                         console.log(xhr.response);
    //                         const toastEvent = $A.get('e.force:showToast');
    //                         toastEvent.setParams({
    //                             title: 'Error!',
    //                             message: 'Somthing gone wrong.' + JSON.parse(xhr.response).message
    //
    //                         });
    //                         toastEvent.fire();
    //                         component.set('v.failureView', true);
    //                     }
    //
    //                 }
    //
    //             });
    //             xhr.send(response.getReturnValue());
    //         }
    //     });
    //     $A.enqueueAction(action);
    //
    // },
    submitContacts:function(component,contactsList){
        component.set('v.componentNotReady',true);
        const apiEndpoit = component.get('v.settings').API_Endpoint__c;
        const url=apiEndpoit + '/rest/collectors/' + component.get('v.settings').Collector_id__c + '/contact/add';
        const header1=component.get('v.settings').TruVoice_API_Key__c;
        const header2=component.get('v.settings').TruVoice_Client_ID__c;

        var xhr=new XMLHttpRequest();
        var action = component.get('c.getDataForContactSubmit');
        const userId = component.get('v.selectedUser').Id;
        const ctcList = contactsList.toString();

        let jsonList=[];
        let respSucc=[];
        let respFail=[];

        function getRespObj(){
            let respObj={
                'last_name':'',
                'first_name':'',
                'email':'',
                'message':'',
                'contact_id':''
            };
            return respObj;
        }


        action.setParams({
            oppId: component.get('v.oppId'),
            senderId: userId,
            contactList: ctcList

        });

        function loopRequest(i,totalCount){
            if(i>=totalCount){return;}

            xhr.open('POST',url , true);
            xhr.setRequestHeader('apikey', header1);
            xhr.setRequestHeader('x-truvoice-client', header2);
            xhr.setRequestHeader('Content-Type', 'application/json');


            xhr.onreadystatechange=$A.getCallback(() =>{


                if(xhr.readyState==4){

                    if(xhr.status==200){
                        let curRespObj=getRespObj();
                        curRespObj.contact_id=JSON.parse(xhr.responseText).contact_id;
                        curRespObj.last_name=JSON.parse(xhr.responseText).last_name;
                        curRespObj.first_name=JSON.parse(xhr.responseText).first_name;
                        curRespObj.email=JSON.parse(xhr.responseText).email;
                        curRespObj.message='success submitted';
                        respSucc.push(curRespObj);

                        console.log('<<<<SUCCESS>>>>');
                        console.log('Contact ID:'+curRespObj.contact_id+' Name:'+curRespObj.last_name+' '+curRespObj.first_name+ ' STATUS:'+curRespObj.message);
                    }else{
                        let curRespObj=getRespObj();
                        curRespObj.message=JSON.parse(xhr.responseText).message;
                        curRespObj.last_name=JSON.parse(jsonList[i]).contact.last_name;
                        curRespObj.first_name=JSON.parse(jsonList[i]).contact.first_name;
                        curRespObj.email=JSON.parse(jsonList[i]).contact.email;
                        curRespObj.contact_id=JSON.parse(jsonList[i]).contact.contact_id;
                        respFail.push(curRespObj);

                        console.log('<<<<<<<<<<FAIL>>>>>>>');
                        console.log('Contact ID:'+curRespObj.contact_id+' Name:'+curRespObj.last_name+' '+curRespObj.first_name+ ' STATUS:'+curRespObj.message);
                    }

                    if(i==totalCount-1){
                        console.log('Fail: '+respFail.length);
                        console.log('SUCC: '+respSucc.length);
                        if(respFail.length==0){

                            console.log('<<<<SUCCESS VIEW>>>>');
                            component.set('v.successView', true);
                        }
                        else if(respSucc.length!=0 && respFail.length!=0){

                            let succNames=respSucc.map(item=>{
                               return `${item.first_name} ${item.last_name}`;
                            });

                            let failNames=respFail.map(item=>{
                                return `${item.first_name} ${item.last_name}`;
                            });

                            component.set('v.succSubContacts',succNames);
                            component.set('v.faileSubContacts',failNames);
                            component.set('v.countSubmitContacts',succNames.length.toString());
                            component.set('v.countFaileContacts',failNames.length.toString());

                            component.set('v.bothTypeView',true);




                        }else if(respFail.length!=0 && respSucc.length==0){
                            const toastEvent = $A.get('e.force:showToast');
                            let msg='';
                            respFail.forEach(item=>{
                                msg+='Contact Name:'+item.last_name+' '+item.first_name+ ', STATUS:'+item.message+';\n';
                            });
                            toastEvent.setParams({
                                title: 'Error!',
                                message: 'Somthing gone wrong. \n' + msg
                            });
                            toastEvent.fire();
                            component.set('v.failureView', true);
                        }
                        component.set('v.componentNotReady',false);
                    }

                    loopRequest(i+1,jsonList.length);
                }
            });
            xhr.send(jsonList[i]);
        }

        action.setCallback(this,response=>{
            if(response.getState()==='SUCCESS'){
                jsonList=response.getReturnValue();

                if(jsonList.length>0){
                    loopRequest(0,jsonList.length);
                }


            }
        });

        $A.enqueueAction(action);

    },

    translateContatcIdsToNames: function (component, selectedContacts) {
        var action = component.get("c.getConactNamesForIds");
        action.setParam('ids', selectedContacts);
        action.setCallback(this, response => {
            if (response.getState() === 'SUCCESS') {
                component.set("v.selectedContacts", response.getReturnValue());
                // component.set('v.successView', true);
            }
        });
        $A.enqueueAction(action);
    }
})