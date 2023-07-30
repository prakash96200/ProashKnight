global class LeadManager {
    webservice static string createLead(string name, string company, string email){
        try{
        Lead l = new Lead();
        l.LastName = name;
        l.Company = company;
        l.Email = email;
        insert l;
            return l.id;
        }catch(Exception e){
            return 'error';
        }
    }
}