//
//  FourSplitScreenFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "FourSplitScreenFilter.h"
NSString * _Nullable const kFourSplitScreenFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
  varying vec2 textureCoordinate;

  void main()
  {
      vec2 uv = textureCoordinate.xy;
      float y;
      if(uv.x <= 0.5){
          uv.x = uv.x * 2.0;
      }else{
          uv.x = (uv.x - 0.5) * 2.0;
      }
      if(uv.y <= 0.5){
          uv.y = uv.y * 2.0;
      }else{
          uv.y = (uv.y - 0.5) *2.0;
      }
      gl_FragColor = texture2D(inputImageTexture,uv);
  }
);


@implementation FourSplitScreenFilter

- (id)init
{
    if(!(self = [super initWithFragmentShaderFromString:kFourSplitScreenFragmentShaderString])){
        return nil;
    }
    return self;
}

@end
