//
//  ThreeSplitScreenFilter.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/8/28.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "ThreeSplitScreenFilter.h"

NSString * _Nullable const kThreeSplitScreenFragmentShaderString = SHADER_STRING
(
  precision highp float;
  uniform sampler2D inputImageTexture;
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

@implementation ThreeSplitScreenFilter

- (id)init
{
    if (!(self = [super initWithFragmentShaderFromString:kThreeSplitScreenFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
