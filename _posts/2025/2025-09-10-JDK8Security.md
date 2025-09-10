---
layout: post
title: "JDK1.8 安全算法找不到的问题"
date: 2025-06-09 10:38:00 +0800
tag: Java
---

* content
{:toc}

## 起因

* `AES/CBC/PKCS5Padding`(*AES*加密算法中的*CBC*模式和*PKCS5Padding*填充方式)

* 本地MAC:
  * jdk: 1.8.431

  * 算法可找到

  * IV长度16字节可用

* 部署到Linux后:

* jdk: 1.8.131

* [算法不能找到](#not-found) (*Cannot find any provider supporting AES/CBC/PKCSSPADDING*)
* [IV长度过长](#illegal-key-size) (*Illegal key size*)

## 解决方案

### 算法不能找到 {#not-found}

主要原因就是jdk文件的缺失、或者版本问题。

#### 方案1：使用 BouncyCastle

[bcprov-jdk159n-1.70.jar](https://downloads.bouncycastle.org/java/bcprov-jdk15on-1.70.jar)，一步到位就不用再折腾JDK

```xml
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk15on</artifactId>
    <version>1.70</version>
</dependency>
```

```java
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Security;
import java.util.Base64;

@Slf4j
public class AESUtil {

    static {
        try {
            Security.addProvider(new BouncyCastleProvider());
            System.out.println("BouncyCastle provider added successfully");
        } catch (Exception e) {
            System.err.println("Failed to add BouncyCastle provider: " + e.getMessage());
        }
    }

    public static String encryptWithPkcs5Padding(String value, String secretKey, String initVector) {
        if (StringUtils.isBlank(secretKey) || StringUtils.isBlank(initVector) || StringUtils.isBlank(value)) {
            return null;
        }
        try {
            SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "AES");
            IvParameterSpec iv = new IvParameterSpec(initVector.getBytes(StandardCharsets.UTF_8));

            // 强制使用BouncyCastle提供商
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding", "BC");

            cipher.init(Cipher.ENCRYPT_MODE, keySpec, iv);
            byte[] encrypted = cipher.doFinal(value.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e) {
            log.error("AESUtil encryptWithPkcs5Padding error", e);
            return null;
        }
    }

    public static String decryptWithPkcs5Padding(String value, String secretKey, String initVector) {
        if (StringUtils.isBlank(secretKey) || StringUtils.isBlank(initVector) || StringUtils.isBlank(value)) {
            return null;
        }
        try {
            SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "AES");
            IvParameterSpec iv = new IvParameterSpec(initVector.getBytes(StandardCharsets.UTF_8));

            // 强制使用BouncyCastle提供商
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding", "BC");

            cipher.init(Cipher.DECRYPT_MODE, keySpec, iv);
            byte[] original = cipher.doFinal(Base64.getDecoder().decode(value));
            return new String(original, StandardCharsets.UTF_8);
        } catch (Exception e) {
            log.error("AESUtil decryptWithPkcs5Padding error", e);
            return null;
        }
    }
}
```

### IV长度过长 {#illegal-key-size}

这个错误是因为**JDK的加密策略限制**。JDK默认限制了加密密钥的长度，需要安装Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files。

#### 方案1：安装JCE无限强度策略文件（推荐）

```shell
# 对于JDK 1.8
wget https://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip

# 或者从其他源下载
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip

# 解压
unzip jce_policy-8.zip

# 备份原文件
cp $JAVA_HOME/jre/lib/security/local_policy.jar $JAVA_HOME/jre/lib/security/local_policy.jar.backup
cp $JAVA_HOME/jre/lib/security/US_export_policy.jar $JAVA_HOME/jre/lib/security/US_export_policy.jar.backup

# 替换新文件
cp UnlimitedJCEPolicyJDK8/local_policy.jar $JAVA_HOME/jre/lib/security/
cp UnlimitedJCEPolicyJDK8/US_export_policy.jar $JAVA_HOME/jre/lib/security/
```
