---
layout: post
title:  "Texturepacker工具与TextureAtlas类"
date:   2019-4-22 8:40:01 +0800
categories: LibGDX
tag: LibGDX
---

* content
{:toc}


## Texturepacker工具的使用

Texturepacker 可以把多张小图片合成在同一张大图上。
使用Texturepacker工具时候有三个参数分别为:

    1. `inputDir` 所有小图存放的文件夹
    2. `outputDir` 合成后输出文件夹
    3. `packFileName` 合成后的文件名称

打包完成后会输出一个 png 文件和 atlas 文件.  
png 是合成后的图片  
atlas 合成后图片内容是每个小图在大图中的名字,位置等信息.  

## TextureAtlas类的使用

![moveButton]({{ '/styles/images/moveButton.png' | prepend: site.baseurl  }}

```java
public class MainGame extends ApplicationAdapter {
	private SpriteBatch batch;
	
	// 纹理图集
	private TextureAtlas atlas;
	
	// 每个小图在在纹理图集中对应的名称常量（实际上就是小图的原文件名，定义在 myatlas.atlas 文件中）
	public static final String MAN = "man";				// 人
	public static final String MUSHROOM = "mushroom";	// 蘑菇
	public static final String FLOWER = "flower";		// 鲜花
	public static final String BUTTON = "button";		// 按钮
	
	// 小图对应的 纹理区域 或 精灵
	private TextureRegion manRegion;		// 人
	private Sprite mushroomSprite;			// 蘑菇
	private Sprite flowerSprite;			// 鲜花
	private TextureRegion button1Region;	// 按钮 1
	private TextureRegion button2Region;	// 按钮 2
	
	@Override
	public void create() {
		// 创建 SpriteBatch
		batch = new SpriteBatch();
		
		// 读取 myatlas.atlas 文件创建纹理图集
		atlas = new TextureAtlas(Gdx.files.internal("atlas/myatlas.atlas"));
		
		// 根据名称从纹理图集中获取纹理区域
		manRegion = atlas.findRegion(MAN);
		
		// 也可以根据名称直接由纹理图集创建精灵
		mushroomSprite = atlas.createSprite(MUSHROOM);
		flowerSprite = atlas.createSprite(FLOWER);
		
		/*
		 * 根据 名称 和 索引 从纹理图集中获取纹理区域
		 * 
		 * 特别说明: 
		 *     纹理图集中的小图名称一般就是小图的原文件名, 但可以给小图加上一个索引（index）属性, 就是在文件名后
		 * 面加上下划线和表示索引的数字（name_index.png）, 例如 button_1.png 和 button_2.png 这两个小图文件, 
		 * gdx-tools 在合成纹理图集时会使用相同的名称（button）分别加上对应的索引值（1 和 2）表示。这样有助于对
		 * 业务相同的图片进行统一命名。纹理图集对小图的描述定义在 myatlas.atlas 文件中, 这是一个文本文件, 可以用
		 * 记事本打开查看。
		 * 
		 * 因此下面获取按钮的纹理区域时使用 "button" 作为名称并加上对应的索引值来获取。
		 */

		button1Region = atlas.findRegion(BUTTON, 1);
		button2Region = atlas.findRegion(BUTTON, 2);
		
		/* 给精灵设置位置属性 */
		flowerSprite.setPosition(190, 80);
		mushroomSprite.setPosition(190, 290);
	}

	@Override
	public void render() {
		// 黑色清屏
		Gdx.gl.glClearColor(0, 0, 0, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		
		// 开始绘制
		batch.begin();
		
		// 绘制精灵
		mushroomSprite.draw(batch);			// 蘑菇
		flowerSprite.draw(batch);			// 鲜花
		
		// 绘制纹理区域
		batch.draw(manRegion, 30, 70);		// 人
		batch.draw(button1Region, 30, 340);	// 按钮 1
		batch.draw(button2Region, 30, 286);	// 按钮 2
		
		// 绘制结束
		batch.end();
	}

	@Override
	public void dispose() {
		// 当应用退出时释放资源
		if (batch != null) {
			batch.dispose();
		}
		// 纹理图集关联了一张合成的大图, 应用退出时需要释放纹理图集资源
		if (atlas != null) {
			atlas.dispose();
		}
	}
}
```

![Animation]({{ '/styles/images/animation.gif' | prepend: site.baseurl  }}