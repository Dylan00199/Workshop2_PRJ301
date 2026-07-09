package Model.Service;

import Model.Account;
import Utilities.PasswordUtils;
import java.util.Date;

public class run {

    public static void main(String[] args) {
        // TODO code application logic here
        Date dob = new Date();
        String hashedPass = PasswordUtils.hash("DuyAnh01345");

        Account obj = new Account("phamAnh@gmail.com", "DuyAnh01345", "leo", "pham", dob, true, "0352053555", true, 3);
        AccountService as = new AccountService();
        int result = as.deleteRec(obj);
        System.out.println(result);
    }

}
