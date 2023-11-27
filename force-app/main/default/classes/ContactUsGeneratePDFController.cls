public without sharing class ContactUsGeneratePDFController {
    public String contactUsName { get; private set; }
    public String contactUsFirstName { get; private set; }
    public String contactUsLastName { get; private set; }
    public String contactUsPhone { get; private set; }
    public String contactUsCompanyName { get; private set; }
    public String contactUsAddressLineOne { get; private set; }
    public String contactUsAddressLineTwo { get; private set; }
    public String contactUsCity { get; private set; }
    public String contactUsState { get; private set; }
    public String contactUsZIP { get; private set; }
    public String contactUsCountry { get; private set; }
    public String contactUsComments { get; private set; }
	public Contact_Us__c contactUsOne { get; private set; }
    public ContactUsGeneratePDFController() {
        String contactUsId = ApexPages.currentPage().getParameters().get('id');
        if (contactUsId != null) {
            Contact_Us__c contactUs = [SELECT Name,First_Name__c,Last_Name__c,Phone__c,Company_Name__c,Address_Line1__c,Address_Line2__c,
                               City__c,Contact_Us_State__c,ZIP_Postal_Code__c,Contact_Us_Country__c,Provide_your_comments_and_or_questions__c
                               FROM Contact_Us__c WHERE Id = :contactUsId LIMIT 1];
            contactUsOne = contactUs;
            contactUsName = contactUs.Name;
            contactUsFirstName = contactUs.First_Name__c;
            contactUsLastName = contactUs.Last_Name__c;
            contactUsPhone = contactUs.Phone__c;
            contactUsCompanyName = contactUs.Company_Name__c;
            contactUsAddressLineOne = contactUs.Address_Line1__c;
            contactUsAddressLineTwo = contactUs.Address_Line2__c;
			contactUsCity = contactUs.City__c;
            contactUsState = contactUs.Contact_Us_State__c;
            contactUsZIP = contactUs.ZIP_Postal_Code__c;
            contactUsCountry = contactUs.Contact_Us_Country__c;
            contactUsComments = contactUs.Provide_your_comments_and_or_questions__c;
        }
    }
}