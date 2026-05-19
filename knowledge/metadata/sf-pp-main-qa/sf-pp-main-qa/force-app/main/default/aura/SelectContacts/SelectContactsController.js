({
    doInit : function(component, event, helper) {
        helper.loadContacts(component);

    },
    filterContacts :  function(component, event, helper) {
        helper.loadContacts(component);
       
        
    },
    
     // fireEvent : function(component, event, helper) {
     //    if ((component.get('v.OppContactsValue').length >0)||(component.get('v.AccContactsValue').length>0)) {
     //        component.getEvent('CheckBoxChanged').fire();
     //        component.set('v.editDisabled', false);
     //    } else component.set('v.editDisabled', true);
     //
     //
     //
     // },

    fireEvent:function(component, event, helper){
        let changeCheckbox=component.getEvent('CheckBoxChanged');
        helper.changeContact(component);
        changeCheckbox.fire();
    },

      addContact: function(component, event, helper) {
          component.getEvent('NewContactAdd').fire();

      },
      editContact :function(component, event, helper) {
          helper.changeContact(component);
      }
    
})