package com.realestate.portal.service;

import com.realestate.portal.model.User;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LoginService {
    private final String FILE_PATH = "users.txt";

    public User authenticate(String inputUser, String inputPass) {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {

                String[] data = line.split(",");
                if (data[0].equals(inputUser) && data[1].equals(inputPass)) {
                    return new User(data[0], data[1], data[2]);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading users file: " + e.getMessage());
        }
        return null;
    }
}