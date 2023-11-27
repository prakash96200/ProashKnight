public class newEmailInvokable {
    @InvocableMethod(label='SendEmail')
    public static void sendEmailFromFlow(List<String> contacts) {
       /* Contact contact = [Select id,Email,AccountId from Contact where id =:contacts[0]];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {contact.Email});
        //mail.setHtmlBody('Congratulations !!!');
        mail.setTemplateID('00X5g000000qUU6');
        mail.setTargetObjectId(contact.id);
        mail.setWhatId(contact.AccountId);
        mail.setSaveAsActivity(true);
        Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail});*/
                                            
     }
    
}