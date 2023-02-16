public with sharing class optingOutFormController {

    @AuraEnabled
    public static void updateSObjects(CustomWrapper wrapper) {

        System.debug('Wrapper Obj');
        System.debug(JSON.serialize(wrapper));

        String emailString = wrapper.email;

        List<Lead> leadsToUpdate = new List<Lead>();
        List<Lead> matchedLeads = [SELECT Id, Name, Email FROM Lead WHERE Email = :emailString];

        if (matchedLeads.isEmpty()) {

            lead newLead = new lead();
            newLead.Email = wrapper.email;
            newLead.FirstName = wrapper.firstName;
            newLead.LastName = wrapper.LastName;
            newLead.company = wrapper.company;
            newLead.Description = wrapper.description;
            newLead.Status = 'New';
            System.debug('Before inserting the new Lead');
            insert newLead;

        } else {

            for (Lead l : matchedLeads) {
                l.Description = wrapper.description;
                leadsToUpdate.add(l);
            }
        }

        update leadsToUpdate;

    }
}