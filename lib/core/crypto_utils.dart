import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

class CryptoUtils {
  String privateKey =
      "MIICXAIBAAKBgQCFtOtpwzJnOf0sSkOrSREqoutExA49xOlVfWCcmipegeP3EgtC\n7GlvZcK5zc5ENzDM/8tZ/nGhIQ0RPpu+Jrzmv0laxhSJI7Zt2a3dy4yFSxauGjXM\nFowYlaDReum83U2lInyHtSZk8Ec3iGgd5A80rx3AfnUHZUiBfS92R3oB8QIDAQAB\nAoGAAcEqBa1GEAy2wcoHsUu4KfMRW0mnVjArT6/hgKyVOcBCmY9nDm3DxG51a7LD\nril7PnVs2bV5EEA6x6smqAwiFnAn6I4tjcJznSh2TjIFhGTtAJTYjm6k4PQE0k7F\nDfbV1gee40GeiB3mXk1smwuIR5aQrD+6dt/RTMXUHutq6bECQQDaeNbWJvps7okT\nyiRxlnjyjp+ZOpcDYzY4HKfaUewjvJlw1CW4/FaUqGmiXsPNd6GARzO6rCkN8OFF\n22Suu8jrAkEAnKyVLTdmOooX80u232ei1lRoclqtksT8SyCkZA6qp8P8+NOVCLrN\n7obuG/Fl9ENMFcF4Z0sSDXeZVNRw/WgpkwJALXuy3mrHAB65ExGmfK9jBryCpZf5\nEI97Hjt5Bo6/psEBAOhp4hVGwTQ+qbso8IHTca1hK5/j/C8F91ExqN8XeQJBAI3W\nhDrqM4d9q08cVZONHFNTGTeltgvwf8N36ruWt5KoEOYnjn3XuEVgLEJp2XY4UrJD\nc8B3qwE8LDkrFpujaDcCQDlmVx55zPwYuogBrnvFDUFZOFR8NRCD3R4YrKPmHJmA\n4KC6n9RJeI5Zh/9bsqmjlrpDkrYDG0XrOqZDxGcPk+M=";
  static String publickey =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCFtOtpwzJnOf0sSkOrSREqoutE\nxA49xOlVfWCcmipegeP3EgtC7GlvZcK5zc5ENzDM/8tZ/nGhIQ0RPpu+Jrzmv0la\nxhSJI7Zt2a3dy4yFSxauGjXMFowYlaDReum83U2lInyHtSZk8Ec3iGgd5A80rx3A\nfnUHZUiBfS92R3oB8QIDAQAB";

  static String encrypt(String rawText) {
    final pubKey = getPublicKey();

    var cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(pubKey));
    final encryptedBytes =
        cipher.process(Uint8List.fromList(utf8.encode(rawText)));
    return base64Encode(encryptedBytes);

    // final encryptor = OAEPEncoding(RSAEngine())
    //   ..init(true, PublicKeyParameter<RSAPublicKey>(pubKey));
    // final encryptedBytes =
    //     encryptor.process(Uint8List.fromList(utf8.encode(rawText)));
    // return base64.encode(encryptedBytes);

    // final cipher = AsymmetricBlockCipher("RSA");
    // cipher.init(true, PublicKeyParameter<RSAPublicKey>(pubKey));
    // final bytes = Uint8List.fromList(utf8.encode(rawText));
    // final encrypted = cipher.process(bytes);
    // final base64Encrypted = base64.encode(encrypted);

