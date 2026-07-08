/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Model.Service;

import java.util.List;

/**
 *
 * @author PC
 */
public interface Accessible<T> {

    void close();

    int insertRec(T obj);

    int updateRec(T obj);

    int deleteRec(T obj);

    T getObjectById(String id);

    List<T> listAll();
}
