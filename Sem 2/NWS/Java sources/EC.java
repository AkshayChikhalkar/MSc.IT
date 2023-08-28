/*
 * TH Ostwestfalen-Lippe
 * FB Elektrotechnik und Technische Informatik
 * NWS
 *
 * Solutions from:
 * Please provide your NAME, MATRIKELNUMMER, ILIAS USER NAME
 */
package th_owl.hs.crypto.ecc;

import java.math.BigInteger;
import java.security.*;
import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import java.security.spec.*;

public class EC {

  public static void main(String[] args) throws Exception {
    test_01();
  }

  // -------------------------------------------------------------
  public static void test_01()
   throws NoSuchAlgorithmException,
   InvalidAlgorithmParameterException, InterruptedException {

    KeyPairGenerator kpGen = KeyPairGenerator.getInstance("EC");
    ECGenParameterSpec ecPar = new ECGenParameterSpec("secp256r1");
    kpGen.initialize(ecPar);
    KeyPair keyPair = kpGen.generateKeyPair();

    ECPrivateKey privateKey = (ECPrivateKey) keyPair.getPrivate();

    ECPublicKey publicKey = (ECPublicKey) keyPair.getPublic();
    ECPoint k_pub = publicKey.getW();
    System.out.println("Public Key:");
    System.out.println("-----------");
    System.out.println("k_pub_x: " + k_pub.getAffineX());
    System.out.println("k_pub_y: " + k_pub.getAffineY());
    System.out.println();

    // Calculation of public key with method(s) implemented below.
    ECParameterSpec eccParameters = publicKey.getParams();
    EllipticCurve ec = eccParameters.getCurve();
    ECPoint g = eccParameters.getGenerator();

    ECPoint myPubKey = multiply(privateKey.getS(), g, ec);
    System.out.println("k_priv * G:");
    System.out.println("-----------");
    System.out.println("k_pub_x: " + myPubKey.getAffineX());
    System.out.println("k_pub_y: " + myPubKey.getAffineY());
    System.out.println();

    // Test 1
    System.out.println("Test 1 "
     + (publicKey.getW().equals(myPubKey) ? "passed!" : "FAILED"));

    // Test 2    
    ECPoint pt = add(k_pub, ECPoint.POINT_INFINITY, ec);
    System.out.println("Test 2 "
     + (myPubKey.equals(pt) ? "passed!" : "FAILED"));
  }

  // -------------------------------------------------------------
  // -------------------------------------------------------------
  /**
   *
   * @param pt1 A point P of the elliptic curve determined by
   * <code>ec</code>
   * @param pt2 A point Q of the elliptic curve determined by
   * <code>ec</code>
   * @param ec
   * @return P + Q
   */
  public static ECPoint add(
   ECPoint pt1, ECPoint pt2, EllipticCurve ec) {
    if( ECPoint.POINT_INFINITY.equals(pt1) ) {
      return pt2;
    }
    if( ECPoint.POINT_INFINITY.equals(pt2) ) {
      return pt1;
    }

    BigInteger x1 = pt1.getAffineX();
    BigInteger y1 = pt1.getAffineY();
    BigInteger x2 = pt2.getAffineX();
    BigInteger y2 = pt2.getAffineY();

    if( x1.equals(x2) ) {
      if( y1.equals(y2) ) {
        return doublePt(pt1, ec);
      } else {
        return ECPoint.POINT_INFINITY;
      }
    }

    BigInteger p = ((ECFieldFp) ec.getField()).getP();
    BigInteger s = y2.subtract(y1).multiply(
     x2.subtract(x1).modInverse(p)).mod(p);
    BigInteger x = s.pow(2).subtract(x1).subtract(x2).mod(p);
    BigInteger y = s.multiply(x1.subtract(x)).subtract(y1).mod(p);
    return new ECPoint(x, y);
  }

  final static BigInteger THREE = new BigInteger("3");

  /**
   *
   * @param pt A point P of the elliptic curve determined by
   * <code>ec</code>
   * @param ec
   * @return 2*P = P + P
   */
  public static ECPoint doublePt(ECPoint pt, EllipticCurve ec) {
    if( ECPoint.POINT_INFINITY.equals(pt) ) {
      return ECPoint.POINT_INFINITY;
    }

    BigInteger x1 = pt.getAffineX();
    BigInteger y1 = pt.getAffineY();
    if( y1.equals(BigInteger.ZERO) ) {
      return ECPoint.POINT_INFINITY;
    }

    BigInteger p = ((ECFieldFp) ec.getField()).getP();
    BigInteger a = ec.getA();
    BigInteger s = x1.pow(2).multiply(THREE).add(a).mod(p).
     multiply(y1.shiftLeft(1).modInverse(p)).mod(p);
    BigInteger x = s.pow(2).subtract(x1.shiftLeft(1)).mod(p);
    BigInteger y = s.multiply(x1.subtract(x)).subtract(y1).mod(p);
    return new ECPoint(x, y);
  }

  /**
   *
   * @param m A positive integer m
   * @param pt A point P of the elliptic curve determined by
   * <code>ec</code>
   * @param ec
   * @return m*P
   */
  public static ECPoint multiply(
   BigInteger m, ECPoint pt, EllipticCurve ec) {
    ECPoint pow2timesPt = pt;
    ECPoint sum = m.testBit(0) ? pt : ECPoint.POINT_INFINITY;
    m = m.shiftRight(1);
    while( !m.equals(BigInteger.ZERO) ) {
      pow2timesPt = doublePt(pow2timesPt, ec);
      if( m.testBit(0) ) {
        sum = add(sum, pow2timesPt, ec);
      }
      m = m.shiftRight(1);
    }
    return sum;
  }
}
