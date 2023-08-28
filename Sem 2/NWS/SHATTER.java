import java.io.FileInputStream;
import java.security.MessageDigest;

public class SHA1Calculator {

    public static void main(String[] args) {
        String filename = "/Users/akshaychikhalkar/Downloads/shattered-1.pdf";
        try {
            FileInputStream inputStream = new FileInputStream(filename);
            byte[] data = new byte[inputStream.available()];
            inputStream.read(data);
            inputStream.close();

            MessageDigest sha1Digest = MessageDigest.getInstance("SHA-1");
            byte[] hashValue = sha1Digest.digest(data);

            StringBuilder hexString = new StringBuilder();
            for (byte b : hashValue) {
                hexString.append(String.format("%02x", b));
            }
            String hexHash = hexString.toString();
            System.out.println("SHA-1 hash value of " + filename + ": " + hexHash);
        } catch (Exception e) {
            System.err.println("Error computing SHA-1 hash value: " + e.getMessage());
        }
    }

}
