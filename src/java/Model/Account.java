/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "accounts")
public class Account {

    @Id
    @Column(name = "account")
    private String account;
    @Column(name = "pass")
    private String pass;
    @Column(name = "firstName")
    private String firstname;
    @Column(name = "lastName")
    private String lastname;
    @Column(name = "birthday")
    private Date dob;
    @Column(name = "gender")
    private boolean gender;
    @Column(name = "phone")
    private String phone;
    @Column(name = "isUse")
    private boolean isUse;
    @Column(name = "roleInSystem")
    private int roleInSystem;

    public Account() {
    }

    public Account(String account, String pass, String firstname, String lastname, Date dob, boolean gender, String phone, boolean isUse, int roleInSystem) {
        this.account = account;
        this.pass = pass;
        this.firstname = firstname;
        this.lastname = lastname;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.isUse = isUse;
        this.roleInSystem = roleInSystem;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isUse() {
        return isUse;
    }

    public void setIsUse(boolean isUse) {
        this.isUse = isUse;
    }

    public int getRoleInSystem() {
        return roleInSystem;
    }

    public void setRoleInSystem(int roleInSystem) {
        this.roleInSystem = roleInSystem;
    }

    @Override
    public String toString() {
        return "Account{" + "account=" + account + ", pass=" + pass + ", firstname=" + firstname + ", lastname=" + lastname + ", dob=" + dob + ", gender=" + gender + ", phone=" + phone + ", isUse=" + isUse + ", roleInSystem=" + roleInSystem + '}';
    }

}
