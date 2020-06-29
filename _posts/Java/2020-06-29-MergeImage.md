---
layout: post
title:  "Merge Images"
date:   2020-06-29 22:51:01 +0800
categories: Java
tag: Java
---

* content
{:toc}

合并图片,把两个图片合成一个图片，如下所示，把一张图片合成在另一张图片之上。

![bg]({{'/styles/images/bg.jpg' | prepend: site.baseurl}})

![Snake]({{'/styles/images/Snake.png' | prepend: site.baseurl}})

![MergeImages]({{'/styles/images/mergeImage.png' | prepend: site.baseurl}})



## Merge Images

```java
package org.example.utils;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * @author Zzzxb
 * @date 2020/6/29 14:22
 * 合并图图片，把一张图片合并到另一张背景图片上
 */
public class MergeImages {

    /**
     * background image path
     */
    private String bgImagePath = "src/main/resources/bg.jpg";

    /**
     * background image size
     */
    private int bgWidth = 300;
    private int bgHeight = 300;


    /**
     * logo image path
     */
    private String logoPath = "src/main/resources/Snake.png";

    /**
     * logo image size
     */
    private int logoWidth = 128;
    private int logoHeight = 128;

    private String outPaht = "src/main/resources/mergeImage.png";

    /**
     * logo x 轴位置
     */
    private int logoPositionX = 86;

    /**
     * logo y 轴位置
     */
    private int logoPositionY = 86;

    /**
     * 合并 logo 到 背景图片上
     * @return
     */
    public boolean mergeLogoToBgImage() throws Exception {
        // 读取 logo 到图片缓存区
        BufferedImage imageLogo = ImageIO.read(new File(logoPath));

        // 读取 bg 到图片缓存区
        BufferedImage imageBg = ImageIO.read(new File(bgImagePath));

        // 创建一个新的图片缓存区,跟背景图片一样大
        BufferedImage imageSaved = new BufferedImage(bgWidth, bgHeight, BufferedImage.TYPE_INT_ARGB);

        // 通过 g2d 进行图片绘制
        Graphics2D g2d = imageSaved.createGraphics();
        g2d.drawImage( imageLogo, null, 0, 0);

        // 把 bg 图片，一个像素一个像素的写到缓存区
        for (int i = 0; i < bgHeight; i++) {
            for (int j = 0; j < bgWidth; j++) {
                int rgb2 = imageBg.getRGB(i,j);
                imageSaved.setRGB(i, j, rgb2);
            }

        }

        // 根据 logo 要合并的位置，替换 bg 图片写入缓存原有位置的像素数据
        for (int i = 0; i < logoHeight; i++) {
            for (int j = 0; j < logoWidth; j++) {
                int rgb1 = imageLogo.getRGB(i, j);
                if ((i+logoPositionX) > bgWidth || (j+logoPositionY) >bgHeight) {
                    break;
                }
                imageSaved.setRGB(i + logoPositionX, j + logoPositionY, rgb1);
            }
        }

        boolean success = false;

        // 写出合并后的图片
        try {
            success = ImageIO.write(imageSaved, "png", new File(outPaht));
        }catch (IOException io) {
            io.printStackTrace();
        }

        return success;
    }
}
```