public class AccountOTP {
    
    @InvocableMethod(label='Account OTP')
    public  static List<Integer> generateOTP(){
        try {
           Integer otp = (Integer)Math.floor(Math.random() * 9000) + 1000;
            return new List<Integer>{otp};
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}