package codeGenerator;
import java.util.Random;

public class codeGenerator {

	//some data variables
	private String key="1234567890";
	private int max = 62;
    
    //constructor 
	public codeGenerator() {
		for(int i=65;i<=90;i++)this.key+=(char)i;
		for(int i=97;i<=122;i++)this.key+=(char)i;
	}
    
    //specification: takes size as input and return a unique code of string type
	public String getCode(int size) {
		String result="";
        //generating some random number 
		Random random = new Random();
        
		for(int i=0;i<size;i++) {
            //getting the random character
			result+=this.key.charAt(random.nextInt(max));
		}
		return result;
	}
}
