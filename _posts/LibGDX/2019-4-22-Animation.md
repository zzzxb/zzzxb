---
layout: post
title:  "动画-Animation"
date:   2019-4-22 8:30:01 +0800
categories: LibGDX
tag: LibGDX
---

* content
{:toc}

![role]({{ '/styles/images/rous.png' | prepend: site.baseurl  }}

``` java
public class Role {
    private Texture walkSheetTexture;

    // 行走动画
    private Animation walkAnimation;

    private TextureRegion currentFrame;

    // 状态时间,渲染见步 delta 的累加值
    private float statemTime;

    public Role() {
        // 创建纹理
        walkSheetTexture = new Texture(Gdx.files.internal("rous.png"));

        int frameRows = 4;
        int frameCols = 4;

        int perCellWidth = walkSheetTexture.getWidth() / frameCols;
        int perCellHeight = walkSheetTexture.getHeight() / frameRows;

        // 按照指定的宽高作为一个单元格分割大图纹理
        TextureRegion[][] cellRegions = TextureRegion.split(walkSheetTexture, perCellWidth, perCellHeight);

        // 把二维数组变为一维数组,因为Animation只能接收一维数组作为关键帧序列
        TextureRegion[] walkFrames = new TextureRegion[frameCols * frameRows];
        int index = 0;
        for (int row = 0; row < frameRows; row++) {
            for (int col = 0; col < frameCols; col++) {
                walkFrames[index++] = cellRegions[row][col];
            }
        }

        walkAnimation = new Animation(0.2F,walkFrames);
        walkAnimation.setPlayMode(Animation.PlayMode.LOOP);
    }
    private int x = 400, y = 400;

    // 渲染图像
    public void render(SpriteBatch batch) {
        batch.draw(currentFrame, x , y);
    }

    // 根据DeltaTime的累加值更新图片状态
    public void update() {
        statemTime += Gdx.graphics.getDeltaTime();
        currentFrame = (TextureRegion)walkAnimation.getKeyFrame(statemTime);
    }
/*
    private boolean count = true;
    private float dic = 0;
    public void update(int dictionary) {
        statemTime += Gdx.graphics.getDeltaTime();
        if (Gdx.input.isTouched()) {
            if (count) {
                switch (dictionary) {
                    case 1:
                        statemTime = 2.4f;
                        dic = 2.4f;
                        break;
                    case 2:
                        statemTime = 0;
                        dic = 0;
                        break;
                    case 3:
                        statemTime = 0.8f;
                        dic = 0.8f;
                        break;
                    case 4:
                        statemTime = 1.6f;
                        dic = 1.6f;
                        break;
                }
            }
            count = false;
        }else {
            count = true;
        }

        if (dictionary == 2) { // 下
            statemTime = statemTime > 0.8f ? 0 : statemTime;
            y -= 1;
        }else if (dictionary == 3) { // 左
            statemTime = statemTime > 1.6f ? 0.81f : statemTime;
            x -= 1;
        }else if (dictionary == 4) { // 右
            statemTime = statemTime > 2.4f ? 1.61f : statemTime;
            x += 1;
        }else if (dictionary == 1) { // 上
            y += 1;
            statemTime = statemTime > 3.2f ? 2.41f : statemTime;
        }else{
            statemTime = dic;
        }

        currentFrame = (TextureRegion)walkAnimation.getKeyFrame(statemTime);
    }
*/

    public void dispose() {
        if (walkSheetTexture != null)
            walkSheetTexture.dispose();
    }
```

![Animation](https://github.com/zzzxb/zzzxb.github.io/blob/master/styles/images/animation.gif)