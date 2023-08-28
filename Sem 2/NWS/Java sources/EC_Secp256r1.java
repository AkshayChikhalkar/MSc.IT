/*
 * Stefan Heiss
 * TH Ostwestfalen-Lippe
 * FB Elektrotechnik und Technische Informatik
 */
package th_owl.hs.crypto.ecc;

import java.math.BigInteger;
import java.security.spec.*;
import th_owl.hs.util.Dump;

public class EC_Secp256r1 extends EllipticCurve​ {

  private static final BigInteger p
   = new BigInteger(1, Dump.hexString2byteArray(""
    + "FFFFFFFF 00000001 00000000 00000000 "
    + "00000000 FFFFFFFF FFFFFFFF FFFFFFFF"));
  private static final ECFieldFp​ ecField = new ECFieldFp​(p);
  private static final BigInteger a
   = new BigInteger(1, Dump.hexString2byteArray(""
    + "FFFFFFFF 00000001 00000000 00000000 "
    + "00000000 FFFFFFFF FFFFFFFF FFFFFFFC"));
  private static final BigInteger b
   = new BigInteger(1, Dump.hexString2byteArray(""
    + "5AC635D8 AA3A93E7 B3EBBD55 769886BC "
    + "651D06B0 CC53B0F6 3BCE3C3E 27D2604B"));

  private static final BigInteger gX
   = new BigInteger(1, Dump.hexString2byteArray(""
    + "6B17D1F2 E12C4247 F8BCE6E5 63A440F2 "
    + "77037D81 2DEB33A0 F4A13945 D898C296"));
  private static final BigInteger gY
   = new BigInteger(1, Dump.hexString2byteArray(""
    + "4FE342E2 FE1A7F9B 8EE7EB4A 7C0F9E16 "
    + "2BCE3357 6B315ECE CBB64068 37BF51F5"));
  private static final ECPoint G = new ECPoint(gX, gY);


  public EC_Secp256r1() {
    super(ecField, a, b);
  }

  public ECPoint getG() {
    return G;
  }
}
