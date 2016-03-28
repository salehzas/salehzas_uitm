package assignment_1_java;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import static java.nio.charset.StandardCharsets.UTF_8;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

   
   public class Assignment_1_Java {

    private static final Charset UTF_8 = Charset.forName("UTF-8");
    public static void main(String[] args) throws FileNotFoundException {
        FileWriter out = null;
        String name;
        String address;
        Scanner in = new Scanner(System.in);
        
        System.out.println("Your name: ");
        name = in.nextLine();
        
        System.out.println("Address: ");
        address = in.nextLine();
        
        
        //==============================================================
        
        try {
            out = new FileWriter("Yourname.txt");
            out.write("Yourname is: "+name);
            out.write(System.lineSeparator());
            out.write("Address: "+address);
            out.close();
        } catch (IOException ex) {
            Logger.getLogger(assignment_1_java.class.getName()).log(Level.SEVERE, null, ex);
        }
        //==============================================================
        
        File text_file = new File("Yourname.txt");
        
        Scanner POOL = new Scanner(text_file);
        String B2S = "";
        
        while(POOL.hasNextLine()){
            String line = POOL.nextLine();
            byte[] bytes = line.getBytes(UTF_8);
            for(byte b : bytes){
                B2S += Integer.toBinaryString(b & 127 | 128).substring(1);
            }
            B2S += System.lineSeparator();
        }
        //=============================================================
        try {
            out = new FileWriter("Yourname.bin");
            out.write(B2S);
            out.close();
        } catch (IOException ex) {
            Logger.getLogger(assignment_1_java.class.getName()).log(Level.SEVERE, null, ex);
        }
        //=============================================================
        File bin_file = new File("Yourname.bin");
        
        Scanner POOL2 = new Scanner(bin_file);
        
        String S2B = "";
        while(POOL2.hasNextLine()){
            String line = POOL2.nextLine();
            int interval = 7;
            int arrayLength = (int) Math.ceil(((line.length()/(double)interval)));
            String[] result = new String[arrayLength];
            
            int B = 0;
            int last_index = result.length - 1;
            for(int C = 0; C<=last_index; C++){
                result[C] = line.substring(B, B+interval);
                S2B +=  (char)Integer.parseInt( result[C], 2 );
                B += interval;
            }
            result[last_index] = line.substring(B);
            S2B += System.lineSeparator();
        }
        //============================================================
        try {
            out = new FileWriter("Last.txt");
            out.write(S2B);
            out.close();
        } catch (IOException ex) {
            Logger.getLogger(assignment_1_java.class.getName()).log(Level.SEVERE, null, ex);
        }
    
  
    }
    
}

// credit to syafiq.jalil for helping me on this