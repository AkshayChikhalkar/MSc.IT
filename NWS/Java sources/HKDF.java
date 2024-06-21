/*
 * Stefan Heiss
 * TH Ostwestfalen-Lippe
 * FB Elektrotechnik und Technische Informatik
 */
package th_owl.hs.nws.kdf;

import java.security.NoSuchAlgorithmException;
import javax.crypto.Mac;

/**
 * <p>
 * This class provides the functionality of a
 * <b>HMAC-based Extract-and-Expand Key Derivation Functions
 * (HKDF)</b> as specified in
 * <a href="https://datatracker.ietf.org/doc/html/rfc5869">
 * <b>RFC 5869</b></a>.
 * </p>
 *
 * <p>
 * Exemplary application of the extract and expand functions:
 * </p>
 *
 * <pre>
 * public static void rfc5869_A4() throws NoSuchAlgorithmException {
 *   byte[] ikm = Dump.hexString2byteArray("0b0b0b0b0b0b0b0b0b0b0b");
 *   byte[] salt = Dump.hexString2byteArray("000102030405060708090a0b0c");
 *   byte[] info = Dump.hexString2byteArray("f0f1f2f3f4f5f6f7f8f9");
 *   int l = 42;
 *
 *   HKDF hkdf = HKDF.getInstance("HmacSHA1");
 *   byte[] prk = hkdf.extract(salt, ikm);
 *   System.out.println(Dump.dump(prk));
 *   System.out.println();
 *
 *   byte[] okm = hkdf.expand(prk, info, l);
 *   System.out.println(Dump.dump(okm));
 * }
 * </pre>
 */
public class HKDF {

  final Mac hmac;

  HKDF(String algorithm) throws NoSuchAlgorithmException {
    hmac = Mac.getInstance(algorithm);
  }

  /**
   * Returns an object implementing the
   * <b>HMAC-based Extract-and-Expand Key Derivation Function
   * (HKDF)</b> specified in
   * <a href="https://datatracker.ietf.org/doc/html/rfc5869">
   * <b>RFC 5869</b></a>.
   *
   * @param algorithm the standard name of the underlying HMAC
   * algorithm.
   *
   * @return HKDF instance based on the named HMAC algorithm.
   *
   * @throws NoSuchAlgorithmException if no Provider supports a
   * MacSpi implementation for the specified HMAC algorithm.
   */
  public static HKDF getInstance(String algorithm)
   throws NoSuchAlgorithmException {
    return new HKDF(algorithm);
  }

  /**
   * Implements
   * <a href="https://datatracker.ietf.org/doc/html/rfc5869#section-2.2">
   * <code>HKDF-Extract(salt, IKM) -&gt; PRK</code></a>.
   *
   * @param salt optional salt value (a non-secret random value);
   * if not provided, it is set to a string of HashLen zeros.
   *
   * @param ikm input keying material.
   *
   * @return PRK - a pseudorandom key of HashLen octets. (HashLen
   * denotes the output length of the underlying HMAC algorithm.)
   */
  public byte[] extract(byte[] salt, byte[] ikm) {
    throw new RuntimeException("Not yet implemented :-(. "
     + "Please implement me.");
  }

  /**
   * Implements
   * <a href="https://datatracker.ietf.org/doc/html/rfc5869#section-2.3">
   * <code>HKDF-Expand(PRK, info, L) -&gt; OKM</code></a>.
   *
   * @param prk a pseudorandom key of at least HashLen octets
   * (usually, the output from the extract step). (HashLen
   * denotes the output length of the underlying HMAC algorithm.)
   *
   * @param info optional context and application specific
   * information (can be a zero-length string).
   *
   * @param l length of output keying material in octets (&lt;=
   * 255*HashLen).
   *
   * @return OKM - output keying material (of l octets).
   */
  public byte[] expand(byte[] prk, byte[] info, int l) {
    throw new RuntimeException("Not yet implemented :-(. "
     + "Please implement me.");
  }
}
