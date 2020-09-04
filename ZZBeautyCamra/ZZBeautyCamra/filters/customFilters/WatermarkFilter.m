//
//  WatermarkFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/3.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "WatermarkFilter.h"

NSString * _Nullable const kWatermarkFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
  uniform sampler2D watermarkTexture;
  varying vec2 textureCoordinate;
  
  void main()
  {
      vec2 uv = textureCoordinate.xy;
      float y;
      if(uv.y >= 0.0 && uv.y<= 1.0/3.0){
          y = uv.y + 2.0/3.0;
      }else if(uv.y > 1.0/3.0 && uv.y <= 2.0/3.0){
          y = uv.y + 1.0/3.0;
      }else {
          y = uv.y;
      }
      gl_FragColor = texture2D(inputImageTexture,vec2(uv.x,y));
  }
);

@implementation WatermarkFilter

- (instancetype)init
{
    if(!([self initWithFragmentShaderFromString:kWatermarkFragmentShaderString])){
        return nil;
    }
    return self;
}

@end
