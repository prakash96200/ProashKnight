public class AccountListController {

    @AuraEnabled
    public static Account fetchAccts(id accId) {

        Account acc = [ SELECT Id, Name, Industry, Type,number__c FROM Account where id=:accId ];
        System.debug('Account'+acc);
    return acc;

    }
    @InvocableMethod
    public static void accountChange(List<Account> newAccounts) {
        for(Account newAccount: newAccounts){
            if(newAccount.Phone == null){
                newAccount.Phone = '9159595714';
            }
        }
        update newAccounts;
    }
    @AuraEnabled
    public static void generatePdf(String webOrderJSON,string DisId){
        Id newcontentDocId;
        Contentversion cv = new Contentversion();
        cv.Title = DisId+'.pdf';
        cv.PathOnClient = 'test3';               
        String pdfContent = webOrderJSON;
        cv.VersionData = blob.toPDF(pdfContent);
        system.debug(pdfContent);
        generate();
        
    }
    public static Pagereference generate(){
        String pageURL ='https://aspire67-dev-ed--c.vf.force.com/apex/newDownload';
        Pagereference downloadPDFPage = new Pagereference(pageURL);
        downloadPDFPage.getHeaders().put ('content-disposition', 'attachment; filename-downloadPDFPage.pdf');
        return downloadPDFPage;
    }
}