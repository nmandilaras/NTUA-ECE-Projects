package noSpark;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Test {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String userName;
	    BufferedReader reader = new BufferedReader(new FileReader("/home/nickiemand16/hundrendk.txt"));
		//BufferedReader reader = new BufferedReader(new FileReader("F:/hundrendk.txt"));
        for(int i=0; i<101; i++){
	        userName = reader.readLine(); 
		    ThreadDemo T1 = new ThreadDemo(userName);
		    T1.start();
        }
		reader.close();
	}
}