    // return base64Encrypted;
  }

  static RSAPublicKey getPublicKey() {
    var pem =
        '-----BEGIN RSA PUBLIC KEY-----\n$publickey\n-----END RSA PUBLIC KEY-----';
    return rsaPublicKeyFromPem(pem);
  }

  static RSAPrivateKey rsaPrivateKeyFromPem(String pem) {
    var bytes = getBytesFromPEMString(pem);
    return rsaPrivateKeyFromDERBytes(bytes);
  }

  static RSAPrivateKey rsaPrivateKeyFromDERBytes(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    //ASN1Object version = topLevelSeq.elements[0];
    //ASN1Object algorithm = topLevelSeq.elements[1];
    var privateKey = topLevelSeq.elements![2];

    asn1Parser = ASN1Parser(privateKey.valueBytes);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements![1] as ASN1Integer;
    //ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements![3] as ASN1Integer;
    var p = pkSeq.elements![4] as ASN1Integer;
    var q = pkSeq.elements![5] as ASN1Integer;
    //ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    //ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    //ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    var rsaPrivateKey = RSAPrivateKey(
        modulus.integer!, privateExponent.integer!, p.integer, q.integer);

    return rsaPrivateKey;
  }

  ///
  /// Decode a [RSAPrivateKey] from the given [pem] string formated in the pkcs1 standard.
  ///
  static RSAPrivateKey rsaPrivateKeyFromPemPkcs1(String pem) {
    var bytes = getBytesFromPEMString(pem);
    return rsaPrivateKeyFromDERBytesPkcs1(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPrivateKey].
  ///
  /// The [bytes] need to follow the the pkcs1 standard
  ///
  static RSAPrivateKey rsaPrivateKeyFromDERBytesPkcs1(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    var modulus = pkSeq.elements![1] as ASN1Integer;
    //ASN1Integer publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements![3] as ASN1Integer;
    var p = pkSeq.elements![4] as ASN1Integer;
    var q = pkSeq.elements![5] as ASN1Integer;
    //ASN1Integer exp1 = pkSeq.elements[6] as ASN1Integer;
    //ASN1Integer exp2 = pkSeq.elements[7] as ASN1Integer;
    //ASN1Integer co = pkSeq.elements[8] as ASN1Integer;

    var rsaPrivateKey = RSAPrivateKey(
        modulus.integer!, privateExponent.integer!, p.integer, q.integer);

    return rsaPrivateKey;
  }

  ///
  /// Helper function for decoding the base64 in [pem].
  ///
  /// Throws an ArgumentError if the given [pem] is not sourounded by begin marker -----BEGIN and
  /// endmarker -----END or the [pem] consists of less than two lines.
  ///
  /// The PEM header check can be skipped by setting the optional paramter [checkHeader] to false.
  ///
  static Uint8List getBytesFromPEMString(String pem,
      {bool checkHeader = true}) {
    var lines = LineSplitter.split(pem)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    String base64;
    if (checkHeader) {
      if (lines.length < 2 ||
          !lines.first.startsWith('-----BEGIN') ||
          !lines.last.startsWith('-----END')) {
        throw ArgumentError('The given string does not have the correct '
            'begin/end markers expected in a PEM file.');
      }
      base64 = lines.sublist(1, lines.length - 1).join('');
    } else {
      base64 = lines.join('');
    }

    return Uint8List.fromList(base64Decode(base64));
  }

  ///
  /// Decode a [RSAPublicKey] from the given [pem] String.
  ///
  static RSAPublicKey rsaPublicKeyFromPem(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return rsaPublicKeyFromDERBytes(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPublicKey].
  ///
  static RSAPublicKey rsaPublicKeyFromDERBytes(Uint8List bytes) {
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    ASN1Sequence publicKeySeq;
    if (topLevelSeq.elements![1].runtimeType == ASN1BitString) {
      var publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;

      var publicKeyAsn =
          ASN1Parser(publicKeyBitString.stringValues as Uint8List?);
      publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    } else {
      publicKeySeq = topLevelSeq;
    }
    var modulus = publicKeySeq.elements![0] as ASN1Integer;
    var exponent = publicKeySeq.elements![1] as ASN1Integer;

    var rsaPublicKey = RSAPublicKey(modulus.integer!, exponent.integer!);

    return rsaPublicKey;
  }

  ///
  /// Decode a [RSAPublicKey] from the given [pem] string formated in the pkcs1 standard.
  ///
  static RSAPublicKey rsaPublicKeyFromPemPkcs1(String pem) {
    var bytes = CryptoUtils.getBytesFromPEMString(pem);
    return rsaPublicKeyFromDERBytesPkcs1(bytes);
  }

  ///
  /// Decode the given [bytes] into an [RSAPublicKey].
  ///
  /// The [bytes] need to follow the the pkcs1 standard
  ///
  static RSAPublicKey rsaPublicKeyFromDERBytesPkcs1(Uint8List bytes) {
    var publicKeyAsn = ASN1Parser(bytes);
    var publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    var modulus = publicKeySeq.elements![0] as ASN1Integer;
    var exponent = publicKeySeq.elements![1] as ASN1Integer;

    var rsaPublicKey = RSAPublicKey(modulus.integer!, exponent.integer!);
    return rsaPublicKey;
  }

  ///
  /// Encrypt the given [message] using the given RSA [publicKey].
  ///
  static String rsaEncrypt(String message, RSAPublicKey publicKey) {
    var cipher = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    var cipherText = cipher.process(Uint8List.fromList(message.codeUnits));

    return String.fromCharCodes(cipherText);
  }

  ///
  /// Decrypt the given [cipherMessage] using the given RSA [privateKey].
  ///
  static String rsaDecrypt(String cipherMessage, RSAPrivateKey privateKey) {
    var cipher = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    var decrypted = cipher.process(Uint8List.fromList(cipherMessage.codeUnits));

    return String.fromCharCodes(decrypted);
  }
}
