---
layout: post
title:  "libGDX中Pixmap使用"
date:   2019-08-30 22:1:25 +0800
categories: LibGDX
tag: LibGDX
---

* content
{:toc}

```java
/**
 * @author Zzzxb  2019/8/29 22:05
 * @description:
 */
public class Welcome extends ApplicationAdapter {
    private SpriteBatch batch;
    private Sprite sprite;
    private Texture texture;
    private Pixmap pixmap;
    private float x = 100f, y = 100f;
    private float speed = 5f;
    private float angle = 0f;

    public Welcome() {
        batch = new SpriteBatch();
        pixmap = new Pixmap(64, 64, Pixmap.Format.RGBA8888);
        pixmap.setColor(0, 1, 0, 0.75f);
        pixmap.fillRectangle(16,16,32,32);
        texture = new Texture(pixmap);
        sprite = new Sprite(texture);
    }

    @Override
    public void render() {
        batch.begin();
        sprite.setRotation(angle);
        sprite.setPosition(x, y);
        sprite.draw(batch);
        update();
        batch.end();
    }

    public void update() {
        if (Gdx.input.isKeyPressed(Input.Keys.J)) {
            y -= speed;
        }
        if (Gdx.input.isKeyPressed(Input.Keys.K)) {
            y += speed;
        }
        if (Gdx.input.isKeyPressed(Input.Keys.H)) {
            x -= speed;
        }
        if (Gdx.input.isKeyPressed(Input.Keys.L)) {
            x += speed;
        }
        angle = (float)(System.currentTimeMillis()%360000)/speed;
    }

    @Override
    public void dispose() {
        pixmap.dispose();
        texture.dispose();
        batch.dispose();
    }
}
```

![pixmap_move]({{'/pixmap_move.gif' | prepend: site.img}})
