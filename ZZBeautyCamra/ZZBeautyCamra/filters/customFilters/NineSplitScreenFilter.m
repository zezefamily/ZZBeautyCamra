//
//  NineSplitScreenFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "NineSplitScreenFilter.h"

NSString * _Nullable const kNineSplitScreenFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
  varying vec2 textureCoordinate;

  void main()
  {
      vec2 uv = textureCoordinate.xy;
      float y;
      if(uv.x <= 1.0/3.0){
          uv.x = uv.x * 3.0;
      }else if(uv.x > 1.0/3.0 && uv.x <= 2.0/3.0){
          uv.x = (uv.x - 1.0/3.0) * 3.0;
      }else{
          uv.x = (uv.x - 2.0/3.0) * 3.0;
      }
      if(uv.y <= 1.0/3.0){
          uv.y = uv.y * 3.0;
      }else if(uv.y > 1.0/3.0 && uv.y <= 2.0/3.0){
          uv.y = (uv.y - 1.0/3.0) * 3.0;
      }else{
          uv.y = (uv.y - 2.0/3.0) * 3.0;
      }
      gl_FragColor = texture2D(inputImageTexture,uv);
  }
);

@implementation NineSplitScreenFilter

- (id)init
{
    if(!(self = [super initWithFragmentShaderFromString:kNineSplitScreenFragmentShaderString])){
        return nil;
    }
    return self;
}
@end
